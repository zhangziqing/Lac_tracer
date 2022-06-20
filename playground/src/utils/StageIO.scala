package utils

import chisel3._ 
import Const.ConstDefine._
import Const._
import utils._

class StageIO extends Bundle {
    def reset() : UInt = {
        0.U(this.getWidth.W)
    }
}

class InstFetchIO extends StageIO {
    // val inst    = UInt(INST_WIDTH.W)
    val branchInfo = new BranchInfo
}

class DecodeIO extends StageIO {
    val inst        = UInt(INST_WIDTH.W)
    val pc          = UInt(DATA_WIDTH.W)
    val regWrAddr   = UInt(REG_WIDTH.W)
    val regWrEn     = Bool()
    val oprand1     = UInt(DATA_WIDTH.W)
    val oprand2     = UInt(DATA_WIDTH.W)
    val storeData   = UInt(DATA_WIDTH.W)
    val aluOp       = UInt(ALU_OP.ALU_OP_WIDTH.W)
    val memOp       = UInt(MEM_OP.MEM_OP_WIDTH.W)
    val mduOp       = UInt(MDU_OP.MDU_OP_WIDTH.W)
    val opWidth     = Bool()
    val branchInfo  = new BranchInfo
}

class ExecuteIO extends StageIO {
    val inst        = UInt(INST_WIDTH.W)
    val pc          = UInt(DATA_WIDTH.W)
    val storeData   = UInt(DATA_WIDTH.W)
    val aluRes      = UInt(DATA_WIDTH.W)
    val memOp       = UInt(MEM_OP.MEM_OP_WIDTH.W)
    val regWrAddr   = UInt(REG_WIDTH.W)
    val regWrEn     = Bool()
}

class MemoryIO extends StageIO {
    val inst        = UInt(INST_WIDTH.W)
    val pc          = UInt(DATA_WIDTH.W)
    val regWrAddr   = UInt(REG_WIDTH.W)
    val regWrEn     = Bool()
    val regWrData   = UInt(DATA_WIDTH.W)
}

class WriteBackIO extends StageIO {
    val inst        = UInt(INST_WIDTH.W)
    val pc          = UInt(DATA_WIDTH.W)
    val regWrdata   = UInt(DATA_WIDTH.W)
}