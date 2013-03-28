package controllers

import play.api._
import play.api.mvc._
import models._

object Application extends Controller {

  def index = Action {
    val user = User(displayName =  "Guan Guan")
//    User.insert(user)
    Ok(views.html.index("Your new application is ready."))
  }

}