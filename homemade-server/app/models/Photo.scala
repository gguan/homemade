package models

import play.api.Play.current
import com.novus.salat._
import com.novus.salat.dao._
import com.mongodb.casbah.Imports._
import se.radley.plugin.salat._
import models.salatctx._
import securesocial.core.{UserId, SocialUser, PasswordInfo}

case class Photo(
	s3Key: String,
	s: String,
	m: String,
	l: String,
	user: ObjectId
)