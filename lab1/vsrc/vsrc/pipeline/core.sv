`ifndef __CORE_SV
`define __CORE_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "pipeline/regfile/regfile.sv"
`include "include/pipes.sv"
`include "pipeline/decode/decode.sv"
`include "pipeline/execute/execute.sv"
`include "pipeline/fetch/fetch.sv"
`include "pipeline/memory/memory.sv"
`include "pipeline/writeback/writeback.sv"
`include "pipeline/forward.sv"
`include "pipeline/bubble.sv"

`else

`endif

module core 
	import common::*;
    import pipes::*;(
	input  logic clk, reset,
	output ibus_req_t  ireq,
	input  ibus_resp_t iresp,
	output dbus_req_t  dreq,
	input  dbus_resp_t dresp
);
	/* TODO: Add your pipeline here. */

	logic branch;
    logic flush;
	addr_t branch_target;
	data_fetch_t data_f;
	data_fetch_t data_f_nxt;
    data_decode_t data_d;
	data_decode_t data_d_nxt;
	creg_addr_t ra1, ra2;
    u64 rd1, rd2;
    u64 src1, src2;
    data_execute_t data_e;
	data_execute_t data_e_nxt;
    data_writeback_t data_w;
    data_memory_t data_m;
	data_memory_t data_m_nxt;
	fetch fetch(
		.clk,
		.reset,
        .flush,
		.branch,
		.branch_target,
		.ireq,
		.iresp,
		.data_f(data_f_nxt)
	);

	always_ff @(posedge clk) begin
		if(reset | branch) begin
			data_f <= '0;
		end
		else if(~flush) begin
			data_f <= data_f_nxt;
		end
	end

	decode decode(
		.data_f,
		.ra1,
		.ra2,
        .src1,
        .src2,
		.data_d(data_d_nxt),
		.branch_target,
		.branch
	);

	always_ff @(posedge clk) begin
		if(reset | flush) begin
			data_d <= '0;
		end
		else begin
			data_d <= data_d_nxt;
		end
	end

    bubble bubble(
        .data_e(data_e_nxt),
        .ra1,
        .ra2,
        .flush
    );

    forward forward(
        .ra1,
        .ra2,
        .rd1,
        .rd2,
        .src1,
        .src2,
        .data_e(data_e_nxt),
        .data_m(data_m_nxt),
        .data_w(data_w)
    );

	execute execute(
		.data_d,
		.data_e(data_e_nxt)
	);
	
	always_ff @(posedge clk) begin
		if(reset) begin
			data_e <= '0;
		end
		else begin
			data_e <= data_e_nxt;
		end
	end

	memory memory(
		.data_e,
		.data_m(data_m_nxt),
		.dreq,
		.dresp
	);

	always_ff @(posedge clk) begin
		if(reset) begin
			data_m <= '0;
		end
		else begin
			data_m <= data_m_nxt;
		end
	end

	writeback writeback(
		.data_m,
		.data_w
	);

	regfile regfile(
		.clk, .reset,
		.ra1,
		.ra2,
		.rd1,
		.rd2,
		.wvalid			(data_w.reg_write),
		.wa				(data_w.write_reg),
		.wd				(data_w.result)
	);


