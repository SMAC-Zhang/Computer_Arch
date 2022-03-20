`ifndef __BUBBLE_SV
`define __BUBBLE_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`else

`endif 

module bubble
	import common::*;
	import pipes::*;(
    input data_execute_t data_e,
    input creg_addr_t ra1, ra2,
    output logic flush
);

    always_comb begin
        //flush = 1'b0;
        if(data_e.mem_to_reg && (data_e.write_reg == ra1 || data_e.write_reg == ra2)) begin
            flush = 1'b1;
        end
        else begin
            flush = 1'b0;
        end
    end

endmodule

`endif 