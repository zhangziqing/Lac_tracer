package core

import chisel3._
import chisel3.util._
import utils.{DecodeIO,InstFetchIO,ReadPort,WritePort}
import Const.ConstDefine._ 
import ISA.RiscV64._
import Const.BranchType
import Const.MDU_OP
import Const.ALU_OP

class Decode extends Module {
    val io = IO(new Bundle {
        val inst         = Input(UInt(INST_WIDTH.W))
        val pc           = Input(UInt(DATA_WIDTH.W))
        val decodeIn     = Input(new InstFetchIO)
        val decodeOut    = Output(new DecodeIO)
        val reg1         = new ReadPort(DATA_WIDTH,REG_WIDTH)
        val reg2         = new ReadPort(DATA_WIDTH,REG_WIDTH)
    })

    val inst    = io.inst
    val pc      = io.pc 

    
    val (r1E:Bool)::(r2E:Bool)::(op1:UInt)::(op2:UInt)::(rWE:Bool)::(branchType:UInt)::(memOp:UInt)::(aluOp:UInt)::(mduOp:UInt)::(opWidth:Bool)::Nil = ListLookup(
        inst,
        instDecodeDefault,
        instDecode
    )
    val mduOppp::isMExtension::Nil = ListLookup(inst, List(MDU_OP.none, 0.B),
        Array(
            Instruction.mul      -> List(MDU_OP.mul,    1.B),
            Instruction.mulh     -> List(MDU_OP.mulh,   1.B),
            Instruction.mulhsu   -> List(MDU_OP.mulhsu, 1.B),
            Instruction.mulhu    -> List(MDU_OP.mulhu,  1.B),
            Instruction.mulw     -> List(MDU_OP.mul,    1.B),
            Instruction.div      -> List(MDU_OP.div,    1.B),

        )
    )
    io.reg1.en      := r1E
    io.reg1.addr    := getReg1(inst)
    io.reg2.en      := r2E
    io.reg2.addr    := getReg2(inst)

    val reg1data = io.reg1.data
    val reg2data = io.reg2.data
    
    io.decodeOut.inst   := inst
    io.decodeOut.pc     := pc
    io.decodeOut.aluOp  := aluOp
    
    io.decodeOut.memOp  := memOp
    io.decodeOut.regWrAddr  := getRegW(inst)
    io.decodeOut.regWrEn    := rWE

    io.decodeOut.oprand1 := getOp(op1, pc, reg1data, inst)
    io.decodeOut.oprand2 := getOp(op2, pc, reg2data, inst)
    io.decodeOut.storeData := io.reg2.data

    io.decodeOut.opWidth    := opWidth
    io.decodeOut.mduOp      := mduOp

    io.decodeOut.branchInfo.bType := branchType
    io.decodeOut.branchInfo.branchTarget := Mux(branchType === BranchType.b,
        getBranchPc(inst,pc),
        io.decodeIn.branchInfo.branchTarget)
}