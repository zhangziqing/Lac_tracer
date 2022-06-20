package core

import chisel3._
import chisel3.util._
import Const.ConstDefine._
import Const.ISADefine._
import utils.BranchInfo
import utils.InstFetchIO
import Const.BranchType

class InstFetch extends Module{
    val io = IO(new Bundle{
        val pc  = Output(UInt(DATA_WIDTH.W))
        // val thispc = Output(UInt(DATA_WIDTH.W))
        val fetchEn = Output(Bool())
        val branchInfo = Input(new BranchInfo)
        val ifOut = Output(new InstFetchIO)
    })

    val pc = RegInit(RESET_VECTOR)
    val snpc = pc + 4.U
    val nextPC = Mux( 
        io.branchInfo.bType === BranchType.n ,
        snpc,
        io.branchInfo.branchTarget
    )
    io.ifOut.branchInfo.bType := BranchType.n
    io.ifOut.branchInfo.branchTarget := snpc
    pc := nextPC
    io.fetchEn := true.B
    io.pc := pc
}