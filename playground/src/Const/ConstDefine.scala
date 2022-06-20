package Const;

import chisel3._
import chisel3.util.log2Ceil
import chisel3.util.Enum

object ConstDefine {
    val INST_WIDTH:Int = 32;
    val DATA_WIDTH:Int = 64;
    val REG_WIDTH:Int = 5;
}

object ALU_OP {
    val ALU_OPERATION_NUM = 15
    val ALU_OP_WIDTH = log2Ceil(ALU_OPERATION_NUM)
    val add::sub::lt::ltu::ge::geu::ne::eq::and::or::xor::sra::srl::sll::nul::Nil = Enum(ALU_OPERATION_NUM)
}

object MEM_OP {
    val MEM_OP_NUM = 12
    val MEM_OP_WIDTH = log2Ceil(MEM_OP_NUM)
    val lb::lh::lw::ld::lbu::lhu::lwu::sb::sh::sw::sd::none::Nil = Enum(MEM_OP_NUM)
}
object BranchType {
    val n = 0.U
    val b = 1.U
    val j = 2.U
    val jr = 3.U
}

object MDU_OP {
    val mul::mulh::mulhsu::mulhu::div::divu::rem::remu::none::Nil=Enum(9)
    val MDU_OP_WIDTH = 4
}

object ISADefine {
    val RESET_VECTOR = "h80000000".U(ConstDefine.DATA_WIDTH.W);
}