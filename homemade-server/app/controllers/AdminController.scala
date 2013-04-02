package controllers

import play.api._
import play.api.mvc._
import models._
import play.api.data._
import play.api.data.Forms._
import org.bson.types.ObjectId

/**
 * Created with IntelliJ IDEA.
 * User: gguan
 * Date: 3/29/13
 * Time: 2:52 AM
 */
object AdminController extends Controller {

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

  def createRecipe = Action { implicit request =>
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
