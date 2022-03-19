`ifndef __CONUNIT_SV
`define __CONUNIT_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`else

`endif

module conunit
	import common::*;
	import pipes::*;(
    input u32 raw_instr,
    output control_t ctl
);
    u7 f7;
    assign f7 = raw_instr[6:0];

    u3 f3;
    assign f3 = raw_instr[14:12];

    u7 f7_2;
    assign f7_2 = raw_instr[31:25];

    always_comb begin
        ctl = '0;
        unique case(f7)
            F7_ADDI: begin
                unique case(f3)
                    F3_ADDI: begin
                        ctl.op = OP_ADDI;
                        ctl.reg_write = 1'b1;
                        ctl.alufunc = ALU_ADD;
                        ctl.alusrc = 1'b1;
                    end
                    F3_XORI: begin
                        ctl.op = OP_XORI;
                        ctl.reg_write = 1'b1;
                        ctl.alufunc = ALU_XOR;
                        ctl.alusrc = 1'b1;
                    end
                    F3_ORI: begin
                        ctl.op = OP_ORI;
                        ctl.reg_write = 1'b1;
                        ctl.alufunc = ALU_OR;
                        ctl.alusrc = 1'b1;
                    end
                    F3_ANDI:begin
                        ctl.op = OP_ANDI;
                        ctl.reg_write = 1'b1;
                        ctl.alufunc = ALU_AND;
                        ctl.alusrc = 1'b1;
                    end
                    default: begin
                        ctl = '0;
                    end
                endcase
            end
            F7_LUI: begin
                ctl.op = OP_LUI;
                ctl.reg_write = 1'b1;
                ctl.alusrc = 1'b1;
                ctl.alufunc = NOP;
            end
            F7_JAL: begin
                ctl.op = OP_JAL;
                ctl.reg_write = 1'b1;
                ctl.branch = 1'b1;
            end
            F7_BEQ: begin
                if(f3 == F3_BEQ) begin
                  ctl.op = OP_BEQ;
                end
            end
            F7_LD: begin
                if(f3 == F3_LD) begin
                    ctl.op = OP_LD;
                    ctl.reg_write = 1'b1;
                    ctl.alufunc = ALU_ADD;
                    ctl.alusrc = 1'b1;
                    ctl.mem_to_reg = 1'b1;
                end
            end
            F7_SD: begin
                if(f3 == F3_SD) begin
                    ctl.op = OP_SD;
                    ctl.mem_write = 1'b1;
                    ctl.alufunc = ALU_ADD;
                    ctl.alusrc = 1'b1;
                end
            end
            F7_ADD: begin
                unique case(f3)
                    F3_ADD: begin
                        if(f7_2 == F7_ADD_2) begin
                        ctl.op = OP_ADD;
                        ctl.reg_write = 1'b1;
                        ctl.alufunc = ALU_ADD;
                        end
                        if(f7_2 == F7_SUB_2) begin
                        ctl.op = OP_SUB;
                        ctl.reg_write = 1'b1;
                        ctl.alufunc = ALU_SUB;
                        end
                    end
                    F3_AND: begin
                        ctl.op = OP_AND;
                        ctl.reg_write = 1'b1;
                        ctl.alufunc = ALU_AND;
                    end
                    F3_OR: begin
                        ctl.op = OP_OR;
                        ctl.reg_write = 1'b1;
                        ctl.alufunc = ALU_OR;
                    end
                    F3_XOR: begin
                        ctl.op = OP_XOR;
                        ctl.reg_write = 1'b1;
                        ctl.alufunc = ALU_XOR;
                    end
                    default: begin
                        ctl = '0;
                    end
                endcase
            end
            F7_AUIPC: begin
                ctl.op = OP_AUIPC;
                ctl.reg_write = 1'b1;
            end
            F7_JALR: begin
                if(f3 == F3_JALR) begin
                    ctl.op = OP_JALR;
                    ctl.reg_write = 1'b1;
                    ctl.branch = 1'b1;
                end
            end
            default: begin
                ctl = '0;
            end
        endcase
    end
    
endmodule

`endif