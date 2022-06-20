package core

import chisel3._
import chisel3.util._
import Const.ConstDefine._
import utils._
import Const.MEM_OP
import scopt.Read

class Memory extends Module {
    val io = IO(new Bundle {
        val memIn   = Input(new ExecuteIO)
        val memOut  = Output(new MemoryIO)
        //val memRead = new ReadPort(DATA_WIDTH, DATA_WIDTH)
        //val memWrite= new WritePort(DATA_WIDTH, DATA_WIDTH, true)
    })
    val memRead =   Wire(new ReadPort(DATA_WIDTH, DATA_WIDTH))
    val memWrite =  Wire(new WritePort(DATA_WIDTH, DATA_WIDTH, true))

    val mem = Module(new PmemManager)

    mem.io.memRead      <> memRead
    mem.io.memWrite     <> memWrite

    val memOp = io.memIn.memOp
    val memReturnData = memRead.data
    val (rdEn:Bool)::(wrEn:Bool)::(memReadData:UInt)::(wrSize:UInt)::Nil = ListLookup(memOp,
        List(0.B,0.B,0.U,0.U),
        Array(
            BitPat(MEM_OP.none)  -> List(0.B,0.B,0.U,0.U),
            BitPat(MEM_OP.lb)   -> List(1.B, 0.B, SignExt(memReturnData(7, 0),  DATA_WIDTH), 0.U),
            BitPat(MEM_OP.lbu)  -> List(1.B, 0.B, memReturnData(7, 0),                       0.U),
            BitPat(MEM_OP.lh)   -> List(1.B, 0.B, SignExt(memReturnData(15, 0), DATA_WIDTH), 0.U),
            BitPat(MEM_OP.lhu)  -> List(1.B, 0.B, memReturnData(15, 0),                      0.U),
            BitPat(MEM_OP.lw)   -> List(1.B, 0.B, SignExt(memReturnData(31, 0), DATA_WIDTH), 0.U),
            BitPat(MEM_OP.lwu)  -> List(1.B, 0.B, memReturnData(31, 0),                      0.U),
            BitPat(MEM_OP.ld)   -> List(1.B, 0.B, SignExt(memReturnData(63, 0), DATA_WIDTH), 0.U),
            BitPat(MEM_OP.sb)   -> List(0.B, 1.B, 0.U,                                       1.U),
            BitPat(MEM_OP.sh)   -> List(0.B, 1.B, 0.U,                                       2.U),
            BitPat(MEM_OP.sw)   -> List(0.B, 1.B, 0.U,                                       4.U),
            BitPat(MEM_OP.sd)   -> List(0.B, 1.B, 0.U,                                       8.U),
        )
    )

    // io.memWrite.data    := io.memIn.storeData
    // io.memWrite.addr    := io.memIn.aluRes
    // io.memWrite.en      := wrEn
    // io.memWrite.wrSize.get := wrSize

    // io.memRead.addr     := io.memIn.aluRes
    // io.memRead.en       := rdEn

   
    memWrite.data       := io.memIn.storeData
    memWrite.addr       := io.memIn.aluRes
    memWrite.en         := wrEn
    memWrite.wrSize.get := wrSize

    memRead.addr        := io.memIn.aluRes
    memRead.en          := rdEn
    io.memOut.inst              := io.memIn.inst
    io.memOut.pc                := io.memIn.pc
    io.memOut.regWrAddr         := io.memIn.regWrAddr
    io.memOut.regWrEn           := io.memIn.regWrEn
    io.memOut.regWrData         := Mux(memOp === MEM_OP.none, io.memIn.aluRes, memReadData)
}
