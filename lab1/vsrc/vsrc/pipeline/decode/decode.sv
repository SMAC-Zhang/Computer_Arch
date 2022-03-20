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
    //input  logic clk,
    input  data_fetch_t data_f,
    input  u64 src1, src2,
    output creg_addr_t ra1, ra2,
    output data_decode_t data_d,
    output addr_t branch_target,
    output logic branch
);

    // always_ff @(posedge clk) begin 
    //     $display("%x\t%x\t%x\n", src1, src2, data_d.sext_imm); 
    // end

    assign data_d.raw_instr = data_f.raw_instr;
    assign data_d.pc_now = data_f.pc_now;
    assign data_d.valid = data_f.valid;
    assign data_d.src1 = src1;
    assign data_d.src2 = src2;
    assign data_d.rd = data_f.raw_instr[11:7];
    assign ra1 = data_f.raw_instr[19:15];
    assign ra2 = data_f.raw_instr[24:20];

    control_t ctl;
    assign data_d.ctl = ctl;

    conunit conunit (
        .raw_instr  (data_f.raw_instr),
        .ctl        (ctl)
    );

    always_comb begin
        branch = '0;
        data_d.sext_imm = '0;
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
                branch = 1'b1;
                data_d.sext_imm = data_f.pc_now + 4;
                branch_target = data_f.pc_now + {
                   {43{data_f.raw_instr[31]}},
                   data_f.raw_instr[31],
                   data_f.raw_instr[19:12],
                   data_f.raw_instr[20],
                   data_f.raw_instr[30:21],
                   1'b0
                }; 
            end
            OP_BEQ: begin
                if(src1 == src2) begin
                    branch = 1'b1;
                    branch_target = data_f.pc_now + {
                        {51{data_f.raw_instr[31]}},
                        data_f.raw_instr[31],
                        data_f.raw_instr[7],
                        data_f.raw_instr[30:25],
                        data_f.raw_instr[11:8],
                        1'b0
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
            end
            OP_SUB: begin
            end
            OP_AND: begin
            end
            OP_OR: begin
            end
            OP_XOR: begin
            end
            OP_AUIPC: begin
                data_d.sext_imm = data_f.pc_now + {
                    {32{data_f.raw_instr[31]}},
                    data_f.raw_instr[31:12],
                    {12{1'b0}}
                };
            end
            OP_JALR: begin
                branch = 1'b1;
                data_d.sext_imm = data_f.pc_now + 4;
                branch_target = (src1 + {
                    {52{data_f.raw_instr[31]}},
                    data_f.raw_instr[31:20]}) & ~1;
            end
            default: begin
                data_d.sext_imm = '0;
                branch = '0;
            end
        endcase
    end

endmodule

`endif