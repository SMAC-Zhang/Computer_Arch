`ifndef __WRITEBACK_SV
`define __WRITEBACK_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"

`else

`endif

module writeback
	import common::*;
	import pipes::*;(
    input data_memory_t data_m,
    output data_writeback_t data_w
);
	assign data_w.reg_write = data_m.reg_write;
	assign data_w.write_reg = data_m.write_reg;
	assign data_w.pc_now = data_m.pc_now;
	assign data_w.raw_instr = data_m.raw_instr;
	assign data_w.skip = data_m.skip;
	assign data_w.addr_31 = data_m.addr_31;
    assign data_w.valid = data_m.valid;

	always_comb begin
		if(data_m.mem_to_reg) begin
			data_w.result = data_m.read_data;
		end
		else begin
			data_w.result = data_m.aluout;
		end
	end


endmodule

`endif