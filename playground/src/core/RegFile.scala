package core

import chisel3._
import utils._
import Const.ConstDefine._

class RegFile extends Module {
    val io = IO(new Bundle{
        val reg1 = Flipped(new ReadPort (DATA_WIDTH, REG_WIDTH))
        val reg2 = Flipped(new ReadPort (DATA_WIDTH, REG_WIDTH))
        val regw = Flipped(new WritePort(DATA_WIDTH, REG_WIDTH)) 
    })
    
    val  regFile = RegInit(VecInit(Seq.fill(32)(0.U(DATA_WIDTH.W))))

    io.reg1.data := Mux(io.reg1.en, regFile(io.reg1.addr), 0.U(DATA_WIDTH.W))
    io.reg2.data := Mux(io.reg2.en, regFile(io.reg2.addr), 0.U(DATA_WIDTH.W))
    val regW =  io.regw.addr
    when(io.regw.en && regW =/= 0.U){
        regFile(io.regw.addr) := io.regw.data
    }
}