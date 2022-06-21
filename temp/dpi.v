
import "DPI-C" function void trap(input int inst,input longint res);
import "DPI-C" function void print(input int inst,input longint pc);
import "DPI-C" function void reg_update(input longint data, input int index);
import "DPI-C" function void dpi_pmem_read(output longint data, input longint addr, input bit en, input bit[3:0] rd_size);
import "DPI-C" function void dpi_pmem_write(input longint data, input longint addr, input bit en, input bit[3:0] wr_size);
module Trap(
  input [31:0]  inst,
  input [63:0]  pc
);
always@(posedge Core.clock)trap(inst,Core.regFile.regFile_10);
always@(*)print(inst, pc);
always@(Core.regFile.regFile_0)reg_update(Core.regFile.regFile_0,32'd0);
always@(Core.regFile.regFile_1)reg_update(Core.regFile.regFile_1,32'd1);
always@(Core.regFile.regFile_2)reg_update(Core.regFile.regFile_2,32'd2);
always@(Core.regFile.regFile_3)reg_update(Core.regFile.regFile_3,32'd3);
always@(Core.regFile.regFile_4)reg_update(Core.regFile.regFile_4,32'd4);
always@(Core.regFile.regFile_5)reg_update(Core.regFile.regFile_5,32'd5);
always@(Core.regFile.regFile_6)reg_update(Core.regFile.regFile_6,32'd6);
always@(Core.regFile.regFile_7)reg_update(Core.regFile.regFile_7,32'd7);
always@(Core.regFile.regFile_8)reg_update(Core.regFile.regFile_8,32'd8);
always@(Core.regFile.regFile_9)reg_update(Core.regFile.regFile_9,32'd9);
always@(Core.regFile.regFile_10)reg_update(Core.regFile.regFile_10,32'd10);
always@(Core.regFile.regFile_11)reg_update(Core.regFile.regFile_11,32'd11);
always@(Core.regFile.regFile_12)reg_update(Core.regFile.regFile_12,32'd12);
always@(Core.regFile.regFile_13)reg_update(Core.regFile.regFile_13,32'd13);
always@(Core.regFile.regFile_14)reg_update(Core.regFile.regFile_14,32'd14);
always@(Core.regFile.regFile_15)reg_update(Core.regFile.regFile_15,32'd15);
always@(Core.regFile.regFile_16)reg_update(Core.regFile.regFile_16,32'd16);
always@(Core.regFile.regFile_17)reg_update(Core.regFile.regFile_17,32'd17);
always@(Core.regFile.regFile_18)reg_update(Core.regFile.regFile_18,32'd18);
always@(Core.regFile.regFile_19)reg_update(Core.regFile.regFile_19,32'd19);
always@(Core.regFile.regFile_20)reg_update(Core.regFile.regFile_20,32'd20);
always@(Core.regFile.regFile_21)reg_update(Core.regFile.regFile_21,32'd21);
always@(Core.regFile.regFile_22)reg_update(Core.regFile.regFile_22,32'd22);
always@(Core.regFile.regFile_23)reg_update(Core.regFile.regFile_23,32'd23);
always@(Core.regFile.regFile_24)reg_update(Core.regFile.regFile_24,32'd24);
always@(Core.regFile.regFile_25)reg_update(Core.regFile.regFile_25,32'd25);
always@(Core.regFile.regFile_26)reg_update(Core.regFile.regFile_26,32'd26);
always@(Core.regFile.regFile_27)reg_update(Core.regFile.regFile_27,32'd27);
always@(Core.regFile.regFile_28)reg_update(Core.regFile.regFile_28,32'd28);
always@(Core.regFile.regFile_29)reg_update(Core.regFile.regFile_29,32'd29);
always@(Core.regFile.regFile_30)reg_update(Core.regFile.regFile_30,32'd30);
always@(Core.regFile.regFile_31)reg_update(Core.regFile.regFile_31,32'd31);
endmodule
module PmemManager(
  output [63:0]memRead_data,
  input [63:0]memRead_addr,
  input memRead_en,
  input [63:0]memWrite_data,
  input [63:0]memWrite_addr,
  input memWrite_en,
  input [3:0]memWrite_wrSize
);
  always@(*) begin
    dpi_pmem_read(memRead_data, memRead_addr, memRead_en, 4'h8);
  end
  always@(*) begin
    dpi_pmem_write(memWrite_data, memWrite_addr, memWrite_en, memWrite_wrSize);
  end
endmodule
