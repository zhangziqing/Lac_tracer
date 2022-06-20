package core

import chisel3._
import chisel3.util._
import utils._
import Const.ConstDefine._


class WriteBack extends Module {
    val io = IO(new Bundle {
        val regw    = new WritePort(DATA_WIDTH, REG_WIDTH)
        val wbIn    = Input(new MemoryIO)
        val wbOut   = Output(new WriteBackIO) 
    })

    io.regw.addr := io.wbIn.regWrAddr
    io.regw.data := io.wbIn.regWrData 
    io.regw.en   := io.wbIn.regWrEn

    io.wbOut.pc     := io.wbIn.pc
    io.wbOut.inst   := io.wbIn.inst
    io.wbOut.regWrdata  := io.wbIn.regWrData
}
