`ifndef __FETCH_SV
`define __FETCH_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`else

`endif

module fetch
	import common::*;
	import pipes::*;(
    input logic clk, reset,
    input logic branch,
    input addr_t branch_target,
    output ibus_req_t  ireq,
	input  ibus_resp_t iresp,
    output data_fetch_t data_f
);
    addr_t pc_nxt, pc_now;
    
    always_comb begin
        if(branch) begin
            pc_nxt = branch_target;
        end 
        else begin
            pc_nxt = pc_now + 4;
        end
    end

    always_ff @(posedge clk) begin
        if(reset) begin
            pc_now <= 64'h8000_0000;
        end
        else begin
            pc_now <= pc_nxt;
        end
    end

    assign ireq.addr = pc_now;
    assign data_f.pc_now = ireq.addr;
    assign data_f.valid = 1'b1;
    assign data_f.raw_instr = iresp.data;

endmodule

`endif