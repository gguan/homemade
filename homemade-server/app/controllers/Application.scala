package controllers

import _root_.models.Recipe
import play.api._
import play.api.mvc._
import models._
import play.api.libs.json.Json
import play.api.libs.json._
import play.api.libs.functional.syntax._

object Application extends Controller {

  def index = Action {
    val user = User(displayName =  "Guan Guan")
//    User.insert(user)
    Ok(views.html.index("Your new application is ready."))
  }

  implicit val personReads = Json.reads[Recipe]
  implicit val personWrites = Json.reads[Recipe]

  def recipes(date: String, pageSize: Int = 5, page: Int = 0) = Action {
    val recipes = Recipe.latestRecipes(page, pageSize, date)
    Ok(Json.toJson(recipes))
  }

}