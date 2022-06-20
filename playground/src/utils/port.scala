package utils

import chisel3.Bundle
import Chisel.{UInt,Bool}
import chisel3.Output
import chisel3.Input
import chisel3._

class ReadPort(data_width:Int, addr_width:Int) extends Bundle {
    val data : UInt = Input(UInt(data_width.W))
    val addr : UInt = Output(UInt(addr_width.W))
    val en   : Bool = Output(Bool())
}
class WritePort(data_width:Int, addr_width:Int,hasMask:Boolean = false) extends Bundle {
    val data : UInt = Output(UInt(data_width.W))
    val addr : UInt = Output(UInt(addr_width.W))
    val en   : Bool = Output(Bool())
    val wrSize = if(hasMask)Some(Output(UInt(4.W)))else None
}