`ifndef __STALL_SV
`define __STALL_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`else

`endif 

module stall
	import common::*;
	import pipes::*;(
    input data_execute_t data_e,
    input creg_addr_t ra1, ra2,
    output logic flush,
    input data_decode_t data_d,
    input op_t op,
    output logic bubble
);

    always_comb begin
        if(data_e.mem_to_reg && (data_e.write_reg == data_d.ra1 || data_e.write_reg == data_d.ra2)) begin
            flush = 1'b1;
        end
        else begin
            flush = 1'b0;
        end
    end

    always_comb begin
        if((op == OP_BEQ  || op == OP_JALR) && data_d.ctl.reg_write && (data_d.rd == ra1 || data_d.rd == ra2) || (data_e.mem_to_reg && (data_e.write_reg == ra1 || data_e.write_reg == ra2))) begin
            bubble = 1'b1;
        end
        else begin
            bubble = 1'b0;
        end
    end
endmodule

`endif 