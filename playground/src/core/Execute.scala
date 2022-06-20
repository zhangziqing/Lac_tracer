package core

import chisel3._
import chisel3.util._
import utils._
import Const._
import Const.ConstDefine._

class Execute extends Module {
    val io = IO(new Bundle {
        val exeIn = Input(new DecodeIO)
        val exeOut = Output(new ExecuteIO)
        val branchInfo = Output(new BranchInfo)
    })

    val opWidth = io.exeIn.opWidth
    val oprand1 = io.exeIn.oprand1
    val oprand2 = io.exeIn.oprand2

    val shOprand1 = MuxCase(oprand1 ,Array(
        (io.exeIn.aluOp === ALU_OP.sra && opWidth) -> SignExt(oprand1(31, 0),DATA_WIDTH),
        (io.exeIn.aluOp === ALU_OP.srl && opWidth) -> ZeroExt(oprand1(31, 0),DATA_WIDTH)
    ))
    val shamt = Mux(opWidth, oprand2(4,0),oprand2(5,0))
    val result = MuxLookup (
        io.exeIn.aluOp,0.U,Seq(
            ALU_OP.add -> (oprand1 + oprand2),
            ALU_OP.sub -> (oprand1 - oprand2),
            ALU_OP.xor -> (oprand1 ^ oprand2),
            ALU_OP.or  -> (oprand1 | oprand2),
            ALU_OP.and -> (oprand1 & oprand2),
            ALU_OP.lt  -> (oprand1.asSInt < oprand2.asSInt ).asUInt,
            ALU_OP.ltu -> (oprand1 < oprand2),
            ALU_OP.eq  -> (oprand1 === oprand2),
            ALU_OP.ne  -> (oprand1 =/= oprand2),
            ALU_OP.ge  -> (oprand1.asSInt >= oprand2.asSInt ).asUInt,
            ALU_OP.geu -> (oprand1 >= oprand2),
            ALU_OP.sll -> (oprand1 << shamt),
            ALU_OP.srl -> (shOprand1 >> shamt),
            ALU_OP.sra -> (shOprand1.asSInt >> shamt).asUInt, 

        )
    )
    val aluRes = Mux(opWidth,SignExt(result(31, 0), DATA_WIDTH), result)    
    io.exeOut.pc        := io.exeIn.pc
    io.exeOut.inst      := io.exeIn.inst
    io.exeOut.memOp     := io.exeIn.memOp
    io.exeOut.regWrAddr := io.exeIn.regWrAddr
    io.exeOut.regWrEn   := io.exeIn.regWrEn
    io.exeOut.storeData := io.exeIn.storeData
    
    val mduOp = io.exeIn.mduOp
    val mdu = Module(new MDU)
    mdu.io.opType := mduOp
    mdu.io.oprand1 := oprand1
    mdu.io.oprand2 := oprand2
    mdu.io.opWidth := opWidth
    val mduRes = mdu.io.result

    val arithmeticRes = Mux(io.exeIn.mduOp =/= MDU_OP.none, mduRes, aluRes)




    val btype = io.exeIn.branchInfo.bType(1).asBool()
    io.branchInfo.branchTarget := Mux(btype,
        aluRes,
        io.exeIn.branchInfo.branchTarget)
    io.branchInfo.bType := Mux(io.exeIn.branchInfo.bType =/= BranchType.b || aluRes === 1.U,io.exeIn.branchInfo.bType,0.U)
    io.exeOut.aluRes    := Mux(btype,
        io.exeIn.branchInfo.branchTarget,
        arithmeticRes
        )
}
class MDU extends Module {
    val io = IO(new Bundle {
        val oprand1 = Input(UInt(DATA_WIDTH.W))
        val oprand2 = Input(UInt(DATA_WIDTH.W))
        val opType  = Input(UInt(MDU_OP.MDU_OP_WIDTH.W))
        val opWidth = Input(Bool())
        val result  = Output(UInt(DATA_WIDTH.W))
    })
    val oprand1 = io.oprand1
    val oprand2 = io.oprand2
    val opType  = io.opType
    val div_res:UInt = MuxLookup(opType,0.U,Array(
        MDU_OP.div      -> (oprand1.asSInt / oprand2.asSInt).asUInt ,
        MDU_OP.divu     -> (oprand1 / oprand2) ,
        MDU_OP.rem      -> (oprand1.asSInt % oprand2.asSInt).asUInt ,
        MDU_OP.remu     -> (oprand1 % oprand2) ,
    ))
    
    val mul_res_final = MuxLookup(opType, 0.U, Array(
        MDU_OP.mul      -> (oprand1 * oprand2)(DATA_WIDTH - 1, 0),
        MDU_OP.mulh     -> (oprand1.asSInt * oprand2.asUInt).asUInt.head(DATA_WIDTH),
        MDU_OP.mulhsu   -> (oprand1.asSInt * oprand2.asSInt).asUInt.head(DATA_WIDTH),
        MDU_OP.mulhu    -> (oprand1 * oprand2).head(DATA_WIDTH)
    ))

    io.result := Mux(opType.head(2)(0).asBool(), div_res, mul_res_final)
}