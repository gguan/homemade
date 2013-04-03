package controllers

import play.api._
import libs.MimeTypes
import play.api.mvc._
import models._
import play.api.data._
import play.api.data.Forms._
import org.bson.types.ObjectId
import java.io.File
import fly.play.s3.{BucketFile, S3}
import helpers.CustomizedFormat.ImageResizer

//import se.digiplant.scalr.api.{Resizer, Scalr}
import org.imgscalr.Scalr
import concurrent.ExecutionContext.Implicits.global
import java.awt.image.BufferedImage
import javax.imageio.ImageIO

/**
 * Created with IntelliJ IDEA.
 * User: gguan
 * Date: 3/29/13
 * Time: 2:52 AM
 */
object AdminController extends Controller {

  val bucket = S3("test.photo")


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
    }
    {
      recipe => Some(recipe.title, recipe.overview, recipe.difficulty.toString, recipe.ingredients.toSeq, recipe.instructions, recipe.tips)
    }
  )

  def addRecipe = Action {
    Ok(views.html.recipeForm(addRecipeForm))
  }

  def createRecipe = Action(parse.multipartFormData) { implicit request =>

    request.body.files.foreach { filePart =>
      val file: File = filePart.ref.file
      if (file.length > 0) {
        println("-----------")

        val fileName = new ObjectId().toString
        // read and upload original image to S3
        val in = new java.io.FileInputStream(file)
        val imgBytes = new Array[Byte](file.length.toInt)
//        in.read(imgBytes)
//        in.close()
//        val result = bucket + BucketFile(fileName, filePart.contentType.get, imgBytes)
//        result.map {
//          case Left(error) => throw new Exception("Error: " + error)
//          case Right(success) => Logger.info("Saved the file" + fileName)
//        }
        // read and upload resized image to S3
        val bufferedImg: BufferedImage = ImageIO.read(file)
        val resizedImg = ImageResizer.resize(file, 400, 400)
        val in2 = new java.io.FileInputStream(file)
        val bytes2 = new Array[Byte](resizedImg.length.toInt)
        in2.read(bytes2)
        in2.close()

        val result2 = bucket + BucketFile(fileName+"-small", filePart.contentType.get, bytes2)
        result2.map {
          case Left(error) => throw new Exception("Error: " + error)
          case Right(success) => Logger.info("Saved the file" + resizedImg.getName)
        }
      }

    }
    addRecipeForm.bindFromRequest.fold(
      errors => {
        Logger.error(errors.toString)
        BadRequest(views.html.recipeForm(errors))
      },
      recipe => {
        println(recipe)
        Ok
      }
    )
  }
}
