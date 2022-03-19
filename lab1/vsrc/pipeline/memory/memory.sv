`ifndef __MEMORY_SV
`define __MEMORY_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`else

`endif

module memory
	import common::*;
	import pipes::*;(
    input data_execute_t data_e,
    output data_memory_t data_m,
    output dbus_req_t  dreq,
	input  dbus_resp_t dresp
);

    assign data_m.reg_write = data_e.reg_write;
    assign data_m.mem_to_reg = data_e.mem_to_reg;
    assign data_m.aluout = data_e.aluout;
    assign data_m.write_reg = data_e.write_reg;
    assign data_m.pc_now = data_e.pc_now;
    assign data_m.raw_instr = data_e.raw_instr;
    assign data_m.skip = data_e.mem_to_reg | data_e.mem_write;
    assign data_m.addr_31 = data_e.aluout[31];
    assign data_m.valid = data_e.valid;

    assign dreq.valid = data_e.mem_to_reg | data_e.mem_write;
    assign dreq.addr = 0;//(data_e.mem_to_reg | data_e.mem_write) ? data_e.aluout : '0;
    assign dreq.size = MSIZE8;

    always_comb begin
        if(data_e.mem_to_reg) begin
            dreq.strobe = '0;
            data_m.read_data = dresp.data;
        end
        else if(data_e.mem_write) begin
            dreq.strobe = 8'b11111111;
            dreq.data = data_e.write_data; 
        end
    end

endmodule

`endif 