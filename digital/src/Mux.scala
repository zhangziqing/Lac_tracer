import chisel3._
import chisel3.util_

class 2Mux1 extends RawModule {
  val io = IO(new Bundle {
    val a = Input(Bool())
    val b = Input(Bool())
    val s = Input(Bool())
    val out = Output(Bool())
  })
  out := Mux(s,a,b);
  
}
object 2Mux1 extends App {
  (new chisel3.stage.ChiselStage).emitVerilog(new 2Mux1 ,args)  
  
}

