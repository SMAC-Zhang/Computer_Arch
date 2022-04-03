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
    input u64 rd1, rd2,
    output u64 src1, src2,
    output u64 srca, srcb,
    input creg_addr_t ra1, ra2,
    input data_decode_t data_d,
    input data_execute_t data_e,
    input data_memory_t data_m
);

    always_comb begin
        if (data_d.ra1 == 5'b00000) begin
            srca = '0;
        end
        else if(data_e.reg_write && data_e.write_reg == data_d.ra1) begin
            srca = data_e.aluout;
        end
        else if(data_m.reg_write && data_m.write_reg == data_d.ra1) begin
            if(data_m.mem_to_reg) begin
                srca = data_m.read_data;
            end
            else begin
                srca = data_m.aluout;
            end
        end
        else begin
            srca = data_d.src1;
        end
    end

    always_comb begin
        if (data_d.ra2 == 5'b00000) begin
            srcb = '0;
        end
        else if(data_e.reg_write && data_e.write_reg == data_d.ra2) begin
            srcb = data_e.aluout;
        end
        else if(data_m.reg_write && data_m.write_reg == data_d.ra2) begin
            if(data_m.mem_to_reg) begin
                srcb = data_m.read_data;
            end
            else begin
                srcb = data_m.aluout;
            end
        end
        else begin
            srcb = data_d.src2;
        end
    end

    always_comb begin
        if (ra1 == 5'b00000) begin
            src1 = '0;
        end
        else if(data_e.reg_write && data_e.write_reg == ra1) begin
            src1 = data_e.aluout;
        end
        else if(data_m.reg_write && data_m.write_reg == ra1) begin
            if(data_m.mem_to_reg) begin
                src1 = data_m.read_data;
            end
            else begin
                src1 = data_m.aluout;
            end
        end
        else begin
            src1 = rd1;
        end
    end

    always_comb begin
        if (ra2 == 5'b00000) begin
            src2 = '0;
        end
        else if(data_e.reg_write && data_e.write_reg == ra2) begin
            src2 = data_e.aluout;
        end
        else if(data_m.reg_write && data_m.write_reg == ra2) begin
            if(data_m.mem_to_reg) begin
                src2 = data_m.read_data;
            end
            else begin
                src2 = data_m.aluout;
            end
        end
        else begin
            src2 = rd2;
        end
    end

endmodule
`endif