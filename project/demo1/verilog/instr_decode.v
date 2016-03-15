module instr_decode(instruction, writeData, RegWrite, RegDst, jumpAddr, read1data, read2data, immediate);

	input [10:0] instruction;	// Used for read1 & read2 regs, write reg, branch
	input RegWrite;						// Write to register or not
	input RegDst;							// Write register MUX control signal
	input [15:0] writeData;		// From write_back stage

	output [15:0] jumpAddr;		// Some sort of jump logic
	output [15:0] read1data;
	output [15:0] read2data;
	output [15:0] immediate;
	
endmodule
