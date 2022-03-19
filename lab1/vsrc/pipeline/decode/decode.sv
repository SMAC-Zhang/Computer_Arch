`ifndef __DECODE_SV
`define __DECODE_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/pipes.sv"
`include "pipeline/decode/conunit.sv"
`else

`endif

module decode 
	import common::*;
	import pipes::*;(
    input  data_fetch_t data_f,
    input  u64 rs1, rs2,
    output creg_addr_t ra1, ra2,
    output data_decode_t data_d,
    output addr_t branch_target,
    output logic branch
);

    assign data_d.raw_instr = data_f.raw_instr;
    assign data_d.pc_now = data_f.pc_now;
    assign data_d.valid = data_f.valid;
    assign data_d.rs1 = rs1;
    assign data_d.rs2 = rs2;
    assign data_d.rd = data_f.raw_instr[11:7];
    assign ra1 = data_f.raw_instr[19:15];
    assign ra2 = data_f.raw_instr[24:20];

    control_t ctl;
    assign data_d.ctl = ctl;
    assign branch = data_d.ctl.branch;

    conunit conunit (
        .raw_instr  (data_f.raw_instr),
        .ctl        (ctl)
    );

    always_comb begin
        unique case(ctl.op)
            OP_ADDI: begin
                data_d.sext_imm = {
                    {52{data_f.raw_instr[31]}},
                    data_f.raw_instr[31:20]
                };
            end
            OP_XORI: begin
                data_d.sext_imm = {
                    {52{data_f.raw_instr[31]}},
                    data_f.raw_instr[31:20]
                };
            end
            OP_ORI: begin
                data_d.sext_imm = {
                    {52{data_f.raw_instr[31]}},
                    data_f.raw_instr[31:20]
                };
            end
            OP_ANDI: begin
                data_d.sext_imm = {
                    {52{data_f.raw_instr[31]}},
                    data_f.raw_instr[31:20]
                };
            end
            OP_LUI: begin
            data_d.sext_imm = {
                    {32{data_f.raw_instr[31]}},
                    data_f.raw_instr[31:12],
                    {12{1'b0}}
                };
            end
            OP_JAL: begin
               data_d.sext_imm = data_f.pc_now + 4;
               branch_target = data_f.pc_now + {
                   {44{data_f.raw_instr[31]}},
                   data_f.raw_instr[31],
                   data_f.raw_instr[19:12],
                   data_f.raw_instr[20],
                   data_f.raw_instr[30:21]
               }; 
            end
            OP_BEQ: begin
                if(rs1 == rs2) begin
                    branch = 1'b1;
                    branch_target = data_f.pc_now + {
                        {52{data_f.raw_instr[31]}},
                        data_f.raw_instr[31],
                        data_f.raw_instr[7],
                        data_f.raw_instr[30:25],
                        data_f.raw_instr[11:8]
                    };
                end
            end
            OP_LD: begin
                data_d.sext_imm = {
                    {52{data_f.raw_instr[31]}},
                    data_f.raw_instr[31:20]
                };
            end
            OP_SD: begin
                data_d.sext_imm = {
                    {52{data_f.raw_instr[31]}},
                    data_f.raw_instr[31:25],
                    data_f.raw_instr[11:7]
                };
            end
            OP_ADD: begin
            //nop    
            end
            OP_SUB: begin
            //nop
            end
            OP_AND: begin
            //nop
            end
            OP_OR: begin
            //nop
            end
            OP_XOR: begin
            //nop
            end
            OP_AUIPC: begin
                data_d.sext_imm = {
                    {32{data_f.raw_instr[31]}},
                    data_f.raw_instr[31:12],
                    {12{1'b0}}
                };
            end
            OP_JALR: begin
                data_d.sext_imm = data_f.pc_now + 4;
                branch_target = rs1 + {
                    {52{data_f.raw_instr[31]}},
                    data_f.raw_instr[31:21],
                    1'b0
                };
            end
            default: begin
                data_d.sext_imm = '0;
            end
        endcase
    end

endmodule

`endif