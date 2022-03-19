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
    output data_execute_t data_e
);

    u64 srca, srcb;
    assign srca = data_d.rs1;
    alu alu(
        .a      (srca),
        .b      (srcb),
        .alufunc(data_d.ctl.alufunc),
        .c      (data_e.aluout)
    );

    assign data_e.reg_write = data_d.ctl.reg_write;
    assign data_e.mem_to_reg = data_d.ctl.mem_to_reg;
    assign data_e.mem_write = data_d.ctl.mem_write;
    assign data_e.write_data = data_d.rs2;
    assign data_e.write_reg = data_d.rd;
    assign data_e.pc_now = data_d.pc_now;
    assign data_e.raw_instr = data_d.raw_instr; 
    assign data_e.valid = data_d.valid;

    always_comb begin
        unique case(data_d.ctl.alusrc)
            0: begin
                srcb = data_d.rs2;
            end
            1: begin
                srcb = data_d.sext_imm;
            end
            default: begin
                srcb = '0;
            end
        endcase
    end

endmodule

`endif