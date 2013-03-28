package models

import play.api.Play.current
import com.novus.salat._
import com.novus.salat.dao._
import com.mongodb.casbah.Imports._
import se.radley.plugin.salat._
import models.salatctx._
import org.bson.types.ObjectId

case class Ingredient(
  id: ObjectId = new ObjectId,
  name: String,
  image: Option[Photo],
  amount: Option[String]
)

object Ingredient extends ModelCompanion[Ingredient, ObjectId] {

	val CouponCacheKey = "Ingr"

 	val collection = mongoCollection("ingreidents")

	val dao = new SalatDAO[Ingredient, ObjectId](collection = collection) {}

  def findById(id: ObjectId): Option[Ingredient] = Ingredient.findOneById(id)
}