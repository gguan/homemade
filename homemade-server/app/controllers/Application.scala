package controllers

import _root_.models.Recipe
import play.api._
import play.api.mvc._
import models._
import play.api.libs.json.Json
import play.api.libs.json._
import play.api.libs.functional.syntax._
import play.api.Play.current

object Application extends Controller {
  val amazonBucket = Play.application.configuration.getString("aws.photoBucket").getOrElse("test.photo")
  def photoUrl(p: String): String = "https://s3.amazonaws.com/" + amazonBucket + "/" + p
  def stepUrl(p: Option[String]): String = p match {
    case Some(s) => "https://s3.amazonaws.com/" + amazonBucket + "/" + s
    case None => ""
  }

  def index = Action {
    val user = User(displayName =  "Guan Guan")
//    User.insert(user)
    Ok(views.html.index("Your new application is ready."))
  }


  def recipes(date: String, pageSize: Int = 5, page: Int = 0) = Action {
    val recipes = Recipe.latestRecipes(page, pageSize, date)

    println(recipes)
    val recipesJson = recipes map { r =>

      val ingredients = r.ingredients map { ing =>
        Json.obj(
          "name" -> ing.name,
          "amount" -> ing.amount
        )
      }

      val steps = r.instructions map { s =>
        Json.obj(
          "content" -> s.content,
          "image" -> stepUrl(s.photo)
        )
      }

      Json.obj(
        "sid" -> r.id.toString,
        "author_id" -> r.authorId.toString,
        "title" -> r.title,
        "overview" -> r.overview.get,
        "photoUrl" -> photoUrl(r.photo),
        "date" -> r.createdAt,
        "difficulty" -> r.difficulty,
        "save_count" -> r.saves.size,
        "made_count" -> r.mades.size,
        "ingredients" -> Json.toJson(ingredients),
        "instructions" -> Json.toJson(steps),
        "tips" -> Json.toJson(r.tips)
      )
    }

    Ok(Json.toJson(recipesJson))
  }

}