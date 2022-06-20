package core

import chisel3._
import Const.ConstDefine._
import utils._
import Const.MDU_OP

class Core extends Module {
    val io = IO(new Bundle {
        // val instMem = new ReadPort(INST_WIDTH, DATA_WIDTH)
        val res = Output(UInt(DATA_WIDTH.W))
        //val memRead = new ReadPort(DATA_WIDTH,DATA_WIDTH)
        //val memWrite= new WritePort(DATA_WIDTH,DATA_WIDTH,true)
    })

    val instFetch   = Module(new InstFetch)
    val decode      = Module(new Decode)  
    val execute     = Module(new Execute)
    val memory      = Module(new Memory)
    val writeBack   = Module(new WriteBack)
    val regFile     = Module(new RegFile)

    // io.instMem.addr         := instFetch.io.pc 
    // io.instMem.en           := instFetch.io.fetchEn
    // val inst = io.instMem.data
    val instMem = Module(new PmemManager);
    instMem.io.memRead.addr := instFetch.io.pc
    val inst = instMem.io.memRead.data
    when(!reset.asBool()){
        instMem.io.memRead.en := true.B 
    }.otherwise{
        instMem.io.memRead.en := false.B
    }

    instMem.io.memWrite.addr := 0.U
    instMem.io.memWrite.data := 0.U
    instMem.io.memWrite.en   := 0.B
    instMem.io.memWrite.wrSize.get := 0.U

    instFetch.io.branchInfo <> execute.io.branchInfo
    instFetch.io.ifOut  <> decode.io.decodeIn
    decode.io.inst      := inst
    decode.io.reg1      <> regFile.io.reg1
    decode.io.reg2      <> regFile.io.reg2
    decode.io.pc        := instFetch.io.pc

    execute.io.exeIn    <> decode.io.decodeOut

    memory.io.memIn     <> execute.io.exeOut
    //memory.io.memRead   <> io.memRead
    //memory.io.memWrite  <> io.memWrite

    writeBack.io.regw   <> regFile.io.regw
    writeBack.io.wbIn   <> memory.io.memOut

    io.res := writeBack.io.wbOut.regWrdata


    //debug
    val dpi = Module(new Trap)
    // dpi.io.inst := io.instMem.data
    dpi.io.inst := instMem.io.memRead.data
    dpi.io.pc   := instMem.io.memRead.addr


}