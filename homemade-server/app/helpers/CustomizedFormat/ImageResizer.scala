package helpers.CustomizedFormat

import java.awt.image.BufferedImage
import javax.imageio.ImageIO
import org.imgscalr.Scalr
import java.io.File
import util.Random
import play.api.libs.Files.TemporaryFile

/**
 * Created with IntelliJ IDEA.
 * User: gguan
 * Date: 4/3/13
 * Time: 3:23 AM
 */
object ImageResizer {

  def resize(file: File, width: Int, height: Int, mode: Scalr.Mode = Scalr.Mode.AUTOMATIC, method: Scalr.Method = Scalr.Method.ULTRA_QUALITY): File = {
    val image = ImageIO.read(file)
    //val resized = Resizer.resize(image, method, mode, width, height, Resizer.OP_ANTIALIAS)
    val resized = Scalr.resize(image, method, mode, width, height)
    val ext = if (image.getType == BufferedImage.TYPE_INT_RGB) "jpg" else "png"
    val tmp = File.createTempFile(Random.nextString(20), ext)
    ImageIO.write(resized, ext.toUpperCase, tmp)
    TemporaryFile(tmp).moveTo(new File("/Users/gguan/Desktop/aaa"))
    tmp
  }

//  def resize2(file: File) = {
//    BufferedImage img = ImageIO.read(file)
//    ImageResizer scaledImg = img.getScaledInstance(400, 400, Image.)
//  }

}
