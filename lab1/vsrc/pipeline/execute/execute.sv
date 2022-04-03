`ifndef __EXECUTE_SV
`define __EXECUTE_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`include "pipeline/execute/alu.sv"
`else

`endif

module execute
	import common::*;
	import pipes::*;(
    input  data_decode_t data_d,
    input u64 src1, src2,
    output data_execute_t data_e
);

    u64 srca, srcb;
    assign srca = src1;

    alu alu(
        .a      (srca),
        .b      (srcb),
        .alufunc(data_d.ctl.alufunc),
        .c      (data_e.aluout)
    );

    assign data_e.reg_write = data_d.ctl.reg_write;
    assign data_e.mem_to_reg = data_d.ctl.mem_to_reg;
    assign data_e.mem_write = data_d.ctl.mem_write;
    assign data_e.write_data = src2;
    assign data_e.write_reg = data_d.rd;
    assign data_e.pc_now = data_d.pc_now;
    assign data_e.raw_instr = data_d.raw_instr; 
    assign data_e.valid = data_d.valid;

    always_comb begin
        if(data_d.ctl.alusrc) begin
            srcb = data_d.sext_imm;
        end
        else begin
            srcb = src2;
        end
    end

endmodule

`endif