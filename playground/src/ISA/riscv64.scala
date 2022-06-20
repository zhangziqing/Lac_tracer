package ISA

import chisel3._
import chisel3.util._
import Const.ConstDefine._
import Const._

object RiscV64 {
    object Instruction{
        val lui     = BitPat("b???????_?????_????? ???_?????_01101_11")
        val auipc   = BitPat("b???????_?????_?????_???_?????_00101_11")
        val jal     = BitPat("b???????_?????_?????_???_?????_11011_11")
        val jalr    = BitPat("b???????_?????_?????_000_?????_11001_11")
        val beq     = BitPat("b???????_?????_?????_000_?????_11000_11")
        val bne     = BitPat("b???????_?????_?????_001_?????_11000_11")
        val blt     = BitPat("b???????_?????_?????_100_?????_11000_11")
        val bge     = BitPat("b???????_?????_?????_101_?????_11000_11")
        val bltu    = BitPat("b???????_?????_?????_110_?????_11000_11")
        val bgeu    = BitPat("b???????_?????_?????_111_?????_11000_11")
        val lb      = BitPat("b???????_?????_?????_000_?????_00000_11")
        val lh      = BitPat("b???????_?????_?????_001_?????_00000_11")
        val lw      = BitPat("b???????_?????_?????_010_?????_00000_11")
        val ld      = BitPat("b???????_?????_?????_011_?????_00000_11")
        val lbu     = BitPat("b???????_?????_?????_100_?????_00000_11")
        val lhu     = BitPat("b???????_?????_?????_101_?????_00000_11")
        val lwu     = BitPat("b???????_?????_?????_110_?????_00000_11")
        val sb      = BitPat("b???????_?????_?????_000_?????_01000_11")
        val sh      = BitPat("b???????_?????_?????_001_?????_01000_11")
        val sw      = BitPat("b???????_?????_?????_010_?????_01000_11")
        val sd      = BitPat("b???????_?????_?????_011_?????_01000_11")
        val addi    = BitPat("b???????_?????_?????_000_?????_00100_11")
        val slti    = BitPat("b???????_?????_?????_010_?????_00100_11")
        val sltiu   = BitPat("b???????_?????_?????_011_?????_00100_11")
        val xori    = BitPat("b???????_?????_?????_100_?????_00100_11")
        val ori     = BitPat("b???????_?????_?????_110_?????_00100_11")
        val andi    = BitPat("b???????_?????_?????_111_?????_00100_11")
        val slli    = BitPat("b000000?_?????_?????_001_?????_00100_11")
        val srli    = BitPat("b000000?_?????_?????_101_?????_00100_11")
        val srai    = BitPat("b010000?_?????_?????_101_?????_00100_11")
        val add     = BitPat("b0000000_?????_?????_000_?????_01100_11")
        val sub     = BitPat("b0100000_?????_?????_000_?????_01100_11")
        val sll     = BitPat("b0000000_?????_?????_001_?????_01100_11")
        val slt     = BitPat("b0000000_?????_?????_010_?????_01100_11")
        val sltu    = BitPat("b0000000_?????_?????_011_?????_01100_11")
        val xor     = BitPat("b0000000_?????_?????_100_?????_01100_11")
        val srl     = BitPat("b0000000_?????_?????_101_?????_01100_11")
        val sra     = BitPat("b0100000_?????_?????_101_?????_01100_11")
        val or      = BitPat("b0000000_?????_?????_110_?????_01100_11")
        val and     = BitPat("b0000000_?????_?????_111_?????_01100_11")
        val ebreak  = BitPat("b0000000_00001_00000_000_00000_11100_11")
        val fence   = BitPat("b0000000_?????_?????_000_?????_00011_11")
        val addiw   = BitPat("b???????_?????_?????_000_?????_00110_11")
        val slliw   = BitPat("b0000000_?????_?????_001_?????_00110_11")
        val srliw   = BitPat("b0000000_?????_?????_101_?????_00110_11")
        val sraiw   = BitPat("b0100000_?????_?????_101_?????_00110_11")
        val addw    = BitPat("b0000000_?????_?????_000_?????_01110_11")
        val subw    = BitPat("b0100000_?????_?????_000_?????_01110_11")
        val sllw    = BitPat("b0000000_?????_?????_001_?????_01110_11")
        val srlw    = BitPat("b0000000_?????_?????_101_?????_01110_11")
        val sraw    = BitPat("b0100000_?????_?????_101_?????_01110_11")
        val mul     = BitPat("b0000001_?????_?????_000_?????_01100_11")
        val mulh    = BitPat("b0000001_?????_?????_001_?????_01100_11")
        val mulhsu  = BitPat("b0000001_?????_?????_010_?????_01100_11")
        val mulhu   = BitPat("b0000001_?????_?????_011_?????_01100_11")
        val div     = BitPat("b0000001_?????_?????_100_?????_01100_11")
        val divu    = BitPat("b0000001_?????_?????_101_?????_01100_11")
        val rem     = BitPat("b0000001_?????_?????_110_?????_01100_11")
        val remu    = BitPat("b0000001_?????_?????_111_?????_01100_11")
        val mulw    = BitPat("b0000001_?????_?????_000_?????_01110_11")
        val divw    = BitPat("b0000001_?????_?????_100_?????_01110_11")
        val divuw   = BitPat("b0000001_?????_?????_101_?????_01110_11")
        val remw    = BitPat("b0000001_?????_?????_110_?????_01110_11")
        val remuw   = BitPat("b0000001_?????_?????_111_?????_01110_11")        
    }
    def isTrap(inst : UInt) = {
        inst === Instruction.ebreak
    }
    object Op {
        val oprandType = 8
        val oprandWidth = log2Ceil(oprandType)
        val reg::immB::immJ::immS::immI::immU::zero::pc::Nil = Enum(oprandType)
    }
    val Y = true.B
    val N = false.B
    val instDecode = Array (
        //                           r1E r2E op1,     op2,     rW BranchType,   MemOp        ALU_OP      MDU_OP       DATA_WIDTH
        Instruction.lui      -> List(N,  N,  Op.zero, Op.immU, Y, BranchType.n, MEM_OP.none, ALU_OP.add, MDU_OP.none, 0.B ),
        Instruction.auipc    -> List(Y,  N,  Op.pc,   Op.immU, Y, BranchType.n, MEM_OP.none, ALU_OP.add, MDU_OP.none, 0.B ),
        Instruction.jal      -> List(Y,  N,  Op.pc,   Op.immJ, Y, BranchType.j, MEM_OP.none, ALU_OP.add, MDU_OP.none, 0.B ),
        Instruction.jalr     -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.j, MEM_OP.none, ALU_OP.add, MDU_OP.none, 0.B ),
        Instruction.beq      -> List(Y,  Y,  Op.reg,  Op.reg,  N, BranchType.b, MEM_OP.none, ALU_OP.eq , MDU_OP.none, 0.B ),
        Instruction.bne      -> List(Y,  Y,  Op.reg,  Op.reg,  N, BranchType.b, MEM_OP.none, ALU_OP.ne , MDU_OP.none, 0.B ),
        Instruction.bge      -> List(Y,  Y,  Op.reg,  Op.reg,  N, BranchType.b, MEM_OP.none, ALU_OP.ge , MDU_OP.none, 0.B ),
        Instruction.blt      -> List(Y,  Y,  Op.reg,  Op.reg,  N, BranchType.b, MEM_OP.none, ALU_OP.lt , MDU_OP.none, 0.B ),
        Instruction.bltu     -> List(Y,  Y,  Op.reg,  Op.reg,  N, BranchType.b, MEM_OP.none, ALU_OP.ltu, MDU_OP.none, 0.B ),
        Instruction.bgeu     -> List(Y,  Y,  Op.reg,  Op.reg,  N, BranchType.b, MEM_OP.none, ALU_OP.geu, MDU_OP.none, 0.B ),
        Instruction.sd       -> List(Y,  Y,  Op.reg,  Op.immS, N, BranchType.n, MEM_OP.sd,   ALU_OP.add, MDU_OP.none, 0.B ),
        Instruction.sw       -> List(Y,  Y,  Op.reg,  Op.immS, N, BranchType.n, MEM_OP.sw,   ALU_OP.add, MDU_OP.none, 0.B ),
        Instruction.sh       -> List(Y,  Y,  Op.reg,  Op.immS, N, BranchType.n, MEM_OP.sh,   ALU_OP.add, MDU_OP.none, 0.B ),
        Instruction.sb       -> List(Y,  Y,  Op.reg,  Op.immS, N, BranchType.n, MEM_OP.sb,   ALU_OP.add, MDU_OP.none, 0.B ),
        Instruction.lb       -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.lb,   ALU_OP.add, MDU_OP.none, 0.B ),
        Instruction.lbu      -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.lbu,  ALU_OP.add, MDU_OP.none, 0.B ),
        Instruction.lhu      -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.lhu,  ALU_OP.add, MDU_OP.none, 0.B ),
        Instruction.lwu      -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.lwu,  ALU_OP.add, MDU_OP.none, 0.B ),
        Instruction.lh       -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.lh,   ALU_OP.add, MDU_OP.none, 0.B ),
        Instruction.lw       -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.lw,   ALU_OP.add, MDU_OP.none, 0.B ),
        Instruction.ld       -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.ld,   ALU_OP.add, MDU_OP.none, 0.B ),
        Instruction.addi     -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.none, ALU_OP.add, MDU_OP.none, 0.B ),
        Instruction.addiw    -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.none, ALU_OP.add, MDU_OP.none, 1.B ),
        Instruction.slli     -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.none, ALU_OP.sll, MDU_OP.none, 0.B ),
        Instruction.slti     -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.none, ALU_OP.lt , MDU_OP.none, 0.B ),
        Instruction.sltiu    -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.none, ALU_OP.ltu, MDU_OP.none, 0.B ),
        Instruction.srli     -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.none, ALU_OP.srl, MDU_OP.none, 0.B ),
        Instruction.srai     -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.none, ALU_OP.sra, MDU_OP.none, 0.B ),
        Instruction.slliw    -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.none, ALU_OP.sll, MDU_OP.none, 1.B ),
        Instruction.srliw    -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.none, ALU_OP.srl, MDU_OP.none, 1.B ),
        Instruction.sraiw    -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.none, ALU_OP.sra, MDU_OP.none, 1.B ),
        Instruction.xori     -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.none, ALU_OP.xor, MDU_OP.none, 0.B ),
        Instruction.ori      -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.none, ALU_OP.or , MDU_OP.none, 0.B ),
        Instruction.andi     -> List(Y,  N,  Op.reg,  Op.immI, Y, BranchType.n, MEM_OP.none, ALU_OP.and, MDU_OP.none, 0.B ),
        Instruction.add      -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.add, MDU_OP.none , 0.B ),
        Instruction.addw     -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.add, MDU_OP.none, 1.B ),
        Instruction.sub      -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.sub, MDU_OP.none, 0.B ),
        Instruction.or       -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.or,  MDU_OP.none, 0.B ),
        Instruction.and      -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.and, MDU_OP.none, 0.B ),
        Instruction.sll      -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.sll, MDU_OP.none, 0.B ),
        Instruction.srl      -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.srl, MDU_OP.none, 0.B ),
        Instruction.sra      -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.sra, MDU_OP.none, 0.B ),
        Instruction.sllw     -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.sll, MDU_OP.none, 1.B ),
        Instruction.srlw     -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.srl, MDU_OP.none, 1.B ),
        Instruction.sraw     -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.sra, MDU_OP.none, 1.B ),
        Instruction.subw     -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.sub, MDU_OP.none, 1.B ),
        Instruction.slt      -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.lt , MDU_OP.none, 0.B ),
        Instruction.sltu     -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.ltu, MDU_OP.none, 0.B ),
        Instruction.xor      -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.xor, MDU_OP.none, 0.B ),      
        Instruction.mul      -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.nul, MDU_OP.mul,  0.B ),
        Instruction.mulh     -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.nul, MDU_OP.mulh, 0.B ),
        Instruction.mulhsu   -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.nul, MDU_OP.mulhsu,0.B),
        Instruction.mulhu    -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.nul, MDU_OP.mulhu,0.B),
        Instruction.div      -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.nul, MDU_OP.div,  0.B ),
        Instruction.divu     -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.nul, MDU_OP.divu, 0.B ),
        Instruction.rem      -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.nul, MDU_OP.rem,  0.B ),
        Instruction.remu     -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.nul, MDU_OP.remu, 0.B ),
        Instruction.mulw     -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.nul, MDU_OP.mul , 1.B ),
        Instruction.divw     -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.nul, MDU_OP.div , 1.B ),
        Instruction.remw     -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.nul, MDU_OP.rem , 1.B ),
        Instruction.divuw    -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.nul, MDU_OP.divu ,1.B),
        Instruction.remuw    -> List(Y,  Y,  Op.reg,  Op.reg,  Y, BranchType.n, MEM_OP.none, ALU_OP.nul, MDU_OP.remu ,1.B),
        
    )

    val instDecodeDefault = List(N, N, Op.zero, Op.zero, N, BranchType.n, MEM_OP.none, ALU_OP.add, MDU_OP.none, 0.B)

    def immI (inst:UInt):UInt = {
        Fill(DATA_WIDTH - 12,inst(31)) ## inst(31,20)
    }
    def immS (inst:UInt):UInt = {
        Fill(DATA_WIDTH - 12, inst(31)) ## inst(31,25) ## inst(11,7)
    }
    def immB (inst:UInt):UInt = {
        Fill(DATA_WIDTH - 12, inst(31)) ## inst(7) ## inst(30,25) ## inst(11,8) ## 0.U(1)
    }
    def immU (inst:UInt):UInt = {
        Fill(DATA_WIDTH - 32, inst(31)) ## inst(31,12) ## 0.U(12.W)
    }
    def immJ (inst:UInt):UInt = {
        Fill(DATA_WIDTH - 20, inst(31)) ## inst(19,12) ## inst(20) ## inst(30, 21) ## 0.U(1)
    }

    def getOp(op:UInt, pc:UInt, reg:UInt, inst:UInt) = {
        MuxLookup(op, 1111111111.U,Seq(
            Op.immI -> immI(inst),
            Op.immB -> immB(inst),
            Op.immJ -> immJ(inst),
            Op.immS -> immS(inst),
            Op.immU -> immU(inst),
            Op.reg  -> reg,
            Op.pc   -> pc,
            Op.zero -> 0.U(DATA_WIDTH.W),
        ))
    }

    def getReg1(inst:UInt):UInt = {
        inst(19, 15)
    }

    def getReg2(inst:UInt):UInt = {
        inst(24,20)
    }

    def getRegW(inst:UInt):UInt = {
        inst(11,7)
    }

    def getJumpPc(inst:UInt, pc:UInt):UInt = {
        (pc + immJ(inst))
    }

    def getBranchPc(inst:UInt, pc:UInt):UInt = {
        (pc + immB(inst))
    }
    def getFunct(inst:UInt){
        inst(14,12)
    }

}