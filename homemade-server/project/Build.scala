import sbt._
import Keys._
import play.Project._

object ApplicationBuild extends Build {

  val appName         = "homemade-server"
  val appVersion      = "1.0-SNAPSHOT"

  val appDependencies = Seq(
    // Add your project dependencies here,
    "se.radley" %% "play-plugins-salat" % "1.2",
    "jp.t2v" %% "play2.auth" % "0.9",
    "securesocial" %% "securesocial" % "master",
    "org.scala-tools.time" % "time_2.8.0" % "0.2",
    "nl.rhinofly" %% "api-s3" % "2.6.1",
    "se.digiplant" %% "play-scalr" % "1.0"
  )


  val main = play.Project(appName, appVersion, appDependencies).settings(
    // Add your own project settings here
    lessEntryPoints <<= baseDirectory(_ / "app" / "assets" / "stylesheets" ** "main.less"),
    routesImport += "se.radley.plugin.salat.Binders._",
    templatesImport += "org.bson.types.ObjectId",
    resolvers ++= Seq(
      "OSS Sonatype Snapshots" at "http://oss.sonatype.org/content/repositories/snapshots/",
      "Rhinofly Internal Repository" at "http://maven-repository.rhinofly.net:8081/artifactory/libs-release-local",
      "Local Play Repository" at "file://usr/local/Cellar/play/2.1.0/libexec/repository/local",
      "sonatype-snapshots" at "https://oss.sonatype.org/content/repositories/snapshots/"
    )
  )

}
