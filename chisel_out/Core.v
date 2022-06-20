module InstFetch(
  input         clock,
  input         reset,
  output [63:0] io_pc,
  input  [1:0]  io_branchInfo_bType,
  input  [63:0] io_branchInfo_branchTarget,
  output [63:0] io_ifOut_branchInfo_branchTarget
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] pc; // @[InstFetch.scala 20:21]
  wire [63:0] snpc = pc + 64'h4; // @[InstFetch.scala 21:19]
  wire  _nextPC_T = io_branchInfo_bType == 2'h0; // @[InstFetch.scala 23:29]
  assign io_pc = pc; // @[InstFetch.scala 31:11]
  assign io_ifOut_branchInfo_branchTarget = pc + 64'h4; // @[InstFetch.scala 21:19]
  always @(posedge clock) begin
    if (reset) begin // @[InstFetch.scala 20:21]
      pc <= 64'h80000000; // @[InstFetch.scala 20:21]
    end else if (_nextPC_T) begin // @[InstFetch.scala 22:21]
      pc <= snpc;
    end else begin
      pc <= io_branchInfo_branchTarget;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  pc = _RAND_0[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Decode(
  input  [31:0] io_inst,
  input  [63:0] io_pc,
  input  [63:0] io_decodeIn_branchInfo_branchTarget,
  output [4:0]  io_decodeOut_regWrAddr,
  output        io_decodeOut_regWrEn,
  output [63:0] io_decodeOut_oprand1,
  output [63:0] io_decodeOut_oprand2,
  output [63:0] io_decodeOut_storeData,
  output [3:0]  io_decodeOut_aluOp,
  output [3:0]  io_decodeOut_memOp,
  output [3:0]  io_decodeOut_mduOp,
  output        io_decodeOut_opWidth,
  output [1:0]  io_decodeOut_branchInfo_bType,
  output [63:0] io_decodeOut_branchInfo_branchTarget,
  input  [63:0] io_reg1_data,
  output [4:0]  io_reg1_addr,
  output        io_reg1_en,
  input  [63:0] io_reg2_data,
  output [4:0]  io_reg2_addr,
  output        io_reg2_en
);
  wire [31:0] _T = io_inst & 32'h7f; // @[Lookup.scala 31:38]
  wire  _T_1 = 32'h37 == _T; // @[Lookup.scala 31:38]
  wire  _T_3 = 32'h17 == _T; // @[Lookup.scala 31:38]
  wire  _T_5 = 32'h6f == _T; // @[Lookup.scala 31:38]
  wire [31:0] _T_6 = io_inst & 32'h707f; // @[Lookup.scala 31:38]
  wire  _T_7 = 32'h67 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_9 = 32'h63 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_11 = 32'h1063 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_13 = 32'h5063 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_15 = 32'h4063 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_17 = 32'h6063 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_19 = 32'h7063 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_21 = 32'h3023 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_23 = 32'h2023 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_25 = 32'h1023 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_27 = 32'h23 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_29 = 32'h3 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_31 = 32'h4003 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_33 = 32'h5003 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_35 = 32'h6003 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_37 = 32'h1003 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_39 = 32'h2003 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_41 = 32'h3003 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_43 = 32'h13 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_45 = 32'h1b == _T_6; // @[Lookup.scala 31:38]
  wire [31:0] _T_46 = io_inst & 32'hfc00707f; // @[Lookup.scala 31:38]
  wire  _T_47 = 32'h1013 == _T_46; // @[Lookup.scala 31:38]
  wire  _T_49 = 32'h2013 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_51 = 32'h3013 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_53 = 32'h5013 == _T_46; // @[Lookup.scala 31:38]
  wire  _T_55 = 32'h40005013 == _T_46; // @[Lookup.scala 31:38]
  wire [31:0] _T_56 = io_inst & 32'hfe00707f; // @[Lookup.scala 31:38]
  wire  _T_57 = 32'h101b == _T_56; // @[Lookup.scala 31:38]
  wire  _T_59 = 32'h501b == _T_56; // @[Lookup.scala 31:38]
  wire  _T_61 = 32'h4000501b == _T_56; // @[Lookup.scala 31:38]
  wire  _T_63 = 32'h4013 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_65 = 32'h6013 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_67 = 32'h7013 == _T_6; // @[Lookup.scala 31:38]
  wire  _T_69 = 32'h33 == _T_56; // @[Lookup.scala 31:38]
  wire  _T_71 = 32'h3b == _T_56; // @[Lookup.scala 31:38]
  wire  _T_73 = 32'h40000033 == _T_56; // @[Lookup.scala 31:38]
  wire  _T_75 = 32'h6033 == _T_56; // @[Lookup.scala 31:38]
  wire  _T_77 = 32'h7033 == _T_56; // @[Lookup.scala 31:38]
  wire  _T_79 = 32'h1033 == _T_56; // @[Lookup.scala 31:38]
  wire  _T_81 = 32'h5033 == _T_56; // @[Lookup.scala 31:38]
  wire  _T_83 = 32'h40005033 == _T_56; // @[Lookup.scala 31:38]
  wire  _T_85 = 32'h103b == _T_56; // @[Lookup.scala 31:38]
  wire  _T_87 = 32'h503b == _T_56; // @[Lookup.scala 31:38]
  wire  _T_89 = 32'h4000503b == _T_56; // @[Lookup.scala 31:38]
  wire  _T_91 = 32'h4000003b == _T_56; // @[Lookup.scala 31:38]
  wire  _T_93 = 32'h2033 == _T_56; // @[Lookup.scala 31:38]
  wire  _T_95 = 32'h3033 == _T_56; // @[Lookup.scala 31:38]
  wire  _T_97 = 32'h4033 == _T_56; // @[Lookup.scala 31:38]
  wire  _T_99 = 32'h2000033 == _T_56; // @[Lookup.scala 31:38]
  wire  _T_101 = 32'h2001033 == _T_56; // @[Lookup.scala 31:38]
  wire  _T_103 = 32'h2002033 == _T_56; // @[Lookup.scala 31:38]
  wire  _T_105 = 32'h2003033 == _T_56; // @[Lookup.scala 31:38]
  wire  _T_107 = 32'h2004033 == _T_56; // @[Lookup.scala 31:38]
  wire  _T_109 = 32'h2005033 == _T_56; // @[Lookup.scala 31:38]
  wire  _T_111 = 32'h2006033 == _T_56; // @[Lookup.scala 31:38]
  wire  _T_113 = 32'h2007033 == _T_56; // @[Lookup.scala 31:38]
  wire  _T_115 = 32'h200003b == _T_56; // @[Lookup.scala 31:38]
  wire  _T_117 = 32'h200403b == _T_56; // @[Lookup.scala 31:38]
  wire  _T_119 = 32'h200603b == _T_56; // @[Lookup.scala 31:38]
  wire  _T_121 = 32'h200503b == _T_56; // @[Lookup.scala 31:38]
  wire  _T_123 = 32'h200703b == _T_56; // @[Lookup.scala 31:38]
  wire  _T_154 = _T_63 | (_T_65 | (_T_67 | (_T_69 | (_T_71 | (_T_73 | (_T_75 | (_T_77 | (_T_79 | (_T_81 | (_T_83 | (
    _T_85 | (_T_87 | (_T_89 | (_T_91 | (_T_93 | (_T_95 | (_T_97 | (_T_99 | (_T_101 | (_T_103 | (_T_105 | (_T_107 | (
    _T_109 | (_T_111 | (_T_113 | (_T_115 | (_T_117 | (_T_119 | (_T_121 | _T_123))))))))))))))))))))))))))))); // @[Lookup.scala 33:37]
  wire  _T_184 = _T_3 | (_T_5 | (_T_7 | (_T_9 | (_T_11 | (_T_13 | (_T_15 | (_T_17 | (_T_19 | (_T_21 | (_T_23 | (_T_25 |
    (_T_27 | (_T_29 | (_T_31 | (_T_33 | (_T_35 | (_T_37 | (_T_39 | (_T_41 | (_T_43 | (_T_45 | (_T_47 | (_T_49 | (_T_51
     | (_T_53 | (_T_55 | (_T_57 | (_T_59 | (_T_61 | _T_154))))))))))))))))))))))))))))); // @[Lookup.scala 33:37]
  wire  _T_213 = _T_67 ? 1'h0 : _T_69 | (_T_71 | (_T_73 | (_T_75 | (_T_77 | (_T_79 | (_T_81 | (_T_83 | (_T_85 | (_T_87
     | (_T_89 | (_T_91 | (_T_93 | (_T_95 | (_T_97 | (_T_99 | (_T_101 | (_T_103 | (_T_105 | (_T_107 | (_T_109 | (_T_111
     | (_T_113 | (_T_115 | (_T_117 | (_T_119 | (_T_121 | _T_123)))))))))))))))))))))))))); // @[Lookup.scala 33:37]
  wire  _T_214 = _T_65 ? 1'h0 : _T_213; // @[Lookup.scala 33:37]
  wire  _T_215 = _T_63 ? 1'h0 : _T_214; // @[Lookup.scala 33:37]
  wire  _T_216 = _T_61 ? 1'h0 : _T_215; // @[Lookup.scala 33:37]
  wire  _T_217 = _T_59 ? 1'h0 : _T_216; // @[Lookup.scala 33:37]
  wire  _T_218 = _T_57 ? 1'h0 : _T_217; // @[Lookup.scala 33:37]
  wire  _T_219 = _T_55 ? 1'h0 : _T_218; // @[Lookup.scala 33:37]
  wire  _T_220 = _T_53 ? 1'h0 : _T_219; // @[Lookup.scala 33:37]
  wire  _T_221 = _T_51 ? 1'h0 : _T_220; // @[Lookup.scala 33:37]
  wire  _T_222 = _T_49 ? 1'h0 : _T_221; // @[Lookup.scala 33:37]
  wire  _T_223 = _T_47 ? 1'h0 : _T_222; // @[Lookup.scala 33:37]
  wire  _T_224 = _T_45 ? 1'h0 : _T_223; // @[Lookup.scala 33:37]
  wire  _T_225 = _T_43 ? 1'h0 : _T_224; // @[Lookup.scala 33:37]
  wire  _T_226 = _T_41 ? 1'h0 : _T_225; // @[Lookup.scala 33:37]
  wire  _T_227 = _T_39 ? 1'h0 : _T_226; // @[Lookup.scala 33:37]
  wire  _T_228 = _T_37 ? 1'h0 : _T_227; // @[Lookup.scala 33:37]
  wire  _T_229 = _T_35 ? 1'h0 : _T_228; // @[Lookup.scala 33:37]
  wire  _T_230 = _T_33 ? 1'h0 : _T_229; // @[Lookup.scala 33:37]
  wire  _T_231 = _T_31 ? 1'h0 : _T_230; // @[Lookup.scala 33:37]
  wire  _T_232 = _T_29 ? 1'h0 : _T_231; // @[Lookup.scala 33:37]
  wire  _T_243 = _T_7 ? 1'h0 : _T_9 | (_T_11 | (_T_13 | (_T_15 | (_T_17 | (_T_19 | (_T_21 | (_T_23 | (_T_25 | (_T_27 |
    _T_232))))))))); // @[Lookup.scala 33:37]
  wire  _T_244 = _T_5 ? 1'h0 : _T_243; // @[Lookup.scala 33:37]
  wire  _T_245 = _T_3 ? 1'h0 : _T_244; // @[Lookup.scala 33:37]
  wire [2:0] _T_246 = _T_123 ? 3'h0 : 3'h6; // @[Lookup.scala 33:37]
  wire [2:0] _T_247 = _T_121 ? 3'h0 : _T_246; // @[Lookup.scala 33:37]
  wire [2:0] _T_248 = _T_119 ? 3'h0 : _T_247; // @[Lookup.scala 33:37]
  wire [2:0] _T_249 = _T_117 ? 3'h0 : _T_248; // @[Lookup.scala 33:37]
  wire [2:0] _T_250 = _T_115 ? 3'h0 : _T_249; // @[Lookup.scala 33:37]
  wire [2:0] _T_251 = _T_113 ? 3'h0 : _T_250; // @[Lookup.scala 33:37]
  wire [2:0] _T_252 = _T_111 ? 3'h0 : _T_251; // @[Lookup.scala 33:37]
  wire [2:0] _T_253 = _T_109 ? 3'h0 : _T_252; // @[Lookup.scala 33:37]
  wire [2:0] _T_254 = _T_107 ? 3'h0 : _T_253; // @[Lookup.scala 33:37]
  wire [2:0] _T_255 = _T_105 ? 3'h0 : _T_254; // @[Lookup.scala 33:37]
  wire [2:0] _T_256 = _T_103 ? 3'h0 : _T_255; // @[Lookup.scala 33:37]
  wire [2:0] _T_257 = _T_101 ? 3'h0 : _T_256; // @[Lookup.scala 33:37]
  wire [2:0] _T_258 = _T_99 ? 3'h0 : _T_257; // @[Lookup.scala 33:37]
  wire [2:0] _T_259 = _T_97 ? 3'h0 : _T_258; // @[Lookup.scala 33:37]
  wire [2:0] _T_260 = _T_95 ? 3'h0 : _T_259; // @[Lookup.scala 33:37]
  wire [2:0] _T_261 = _T_93 ? 3'h0 : _T_260; // @[Lookup.scala 33:37]
  wire [2:0] _T_262 = _T_91 ? 3'h0 : _T_261; // @[Lookup.scala 33:37]
  wire [2:0] _T_263 = _T_89 ? 3'h0 : _T_262; // @[Lookup.scala 33:37]
  wire [2:0] _T_264 = _T_87 ? 3'h0 : _T_263; // @[Lookup.scala 33:37]
  wire [2:0] _T_265 = _T_85 ? 3'h0 : _T_264; // @[Lookup.scala 33:37]
  wire [2:0] _T_266 = _T_83 ? 3'h0 : _T_265; // @[Lookup.scala 33:37]
  wire [2:0] _T_267 = _T_81 ? 3'h0 : _T_266; // @[Lookup.scala 33:37]
  wire [2:0] _T_268 = _T_79 ? 3'h0 : _T_267; // @[Lookup.scala 33:37]
  wire [2:0] _T_269 = _T_77 ? 3'h0 : _T_268; // @[Lookup.scala 33:37]
  wire [2:0] _T_270 = _T_75 ? 3'h0 : _T_269; // @[Lookup.scala 33:37]
  wire [2:0] _T_271 = _T_73 ? 3'h0 : _T_270; // @[Lookup.scala 33:37]
  wire [2:0] _T_272 = _T_71 ? 3'h0 : _T_271; // @[Lookup.scala 33:37]
  wire [2:0] _T_273 = _T_69 ? 3'h0 : _T_272; // @[Lookup.scala 33:37]
  wire [2:0] _T_274 = _T_67 ? 3'h0 : _T_273; // @[Lookup.scala 33:37]
  wire [2:0] _T_275 = _T_65 ? 3'h0 : _T_274; // @[Lookup.scala 33:37]
  wire [2:0] _T_276 = _T_63 ? 3'h0 : _T_275; // @[Lookup.scala 33:37]
  wire [2:0] _T_277 = _T_61 ? 3'h0 : _T_276; // @[Lookup.scala 33:37]
  wire [2:0] _T_278 = _T_59 ? 3'h0 : _T_277; // @[Lookup.scala 33:37]
  wire [2:0] _T_279 = _T_57 ? 3'h0 : _T_278; // @[Lookup.scala 33:37]
  wire [2:0] _T_280 = _T_55 ? 3'h0 : _T_279; // @[Lookup.scala 33:37]
  wire [2:0] _T_281 = _T_53 ? 3'h0 : _T_280; // @[Lookup.scala 33:37]
  wire [2:0] _T_282 = _T_51 ? 3'h0 : _T_281; // @[Lookup.scala 33:37]
  wire [2:0] _T_283 = _T_49 ? 3'h0 : _T_282; // @[Lookup.scala 33:37]
  wire [2:0] _T_284 = _T_47 ? 3'h0 : _T_283; // @[Lookup.scala 33:37]
  wire [2:0] _T_285 = _T_45 ? 3'h0 : _T_284; // @[Lookup.scala 33:37]
  wire [2:0] _T_286 = _T_43 ? 3'h0 : _T_285; // @[Lookup.scala 33:37]
  wire [2:0] _T_287 = _T_41 ? 3'h0 : _T_286; // @[Lookup.scala 33:37]
  wire [2:0] _T_288 = _T_39 ? 3'h0 : _T_287; // @[Lookup.scala 33:37]
  wire [2:0] _T_289 = _T_37 ? 3'h0 : _T_288; // @[Lookup.scala 33:37]
  wire [2:0] _T_290 = _T_35 ? 3'h0 : _T_289; // @[Lookup.scala 33:37]
  wire [2:0] _T_291 = _T_33 ? 3'h0 : _T_290; // @[Lookup.scala 33:37]
  wire [2:0] _T_292 = _T_31 ? 3'h0 : _T_291; // @[Lookup.scala 33:37]
  wire [2:0] _T_293 = _T_29 ? 3'h0 : _T_292; // @[Lookup.scala 33:37]
  wire [2:0] _T_294 = _T_27 ? 3'h0 : _T_293; // @[Lookup.scala 33:37]
  wire [2:0] _T_295 = _T_25 ? 3'h0 : _T_294; // @[Lookup.scala 33:37]
  wire [2:0] _T_296 = _T_23 ? 3'h0 : _T_295; // @[Lookup.scala 33:37]
  wire [2:0] _T_297 = _T_21 ? 3'h0 : _T_296; // @[Lookup.scala 33:37]
  wire [2:0] _T_298 = _T_19 ? 3'h0 : _T_297; // @[Lookup.scala 33:37]
  wire [2:0] _T_299 = _T_17 ? 3'h0 : _T_298; // @[Lookup.scala 33:37]
  wire [2:0] _T_300 = _T_15 ? 3'h0 : _T_299; // @[Lookup.scala 33:37]
  wire [2:0] _T_301 = _T_13 ? 3'h0 : _T_300; // @[Lookup.scala 33:37]
  wire [2:0] _T_302 = _T_11 ? 3'h0 : _T_301; // @[Lookup.scala 33:37]
  wire [2:0] _T_303 = _T_9 ? 3'h0 : _T_302; // @[Lookup.scala 33:37]
  wire [2:0] _T_304 = _T_7 ? 3'h0 : _T_303; // @[Lookup.scala 33:37]
  wire [2:0] _T_305 = _T_5 ? 3'h7 : _T_304; // @[Lookup.scala 33:37]
  wire [2:0] _T_306 = _T_3 ? 3'h7 : _T_305; // @[Lookup.scala 33:37]
  wire [2:0] op1 = _T_1 ? 3'h6 : _T_306; // @[Lookup.scala 33:37]
  wire [2:0] _T_335 = _T_67 ? 3'h4 : _T_273; // @[Lookup.scala 33:37]
  wire [2:0] _T_336 = _T_65 ? 3'h4 : _T_335; // @[Lookup.scala 33:37]
  wire [2:0] _T_337 = _T_63 ? 3'h4 : _T_336; // @[Lookup.scala 33:37]
  wire [2:0] _T_338 = _T_61 ? 3'h4 : _T_337; // @[Lookup.scala 33:37]
  wire [2:0] _T_339 = _T_59 ? 3'h4 : _T_338; // @[Lookup.scala 33:37]
  wire [2:0] _T_340 = _T_57 ? 3'h4 : _T_339; // @[Lookup.scala 33:37]
  wire [2:0] _T_341 = _T_55 ? 3'h4 : _T_340; // @[Lookup.scala 33:37]
  wire [2:0] _T_342 = _T_53 ? 3'h4 : _T_341; // @[Lookup.scala 33:37]
  wire [2:0] _T_343 = _T_51 ? 3'h4 : _T_342; // @[Lookup.scala 33:37]
  wire [2:0] _T_344 = _T_49 ? 3'h4 : _T_343; // @[Lookup.scala 33:37]
  wire [2:0] _T_345 = _T_47 ? 3'h4 : _T_344; // @[Lookup.scala 33:37]
  wire [2:0] _T_346 = _T_45 ? 3'h4 : _T_345; // @[Lookup.scala 33:37]
  wire [2:0] _T_347 = _T_43 ? 3'h4 : _T_346; // @[Lookup.scala 33:37]
  wire [2:0] _T_348 = _T_41 ? 3'h4 : _T_347; // @[Lookup.scala 33:37]
  wire [2:0] _T_349 = _T_39 ? 3'h4 : _T_348; // @[Lookup.scala 33:37]
  wire [2:0] _T_350 = _T_37 ? 3'h4 : _T_349; // @[Lookup.scala 33:37]
  wire [2:0] _T_351 = _T_35 ? 3'h4 : _T_350; // @[Lookup.scala 33:37]
  wire [2:0] _T_352 = _T_33 ? 3'h4 : _T_351; // @[Lookup.scala 33:37]
  wire [2:0] _T_353 = _T_31 ? 3'h4 : _T_352; // @[Lookup.scala 33:37]
  wire [2:0] _T_354 = _T_29 ? 3'h4 : _T_353; // @[Lookup.scala 33:37]
  wire [2:0] _T_355 = _T_27 ? 3'h3 : _T_354; // @[Lookup.scala 33:37]
  wire [2:0] _T_356 = _T_25 ? 3'h3 : _T_355; // @[Lookup.scala 33:37]
  wire [2:0] _T_357 = _T_23 ? 3'h3 : _T_356; // @[Lookup.scala 33:37]
  wire [2:0] _T_358 = _T_21 ? 3'h3 : _T_357; // @[Lookup.scala 33:37]
  wire [2:0] _T_359 = _T_19 ? 3'h0 : _T_358; // @[Lookup.scala 33:37]
  wire [2:0] _T_360 = _T_17 ? 3'h0 : _T_359; // @[Lookup.scala 33:37]
  wire [2:0] _T_361 = _T_15 ? 3'h0 : _T_360; // @[Lookup.scala 33:37]
  wire [2:0] _T_362 = _T_13 ? 3'h0 : _T_361; // @[Lookup.scala 33:37]
  wire [2:0] _T_363 = _T_11 ? 3'h0 : _T_362; // @[Lookup.scala 33:37]
  wire [2:0] _T_364 = _T_9 ? 3'h0 : _T_363; // @[Lookup.scala 33:37]
  wire [2:0] _T_365 = _T_7 ? 3'h4 : _T_364; // @[Lookup.scala 33:37]
  wire [2:0] _T_366 = _T_5 ? 3'h2 : _T_365; // @[Lookup.scala 33:37]
  wire [2:0] _T_367 = _T_3 ? 3'h5 : _T_366; // @[Lookup.scala 33:37]
  wire [2:0] op2 = _T_1 ? 3'h5 : _T_367; // @[Lookup.scala 33:37]
  wire  _T_416 = _T_27 ? 1'h0 : _T_29 | (_T_31 | (_T_33 | (_T_35 | (_T_37 | (_T_39 | (_T_41 | (_T_43 | (_T_45 | (_T_47
     | (_T_49 | (_T_51 | (_T_53 | (_T_55 | (_T_57 | (_T_59 | (_T_61 | _T_154)))))))))))))))); // @[Lookup.scala 33:37]
  wire  _T_417 = _T_25 ? 1'h0 : _T_416; // @[Lookup.scala 33:37]
  wire  _T_418 = _T_23 ? 1'h0 : _T_417; // @[Lookup.scala 33:37]
  wire  _T_419 = _T_21 ? 1'h0 : _T_418; // @[Lookup.scala 33:37]
  wire  _T_420 = _T_19 ? 1'h0 : _T_419; // @[Lookup.scala 33:37]
  wire  _T_421 = _T_17 ? 1'h0 : _T_420; // @[Lookup.scala 33:37]
  wire  _T_422 = _T_15 ? 1'h0 : _T_421; // @[Lookup.scala 33:37]
  wire  _T_423 = _T_13 ? 1'h0 : _T_422; // @[Lookup.scala 33:37]
  wire  _T_424 = _T_11 ? 1'h0 : _T_423; // @[Lookup.scala 33:37]
  wire  _T_425 = _T_9 ? 1'h0 : _T_424; // @[Lookup.scala 33:37]
  wire  _T_486 = _T_9 | (_T_11 | (_T_13 | (_T_15 | (_T_17 | _T_19)))); // @[Lookup.scala 33:37]
  wire [1:0] _T_487 = _T_7 ? 2'h2 : {{1'd0}, _T_486}; // @[Lookup.scala 33:37]
  wire [1:0] _T_488 = _T_5 ? 2'h2 : _T_487; // @[Lookup.scala 33:37]
  wire [1:0] _T_489 = _T_3 ? 2'h0 : _T_488; // @[Lookup.scala 33:37]
  wire [1:0] branchType = _T_1 ? 2'h0 : _T_489; // @[Lookup.scala 33:37]
  wire [3:0] _T_531 = _T_41 ? 4'h3 : 4'hb; // @[Lookup.scala 33:37]
  wire [3:0] _T_532 = _T_39 ? 4'h2 : _T_531; // @[Lookup.scala 33:37]
  wire [3:0] _T_533 = _T_37 ? 4'h1 : _T_532; // @[Lookup.scala 33:37]
  wire [3:0] _T_534 = _T_35 ? 4'h6 : _T_533; // @[Lookup.scala 33:37]
  wire [3:0] _T_535 = _T_33 ? 4'h5 : _T_534; // @[Lookup.scala 33:37]
  wire [3:0] _T_536 = _T_31 ? 4'h4 : _T_535; // @[Lookup.scala 33:37]
  wire [3:0] _T_537 = _T_29 ? 4'h0 : _T_536; // @[Lookup.scala 33:37]
  wire [3:0] _T_538 = _T_27 ? 4'h7 : _T_537; // @[Lookup.scala 33:37]
  wire [3:0] _T_539 = _T_25 ? 4'h8 : _T_538; // @[Lookup.scala 33:37]
  wire [3:0] _T_540 = _T_23 ? 4'h9 : _T_539; // @[Lookup.scala 33:37]
  wire [3:0] _T_541 = _T_21 ? 4'ha : _T_540; // @[Lookup.scala 33:37]
  wire [3:0] _T_542 = _T_19 ? 4'hb : _T_541; // @[Lookup.scala 33:37]
  wire [3:0] _T_543 = _T_17 ? 4'hb : _T_542; // @[Lookup.scala 33:37]
  wire [3:0] _T_544 = _T_15 ? 4'hb : _T_543; // @[Lookup.scala 33:37]
  wire [3:0] _T_545 = _T_13 ? 4'hb : _T_544; // @[Lookup.scala 33:37]
  wire [3:0] _T_546 = _T_11 ? 4'hb : _T_545; // @[Lookup.scala 33:37]
  wire [3:0] _T_547 = _T_9 ? 4'hb : _T_546; // @[Lookup.scala 33:37]
  wire [3:0] _T_548 = _T_7 ? 4'hb : _T_547; // @[Lookup.scala 33:37]
  wire [3:0] _T_549 = _T_5 ? 4'hb : _T_548; // @[Lookup.scala 33:37]
  wire [3:0] _T_550 = _T_3 ? 4'hb : _T_549; // @[Lookup.scala 33:37]
  wire [3:0] _T_551 = _T_123 ? 4'he : 4'h0; // @[Lookup.scala 33:37]
  wire [3:0] _T_552 = _T_121 ? 4'he : _T_551; // @[Lookup.scala 33:37]
  wire [3:0] _T_553 = _T_119 ? 4'he : _T_552; // @[Lookup.scala 33:37]
  wire [3:0] _T_554 = _T_117 ? 4'he : _T_553; // @[Lookup.scala 33:37]
  wire [3:0] _T_555 = _T_115 ? 4'he : _T_554; // @[Lookup.scala 33:37]
  wire [3:0] _T_556 = _T_113 ? 4'he : _T_555; // @[Lookup.scala 33:37]
  wire [3:0] _T_557 = _T_111 ? 4'he : _T_556; // @[Lookup.scala 33:37]
  wire [3:0] _T_558 = _T_109 ? 4'he : _T_557; // @[Lookup.scala 33:37]
  wire [3:0] _T_559 = _T_107 ? 4'he : _T_558; // @[Lookup.scala 33:37]
  wire [3:0] _T_560 = _T_105 ? 4'he : _T_559; // @[Lookup.scala 33:37]
  wire [3:0] _T_561 = _T_103 ? 4'he : _T_560; // @[Lookup.scala 33:37]
  wire [3:0] _T_562 = _T_101 ? 4'he : _T_561; // @[Lookup.scala 33:37]
  wire [3:0] _T_563 = _T_99 ? 4'he : _T_562; // @[Lookup.scala 33:37]
  wire [3:0] _T_564 = _T_97 ? 4'ha : _T_563; // @[Lookup.scala 33:37]
  wire [3:0] _T_565 = _T_95 ? 4'h3 : _T_564; // @[Lookup.scala 33:37]
  wire [3:0] _T_566 = _T_93 ? 4'h2 : _T_565; // @[Lookup.scala 33:37]
  wire [3:0] _T_567 = _T_91 ? 4'h1 : _T_566; // @[Lookup.scala 33:37]
  wire [3:0] _T_568 = _T_89 ? 4'hb : _T_567; // @[Lookup.scala 33:37]
  wire [3:0] _T_569 = _T_87 ? 4'hc : _T_568; // @[Lookup.scala 33:37]
  wire [3:0] _T_570 = _T_85 ? 4'hd : _T_569; // @[Lookup.scala 33:37]
  wire [3:0] _T_571 = _T_83 ? 4'hb : _T_570; // @[Lookup.scala 33:37]
  wire [3:0] _T_572 = _T_81 ? 4'hc : _T_571; // @[Lookup.scala 33:37]
  wire [3:0] _T_573 = _T_79 ? 4'hd : _T_572; // @[Lookup.scala 33:37]
  wire [3:0] _T_574 = _T_77 ? 4'h8 : _T_573; // @[Lookup.scala 33:37]
  wire [3:0] _T_575 = _T_75 ? 4'h9 : _T_574; // @[Lookup.scala 33:37]
  wire [3:0] _T_576 = _T_73 ? 4'h1 : _T_575; // @[Lookup.scala 33:37]
  wire [3:0] _T_577 = _T_71 ? 4'h0 : _T_576; // @[Lookup.scala 33:37]
  wire [3:0] _T_578 = _T_69 ? 4'h0 : _T_577; // @[Lookup.scala 33:37]
  wire [3:0] _T_579 = _T_67 ? 4'h8 : _T_578; // @[Lookup.scala 33:37]
  wire [3:0] _T_580 = _T_65 ? 4'h9 : _T_579; // @[Lookup.scala 33:37]
  wire [3:0] _T_581 = _T_63 ? 4'ha : _T_580; // @[Lookup.scala 33:37]
  wire [3:0] _T_582 = _T_61 ? 4'hb : _T_581; // @[Lookup.scala 33:37]
  wire [3:0] _T_583 = _T_59 ? 4'hc : _T_582; // @[Lookup.scala 33:37]
  wire [3:0] _T_584 = _T_57 ? 4'hd : _T_583; // @[Lookup.scala 33:37]
  wire [3:0] _T_585 = _T_55 ? 4'hb : _T_584; // @[Lookup.scala 33:37]
  wire [3:0] _T_586 = _T_53 ? 4'hc : _T_585; // @[Lookup.scala 33:37]
  wire [3:0] _T_587 = _T_51 ? 4'h3 : _T_586; // @[Lookup.scala 33:37]
  wire [3:0] _T_588 = _T_49 ? 4'h2 : _T_587; // @[Lookup.scala 33:37]
  wire [3:0] _T_589 = _T_47 ? 4'hd : _T_588; // @[Lookup.scala 33:37]
  wire [3:0] _T_590 = _T_45 ? 4'h0 : _T_589; // @[Lookup.scala 33:37]
  wire [3:0] _T_591 = _T_43 ? 4'h0 : _T_590; // @[Lookup.scala 33:37]
  wire [3:0] _T_592 = _T_41 ? 4'h0 : _T_591; // @[Lookup.scala 33:37]
  wire [3:0] _T_593 = _T_39 ? 4'h0 : _T_592; // @[Lookup.scala 33:37]
  wire [3:0] _T_594 = _T_37 ? 4'h0 : _T_593; // @[Lookup.scala 33:37]
  wire [3:0] _T_595 = _T_35 ? 4'h0 : _T_594; // @[Lookup.scala 33:37]
  wire [3:0] _T_596 = _T_33 ? 4'h0 : _T_595; // @[Lookup.scala 33:37]
  wire [3:0] _T_597 = _T_31 ? 4'h0 : _T_596; // @[Lookup.scala 33:37]
  wire [3:0] _T_598 = _T_29 ? 4'h0 : _T_597; // @[Lookup.scala 33:37]
  wire [3:0] _T_599 = _T_27 ? 4'h0 : _T_598; // @[Lookup.scala 33:37]
  wire [3:0] _T_600 = _T_25 ? 4'h0 : _T_599; // @[Lookup.scala 33:37]
  wire [3:0] _T_601 = _T_23 ? 4'h0 : _T_600; // @[Lookup.scala 33:37]
  wire [3:0] _T_602 = _T_21 ? 4'h0 : _T_601; // @[Lookup.scala 33:37]
  wire [3:0] _T_603 = _T_19 ? 4'h5 : _T_602; // @[Lookup.scala 33:37]
  wire [3:0] _T_604 = _T_17 ? 4'h3 : _T_603; // @[Lookup.scala 33:37]
  wire [3:0] _T_605 = _T_15 ? 4'h2 : _T_604; // @[Lookup.scala 33:37]
  wire [3:0] _T_606 = _T_13 ? 4'h4 : _T_605; // @[Lookup.scala 33:37]
  wire [3:0] _T_607 = _T_11 ? 4'h6 : _T_606; // @[Lookup.scala 33:37]
  wire [3:0] _T_608 = _T_9 ? 4'h7 : _T_607; // @[Lookup.scala 33:37]
  wire [3:0] _T_609 = _T_7 ? 4'h0 : _T_608; // @[Lookup.scala 33:37]
  wire [3:0] _T_610 = _T_5 ? 4'h0 : _T_609; // @[Lookup.scala 33:37]
  wire [3:0] _T_611 = _T_3 ? 4'h0 : _T_610; // @[Lookup.scala 33:37]
  wire [3:0] _T_612 = _T_123 ? 4'h7 : 4'h8; // @[Lookup.scala 33:37]
  wire [3:0] _T_613 = _T_121 ? 4'h5 : _T_612; // @[Lookup.scala 33:37]
  wire [3:0] _T_614 = _T_119 ? 4'h6 : _T_613; // @[Lookup.scala 33:37]
  wire [3:0] _T_615 = _T_117 ? 4'h4 : _T_614; // @[Lookup.scala 33:37]
  wire [3:0] _T_616 = _T_115 ? 4'h0 : _T_615; // @[Lookup.scala 33:37]
  wire [3:0] _T_617 = _T_113 ? 4'h7 : _T_616; // @[Lookup.scala 33:37]
  wire [3:0] _T_618 = _T_111 ? 4'h6 : _T_617; // @[Lookup.scala 33:37]
  wire [3:0] _T_619 = _T_109 ? 4'h5 : _T_618; // @[Lookup.scala 33:37]
  wire [3:0] _T_620 = _T_107 ? 4'h4 : _T_619; // @[Lookup.scala 33:37]
  wire [3:0] _T_621 = _T_105 ? 4'h3 : _T_620; // @[Lookup.scala 33:37]
  wire [3:0] _T_622 = _T_103 ? 4'h2 : _T_621; // @[Lookup.scala 33:37]
  wire [3:0] _T_623 = _T_101 ? 4'h1 : _T_622; // @[Lookup.scala 33:37]
  wire [3:0] _T_624 = _T_99 ? 4'h0 : _T_623; // @[Lookup.scala 33:37]
  wire [3:0] _T_625 = _T_97 ? 4'h8 : _T_624; // @[Lookup.scala 33:37]
  wire [3:0] _T_626 = _T_95 ? 4'h8 : _T_625; // @[Lookup.scala 33:37]
  wire [3:0] _T_627 = _T_93 ? 4'h8 : _T_626; // @[Lookup.scala 33:37]
  wire [3:0] _T_628 = _T_91 ? 4'h8 : _T_627; // @[Lookup.scala 33:37]
  wire [3:0] _T_629 = _T_89 ? 4'h8 : _T_628; // @[Lookup.scala 33:37]
  wire [3:0] _T_630 = _T_87 ? 4'h8 : _T_629; // @[Lookup.scala 33:37]
  wire [3:0] _T_631 = _T_85 ? 4'h8 : _T_630; // @[Lookup.scala 33:37]
  wire [3:0] _T_632 = _T_83 ? 4'h8 : _T_631; // @[Lookup.scala 33:37]
  wire [3:0] _T_633 = _T_81 ? 4'h8 : _T_632; // @[Lookup.scala 33:37]
  wire [3:0] _T_634 = _T_79 ? 4'h8 : _T_633; // @[Lookup.scala 33:37]
  wire [3:0] _T_635 = _T_77 ? 4'h8 : _T_634; // @[Lookup.scala 33:37]
  wire [3:0] _T_636 = _T_75 ? 4'h8 : _T_635; // @[Lookup.scala 33:37]
  wire [3:0] _T_637 = _T_73 ? 4'h8 : _T_636; // @[Lookup.scala 33:37]
  wire [3:0] _T_638 = _T_71 ? 4'h8 : _T_637; // @[Lookup.scala 33:37]
  wire [3:0] _T_639 = _T_69 ? 4'h8 : _T_638; // @[Lookup.scala 33:37]
  wire [3:0] _T_640 = _T_67 ? 4'h8 : _T_639; // @[Lookup.scala 33:37]
  wire [3:0] _T_641 = _T_65 ? 4'h8 : _T_640; // @[Lookup.scala 33:37]
  wire [3:0] _T_642 = _T_63 ? 4'h8 : _T_641; // @[Lookup.scala 33:37]
  wire [3:0] _T_643 = _T_61 ? 4'h8 : _T_642; // @[Lookup.scala 33:37]
  wire [3:0] _T_644 = _T_59 ? 4'h8 : _T_643; // @[Lookup.scala 33:37]
  wire [3:0] _T_645 = _T_57 ? 4'h8 : _T_644; // @[Lookup.scala 33:37]
  wire [3:0] _T_646 = _T_55 ? 4'h8 : _T_645; // @[Lookup.scala 33:37]
  wire [3:0] _T_647 = _T_53 ? 4'h8 : _T_646; // @[Lookup.scala 33:37]
  wire [3:0] _T_648 = _T_51 ? 4'h8 : _T_647; // @[Lookup.scala 33:37]
  wire [3:0] _T_649 = _T_49 ? 4'h8 : _T_648; // @[Lookup.scala 33:37]
  wire [3:0] _T_650 = _T_47 ? 4'h8 : _T_649; // @[Lookup.scala 33:37]
  wire [3:0] _T_651 = _T_45 ? 4'h8 : _T_650; // @[Lookup.scala 33:37]
  wire [3:0] _T_652 = _T_43 ? 4'h8 : _T_651; // @[Lookup.scala 33:37]
  wire [3:0] _T_653 = _T_41 ? 4'h8 : _T_652; // @[Lookup.scala 33:37]
  wire [3:0] _T_654 = _T_39 ? 4'h8 : _T_653; // @[Lookup.scala 33:37]
  wire [3:0] _T_655 = _T_37 ? 4'h8 : _T_654; // @[Lookup.scala 33:37]
  wire [3:0] _T_656 = _T_35 ? 4'h8 : _T_655; // @[Lookup.scala 33:37]
  wire [3:0] _T_657 = _T_33 ? 4'h8 : _T_656; // @[Lookup.scala 33:37]
  wire [3:0] _T_658 = _T_31 ? 4'h8 : _T_657; // @[Lookup.scala 33:37]
  wire [3:0] _T_659 = _T_29 ? 4'h8 : _T_658; // @[Lookup.scala 33:37]
  wire [3:0] _T_660 = _T_27 ? 4'h8 : _T_659; // @[Lookup.scala 33:37]
  wire [3:0] _T_661 = _T_25 ? 4'h8 : _T_660; // @[Lookup.scala 33:37]
  wire [3:0] _T_662 = _T_23 ? 4'h8 : _T_661; // @[Lookup.scala 33:37]
  wire [3:0] _T_663 = _T_21 ? 4'h8 : _T_662; // @[Lookup.scala 33:37]
  wire [3:0] _T_664 = _T_19 ? 4'h8 : _T_663; // @[Lookup.scala 33:37]
  wire [3:0] _T_665 = _T_17 ? 4'h8 : _T_664; // @[Lookup.scala 33:37]
  wire [3:0] _T_666 = _T_15 ? 4'h8 : _T_665; // @[Lookup.scala 33:37]
  wire [3:0] _T_667 = _T_13 ? 4'h8 : _T_666; // @[Lookup.scala 33:37]
  wire [3:0] _T_668 = _T_11 ? 4'h8 : _T_667; // @[Lookup.scala 33:37]
  wire [3:0] _T_669 = _T_9 ? 4'h8 : _T_668; // @[Lookup.scala 33:37]
  wire [3:0] _T_670 = _T_7 ? 4'h8 : _T_669; // @[Lookup.scala 33:37]
  wire [3:0] _T_671 = _T_5 ? 4'h8 : _T_670; // @[Lookup.scala 33:37]
  wire [3:0] _T_672 = _T_3 ? 4'h8 : _T_671; // @[Lookup.scala 33:37]
  wire  _T_678 = _T_113 ? 1'h0 : _T_115 | (_T_117 | (_T_119 | (_T_121 | _T_123))); // @[Lookup.scala 33:37]
  wire  _T_679 = _T_111 ? 1'h0 : _T_678; // @[Lookup.scala 33:37]
  wire  _T_680 = _T_109 ? 1'h0 : _T_679; // @[Lookup.scala 33:37]
  wire  _T_681 = _T_107 ? 1'h0 : _T_680; // @[Lookup.scala 33:37]
  wire  _T_682 = _T_105 ? 1'h0 : _T_681; // @[Lookup.scala 33:37]
  wire  _T_683 = _T_103 ? 1'h0 : _T_682; // @[Lookup.scala 33:37]
  wire  _T_684 = _T_101 ? 1'h0 : _T_683; // @[Lookup.scala 33:37]
  wire  _T_685 = _T_99 ? 1'h0 : _T_684; // @[Lookup.scala 33:37]
  wire  _T_686 = _T_97 ? 1'h0 : _T_685; // @[Lookup.scala 33:37]
  wire  _T_687 = _T_95 ? 1'h0 : _T_686; // @[Lookup.scala 33:37]
  wire  _T_688 = _T_93 ? 1'h0 : _T_687; // @[Lookup.scala 33:37]
  wire  _T_693 = _T_83 ? 1'h0 : _T_85 | (_T_87 | (_T_89 | (_T_91 | _T_688))); // @[Lookup.scala 33:37]
  wire  _T_694 = _T_81 ? 1'h0 : _T_693; // @[Lookup.scala 33:37]
  wire  _T_695 = _T_79 ? 1'h0 : _T_694; // @[Lookup.scala 33:37]
  wire  _T_696 = _T_77 ? 1'h0 : _T_695; // @[Lookup.scala 33:37]
  wire  _T_697 = _T_75 ? 1'h0 : _T_696; // @[Lookup.scala 33:37]
  wire  _T_698 = _T_73 ? 1'h0 : _T_697; // @[Lookup.scala 33:37]
  wire  _T_700 = _T_69 ? 1'h0 : _T_71 | _T_698; // @[Lookup.scala 33:37]
  wire  _T_701 = _T_67 ? 1'h0 : _T_700; // @[Lookup.scala 33:37]
  wire  _T_702 = _T_65 ? 1'h0 : _T_701; // @[Lookup.scala 33:37]
  wire  _T_703 = _T_63 ? 1'h0 : _T_702; // @[Lookup.scala 33:37]
  wire  _T_707 = _T_55 ? 1'h0 : _T_57 | (_T_59 | (_T_61 | _T_703)); // @[Lookup.scala 33:37]
  wire  _T_708 = _T_53 ? 1'h0 : _T_707; // @[Lookup.scala 33:37]
  wire  _T_709 = _T_51 ? 1'h0 : _T_708; // @[Lookup.scala 33:37]
  wire  _T_710 = _T_49 ? 1'h0 : _T_709; // @[Lookup.scala 33:37]
  wire  _T_711 = _T_47 ? 1'h0 : _T_710; // @[Lookup.scala 33:37]
  wire  _T_713 = _T_43 ? 1'h0 : _T_45 | _T_711; // @[Lookup.scala 33:37]
  wire  _T_714 = _T_41 ? 1'h0 : _T_713; // @[Lookup.scala 33:37]
  wire  _T_715 = _T_39 ? 1'h0 : _T_714; // @[Lookup.scala 33:37]
  wire  _T_716 = _T_37 ? 1'h0 : _T_715; // @[Lookup.scala 33:37]
  wire  _T_717 = _T_35 ? 1'h0 : _T_716; // @[Lookup.scala 33:37]
  wire  _T_718 = _T_33 ? 1'h0 : _T_717; // @[Lookup.scala 33:37]
  wire  _T_719 = _T_31 ? 1'h0 : _T_718; // @[Lookup.scala 33:37]
  wire  _T_720 = _T_29 ? 1'h0 : _T_719; // @[Lookup.scala 33:37]
  wire  _T_721 = _T_27 ? 1'h0 : _T_720; // @[Lookup.scala 33:37]
  wire  _T_722 = _T_25 ? 1'h0 : _T_721; // @[Lookup.scala 33:37]
  wire  _T_723 = _T_23 ? 1'h0 : _T_722; // @[Lookup.scala 33:37]
  wire  _T_724 = _T_21 ? 1'h0 : _T_723; // @[Lookup.scala 33:37]
  wire  _T_725 = _T_19 ? 1'h0 : _T_724; // @[Lookup.scala 33:37]
  wire  _T_726 = _T_17 ? 1'h0 : _T_725; // @[Lookup.scala 33:37]
  wire  _T_727 = _T_15 ? 1'h0 : _T_726; // @[Lookup.scala 33:37]
  wire  _T_728 = _T_13 ? 1'h0 : _T_727; // @[Lookup.scala 33:37]
  wire  _T_729 = _T_11 ? 1'h0 : _T_728; // @[Lookup.scala 33:37]
  wire  _T_730 = _T_9 ? 1'h0 : _T_729; // @[Lookup.scala 33:37]
  wire  _T_731 = _T_7 ? 1'h0 : _T_730; // @[Lookup.scala 33:37]
  wire  _T_732 = _T_5 ? 1'h0 : _T_731; // @[Lookup.scala 33:37]
  wire  _T_733 = _T_3 ? 1'h0 : _T_732; // @[Lookup.scala 33:37]
  wire [51:0] _io_decodeOut_oprand1_T_2 = io_inst[31] ? 52'hfffffffffffff : 52'h0; // @[Bitwise.scala 72:12]
  wire [63:0] _io_decodeOut_oprand1_T_4 = {_io_decodeOut_oprand1_T_2,io_inst[31:20]}; // @[riscv64.scala 155:40]
  wire [63:0] _io_decodeOut_oprand1_T_14 = {_io_decodeOut_oprand1_T_2,io_inst[7],io_inst[30:25],io_inst[11:8],1'h0}; // @[riscv64.scala 161:81]
  wire [43:0] _io_decodeOut_oprand1_T_17 = io_inst[31] ? 44'hfffffffffff : 44'h0; // @[Bitwise.scala 72:12]
  wire [63:0] _io_decodeOut_oprand1_T_24 = {_io_decodeOut_oprand1_T_17,io_inst[19:12],io_inst[20],io_inst[30:21],1'h0}; // @[riscv64.scala 167:84]
  wire [63:0] _io_decodeOut_oprand1_T_31 = {_io_decodeOut_oprand1_T_2,io_inst[31:25],io_inst[11:7]}; // @[riscv64.scala 158:56]
  wire [31:0] _io_decodeOut_oprand1_T_34 = io_inst[31] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [63:0] _io_decodeOut_oprand1_T_37 = {_io_decodeOut_oprand1_T_34,io_inst[31:12],12'h0}; // @[riscv64.scala 164:56]
  wire [63:0] _io_decodeOut_oprand1_T_39 = 3'h1 == op1 ? _io_decodeOut_oprand1_T_14 : _io_decodeOut_oprand1_T_4; // @[Mux.scala 80:57]
  wire [63:0] _io_decodeOut_oprand1_T_41 = 3'h2 == op1 ? _io_decodeOut_oprand1_T_24 : _io_decodeOut_oprand1_T_39; // @[Mux.scala 80:57]
  wire [63:0] _io_decodeOut_oprand1_T_43 = 3'h3 == op1 ? _io_decodeOut_oprand1_T_31 : _io_decodeOut_oprand1_T_41; // @[Mux.scala 80:57]
  wire [63:0] _io_decodeOut_oprand1_T_45 = 3'h5 == op1 ? _io_decodeOut_oprand1_T_37 : _io_decodeOut_oprand1_T_43; // @[Mux.scala 80:57]
  wire [63:0] _io_decodeOut_oprand1_T_47 = 3'h0 == op1 ? io_reg1_data : _io_decodeOut_oprand1_T_45; // @[Mux.scala 80:57]
  wire [63:0] _io_decodeOut_oprand1_T_49 = 3'h7 == op1 ? io_pc : _io_decodeOut_oprand1_T_47; // @[Mux.scala 80:57]
  wire [63:0] _io_decodeOut_oprand2_T_39 = 3'h1 == op2 ? _io_decodeOut_oprand1_T_14 : _io_decodeOut_oprand1_T_4; // @[Mux.scala 80:57]
  wire [63:0] _io_decodeOut_oprand2_T_41 = 3'h2 == op2 ? _io_decodeOut_oprand1_T_24 : _io_decodeOut_oprand2_T_39; // @[Mux.scala 80:57]
  wire [63:0] _io_decodeOut_oprand2_T_43 = 3'h3 == op2 ? _io_decodeOut_oprand1_T_31 : _io_decodeOut_oprand2_T_41; // @[Mux.scala 80:57]
  wire [63:0] _io_decodeOut_oprand2_T_45 = 3'h5 == op2 ? _io_decodeOut_oprand1_T_37 : _io_decodeOut_oprand2_T_43; // @[Mux.scala 80:57]
  wire [63:0] _io_decodeOut_oprand2_T_47 = 3'h0 == op2 ? io_reg2_data : _io_decodeOut_oprand2_T_45; // @[Mux.scala 80:57]
  wire [63:0] _io_decodeOut_oprand2_T_49 = 3'h7 == op2 ? io_pc : _io_decodeOut_oprand2_T_47; // @[Mux.scala 80:57]
  wire [63:0] _io_decodeOut_branchInfo_branchTarget_T_12 = io_pc + _io_decodeOut_oprand1_T_14; // @[riscv64.scala 200:13]
  assign io_decodeOut_regWrAddr = io_inst[11:7]; // @[riscv64.scala 192:13]
  assign io_decodeOut_regWrEn = _T_1 | (_T_3 | (_T_5 | (_T_7 | _T_425))); // @[Lookup.scala 33:37]
  assign io_decodeOut_oprand1 = 3'h6 == op1 ? 64'h0 : _io_decodeOut_oprand1_T_49; // @[Mux.scala 80:57]
  assign io_decodeOut_oprand2 = 3'h6 == op2 ? 64'h0 : _io_decodeOut_oprand2_T_49; // @[Mux.scala 80:57]
  assign io_decodeOut_storeData = io_reg2_data; // @[Decode.scala 60:28]
  assign io_decodeOut_aluOp = _T_1 ? 4'h0 : _T_611; // @[Lookup.scala 33:37]
  assign io_decodeOut_memOp = _T_1 ? 4'hb : _T_550; // @[Lookup.scala 33:37]
  assign io_decodeOut_mduOp = _T_1 ? 4'h8 : _T_672; // @[Lookup.scala 33:37]
  assign io_decodeOut_opWidth = _T_1 ? 1'h0 : _T_733; // @[Lookup.scala 33:37]
  assign io_decodeOut_branchInfo_bType = _T_1 ? 2'h0 : _T_489; // @[Lookup.scala 33:37]
  assign io_decodeOut_branchInfo_branchTarget = branchType == 2'h1 ? _io_decodeOut_branchInfo_branchTarget_T_12 :
    io_decodeIn_branchInfo_branchTarget; // @[Decode.scala 66:48]
  assign io_reg1_addr = io_inst[19:15]; // @[riscv64.scala 184:13]
  assign io_reg1_en = _T_1 ? 1'h0 : _T_184; // @[Lookup.scala 33:37]
  assign io_reg2_addr = io_inst[24:20]; // @[riscv64.scala 188:13]
  assign io_reg2_en = _T_1 ? 1'h0 : _T_245; // @[Lookup.scala 33:37]
endmodule
module MDU(
  input  [63:0] io_oprand1,
  input  [63:0] io_oprand2,
  input  [3:0]  io_opType,
  output [63:0] io_result
);
  wire [64:0] _div_res_T_3 = $signed(io_oprand1) / $signed(io_oprand2); // @[Execute.scala 87:62]
  wire [63:0] _div_res_T_4 = io_oprand1 / io_oprand2; // @[Execute.scala 88:37]
  wire [63:0] _div_res_T_8 = $signed(io_oprand1) % $signed(io_oprand2); // @[Execute.scala 89:62]
  wire [63:0] _GEN_0 = io_oprand1 % io_oprand2; // @[Execute.scala 90:37]
  wire [63:0] _div_res_T_9 = _GEN_0[63:0]; // @[Execute.scala 90:37]
  wire [64:0] _div_res_T_11 = 4'h4 == io_opType ? _div_res_T_3 : 65'h0; // @[Mux.scala 80:57]
  wire [64:0] _div_res_T_13 = 4'h5 == io_opType ? {{1'd0}, _div_res_T_4} : _div_res_T_11; // @[Mux.scala 80:57]
  wire [64:0] _div_res_T_15 = 4'h6 == io_opType ? {{1'd0}, _div_res_T_8} : _div_res_T_13; // @[Mux.scala 80:57]
  wire [64:0] div_res = 4'h7 == io_opType ? {{1'd0}, _div_res_T_9} : _div_res_T_15; // @[Mux.scala 80:57]
  wire [127:0] _mul_res_final_T = io_oprand1 * io_oprand2; // @[Execute.scala 94:37]
  wire [64:0] _mul_res_final_T_3 = {1'b0,$signed(io_oprand2)}; // @[Execute.scala 95:44]
  wire [128:0] _mul_res_final_T_4 = $signed(io_oprand1) * $signed(_mul_res_final_T_3); // @[Execute.scala 95:44]
  wire [127:0] _mul_res_final_T_7 = _mul_res_final_T_4[127:0]; // @[Execute.scala 95:62]
  wire [127:0] _mul_res_final_T_12 = $signed(io_oprand1) * $signed(io_oprand2); // @[Execute.scala 96:62]
  wire [63:0] _mul_res_final_T_17 = 4'h0 == io_opType ? _mul_res_final_T[63:0] : 64'h0; // @[Mux.scala 80:57]
  wire [63:0] _mul_res_final_T_19 = 4'h1 == io_opType ? _mul_res_final_T_7[127:64] : _mul_res_final_T_17; // @[Mux.scala 80:57]
  wire [63:0] _mul_res_final_T_21 = 4'h2 == io_opType ? _mul_res_final_T_12[127:64] : _mul_res_final_T_19; // @[Mux.scala 80:57]
  wire [63:0] mul_res_final = 4'h3 == io_opType ? _mul_res_final_T[127:64] : _mul_res_final_T_21; // @[Mux.scala 80:57]
  wire [64:0] _io_result_T_3 = io_opType[2] ? div_res : {{1'd0}, mul_res_final}; // @[Execute.scala 100:21]
  assign io_result = _io_result_T_3[63:0]; // @[Execute.scala 100:15]
endmodule
module Execute(
  input  [4:0]  io_exeIn_regWrAddr,
  input         io_exeIn_regWrEn,
  input  [63:0] io_exeIn_oprand1,
  input  [63:0] io_exeIn_oprand2,
  input  [63:0] io_exeIn_storeData,
  input  [3:0]  io_exeIn_aluOp,
  input  [3:0]  io_exeIn_memOp,
  input  [3:0]  io_exeIn_mduOp,
  input         io_exeIn_opWidth,
  input  [1:0]  io_exeIn_branchInfo_bType,
  input  [63:0] io_exeIn_branchInfo_branchTarget,
  output [63:0] io_exeOut_storeData,
  output [63:0] io_exeOut_aluRes,
  output [3:0]  io_exeOut_memOp,
  output [4:0]  io_exeOut_regWrAddr,
  output        io_exeOut_regWrEn,
  output [1:0]  io_branchInfo_bType,
  output [63:0] io_branchInfo_branchTarget
);
  wire [63:0] mdu_io_oprand1; // @[Execute.scala 53:21]
  wire [63:0] mdu_io_oprand2; // @[Execute.scala 53:21]
  wire [3:0] mdu_io_opType; // @[Execute.scala 53:21]
  wire [63:0] mdu_io_result; // @[Execute.scala 53:21]
  wire  _shOprand1_T_1 = io_exeIn_aluOp == 4'hb & io_exeIn_opWidth; // @[Execute.scala 21:40]
  wire [31:0] _shOprand1_res_T_2 = io_exeIn_oprand1[31] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [63:0] shOprand1_res = {_shOprand1_res_T_2,io_exeIn_oprand1[31:0]}; // @[tools.scala 9:88]
  wire  _shOprand1_T_4 = io_exeIn_aluOp == 4'hc & io_exeIn_opWidth; // @[Execute.scala 22:40]
  wire [63:0] shOprand1_res_1 = {32'h0,io_exeIn_oprand1[31:0]}; // @[tools.scala 16:75]
  wire [63:0] _shOprand1_T_6 = _shOprand1_T_4 ? shOprand1_res_1 : io_exeIn_oprand1; // @[Mux.scala 98:16]
  wire [63:0] shOprand1 = _shOprand1_T_1 ? shOprand1_res : _shOprand1_T_6; // @[Mux.scala 98:16]
  wire [5:0] shamt = io_exeIn_opWidth ? {{1'd0}, io_exeIn_oprand2[4:0]} : io_exeIn_oprand2[5:0]; // @[Execute.scala 24:20]
  wire [63:0] _result_T_1 = io_exeIn_oprand1 + io_exeIn_oprand2; // @[Execute.scala 27:36]
  wire [63:0] _result_T_3 = io_exeIn_oprand1 - io_exeIn_oprand2; // @[Execute.scala 28:36]
  wire [63:0] _result_T_4 = io_exeIn_oprand1 ^ io_exeIn_oprand2; // @[Execute.scala 29:36]
  wire [63:0] _result_T_5 = io_exeIn_oprand1 | io_exeIn_oprand2; // @[Execute.scala 30:36]
  wire [63:0] _result_T_6 = io_exeIn_oprand1 & io_exeIn_oprand2; // @[Execute.scala 31:36]
  wire  _result_T_9 = $signed(io_exeIn_oprand1) < $signed(io_exeIn_oprand2); // @[Execute.scala 32:43]
  wire  _result_T_10 = io_exeIn_oprand1 < io_exeIn_oprand2; // @[Execute.scala 33:36]
  wire  _result_T_11 = io_exeIn_oprand1 == io_exeIn_oprand2; // @[Execute.scala 34:36]
  wire  _result_T_12 = io_exeIn_oprand1 != io_exeIn_oprand2; // @[Execute.scala 35:36]
  wire  _result_T_15 = $signed(io_exeIn_oprand1) >= $signed(io_exeIn_oprand2); // @[Execute.scala 36:43]
  wire  _result_T_16 = io_exeIn_oprand1 >= io_exeIn_oprand2; // @[Execute.scala 37:36]
  wire [126:0] _GEN_0 = {{63'd0}, io_exeIn_oprand1}; // @[Execute.scala 38:36]
  wire [126:0] _result_T_17 = _GEN_0 << shamt; // @[Execute.scala 38:36]
  wire [63:0] _result_T_18 = shOprand1 >> shamt; // @[Execute.scala 39:38]
  wire [63:0] _result_T_19 = _shOprand1_T_1 ? shOprand1_res : _shOprand1_T_6; // @[Execute.scala 40:38]
  wire [63:0] _result_T_21 = $signed(_result_T_19) >>> shamt; // @[Execute.scala 40:55]
  wire [63:0] _result_T_23 = 4'h0 == io_exeIn_aluOp ? _result_T_1 : 64'h0; // @[Mux.scala 80:57]
  wire [63:0] _result_T_25 = 4'h1 == io_exeIn_aluOp ? _result_T_3 : _result_T_23; // @[Mux.scala 80:57]
  wire [63:0] _result_T_27 = 4'ha == io_exeIn_aluOp ? _result_T_4 : _result_T_25; // @[Mux.scala 80:57]
  wire [63:0] _result_T_29 = 4'h9 == io_exeIn_aluOp ? _result_T_5 : _result_T_27; // @[Mux.scala 80:57]
  wire [63:0] _result_T_31 = 4'h8 == io_exeIn_aluOp ? _result_T_6 : _result_T_29; // @[Mux.scala 80:57]
  wire [63:0] _result_T_33 = 4'h2 == io_exeIn_aluOp ? {{63'd0}, _result_T_9} : _result_T_31; // @[Mux.scala 80:57]
  wire [63:0] _result_T_35 = 4'h3 == io_exeIn_aluOp ? {{63'd0}, _result_T_10} : _result_T_33; // @[Mux.scala 80:57]
  wire [63:0] _result_T_37 = 4'h7 == io_exeIn_aluOp ? {{63'd0}, _result_T_11} : _result_T_35; // @[Mux.scala 80:57]
  wire [63:0] _result_T_39 = 4'h6 == io_exeIn_aluOp ? {{63'd0}, _result_T_12} : _result_T_37; // @[Mux.scala 80:57]
  wire [63:0] _result_T_41 = 4'h4 == io_exeIn_aluOp ? {{63'd0}, _result_T_15} : _result_T_39; // @[Mux.scala 80:57]
  wire [63:0] _result_T_43 = 4'h5 == io_exeIn_aluOp ? {{63'd0}, _result_T_16} : _result_T_41; // @[Mux.scala 80:57]
  wire [126:0] _result_T_45 = 4'hd == io_exeIn_aluOp ? _result_T_17 : {{63'd0}, _result_T_43}; // @[Mux.scala 80:57]
  wire [126:0] _result_T_47 = 4'hc == io_exeIn_aluOp ? {{63'd0}, _result_T_18} : _result_T_45; // @[Mux.scala 80:57]
  wire [126:0] result = 4'hb == io_exeIn_aluOp ? {{63'd0}, _result_T_21} : _result_T_47; // @[Mux.scala 80:57]
  wire [31:0] _aluRes_res_T_2 = result[31] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [63:0] aluRes_res = {_aluRes_res_T_2,result[31:0]}; // @[tools.scala 9:88]
  wire [126:0] aluRes = io_exeIn_opWidth ? {{63'd0}, aluRes_res} : result; // @[Execute.scala 44:21]
  wire [126:0] arithmeticRes = io_exeIn_mduOp != 4'h8 ? {{63'd0}, mdu_io_result} : aluRes; // @[Execute.scala 60:28]
  wire  btype = io_exeIn_branchInfo_bType[1]; // @[Execute.scala 65:42]
  wire [126:0] _io_branchInfo_branchTarget_T = btype ? aluRes : {{63'd0}, io_exeIn_branchInfo_branchTarget}; // @[Execute.scala 66:38]
  wire [126:0] _io_exeOut_aluRes_T = btype ? {{63'd0}, io_exeIn_branchInfo_branchTarget} : arithmeticRes; // @[Execute.scala 70:31]
  MDU mdu ( // @[Execute.scala 53:21]
    .io_oprand1(mdu_io_oprand1),
    .io_oprand2(mdu_io_oprand2),
    .io_opType(mdu_io_opType),
    .io_result(mdu_io_result)
  );
  assign io_exeOut_storeData = io_exeIn_storeData; // @[Execute.scala 50:25]
  assign io_exeOut_aluRes = _io_exeOut_aluRes_T[63:0]; // @[Execute.scala 70:25]
  assign io_exeOut_memOp = io_exeIn_memOp; // @[Execute.scala 47:25]
  assign io_exeOut_regWrAddr = io_exeIn_regWrAddr; // @[Execute.scala 48:25]
  assign io_exeOut_regWrEn = io_exeIn_regWrEn; // @[Execute.scala 49:25]
  assign io_branchInfo_bType = io_exeIn_branchInfo_bType != 2'h1 | aluRes == 127'h1 ? io_exeIn_branchInfo_bType : 2'h0; // @[Execute.scala 69:31]
  assign io_branchInfo_branchTarget = _io_branchInfo_branchTarget_T[63:0]; // @[Execute.scala 66:32]
  assign mdu_io_oprand1 = io_exeIn_oprand1; // @[Execute.scala 55:20]
  assign mdu_io_oprand2 = io_exeIn_oprand2; // @[Execute.scala 56:20]
  assign mdu_io_opType = io_exeIn_mduOp; // @[Execute.scala 54:19]
endmodule
module Memory(
  input  [63:0] io_memIn_storeData,
  input  [63:0] io_memIn_aluRes,
  input  [3:0]  io_memIn_memOp,
  input  [4:0]  io_memIn_regWrAddr,
  input         io_memIn_regWrEn,
  output [4:0]  io_memOut_regWrAddr,
  output        io_memOut_regWrEn,
  output [63:0] io_memOut_regWrData
);
  wire [63:0] mem_memRead_data; // @[Memory.scala 20:21]
  wire [63:0] mem_memRead_addr; // @[Memory.scala 20:21]
  wire  mem_memRead_en; // @[Memory.scala 20:21]
  wire [63:0] mem_memWrite_data; // @[Memory.scala 20:21]
  wire [63:0] mem_memWrite_addr; // @[Memory.scala 20:21]
  wire  mem_memWrite_en; // @[Memory.scala 20:21]
  wire [3:0] mem_memWrite_wrSize; // @[Memory.scala 20:21]
  wire [63:0] memRead_data = mem_memRead_data; // @[Memory.scala 17:25 Memory.scala 22:25]
  wire [55:0] _res_T_2 = memRead_data[7] ? 56'hffffffffffffff : 56'h0; // @[Bitwise.scala 72:12]
  wire [63:0] res = {_res_T_2,memRead_data[7:0]}; // @[tools.scala 9:88]
  wire [47:0] _res_T_5 = memRead_data[15] ? 48'hffffffffffff : 48'h0; // @[Bitwise.scala 72:12]
  wire [63:0] res_1 = {_res_T_5,memRead_data[15:0]}; // @[tools.scala 9:88]
  wire [31:0] _res_T_8 = memRead_data[31] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [63:0] res_2 = {_res_T_8,memRead_data[31:0]}; // @[tools.scala 9:88]
  wire  _T_8 = 4'hb == io_memIn_memOp; // @[Lookup.scala 31:38]
  wire  _T_10 = 4'h0 == io_memIn_memOp; // @[Lookup.scala 31:38]
  wire  _T_12 = 4'h4 == io_memIn_memOp; // @[Lookup.scala 31:38]
  wire  _T_14 = 4'h1 == io_memIn_memOp; // @[Lookup.scala 31:38]
  wire  _T_16 = 4'h5 == io_memIn_memOp; // @[Lookup.scala 31:38]
  wire  _T_18 = 4'h2 == io_memIn_memOp; // @[Lookup.scala 31:38]
  wire  _T_20 = 4'h6 == io_memIn_memOp; // @[Lookup.scala 31:38]
  wire  _T_22 = 4'h3 == io_memIn_memOp; // @[Lookup.scala 31:38]
  wire  _T_24 = 4'h7 == io_memIn_memOp; // @[Lookup.scala 31:38]
  wire  _T_26 = 4'h8 == io_memIn_memOp; // @[Lookup.scala 31:38]
  wire  _T_28 = 4'h9 == io_memIn_memOp; // @[Lookup.scala 31:38]
  wire  _T_30 = 4'ha == io_memIn_memOp; // @[Lookup.scala 31:38]
  wire  _T_46 = _T_22 ? 1'h0 : _T_24 | (_T_26 | (_T_28 | _T_30)); // @[Lookup.scala 33:37]
  wire  _T_47 = _T_20 ? 1'h0 : _T_46; // @[Lookup.scala 33:37]
  wire  _T_48 = _T_18 ? 1'h0 : _T_47; // @[Lookup.scala 33:37]
  wire  _T_49 = _T_16 ? 1'h0 : _T_48; // @[Lookup.scala 33:37]
  wire  _T_50 = _T_14 ? 1'h0 : _T_49; // @[Lookup.scala 33:37]
  wire  _T_51 = _T_12 ? 1'h0 : _T_50; // @[Lookup.scala 33:37]
  wire  _T_52 = _T_10 ? 1'h0 : _T_51; // @[Lookup.scala 33:37]
  wire [63:0] _T_57 = _T_22 ? memRead_data : 64'h0; // @[Lookup.scala 33:37]
  wire [63:0] _T_58 = _T_20 ? {{32'd0}, memRead_data[31:0]} : _T_57; // @[Lookup.scala 33:37]
  wire [63:0] _T_59 = _T_18 ? res_2 : _T_58; // @[Lookup.scala 33:37]
  wire [63:0] _T_60 = _T_16 ? {{48'd0}, memRead_data[15:0]} : _T_59; // @[Lookup.scala 33:37]
  wire [63:0] _T_61 = _T_14 ? res_1 : _T_60; // @[Lookup.scala 33:37]
  wire [63:0] _T_62 = _T_12 ? {{56'd0}, memRead_data[7:0]} : _T_61; // @[Lookup.scala 33:37]
  wire [63:0] _T_63 = _T_10 ? res : _T_62; // @[Lookup.scala 33:37]
  wire [63:0] memReadData = _T_8 ? 64'h0 : _T_63; // @[Lookup.scala 33:37]
  wire [3:0] _T_64 = _T_30 ? 4'h8 : 4'h0; // @[Lookup.scala 33:37]
  wire [3:0] _T_65 = _T_28 ? 4'h4 : _T_64; // @[Lookup.scala 33:37]
  wire [3:0] _T_66 = _T_26 ? 4'h2 : _T_65; // @[Lookup.scala 33:37]
  wire [3:0] _T_67 = _T_24 ? 4'h1 : _T_66; // @[Lookup.scala 33:37]
  wire [3:0] _T_68 = _T_22 ? 4'h0 : _T_67; // @[Lookup.scala 33:37]
  wire [3:0] _T_69 = _T_20 ? 4'h0 : _T_68; // @[Lookup.scala 33:37]
  wire [3:0] _T_70 = _T_18 ? 4'h0 : _T_69; // @[Lookup.scala 33:37]
  wire [3:0] _T_71 = _T_16 ? 4'h0 : _T_70; // @[Lookup.scala 33:37]
  wire [3:0] _T_72 = _T_14 ? 4'h0 : _T_71; // @[Lookup.scala 33:37]
  wire [3:0] _T_73 = _T_12 ? 4'h0 : _T_72; // @[Lookup.scala 33:37]
  wire [3:0] _T_74 = _T_10 ? 4'h0 : _T_73; // @[Lookup.scala 33:37]
  PmemManager mem ( // @[Memory.scala 20:21]
    .memRead_data(mem_memRead_data),
    .memRead_addr(mem_memRead_addr),
    .memRead_en(mem_memRead_en),
    .memWrite_data(mem_memWrite_data),
    .memWrite_addr(mem_memWrite_addr),
    .memWrite_en(mem_memWrite_en),
    .memWrite_wrSize(mem_memWrite_wrSize)
  );
  assign io_memOut_regWrAddr = io_memIn_regWrAddr; // @[Memory.scala 63:33]
  assign io_memOut_regWrEn = io_memIn_regWrEn; // @[Memory.scala 64:33]
  assign io_memOut_regWrData = io_memIn_memOp == 4'hb ? io_memIn_aluRes : memReadData; // @[Memory.scala 65:39]
  assign mem_memRead_addr = io_memIn_aluRes; // @[Memory.scala 17:25 Memory.scala 59:25]
  assign mem_memRead_en = _T_8 ? 1'h0 : _T_10 | (_T_12 | (_T_14 | (_T_16 | (_T_18 | (_T_20 | _T_22))))); // @[Lookup.scala 33:37]
  assign mem_memWrite_data = io_memIn_storeData; // @[Memory.scala 18:25 Memory.scala 54:25]
  assign mem_memWrite_addr = io_memIn_aluRes; // @[Memory.scala 18:25 Memory.scala 55:25]
  assign mem_memWrite_en = _T_8 ? 1'h0 : _T_52; // @[Lookup.scala 33:37]
  assign mem_memWrite_wrSize = _T_8 ? 4'h0 : _T_74; // @[Lookup.scala 33:37]
endmodule
module WriteBack(
  output [63:0] io_regw_data,
  output [4:0]  io_regw_addr,
  output        io_regw_en,
  input  [4:0]  io_wbIn_regWrAddr,
  input         io_wbIn_regWrEn,
  input  [63:0] io_wbIn_regWrData,
  output [63:0] io_wbOut_regWrdata
);
  assign io_regw_data = io_wbIn_regWrData; // @[WriteBack.scala 17:18]
  assign io_regw_addr = io_wbIn_regWrAddr; // @[WriteBack.scala 16:18]
  assign io_regw_en = io_wbIn_regWrEn; // @[WriteBack.scala 18:18]
  assign io_wbOut_regWrdata = io_wbIn_regWrData; // @[WriteBack.scala 22:25]
endmodule
module RegFile(
  input         clock,
  input         reset,
  output [63:0] io_reg1_data,
  input  [4:0]  io_reg1_addr,
  input         io_reg1_en,
  output [63:0] io_reg2_data,
  input  [4:0]  io_reg2_addr,
  input         io_reg2_en,
  input  [63:0] io_regw_data,
  input  [4:0]  io_regw_addr,
  input         io_regw_en
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [63:0] _RAND_2;
  reg [63:0] _RAND_3;
  reg [63:0] _RAND_4;
  reg [63:0] _RAND_5;
  reg [63:0] _RAND_6;
  reg [63:0] _RAND_7;
  reg [63:0] _RAND_8;
  reg [63:0] _RAND_9;
  reg [63:0] _RAND_10;
  reg [63:0] _RAND_11;
  reg [63:0] _RAND_12;
  reg [63:0] _RAND_13;
  reg [63:0] _RAND_14;
  reg [63:0] _RAND_15;
  reg [63:0] _RAND_16;
  reg [63:0] _RAND_17;
  reg [63:0] _RAND_18;
  reg [63:0] _RAND_19;
  reg [63:0] _RAND_20;
  reg [63:0] _RAND_21;
  reg [63:0] _RAND_22;
  reg [63:0] _RAND_23;
  reg [63:0] _RAND_24;
  reg [63:0] _RAND_25;
  reg [63:0] _RAND_26;
  reg [63:0] _RAND_27;
  reg [63:0] _RAND_28;
  reg [63:0] _RAND_29;
  reg [63:0] _RAND_30;
  reg [63:0] _RAND_31;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] regFile_0; // @[RegFile.scala 14:27]
  reg [63:0] regFile_1; // @[RegFile.scala 14:27]
  reg [63:0] regFile_2; // @[RegFile.scala 14:27]
  reg [63:0] regFile_3; // @[RegFile.scala 14:27]
  reg [63:0] regFile_4; // @[RegFile.scala 14:27]
  reg [63:0] regFile_5; // @[RegFile.scala 14:27]
  reg [63:0] regFile_6; // @[RegFile.scala 14:27]
  reg [63:0] regFile_7; // @[RegFile.scala 14:27]
  reg [63:0] regFile_8; // @[RegFile.scala 14:27]
  reg [63:0] regFile_9; // @[RegFile.scala 14:27]
  reg [63:0] regFile_10; // @[RegFile.scala 14:27]
  reg [63:0] regFile_11; // @[RegFile.scala 14:27]
  reg [63:0] regFile_12; // @[RegFile.scala 14:27]
  reg [63:0] regFile_13; // @[RegFile.scala 14:27]
  reg [63:0] regFile_14; // @[RegFile.scala 14:27]
  reg [63:0] regFile_15; // @[RegFile.scala 14:27]
  reg [63:0] regFile_16; // @[RegFile.scala 14:27]
  reg [63:0] regFile_17; // @[RegFile.scala 14:27]
  reg [63:0] regFile_18; // @[RegFile.scala 14:27]
  reg [63:0] regFile_19; // @[RegFile.scala 14:27]
  reg [63:0] regFile_20; // @[RegFile.scala 14:27]
  reg [63:0] regFile_21; // @[RegFile.scala 14:27]
  reg [63:0] regFile_22; // @[RegFile.scala 14:27]
  reg [63:0] regFile_23; // @[RegFile.scala 14:27]
  reg [63:0] regFile_24; // @[RegFile.scala 14:27]
  reg [63:0] regFile_25; // @[RegFile.scala 14:27]
  reg [63:0] regFile_26; // @[RegFile.scala 14:27]
  reg [63:0] regFile_27; // @[RegFile.scala 14:27]
  reg [63:0] regFile_28; // @[RegFile.scala 14:27]
  reg [63:0] regFile_29; // @[RegFile.scala 14:27]
  reg [63:0] regFile_30; // @[RegFile.scala 14:27]
  reg [63:0] regFile_31; // @[RegFile.scala 14:27]
  wire [63:0] _GEN_1 = 5'h1 == io_reg1_addr ? regFile_1 : regFile_0; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_2 = 5'h2 == io_reg1_addr ? regFile_2 : _GEN_1; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_3 = 5'h3 == io_reg1_addr ? regFile_3 : _GEN_2; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_4 = 5'h4 == io_reg1_addr ? regFile_4 : _GEN_3; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_5 = 5'h5 == io_reg1_addr ? regFile_5 : _GEN_4; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_6 = 5'h6 == io_reg1_addr ? regFile_6 : _GEN_5; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_7 = 5'h7 == io_reg1_addr ? regFile_7 : _GEN_6; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_8 = 5'h8 == io_reg1_addr ? regFile_8 : _GEN_7; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_9 = 5'h9 == io_reg1_addr ? regFile_9 : _GEN_8; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_10 = 5'ha == io_reg1_addr ? regFile_10 : _GEN_9; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_11 = 5'hb == io_reg1_addr ? regFile_11 : _GEN_10; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_12 = 5'hc == io_reg1_addr ? regFile_12 : _GEN_11; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_13 = 5'hd == io_reg1_addr ? regFile_13 : _GEN_12; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_14 = 5'he == io_reg1_addr ? regFile_14 : _GEN_13; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_15 = 5'hf == io_reg1_addr ? regFile_15 : _GEN_14; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_16 = 5'h10 == io_reg1_addr ? regFile_16 : _GEN_15; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_17 = 5'h11 == io_reg1_addr ? regFile_17 : _GEN_16; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_18 = 5'h12 == io_reg1_addr ? regFile_18 : _GEN_17; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_19 = 5'h13 == io_reg1_addr ? regFile_19 : _GEN_18; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_20 = 5'h14 == io_reg1_addr ? regFile_20 : _GEN_19; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_21 = 5'h15 == io_reg1_addr ? regFile_21 : _GEN_20; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_22 = 5'h16 == io_reg1_addr ? regFile_22 : _GEN_21; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_23 = 5'h17 == io_reg1_addr ? regFile_23 : _GEN_22; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_24 = 5'h18 == io_reg1_addr ? regFile_24 : _GEN_23; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_25 = 5'h19 == io_reg1_addr ? regFile_25 : _GEN_24; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_26 = 5'h1a == io_reg1_addr ? regFile_26 : _GEN_25; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_27 = 5'h1b == io_reg1_addr ? regFile_27 : _GEN_26; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_28 = 5'h1c == io_reg1_addr ? regFile_28 : _GEN_27; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_29 = 5'h1d == io_reg1_addr ? regFile_29 : _GEN_28; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_30 = 5'h1e == io_reg1_addr ? regFile_30 : _GEN_29; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_31 = 5'h1f == io_reg1_addr ? regFile_31 : _GEN_30; // @[RegFile.scala 16:24 RegFile.scala 16:24]
  wire [63:0] _GEN_33 = 5'h1 == io_reg2_addr ? regFile_1 : regFile_0; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_34 = 5'h2 == io_reg2_addr ? regFile_2 : _GEN_33; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_35 = 5'h3 == io_reg2_addr ? regFile_3 : _GEN_34; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_36 = 5'h4 == io_reg2_addr ? regFile_4 : _GEN_35; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_37 = 5'h5 == io_reg2_addr ? regFile_5 : _GEN_36; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_38 = 5'h6 == io_reg2_addr ? regFile_6 : _GEN_37; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_39 = 5'h7 == io_reg2_addr ? regFile_7 : _GEN_38; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_40 = 5'h8 == io_reg2_addr ? regFile_8 : _GEN_39; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_41 = 5'h9 == io_reg2_addr ? regFile_9 : _GEN_40; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_42 = 5'ha == io_reg2_addr ? regFile_10 : _GEN_41; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_43 = 5'hb == io_reg2_addr ? regFile_11 : _GEN_42; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_44 = 5'hc == io_reg2_addr ? regFile_12 : _GEN_43; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_45 = 5'hd == io_reg2_addr ? regFile_13 : _GEN_44; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_46 = 5'he == io_reg2_addr ? regFile_14 : _GEN_45; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_47 = 5'hf == io_reg2_addr ? regFile_15 : _GEN_46; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_48 = 5'h10 == io_reg2_addr ? regFile_16 : _GEN_47; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_49 = 5'h11 == io_reg2_addr ? regFile_17 : _GEN_48; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_50 = 5'h12 == io_reg2_addr ? regFile_18 : _GEN_49; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_51 = 5'h13 == io_reg2_addr ? regFile_19 : _GEN_50; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_52 = 5'h14 == io_reg2_addr ? regFile_20 : _GEN_51; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_53 = 5'h15 == io_reg2_addr ? regFile_21 : _GEN_52; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_54 = 5'h16 == io_reg2_addr ? regFile_22 : _GEN_53; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_55 = 5'h17 == io_reg2_addr ? regFile_23 : _GEN_54; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_56 = 5'h18 == io_reg2_addr ? regFile_24 : _GEN_55; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_57 = 5'h19 == io_reg2_addr ? regFile_25 : _GEN_56; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_58 = 5'h1a == io_reg2_addr ? regFile_26 : _GEN_57; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_59 = 5'h1b == io_reg2_addr ? regFile_27 : _GEN_58; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_60 = 5'h1c == io_reg2_addr ? regFile_28 : _GEN_59; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_61 = 5'h1d == io_reg2_addr ? regFile_29 : _GEN_60; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_62 = 5'h1e == io_reg2_addr ? regFile_30 : _GEN_61; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  wire [63:0] _GEN_63 = 5'h1f == io_reg2_addr ? regFile_31 : _GEN_62; // @[RegFile.scala 17:24 RegFile.scala 17:24]
  assign io_reg1_data = io_reg1_en ? _GEN_31 : 64'h0; // @[RegFile.scala 16:24]
  assign io_reg2_data = io_reg2_en ? _GEN_63 : 64'h0; // @[RegFile.scala 17:24]
  always @(posedge clock) begin
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_0 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h0 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_0 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_1 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h1 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_1 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_2 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h2 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_2 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_3 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h3 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_3 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_4 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h4 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_4 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_5 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h5 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_5 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_6 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h6 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_6 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_7 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h7 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_7 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_8 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h8 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_8 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_9 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h9 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_9 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_10 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'ha == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_10 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_11 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'hb == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_11 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_12 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'hc == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_12 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_13 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'hd == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_13 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_14 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'he == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_14 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_15 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'hf == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_15 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_16 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h10 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_16 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_17 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h11 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_17 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_18 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h12 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_18 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_19 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h13 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_19 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_20 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h14 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_20 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_21 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h15 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_21 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_22 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h16 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_22 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_23 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h17 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_23 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_24 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h18 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_24 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_25 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h19 == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_25 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_26 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h1a == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_26 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_27 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h1b == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_27 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_28 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h1c == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_28 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_29 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h1d == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_29 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_30 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h1e == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_30 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
    if (reset) begin // @[RegFile.scala 14:27]
      regFile_31 <= 64'h0; // @[RegFile.scala 14:27]
    end else if (io_regw_en & io_regw_addr != 5'h0) begin // @[RegFile.scala 19:37]
      if (5'h1f == io_regw_addr) begin // @[RegFile.scala 20:31]
        regFile_31 <= io_regw_data; // @[RegFile.scala 20:31]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  regFile_0 = _RAND_0[63:0];
  _RAND_1 = {2{`RANDOM}};
  regFile_1 = _RAND_1[63:0];
  _RAND_2 = {2{`RANDOM}};
  regFile_2 = _RAND_2[63:0];
  _RAND_3 = {2{`RANDOM}};
  regFile_3 = _RAND_3[63:0];
  _RAND_4 = {2{`RANDOM}};
  regFile_4 = _RAND_4[63:0];
  _RAND_5 = {2{`RANDOM}};
  regFile_5 = _RAND_5[63:0];
  _RAND_6 = {2{`RANDOM}};
  regFile_6 = _RAND_6[63:0];
  _RAND_7 = {2{`RANDOM}};
  regFile_7 = _RAND_7[63:0];
  _RAND_8 = {2{`RANDOM}};
  regFile_8 = _RAND_8[63:0];
  _RAND_9 = {2{`RANDOM}};
  regFile_9 = _RAND_9[63:0];
  _RAND_10 = {2{`RANDOM}};
  regFile_10 = _RAND_10[63:0];
  _RAND_11 = {2{`RANDOM}};
  regFile_11 = _RAND_11[63:0];
  _RAND_12 = {2{`RANDOM}};
  regFile_12 = _RAND_12[63:0];
  _RAND_13 = {2{`RANDOM}};
  regFile_13 = _RAND_13[63:0];
  _RAND_14 = {2{`RANDOM}};
  regFile_14 = _RAND_14[63:0];
  _RAND_15 = {2{`RANDOM}};
  regFile_15 = _RAND_15[63:0];
  _RAND_16 = {2{`RANDOM}};
  regFile_16 = _RAND_16[63:0];
  _RAND_17 = {2{`RANDOM}};
  regFile_17 = _RAND_17[63:0];
  _RAND_18 = {2{`RANDOM}};
  regFile_18 = _RAND_18[63:0];
  _RAND_19 = {2{`RANDOM}};
  regFile_19 = _RAND_19[63:0];
  _RAND_20 = {2{`RANDOM}};
  regFile_20 = _RAND_20[63:0];
  _RAND_21 = {2{`RANDOM}};
  regFile_21 = _RAND_21[63:0];
  _RAND_22 = {2{`RANDOM}};
  regFile_22 = _RAND_22[63:0];
  _RAND_23 = {2{`RANDOM}};
  regFile_23 = _RAND_23[63:0];
  _RAND_24 = {2{`RANDOM}};
  regFile_24 = _RAND_24[63:0];
  _RAND_25 = {2{`RANDOM}};
  regFile_25 = _RAND_25[63:0];
  _RAND_26 = {2{`RANDOM}};
  regFile_26 = _RAND_26[63:0];
  _RAND_27 = {2{`RANDOM}};
  regFile_27 = _RAND_27[63:0];
  _RAND_28 = {2{`RANDOM}};
  regFile_28 = _RAND_28[63:0];
  _RAND_29 = {2{`RANDOM}};
  regFile_29 = _RAND_29[63:0];
  _RAND_30 = {2{`RANDOM}};
  regFile_30 = _RAND_30[63:0];
  _RAND_31 = {2{`RANDOM}};
  regFile_31 = _RAND_31[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Core(
  input         clock,
  input         reset,
  output [63:0] io_res
);
  wire  instFetch_clock; // @[Core.scala 16:29]
  wire  instFetch_reset; // @[Core.scala 16:29]
  wire [63:0] instFetch_io_pc; // @[Core.scala 16:29]
  wire [1:0] instFetch_io_branchInfo_bType; // @[Core.scala 16:29]
  wire [63:0] instFetch_io_branchInfo_branchTarget; // @[Core.scala 16:29]
  wire [63:0] instFetch_io_ifOut_branchInfo_branchTarget; // @[Core.scala 16:29]
  wire [31:0] decode_io_inst; // @[Core.scala 17:29]
  wire [63:0] decode_io_pc; // @[Core.scala 17:29]
  wire [63:0] decode_io_decodeIn_branchInfo_branchTarget; // @[Core.scala 17:29]
  wire [4:0] decode_io_decodeOut_regWrAddr; // @[Core.scala 17:29]
  wire  decode_io_decodeOut_regWrEn; // @[Core.scala 17:29]
  wire [63:0] decode_io_decodeOut_oprand1; // @[Core.scala 17:29]
  wire [63:0] decode_io_decodeOut_oprand2; // @[Core.scala 17:29]
  wire [63:0] decode_io_decodeOut_storeData; // @[Core.scala 17:29]
  wire [3:0] decode_io_decodeOut_aluOp; // @[Core.scala 17:29]
  wire [3:0] decode_io_decodeOut_memOp; // @[Core.scala 17:29]
  wire [3:0] decode_io_decodeOut_mduOp; // @[Core.scala 17:29]
  wire  decode_io_decodeOut_opWidth; // @[Core.scala 17:29]
  wire [1:0] decode_io_decodeOut_branchInfo_bType; // @[Core.scala 17:29]
  wire [63:0] decode_io_decodeOut_branchInfo_branchTarget; // @[Core.scala 17:29]
  wire [63:0] decode_io_reg1_data; // @[Core.scala 17:29]
  wire [4:0] decode_io_reg1_addr; // @[Core.scala 17:29]
  wire  decode_io_reg1_en; // @[Core.scala 17:29]
  wire [63:0] decode_io_reg2_data; // @[Core.scala 17:29]
  wire [4:0] decode_io_reg2_addr; // @[Core.scala 17:29]
  wire  decode_io_reg2_en; // @[Core.scala 17:29]
  wire [4:0] execute_io_exeIn_regWrAddr; // @[Core.scala 18:29]
  wire  execute_io_exeIn_regWrEn; // @[Core.scala 18:29]
  wire [63:0] execute_io_exeIn_oprand1; // @[Core.scala 18:29]
  wire [63:0] execute_io_exeIn_oprand2; // @[Core.scala 18:29]
  wire [63:0] execute_io_exeIn_storeData; // @[Core.scala 18:29]
  wire [3:0] execute_io_exeIn_aluOp; // @[Core.scala 18:29]
  wire [3:0] execute_io_exeIn_memOp; // @[Core.scala 18:29]
  wire [3:0] execute_io_exeIn_mduOp; // @[Core.scala 18:29]
  wire  execute_io_exeIn_opWidth; // @[Core.scala 18:29]
  wire [1:0] execute_io_exeIn_branchInfo_bType; // @[Core.scala 18:29]
  wire [63:0] execute_io_exeIn_branchInfo_branchTarget; // @[Core.scala 18:29]
  wire [63:0] execute_io_exeOut_storeData; // @[Core.scala 18:29]
  wire [63:0] execute_io_exeOut_aluRes; // @[Core.scala 18:29]
  wire [3:0] execute_io_exeOut_memOp; // @[Core.scala 18:29]
  wire [4:0] execute_io_exeOut_regWrAddr; // @[Core.scala 18:29]
  wire  execute_io_exeOut_regWrEn; // @[Core.scala 18:29]
  wire [1:0] execute_io_branchInfo_bType; // @[Core.scala 18:29]
  wire [63:0] execute_io_branchInfo_branchTarget; // @[Core.scala 18:29]
  wire [63:0] memory_io_memIn_storeData; // @[Core.scala 19:29]
  wire [63:0] memory_io_memIn_aluRes; // @[Core.scala 19:29]
  wire [3:0] memory_io_memIn_memOp; // @[Core.scala 19:29]
  wire [4:0] memory_io_memIn_regWrAddr; // @[Core.scala 19:29]
  wire  memory_io_memIn_regWrEn; // @[Core.scala 19:29]
  wire [4:0] memory_io_memOut_regWrAddr; // @[Core.scala 19:29]
  wire  memory_io_memOut_regWrEn; // @[Core.scala 19:29]
  wire [63:0] memory_io_memOut_regWrData; // @[Core.scala 19:29]
  wire [63:0] writeBack_io_regw_data; // @[Core.scala 20:29]
  wire [4:0] writeBack_io_regw_addr; // @[Core.scala 20:29]
  wire  writeBack_io_regw_en; // @[Core.scala 20:29]
  wire [4:0] writeBack_io_wbIn_regWrAddr; // @[Core.scala 20:29]
  wire  writeBack_io_wbIn_regWrEn; // @[Core.scala 20:29]
  wire [63:0] writeBack_io_wbIn_regWrData; // @[Core.scala 20:29]
  wire [63:0] writeBack_io_wbOut_regWrdata; // @[Core.scala 20:29]
  wire  regFile_clock; // @[Core.scala 21:29]
  wire  regFile_reset; // @[Core.scala 21:29]
  wire [63:0] regFile_io_reg1_data; // @[Core.scala 21:29]
  wire [4:0] regFile_io_reg1_addr; // @[Core.scala 21:29]
  wire  regFile_io_reg1_en; // @[Core.scala 21:29]
  wire [63:0] regFile_io_reg2_data; // @[Core.scala 21:29]
  wire [4:0] regFile_io_reg2_addr; // @[Core.scala 21:29]
  wire  regFile_io_reg2_en; // @[Core.scala 21:29]
  wire [63:0] regFile_io_regw_data; // @[Core.scala 21:29]
  wire [4:0] regFile_io_regw_addr; // @[Core.scala 21:29]
  wire  regFile_io_regw_en; // @[Core.scala 21:29]
  wire [63:0] instMem_memRead_data; // @[Core.scala 26:25]
  wire [63:0] instMem_memRead_addr; // @[Core.scala 26:25]
  wire  instMem_memRead_en; // @[Core.scala 26:25]
  wire [63:0] instMem_memWrite_data; // @[Core.scala 26:25]
  wire [63:0] instMem_memWrite_addr; // @[Core.scala 26:25]
  wire  instMem_memWrite_en; // @[Core.scala 26:25]
  wire [3:0] instMem_memWrite_wrSize; // @[Core.scala 26:25]
  wire [31:0] dpi_inst; // @[Core.scala 60:21]
  wire [63:0] dpi_pc; // @[Core.scala 60:21]
  InstFetch instFetch ( // @[Core.scala 16:29]
    .clock(instFetch_clock),
    .reset(instFetch_reset),
    .io_pc(instFetch_io_pc),
    .io_branchInfo_bType(instFetch_io_branchInfo_bType),
    .io_branchInfo_branchTarget(instFetch_io_branchInfo_branchTarget),
    .io_ifOut_branchInfo_branchTarget(instFetch_io_ifOut_branchInfo_branchTarget)
  );
  Decode decode ( // @[Core.scala 17:29]
    .io_inst(decode_io_inst),
    .io_pc(decode_io_pc),
    .io_decodeIn_branchInfo_branchTarget(decode_io_decodeIn_branchInfo_branchTarget),
    .io_decodeOut_regWrAddr(decode_io_decodeOut_regWrAddr),
    .io_decodeOut_regWrEn(decode_io_decodeOut_regWrEn),
    .io_decodeOut_oprand1(decode_io_decodeOut_oprand1),
    .io_decodeOut_oprand2(decode_io_decodeOut_oprand2),
    .io_decodeOut_storeData(decode_io_decodeOut_storeData),
    .io_decodeOut_aluOp(decode_io_decodeOut_aluOp),
    .io_decodeOut_memOp(decode_io_decodeOut_memOp),
    .io_decodeOut_mduOp(decode_io_decodeOut_mduOp),
    .io_decodeOut_opWidth(decode_io_decodeOut_opWidth),
    .io_decodeOut_branchInfo_bType(decode_io_decodeOut_branchInfo_bType),
    .io_decodeOut_branchInfo_branchTarget(decode_io_decodeOut_branchInfo_branchTarget),
    .io_reg1_data(decode_io_reg1_data),
    .io_reg1_addr(decode_io_reg1_addr),
    .io_reg1_en(decode_io_reg1_en),
    .io_reg2_data(decode_io_reg2_data),
    .io_reg2_addr(decode_io_reg2_addr),
    .io_reg2_en(decode_io_reg2_en)
  );
  Execute execute ( // @[Core.scala 18:29]
    .io_exeIn_regWrAddr(execute_io_exeIn_regWrAddr),
    .io_exeIn_regWrEn(execute_io_exeIn_regWrEn),
    .io_exeIn_oprand1(execute_io_exeIn_oprand1),
    .io_exeIn_oprand2(execute_io_exeIn_oprand2),
    .io_exeIn_storeData(execute_io_exeIn_storeData),
    .io_exeIn_aluOp(execute_io_exeIn_aluOp),
    .io_exeIn_memOp(execute_io_exeIn_memOp),
    .io_exeIn_mduOp(execute_io_exeIn_mduOp),
    .io_exeIn_opWidth(execute_io_exeIn_opWidth),
    .io_exeIn_branchInfo_bType(execute_io_exeIn_branchInfo_bType),
    .io_exeIn_branchInfo_branchTarget(execute_io_exeIn_branchInfo_branchTarget),
    .io_exeOut_storeData(execute_io_exeOut_storeData),
    .io_exeOut_aluRes(execute_io_exeOut_aluRes),
    .io_exeOut_memOp(execute_io_exeOut_memOp),
    .io_exeOut_regWrAddr(execute_io_exeOut_regWrAddr),
    .io_exeOut_regWrEn(execute_io_exeOut_regWrEn),
    .io_branchInfo_bType(execute_io_branchInfo_bType),
    .io_branchInfo_branchTarget(execute_io_branchInfo_branchTarget)
  );
  Memory memory ( // @[Core.scala 19:29]
    .io_memIn_storeData(memory_io_memIn_storeData),
    .io_memIn_aluRes(memory_io_memIn_aluRes),
    .io_memIn_memOp(memory_io_memIn_memOp),
    .io_memIn_regWrAddr(memory_io_memIn_regWrAddr),
    .io_memIn_regWrEn(memory_io_memIn_regWrEn),
    .io_memOut_regWrAddr(memory_io_memOut_regWrAddr),
    .io_memOut_regWrEn(memory_io_memOut_regWrEn),
    .io_memOut_regWrData(memory_io_memOut_regWrData)
  );
  WriteBack writeBack ( // @[Core.scala 20:29]
    .io_regw_data(writeBack_io_regw_data),
    .io_regw_addr(writeBack_io_regw_addr),
    .io_regw_en(writeBack_io_regw_en),
    .io_wbIn_regWrAddr(writeBack_io_wbIn_regWrAddr),
    .io_wbIn_regWrEn(writeBack_io_wbIn_regWrEn),
    .io_wbIn_regWrData(writeBack_io_wbIn_regWrData),
    .io_wbOut_regWrdata(writeBack_io_wbOut_regWrdata)
  );
  RegFile regFile ( // @[Core.scala 21:29]
    .clock(regFile_clock),
    .reset(regFile_reset),
    .io_reg1_data(regFile_io_reg1_data),
    .io_reg1_addr(regFile_io_reg1_addr),
    .io_reg1_en(regFile_io_reg1_en),
    .io_reg2_data(regFile_io_reg2_data),
    .io_reg2_addr(regFile_io_reg2_addr),
    .io_reg2_en(regFile_io_reg2_en),
    .io_regw_data(regFile_io_regw_data),
    .io_regw_addr(regFile_io_regw_addr),
    .io_regw_en(regFile_io_regw_en)
  );
  PmemManager instMem ( // @[Core.scala 26:25]
    .memRead_data(instMem_memRead_data),
    .memRead_addr(instMem_memRead_addr),
    .memRead_en(instMem_memRead_en),
    .memWrite_data(instMem_memWrite_data),
    .memWrite_addr(instMem_memWrite_addr),
    .memWrite_en(instMem_memWrite_en),
    .memWrite_wrSize(instMem_memWrite_wrSize)
  );
  Trap dpi ( // @[Core.scala 60:21]
    .inst(dpi_inst),
    .pc(dpi_pc)
  );
  assign io_res = writeBack_io_wbOut_regWrdata; // @[Core.scala 56:12]
  assign instFetch_clock = clock;
  assign instFetch_reset = reset;
  assign instFetch_io_branchInfo_bType = execute_io_branchInfo_bType; // @[Core.scala 40:29]
  assign instFetch_io_branchInfo_branchTarget = execute_io_branchInfo_branchTarget; // @[Core.scala 40:29]
  assign decode_io_inst = instMem_memRead_data[31:0]; // @[Core.scala 42:25]
  assign decode_io_pc = instFetch_io_pc; // @[Core.scala 45:25]
  assign decode_io_decodeIn_branchInfo_branchTarget = instFetch_io_ifOut_branchInfo_branchTarget; // @[Core.scala 41:25]
  assign decode_io_reg1_data = regFile_io_reg1_data; // @[Core.scala 43:25]
  assign decode_io_reg2_data = regFile_io_reg2_data; // @[Core.scala 44:25]
  assign execute_io_exeIn_regWrAddr = decode_io_decodeOut_regWrAddr; // @[Core.scala 47:25]
  assign execute_io_exeIn_regWrEn = decode_io_decodeOut_regWrEn; // @[Core.scala 47:25]
  assign execute_io_exeIn_oprand1 = decode_io_decodeOut_oprand1; // @[Core.scala 47:25]
  assign execute_io_exeIn_oprand2 = decode_io_decodeOut_oprand2; // @[Core.scala 47:25]
  assign execute_io_exeIn_storeData = decode_io_decodeOut_storeData; // @[Core.scala 47:25]
  assign execute_io_exeIn_aluOp = decode_io_decodeOut_aluOp; // @[Core.scala 47:25]
  assign execute_io_exeIn_memOp = decode_io_decodeOut_memOp; // @[Core.scala 47:25]
  assign execute_io_exeIn_mduOp = decode_io_decodeOut_mduOp; // @[Core.scala 47:25]
  assign execute_io_exeIn_opWidth = decode_io_decodeOut_opWidth; // @[Core.scala 47:25]
  assign execute_io_exeIn_branchInfo_bType = decode_io_decodeOut_branchInfo_bType; // @[Core.scala 47:25]
  assign execute_io_exeIn_branchInfo_branchTarget = decode_io_decodeOut_branchInfo_branchTarget; // @[Core.scala 47:25]
  assign memory_io_memIn_storeData = execute_io_exeOut_storeData; // @[Core.scala 49:25]
  assign memory_io_memIn_aluRes = execute_io_exeOut_aluRes; // @[Core.scala 49:25]
  assign memory_io_memIn_memOp = execute_io_exeOut_memOp; // @[Core.scala 49:25]
  assign memory_io_memIn_regWrAddr = execute_io_exeOut_regWrAddr; // @[Core.scala 49:25]
  assign memory_io_memIn_regWrEn = execute_io_exeOut_regWrEn; // @[Core.scala 49:25]
  assign writeBack_io_wbIn_regWrAddr = memory_io_memOut_regWrAddr; // @[Core.scala 54:25]
  assign writeBack_io_wbIn_regWrEn = memory_io_memOut_regWrEn; // @[Core.scala 54:25]
  assign writeBack_io_wbIn_regWrData = memory_io_memOut_regWrData; // @[Core.scala 54:25]
  assign regFile_clock = clock;
  assign regFile_reset = reset;
  assign regFile_io_reg1_addr = decode_io_reg1_addr; // @[Core.scala 43:25]
  assign regFile_io_reg1_en = decode_io_reg1_en; // @[Core.scala 43:25]
  assign regFile_io_reg2_addr = decode_io_reg2_addr; // @[Core.scala 44:25]
  assign regFile_io_reg2_en = decode_io_reg2_en; // @[Core.scala 44:25]
  assign regFile_io_regw_data = writeBack_io_regw_data; // @[Core.scala 53:25]
  assign regFile_io_regw_addr = writeBack_io_regw_addr; // @[Core.scala 53:25]
  assign regFile_io_regw_en = writeBack_io_regw_en; // @[Core.scala 53:25]
  assign instMem_memRead_addr = instFetch_io_pc; // @[Core.scala 27:29]
  assign instMem_memRead_en = ~reset; // @[Core.scala 29:10]
  assign instMem_memWrite_data = 64'h0; // @[Core.scala 36:30]
  assign instMem_memWrite_addr = 64'h0; // @[Core.scala 35:30]
  assign instMem_memWrite_en = 1'h0; // @[Core.scala 37:30]
  assign instMem_memWrite_wrSize = 4'h0; // @[Core.scala 38:36]
  assign dpi_inst = instMem_memRead_data[31:0]; // @[Core.scala 62:17]
  assign dpi_pc = instMem_memRead_addr; // @[Core.scala 63:17]
endmodule
