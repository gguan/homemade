package models

import com.novus.salat.{TypeHintFrequency, StringTypeHintStrategy, Context}
import play.api.Play
import play.api.Play.current

package object salatctx {
  /**
   * Here is where we define the custom Play serialization context, including the Play classloader.
   */
  implicit val context = {
   	val ctx = new Context {
   		val name = "play-context"
   		override val typeHintStrategy = StringTypeHintStrategy(when = TypeHintFrequency.Always, typeHint = "_t")
   	}
   	ctx.registerClassLoader(Play.classloader)
   	ctx.registerGlobalKeyOverride(remapThis = "id", toThisInstead = "_id")
   	ctx
  }

 }