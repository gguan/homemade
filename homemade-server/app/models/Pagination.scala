package models

case class Page[+A](items: Seq[A], cursor: Int, count: Int, total: Long) {
  lazy val prev = Option(cursor - count).filter(_ >= 0).getOrElse(0)
  lazy val next = Option(cursor + count).filter(_ <= total).getOrElse(total)
}

