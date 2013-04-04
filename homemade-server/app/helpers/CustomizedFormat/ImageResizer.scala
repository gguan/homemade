package helpers.CustomizedFormat

import java.awt.image.BufferedImage
import javax.imageio.ImageIO
import org.imgscalr.Scalr
import java.io.File
import util.Random

/**
 * Created with IntelliJ IDEA.
 * User: gguan
 * Date: 4/3/13
 * Time: 3:23 AM
 */
object ImageResizer {

  def resize(file: File, width: Int, height: Int, mode: Scalr.Mode = Scalr.Mode.AUTOMATIC, method: Scalr.Method = Scalr.Method.AUTOMATIC): File = {
    val image = ImageIO.read(file)
    //val resized = Resizer.resize(image, method, mode, width, height, Resizer.OP_ANTIALIAS)
    val resized = Scalr.resize(image, method, mode, width, height)
    val ext = if (image.getType == BufferedImage.TYPE_INT_RGB) "jpg" else "png"
    val tmp = File.createTempFile(Random.nextString(20), ext)
    ImageIO.write(resized, ext.toUpperCase, tmp)
    tmp
  }

//  def resize2(file: File) = {
//    val img: BufferedImage = ImageIO.read(file)
//
//    val thumbnail = Scalr.resize(bufferedImage, 400)
//
//    val byteArrayOutputStream: ByteArrayOutputStream = new ByteArrayOutputStream()
//    ImageIO.write(thumbnail, "jpg", byteArrayOutputStream)
//    inputStream: InputStream = new ByteArrayInputStream(byteArrayOutputStream.toByteArray())
//  }

}
