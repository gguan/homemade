package models

import org.scala_tools.time.Imports._
import play.api.Play.current
import com.novus.salat._
import com.novus.salat.dao._
import com.novus.salat.annotations._
import com.mongodb.casbah.Imports._
import se.radley.plugin.salat._
import models.salatctx._
import org.joda.time.format.{ISODateTimeFormat, DateTimeFormatter}

case class Comment (
  author: ObjectId,
  content: String,
  date: DateTime
)

case class Step(
  content: String,
  photo: Option[String]
)

case class Recipe(
	id: ObjectId = new ObjectId,
  authorId: ObjectId,
	title: String,
	overview: Option[String] = None,
  photo: String,
  createdAt: DateTime = new DateTime,
  difficulty: Int = 0,
  saves: List[ObjectId] = List(),
  mades: List[ObjectId] = List(),
	ingredients: Set[Ingredient] = Set(),
  instructions: List[Step] = List(),
  tips: List[String] = List(),
  views: Int = 0,
	comments: List[Comment] = List(),
  isReviewed: Boolean = false
)


object Recipe extends ModelCompanion[Recipe, ObjectId] {

	val recipeCacheKey = "recp"

	val collection = mongoCollection("recipes")

	val dao = new SalatDAO[Recipe, ObjectId](collection = collection) {}

	/**
	 * Find one user by id
	 */
	def findById(id: ObjectId): Option[Recipe] = Recipe.findOneById(id)

	def list(page: Int = 0, pageSize: Int = 20): Page[Recipe] = {
		val where = MongoDBObject.empty
		val totalRows = count(where)
		val offset = pageSize * page
		val recipes = Recipe.find(where).limit(pageSize).skip(offset)
		Page(recipes.toSeq, page, offset, totalRows)
	}

	def listByUser(uid: ObjectId, page: Int = 0, pageSize: Int = 20): Page[Recipe] = {
		val where = MongoDBObject("author_id" -> uid)
		val totalRows = count(where)
		val offset = pageSize * page
		val recipes = Recipe.find(where).limit(pageSize).skip(offset)
		Page(recipes.toSeq, page, offset, totalRows)
	}

	/**
	 * Remove a user from database
	 */
	def delete(id: ObjectId) = {
		Recipe.remove(MongoDBObject("_id" -> id))
	}

  def latestRecipes(page: Int = 0, pageSize: Int = 5, date: String): List[Recipe] = {
    val formatter: DateTimeFormatter = ISODateTimeFormat.dateTime()
    val dt: DateTime = formatter.parseDateTime(date)
    val where = MongoDBObject("createdAt" -> MongoDBObject("$gt" -> dt))
    val offset = pageSize * page
    val recipes = Recipe.find(where).sort(MongoDBObject("createdAt" -> 1)).limit(pageSize).skip(offset)
    recipes.toList
  }


}