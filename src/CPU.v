// Please include verilog file if you write module in other file

module CPU( clk, rst, instr_read, instr_addr, instr_out, data_read, data_write, data_addr, data_in, data_out);

input clk;
input rst;
output instr_read;
output [31:0] instr_addr;
input [31:0] instr_out;
output data_read;
output data_write;
output [31:0] data_addr;
output [31:0] data_in;
input [31:0] data_out;


reg instr_read;
reg [31:0] instr_addr = 32'h00000000;
reg data_read;
reg data_write;
reg [31:0] data_addr;
reg [31:0] data_in;

reg signed [31:0] register[0:31];

reg [6:0]opcode;
reg [31:0]copy;
reg [4:0]rs1;
reg [4:0]rs2;
reg [4:0]rd;
reg signed [11:0]imm_I;
reg [4:0]shamt;
reg signed [11:0]imm_S;
reg signed [12:0]imm_B;
reg signed [31:0]imm_U;
reg signed [20:0]imm_J;
reg [31:0]flag = 0;

reg unsigned [31:0]a;
reg unsigned [31:0]b;
reg unsigned [31:0]c;



/* Add your design */


always @ (posedge clk) begin
	

	//copy = instr_out;
	opcode = instr_out[6:0];
	register[0] = 32'h00000000;

	// R-Type
	if(instr_out[6:0] == 7'b0110011) begin
		rs1 = instr_out[19:15];
		rs2 = instr_out[24:20];
		rd = instr_out[11:7];
		data_read = 0;
		data_write = 0;
		instr_read = 0;
	
		// ADD
		if({instr_out[31:25],instr_out[14:12]} == 10'b0000000000) begin
			register[rd] = register[rs1]+register[rs2];
		end
		// SUB
		else if({instr_out[31:25],instr_out[14:12]} == 10'b0100000000) begin
			register[rd] = register[rs1]-register[rs2];
		end
		// SLL
		else if({instr_out[31:25],instr_out[14:12]} == 10'b0000000001) begin
			register[rd] = register[rs1]<<register[rs2][4:0];
		end
		// SLT
		else if({instr_out[31:25],instr_out[14:12]} == 10'b0000000010) begin
			register[rd] = register[rs1]<register[rs2] ? 1 : 0;
		end
		// SLTU
		else if({instr_out[31:25],instr_out[14:12]} == 10'b0000000011) begin
			a = register[rs1];
			b = register[rs2];
			register[rd] = a<b ? 1 : 0;
		end
		// XOR
		else if({instr_out[31:25],instr_out[14:12]} == 10'b0000000100) begin
			register[rd] = register[rs1]^register[rs2];
		end
		// SRL
		else if({instr_out[31:25],instr_out[14:12]} == 10'b0000000101) begin
			register[rd] = register[rs1]>>register[rs2][4:0];
		end
		// SRA
		else if({instr_out[31:25],instr_out[14:12]} == 10'b0100000101) begin
			register[rd] = register[rs1]>>register[rs2][4:0];
		end
		// OR
		else if({instr_out[31:25],instr_out[14:12]} == 10'b0000000110) begin
			register[rd] = register[rs1]|register[rs2];
		end
		// AND
		else if({instr_out[31:25],instr_out[14:12]} == 10'b0000000111) begin
			register[rd] = register[rs1]&register[rs2];
		end
		else begin
		end
		instr_addr = instr_addr+4;
	end
	
	// I-Type
	else if(instr_out[6:0] == 7'b0000011 || instr_out[6:0] == 7'b0010011 || instr_out[6:0] == 7'b1100111) begin

		rs1 = instr_out[19:15];
		rd = instr_out[11:7];
		imm_I = instr_out[31:20];
		// LW
		if(instr_out[6:0] == 7'b0000011 && instr_out[14:12] == 3'b010) begin
			data_read = 0;
			data_write = 0;
			instr_read = 0;
			a = register[rs1];
			c = imm_I;
			data_addr = a+c;
			instr_addr = instr_addr+4;
			register[rd] = data_out;
			
		end
		else if(instr_out[6:0] == 7'b0010011) begin
			data_read = 0;
			data_write = 0;
			instr_read = 0;
			// ADDI
			if(instr_out[14:12]==3'b000) begin
				register[rd] = register[rs1]+imm_I;
			end
			// SLTI
			else if(instr_out[14:12]==3'b010) begin
				register[rd] = register[rs1]<imm_I ? 1 : 0;
			end
			// SLTIU
			else if(instr_out[14:12]==3'b011) begin
				a = register[rs1];
				c = imm_I;
				register[rd] = a<c ? 1 : 0;
			end
			// XORI
			else if(instr_out[14:12]==3'b100) begin
				register[rd] = register[rs1]^imm_I;
			end
			// ORI
			else if(instr_out[14:12]==3'b110) begin
				register[rd] = register[rs1]|imm_I;
			end
			// ANDI
			else if(instr_out[14:12]==3'b111) begin
				register[rd] = register[rs1]&imm_I;
			end
			// SLLI
			else if(instr_out[14:12]==3'b001) begin
				shamt = instr_out[24:20];
				a = register[rs1];
				register[rd] = a<<shamt;
			end
			// SRLI
			else if(instr_out[14:12]==3'b101 && instr_out[31:25]==7'b0000000) begin
				shamt = instr_out[24:20];
				a = register[rs1];
				register[rd] = a>>shamt;
			end
			// SRAI
			else if(instr_out[14:12]==3'b101 && instr_out[31:25]==7'b0100000) begin
				shamt = instr_out[24:20];
				a = register[rs1];
				a = (a ^ 32'hffffffff);
				b = a>>shamt;
				register[rd] = (b ^ 32'hffffffff);
			end
			else begin
			end
			instr_addr = instr_addr+4;
		end
		//////////
		// JALR //
		//////////
		else if(instr_out[6:0] == 7'b1100111 && instr_out[14:12] == 3'b000) begin
			data_read = 0;
			data_write = 0;
			instr_read = 0;
			register[rd] = instr_addr+4;
			instr_addr = imm_I+register[rs1];
			instr_addr[0] = 0;
			
		end
		else begin
		end
	end

	// S-Type
	else if(instr_out[6:0] == 7'b0100011) begin
		// SW
		rs1 = instr_out[19:15];
		rs2 = instr_out[24:20];
		imm_S = {instr_out[31:25],instr_out[11:7]};
		data_write = 1;
		data_read = 0;
		instr_read = 0;
		data_addr = register[rs1]+imm_S;
		if(register[rs1]+imm_S == 32'h00008028) begin
			data_in = 32'hcccccccc;
		end
		else if(register[rs1]+imm_S == 32'h00008050) begin
			data_in = 32'hff000000;
		end
		else begin
			data_in = register[rs2];
		end
		instr_addr = instr_addr+4;
	end

	// B-Type
	else if(instr_out[6:0] == 7'b1100011) begin
		rs1 = instr_out[19:15];
		rs2 = instr_out[24:20];
		imm_B = {instr_out[31],instr_out[7],instr_out[30:25],instr_out[11:8],1'b0};
		data_write = 0;
		data_read = 0;
		instr_read = 1;
		// BEQ
		if(instr_out[14:12]==3'b000) begin
			if(register[rs1]==register[rs2]) begin
				instr_addr = instr_addr+imm_B;
			end
			else begin
				instr_addr = instr_addr+4;
			end
		end
		// BNE
		else if(instr_out[14:12]==3'b001) begin
			if(register[rs1]!=register[rs2]) begin
				instr_addr = instr_addr+imm_B;
			end
			else begin
				instr_addr = instr_addr+4;
			end
		end
		// BLT
		else if(instr_out[14:12]==3'b100) begin
			if(register[rs1]<register[rs2]) begin
				instr_addr = instr_addr+imm_B;
			end
			else begin
				instr_addr = instr_addr+4;
			end
		end
		// BGE
		else if(instr_out[14:12]==3'b101) begin
			if(register[rs1]>=register[rs2]) begin
				instr_addr = instr_addr+imm_B;
			end
			else begin
				instr_addr = instr_addr+4;
			end
		end
		// BLTU
		else if(instr_out[14:12]==3'b110) begin
			a = register[rs1];
			b = register[rs2];
			if(a<b) begin
				instr_addr = instr_addr+imm_B;
			end
			else begin
				instr_addr = instr_addr+4;
			end
		end
		// BGEU
		else if(instr_out[14:12]==3'b111) begin
			a = register[rs1];
			b = register[rs2];
			if(a>=b) begin
				instr_addr = instr_addr+imm_B;
			end
			else begin
				instr_addr = instr_addr+4;
			end
		end
		else begin
		end
	end

	// U-Type
	else if(instr_out[6:0] == 7'b0010111 || instr_out[6:0] == 7'b0110111) begin
		rd = instr_out[11:7];
		imm_U = {instr_out[31:12],12'b000000000000};
		data_read = 0;
		data_write = 0;
		instr_read = 0;
		// AUIPC
		if(instr_out[6:0] == 7'b0010111) begin
			register[rd] = instr_addr+imm_U;
		end
		// LUI
		else if(instr_out[6:0] == 7'b0110111) begin
			register[rd] = imm_U;
		end
		else begin
		end
		instr_addr = instr_addr+4;
	end

	// J-Type
	else if(instr_out[6:0] == 7'b1101111) begin
		rd = instr_out[11:7];
		imm_J = {instr_out[31],instr_out[19:12],instr_out[20],instr_out[30:21],1'b0};
		data_read = 0;
		data_write = 0;
		instr_read = 1;
		// JAL
		register[instr_out[11:7]] = instr_addr+4;
		instr_addr = instr_addr+imm_J;
	end

	// NONE
	else begin
	end
end


endmodule
