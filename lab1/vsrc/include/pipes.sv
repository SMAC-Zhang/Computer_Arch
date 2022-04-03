`ifndef __PIPES_SV
`define __PIPES_SV

`ifdef VERILATOR
`include "include/common.sv"

`else

`endif

package pipes;
import common::*;
/* Define instrucion decoding rules here */

// parameter F7_RI = 7'bxxxxxxx;
//对应指令[6:0]位
parameter F7_ADDI = 7'b0010011;
// parameter F7_XORI = 7'b0010011;
// parameter F7_ORI = 7'b0010011;
// parameter F7_ANDI = 7'b0010011;
parameter F7_LUI = 7'b0110111;
parameter F7_JAL = 7'b1101111;
parameter F7_BEQ = 7'b1100011;
parameter F7_LD = 7'b0000011;
parameter F7_SD = 7'b0100011;
parameter F7_ADD = 7'b0110011;
// parameter F7_SUB = 7'b0110011;
// parameter F7_AND = 7'b0110011;
// parameter F7_OR = 7'b0110011;
// parameter F7_XOR = 7'b0110011;
parameter F7_AUIPC = 7'b0010111;
parameter F7_JALR = 7'b1100111;

//对应指令[14:12]位
parameter F3_ADDI = 3'b000;
parameter F3_XORI = 3'b100;
parameter F3_ORI = 3'b110;
parameter F3_ANDI = 3'b111;
parameter F3_BEQ = 3'b000;
parameter F3_LD = 3'b011;
parameter F3_SD = 3'b011;
parameter F3_ADD = 3'b000;//SUB
// parameter F3_SUB = 3'b000;
parameter F3_AND = 3'b111;
parameter F3_OR = 3'b110;
parameter F3_XOR = 3'b100;
parameter F3_JALR = 3'b000;

//对应指令[31:25]位
parameter F7_ADD_2 = 7'b0000000;
parameter F7_SUB_2 = 7'b0100000;
parameter F7_AND_2 = 7'b0000000;
parameter F7_OR_2 = 7'b0000000;
parameter F7_XOR_2 = 7'b0000000;

/* Define pipeline structures here */

typedef enum logic[3:0] {
    NOP,
	ALU_ADD,
    ALU_SUB,
    ALU_AND,
    ALU_OR,
    ALU_XOR
} alufunc_t;

typedef enum logic[5:0] {
    NULL,
    OP_ADDI,
    OP_XORI,
    OP_ORI,
    OP_ANDI,
    OP_LUI,
    OP_JAL,
    OP_BEQ,
    OP_LD,
    OP_SD,
    OP_ADD,
    OP_SUB,
    OP_AND,
    OP_OR,
    OP_XOR,
    OP_AUIPC,
    OP_JALR
} op_t;

typedef struct packed {
    op_t op;
    u1 reg_write;
    u1 mem_to_reg;
    alufunc_t alufunc;
    u1 alusrc;
    u1 mem_write;
    //u1 branch;
} control_t ;

typedef struct packed {
    u32 raw_instr;
    addr_t pc_now;
    u1 valid;
} data_fetch_t;

typedef struct packed {
    control_t ctl;
    u64 src1, src2;
    creg_addr_t ra1, ra2;
    creg_addr_t rd;
    u64 sext_imm;
    u32 raw_instr;
    addr_t pc_now;
    u1 valid;
} data_decode_t;

typedef struct packed {
    u1 reg_write;
    u1 mem_to_reg;
    u1 mem_write;
    u64 aluout;
    u64 write_data;
    creg_addr_t write_reg;
    addr_t pc_now;
    u32 raw_instr;
    u1 valid;
} data_execute_t;

typedef struct packed {
    u1 addr_31;
    u1 skip;
    u1 reg_write;
    u1 mem_to_reg;
    word_t read_data;
    u64 aluout;
    creg_addr_t write_reg;
    addr_t pc_now;
    u32 raw_instr;
    u1 valid;
} data_memory_t;

typedef struct packed {
    u1 addr_31;
    u1 skip;
    u1 reg_write;
    u64 result;
    creg_addr_t write_reg;
    addr_t pc_now;
    u32 raw_instr;
    u1 valid;
} data_writeback_t;

endpackage

`endif
