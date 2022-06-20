package utils

import chisel3._
import chisel3.util._
import Const.ConstDefine._

class BranchInfo extends Bundle {
    val bType = UInt(2.W)
    val branchTarget = UInt(DATA_WIDTH.W)
} 