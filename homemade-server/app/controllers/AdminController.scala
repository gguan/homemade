package controllers

import play.api._
import play.api.mvc._
import models._
import play.api.data._
import play.api.data.Forms._
import org.bson.types.ObjectId
import java.io.File
import fly.play.s3.{BucketFile, S3}
import se.digiplant.scalr.api.{Resizer, Scalr}
import scalax.io.Resource
import concurrent.ExecutionContext.Implicits.global
import play.mvc.Http.MultipartFormData.FilePart

/**
 * Created with IntelliJ IDEA.
 * User: gguan
 * Date: 3/29/13
 * Time: 2:52 AM
 */
object AdminController extends Controller {

  val bucket = S3(play.api.Play.current.configuration.getString("aws.photoBucket").getOrElse("test.photo"))

  // recipe form definition
  val addRecipeForm: Form[Recipe] = Form(
    mapping(
      "title" -> text(minLength = 3),
      "overview" -> optional(text),
      "difficulty" -> text,
      "ingredients" -> seq(
        mapping(
          "name" -> nonEmptyText,
          "amount" -> optional(text)
        )((name, amount) => Ingredient(name = name, image = None, amount = amount))(ingredient => Some(ingredient.name, ingredient.amount))
      ),
      "instructions" -> list(
        mapping(
          "content" -> nonEmptyText
        )(Step(_, None))( step => Some(step.content))
      ),
      "tips" -> list(nonEmptyText)
    )
    {
      (title, overview, difficulty, ingredients, instructions, tips) =>
        Recipe(title = title, overview = overview, difficulty = difficulty.toInt, ingredients = ingredients.toSet, instructions = instructions, tips = tips, authorId = new ObjectId, photo = "")
    } {
      recipe => Some(recipe.title, recipe.overview, recipe.difficulty.toString, recipe.ingredients.toSeq, recipe.instructions, recipe.tips)
    }
  )

  // recipe form page
  def addRecipe = Action {
    Ok(views.html.recipeForm(addRecipeForm))
  }

  // add new recipe
  def createRecipe = Action(parse.multipartFormData) { implicit request =>

    addRecipeForm.bindFromRequest.fold(
      errors => {
        Logger.debug(errors.toString)
        Logger.error("Form incomplete.")
        BadRequest(views.html.recipeForm(errors))
      },
      recipe => {
        if (request.body.file("recipePhoto") == None) {
          Logger.error("No photo uploaded.")
          BadRequest(views.html.recipeForm(addRecipeForm.bindFromRequest))
        }
        var newRecipe: Recipe = recipe.copy()
        // loop all files and upload to S3
        request.body.files.foreach { filePart =>

          val file: File = filePart.ref.file
          if (file.length > 0) {
            Logger.debug("-----------" + filePart.key)
            if (filePart.key == "recipePhoto") {
              newRecipe = newRecipe.copy(photo = uploadImage(file, filePart.contentType.get))
            } else {
              val stepPhoto = uploadImage(file, filePart.contentType.get)
              // find index from 'instructions[0].img'
              val index = filePart.key.dropRight(5).drop(13).toInt
              val instructions = newRecipe.instructions.updated(index, Step(recipe.instructions(index).content, Some(stepPhoto)))
              newRecipe = newRecipe.copy(instructions = instructions)
            }
          }
        }
        Logger.debug(newRecipe.toString)
        Recipe.insert(newRecipe)
        Ok("Successfully created a new recipe.")
      }
    )

  }

  def uploadImage(file: File, contentType: String): String = {
    val fileName = new ObjectId().toString
    // read and upload original image to S3
    val result = bucket + BucketFile(fileName+"-original", contentType, Resource.fromFile(file).byteArray)
    result.map {
      case Left(error) => throw new Exception("Error: " + error)
      case Right(success) => Logger.info("Saved the file" + fileName)
    }

    // read and upload resized image to S3
    val resizedImg = Scalr.resize(file, 600, 600, Resizer.Mode.FIT_TO_WIDTH, Resizer.Method.ULTRA_QUALITY)
    val result2 = bucket + BucketFile(fileName, contentType, Resource.fromFile(resizedImg).byteArray)
    result2.map {
      case Left(error) => throw new Exception("Error: " + error)
      case Right(success) => Logger.info("Saved the file" + resizedImg.getName)
    }

    fileName
  }

}
