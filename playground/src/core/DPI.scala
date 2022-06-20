package core

import chisel3._
import chisel3.util._
import Const.ConstDefine._
import utils._
import ISA.RiscV64

class Trap extends BlackBox {
    val io = IO(new Bundle {
        val inst = Input(UInt(INST_WIDTH.W))
        val pc   = Input(UInt(DATA_WIDTH.W))
    })
    
}
class PmemManager extends BlackBox {
    val io = IO(new Bundle {
        val memRead     = Flipped(new ReadPort(DATA_WIDTH,DATA_WIDTH))
        val memWrite    = Flipped(new WritePort(DATA_WIDTH,DATA_WIDTH,true)) 
    })
}