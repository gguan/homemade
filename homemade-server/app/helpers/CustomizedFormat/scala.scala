package helpers

import play.api.data._
import play.api.data.format._
import play.api.data.format.Formats._
import play.api.data.Forms._
import com.mongodb.casbah.Imports._


/** This object defines several default formatters. */
object Formats {

  /**
   * Default formatter for the `Double` type.
   */
  implicit def doubleFormat: Formatter[Double] = new Formatter[Double] {

    override val format = Some("format.real", Nil)

    def bind(key: String, data: Map[String, String]) =
      parsing(_.toDouble, "error.real", Nil)(key, data)

    def unbind(key: String, value: Double) = Map(key -> value.toString)
  }

  def jodaDateTimeFormat(pattern: String): Formatter[org.joda.time.DateTime] = new Formatter[org.joda.time.DateTime] {

    import org.joda.time.DateTime

    override val format = Some("format.date", Seq(pattern))

    def bind(key: String, data: Map[String, String]) = {

      stringFormat.bind(key, data).right.flatMap { s =>
        scala.util.control.Exception.allCatch[DateTime]
          .either(DateTime.parse(s, org.joda.time.format.DateTimeFormat.forPattern(pattern)))
          .left.map(e => Seq(FormError(key, "error.date", Nil)))
      }
    }

    def unbind(key: String, value: DateTime) = Map(key -> value.toString(pattern))
  }

  /**
   * Helper for formatters binders
   * @param parse Function parsing a String value into a T value, throwing an exception in case of failure
   * @param error Error to set in case of parsing failure
   * @param key Key name of the field to parse
   * @param data Field data
   */
  private def parsing[T](parse: String => T, errMsg: String, errArgs: Seq[Any])(key: String, data: Map[String, String]): Either[Seq[FormError], T] = {
    stringFormat.bind(key, data).right.flatMap { s =>
      util.control.Exception.allCatch[T]
        .either(parse(s))
        .left.map(e => Seq(FormError(key, errMsg, errArgs)))
    }
  }

}