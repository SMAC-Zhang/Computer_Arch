`ifndef __FORWARD_SV
`define __FORWARD_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`else

`endif 

module forward
	import common::*;
	import pipes::*;(
    input creg_addr_t ra1, ra2,
    input u64 rd1, rd2,
    output u64 src1, src2,
    input data_execute_t data_e,
    input data_memory_t data_m,
    input data_writeback_t data_w
);

    always_comb begin
        src1 = rd1;
        src2 = rd2;
        if(data_w.reg_write) begin
            if(data_w.write_reg == ra1 && ra1 != 5'b00000) begin
                src1 = data_w.result;
            end
            if(data_w.write_reg == ra2 && ra2 != 5'b00000) begin
                src2 = data_w.result;
            end
        end
        if(data_m.reg_write) begin
            if(data_m.write_reg == ra1 && ra1 != 5'b00000) begin
                src1 = data_m.aluout;
            end
            if(data_m.write_reg == ra2 && ra2 != 5'b00000) begin
                src2 = data_m.aluout;
            end
        end
        if(data_m.mem_to_reg) begin
            if(data_m.write_reg == ra1 && ra1 != 5'b00000) begin
                src1 = data_m.read_data;
            end
            if(data_m.write_reg == ra2 && ra2 != 5'b00000) begin
                src2 = data_m.read_data;
            end
        end
        if(data_e.reg_write) begin
            if(data_e.write_reg == ra1 && ra1 != 5'b00000) begin
                src1 = data_e.aluout;
            end
            if(data_e.write_reg == ra2 && ra2 != 5'b00000) begin
                src2 = data_e.aluout;
            end
        end
    end
endmodule
`endif