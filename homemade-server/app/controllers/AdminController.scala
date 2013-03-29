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
      "difficulty" -> number(min = 1, max = 5),

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
      )
    )

    {
      (title, overview, difficulty, ingredients, instructions) =>
        Recipe(title = title, overview = overview, difficulty = difficulty, ingredients = ingredients.toSet, instructions = instructions, authorId = new ObjectId, photo = "")
    }
    {
      recipe => Some(recipe.title, recipe.overview, recipe.difficulty, recipe.ingredients.toSeq, recipe.instructions)
    }
  )

  def addRecipe = Action {
    Ok(views.html.recipeForm(addRecipeForm))
  }

  def createRecipe = Action {
    Ok
  }
}