`ifdef VERILATOR
	DifftestInstrCommit DifftestInstrCommit(
		.clock              (clk),
		.coreid             (0),
		.index              (0),
		.valid              (data_w.valid),
		.pc                 (data_w.pc_now),
		.instr              (data_w.raw_instr),
		.skip               (data_w.skip & ~data_w.addr_31),
		.isRVC              (0),
		.scFailed           (0),
		.wen                (data_w.reg_write),
		.wdest              (data_w.write_reg),
		.wdata              (data_w.result)
	);
	      
	DifftestArchIntRegState DifftestArchIntRegState (
		.clock              (clk),
		.coreid             (0),
		.gpr_0              (regfile.regs_nxt[0]),
		.gpr_1              (regfile.regs_nxt[1]),
		.gpr_2              (regfile.regs_nxt[2]),
		.gpr_3              (regfile.regs_nxt[3]),
		.gpr_4              (regfile.regs_nxt[4]),
		.gpr_5              (regfile.regs_nxt[5]),
		.gpr_6              (regfile.regs_nxt[6]),
		.gpr_7              (regfile.regs_nxt[7]),
		.gpr_8              (regfile.regs_nxt[8]),
		.gpr_9              (regfile.regs_nxt[9]),
		.gpr_10             (regfile.regs_nxt[10]),
		.gpr_11             (regfile.regs_nxt[11]),
		.gpr_12             (regfile.regs_nxt[12]),
		.gpr_13             (regfile.regs_nxt[13]),
		.gpr_14             (regfile.regs_nxt[14]),
		.gpr_15             (regfile.regs_nxt[15]),
		.gpr_16             (regfile.regs_nxt[16]),
		.gpr_17             (regfile.regs_nxt[17]),
		.gpr_18             (regfile.regs_nxt[18]),
		.gpr_19             (regfile.regs_nxt[19]),
		.gpr_20             (regfile.regs_nxt[20]),
		.gpr_21             (regfile.regs_nxt[21]),
		.gpr_22             (regfile.regs_nxt[22]),
		.gpr_23             (regfile.regs_nxt[23]),
		.gpr_24             (regfile.regs_nxt[24]),
		.gpr_25             (regfile.regs_nxt[25]),
		.gpr_26             (regfile.regs_nxt[26]),
		.gpr_27             (regfile.regs_nxt[27]),
		.gpr_28             (regfile.regs_nxt[28]),
		.gpr_29             (regfile.regs_nxt[29]),
		.gpr_30             (regfile.regs_nxt[30]),
		.gpr_31             (regfile.regs_nxt[31])
	);
	      
	DifftestTrapEvent DifftestTrapEvent(
		.clock              (clk),
		.coreid             (0),
		.valid              (0),
		.code               (0),
		.pc                 (0),
		.cycleCnt           (0),
		.instrCnt           (0)
	);
	      
	DifftestCSRState DifftestCSRState(
		.clock              (clk),
		.coreid             (0),
		.priviledgeMode     (3),
		.mstatus            (0),
		.sstatus            (0),
		.mepc               (0),
		.sepc               (0),
		.mtval              (0),
		.stval              (0),
		.mtvec              (0),
		.stvec              (0),
		.mcause             (0),
		.scause             (0),
		.satp               (0),
		.mip                (0),
		.mie                (0),
		.mscratch           (0),
		.sscratch           (0),
		.mideleg            (0),
		.medeleg            (0)
	      );
	      
	DifftestArchFpRegState DifftestArchFpRegState(
		.clock              (clk),
		.coreid             (0),
		.fpr_0              (0),
		.fpr_1              (0),
		.fpr_2              (0),
		.fpr_3              (0),
		.fpr_4              (0),
		.fpr_5              (0),
		.fpr_6              (0),
		.fpr_7              (0),
		.fpr_8              (0),
		.fpr_9              (0),
		.fpr_10             (0),
		.fpr_11             (0),
		.fpr_12             (0),
		.fpr_13             (0),
		.fpr_14             (0),
		.fpr_15             (0),
		.fpr_16             (0),
		.fpr_17             (0),
		.fpr_18             (0),
		.fpr_19             (0),
		.fpr_20             (0),
		.fpr_21             (0),
		.fpr_22             (0),
		.fpr_23             (0),
		.fpr_24             (0),
		.fpr_25             (0),
		.fpr_26             (0),
		.fpr_27             (0),
		.fpr_28             (0),
		.fpr_29             (0),
		.fpr_30             (0),
		.fpr_31             (0)
	);
	
`endif
endmodule
`endif