package utils

import chisel3._
import chisel3.util._

object SignExt {
  def apply(src:UInt,width:Int):UInt={
    val srcWidth = src.getWidth
    val res = if(width <= srcWidth) src else Fill(width - srcWidth, src(srcWidth - 1)) ## src 
    res 
  }
}
object ZeroExt {
  def apply (src :UInt, width:Int):UInt = {
    val srcWidth = src.getWidth
    val res = if (width <= srcWidth) src else Fill(width - srcWidth, 0.U) ## src
    res
  }
}
