package models

import org.scala_tools.time.Imports._
import play.api.Play.current
import com.novus.salat.dao._
import com.mongodb.casbah.Imports._
import se.radley.plugin.salat._
import models.salatctx._
import securesocial.core.{UserId, Identity, PasswordInfo}
import scala.collection.mutable.Set


case class User(
	id: ObjectId = new ObjectId,
	displayName: String,
	firstName: Option[String] = None,
	lastName: Option[String] = None,
  avatar: Option[String] = Some(User.defaultAvatar),
  bio: Option[String] = None,
  recipes: List[ObjectId] = List(),
  doneRecipes: List[ObjectId] = List(),
  ingredients: Set[ObjectId] = Set(),
  // system properties
	email: Option[String] = None,
	password: Option[PasswordInfo] = None,
  active: Boolean = true,
	emailValidated: Boolean = false,
	created: DateTime = new DateTime,
	lastAccess: DateTime = new DateTime,
	linkedAccounts: Set[UserId] = Set(),
	permission: Permission = NormalUser,
  accessToken: Option[String] = None
)

object User extends ModelCompanion[User, ObjectId] {

	val defaultAvatar = "http://www.gravatar.com/avatar/00000000000000000000000000000000?s=160"

	val userCacheKey = "Usr"

	val collection = mongoCollection("users")

	val dao = new SalatDAO[User, ObjectId](collection = collection) {}


  def findById(id: String): Option[User] = findById(new ObjectId(id))
  /**
	 * Find one user by id
	 */
	def findById(id: ObjectId): Option[User] = User.findOneById(id)

	/**
	 * Find one user by provider key and provider id
	 */
	def findByUserIdentity(userId: UserId) = User.findOne(
	 	MongoDBObject("linkedAccounts._id" -> userId.id, "linkedAccounts.providerId" -> userId.providerId)
	)

	/**
	 * Find one user by email and provider id
	 */
	def findByEmailAndProvider(email: String, providerId: String) = User.findOne(
	 	MongoDBObject("email" -> email, "linkedAccounts.providerId" -> providerId)
	)

	/**
	 * Update user last access datetime
	 */
	def updateLastAccess(id: ObjectId) = User.update(
	 	q = MongoDBObject("_id" -> id),
	 	o = MongoDBObject("$set" -> MongoDBObject("lastAccess" -> DateTime.now)),
	 	upsert = false,
	 	multi = false,
	 	wc = User.dao.collection.writeConcern
  )

	/**
	 * Retrive info from SocialUser and store user object in db
	 */
	def saveSocialUser(socialUser: Identity) = {
	 	val user = User(
	 		displayName = socialUser.firstName + socialUser.lastName,
	 		firstName = Some(socialUser.firstName),
	 		lastName = Some(socialUser.lastName),
	 		email = socialUser.email,
	 		avatar = socialUser.avatarUrl,
	 		password = socialUser.passwordInfo)
	 	user.linkedAccounts += socialUser.id
	 	User.insert(user)
	 	user.id
	}



  /**
   * Link a new account to current user account
   */
  def linkedSocialAccount(user: User, socialUser: Identity) = {
    user.linkedAccounts += socialUser.id
    User.save(user.copy())
  }

	/**
	 * Diable a user, set active to false
	 */
	def disable(id: ObjectId, disabled: Boolean) = User.update(
	 	q = MongoDBObject("_id" -> id),
	 	o = MongoDBObject("$set" -> MongoDBObject("active" -> disabled)),
	 	upsert = false,
	 	multi = false,
	 	wc = User.dao.collection.writeConcern)

	/**
	 * Remove a user from database
	 */
	def delete(id: ObjectId) = {
	 	User.remove(MongoDBObject("_id" -> id))
	}

  /**
   * Update a user
   */
	def updateUser(user: User) = {
	 	User.save(user.copy())
	}

	def list(page: Int = 0, pageSize: Int = 10, orderBy: String = "username", filter: String = ""): Page[User] = {
	 	val where = if (filter == "") MongoDBObject.empty else MongoDBObject("username" ->(""".*"""+filter+""".*""").r)
	 	val ascDesc = if (orderBy == "") -1 else 1
	 	val order = MongoDBObject(orderBy -> ascDesc)

	 	val totalRows = count(where)
	 	val offset = pageSize * page
	 	val users = find(where).sort(order).limit(pageSize).skip(offset)

	 	Page(users.toSeq, page, pageSize, totalRows)
	}



}