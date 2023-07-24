module processor_module(instruction_format, clk, result);

input [31:0] instruction_format;
input clk;
output reg [31:0] result;

reg c, n, z, v;

reg [31:0] program_instructions [0:31];
reg [31:0] registers [0:31];
reg [7:0] memory [0:31];

reg [31:0] temporary;
reg run;

integer program_counter=0;
integer instruction_counter;

reg [4:0] operand1_addr;
reg [4:0] operand2_addr;
reg [15:0] operand2_immediate;
reg [25:0] target_address;
reg [26:0] jump_target_addr;
reg [4:0] opcode;
reg [4:0] destination_addr;
reg check;

reg [31:0] operand1;
reg [31:0] operand2;

initial begin
    opcode =  instruction_format[31:27];
    destination_addr = instruction_format[26:22];
    operand1_addr = instruction_format[21:17];
	 check = instruction_format[16];
    operand2_addr = instruction_format[15:11];
    operand2_immediate = instruction_format[15:0];
    target_address = instruction_format[25:0];
    jump_target_addr = instruction_format[26:0];
end


integer i;
  
initial begin
	for (i=0;i<32;i=i+1)
	begin
		if (i%2==0)
			registers[i] = 32'b00000000000000000000000000000000;
		else if (i%3==0)
			registers[i] = 32'b11110000111100001111000011110000;
		else
			registers[i] = 32'b11111111111111111111111111111111;
	end
end

initial begin
	for (i=0;i<32;i=i+1)
	begin
		if (i%2==0)
			memory[i] = 8'b00000000;
		else if (i%3==0)
			memory[i] = 8'b11110000;
		else
			memory[i] = 8'b11111111;
	end
end


always @(posedge clk)
	begin
		run = 1;
		for (i=0;i<32;i=i+1)
			begin
				if (run==0)
					begin
						$display("Total Instructions Executed till: %d\n", program_counter);
						$finish;
					end
				program_counter = program_counter + 1;
				//execute;
				
				operand1 = registers[operand1_addr];
				operand2 = (check==0)?(registers[operand2_addr]):({16'b0000000000000000,operand2_immediate});
				case(opcode)
					5'b00000: begin
						result = 32'b00000000000000000000000000000000;
						// pass
						// no operation
					end
					5'b00001: begin 
						run = 0;
						result = 32'b00000000000000000000000000000000;
						end
					5'b00010: begin
						{c,result} = operand1+operand2;
						v = (result[31] & ~operand1[31] & ~operand2[31]) | (~result[31] & operand1[31] & operand2[31]);
					end
					5'b00011: begin
						{n,result} = operand1-operand2;
						v = (result[31] & ~operand1[31] & ~(1^operand2[31])) | (~result[31] & operand1[31] & (1^operand2[31]));
					end
					5'b00100: result = ~operand1;
					5'b00101: begin
						operand2 = (check==0)?(registers[operand2_addr]):({16'b1111111111111111,operand2_immediate});
						result = operand1&&operand2;
					end
					5'b00110: begin
						operand2 = (check==0)?(registers[operand2_addr]):({16'b0000000000000000,operand2_immediate});
						result = operand1||operand2;
					end
					5'b00111: result = operand1^operand2;
					5'b01000: begin
						operand2 = (check==0)?(registers[operand2_addr]):({16'b1111111111111111,operand2_immediate});
						result = ~(operand1||operand2);
					end
					5'b01001: begin
						v = operand1[16];
						result = operand1<<operand2;
					end
					5'b01010: begin
						v = operand1[16];
						result = operand1>>operand2;
					end
					5'b01011: begin
						v = operand1[31];
						result = operand1<<operand2;
						result[31] = v;
					end
					5'b01100: begin
						v = operand1[31];
						result = operand1>>operand2;
						result[31] = v;
					end
					5'b01101: begin
						result = 32'b00000000000000000000000000000000;
						{n,temporary} = operand1-operand2;
						v = (result[31] & ~operand1[31] & ~(1^operand2[31])) | (~result[31] & operand1[31] & (1^operand2[31]));
					end
					5'b01110: begin
						result = 32'b00000000000000000000000000000000;
						program_counter = (c==1)?(program_counter+target_address):(program_counter);
					end
					5'b01111: begin
						result = 32'b00000000000000000000000000000000;
						program_counter = (c==0)?(program_counter+target_address):(program_counter);
					end
					5'b10000: begin
						result = 32'b00000000000000000000000000000000;
						program_counter = (z==1)?(program_counter+target_address):(program_counter);
					end
					5'b10001: begin
						result = 32'b00000000000000000000000000000000;
						program_counter = (z==0)?(program_counter+target_address):(program_counter);
					end
					5'b10010: begin
						result = 32'b00000000000000000000000000000000;
						program_counter = (n==0)?(program_counter+target_address):(program_counter);
					end
					5'b10011: begin
						result = 32'b00000000000000000000000000000000;
						program_counter = (n==1)?(program_counter+target_address):(program_counter);
					end
					5'b10100: begin
						result = memory[target_address];
						registers[destination_addr] = memory[{7'b0000000, target_address}];
					end
					5'b10101: begin
						result = 32'b00000000000000000000000000000000;
						memory[{7'b0000000, target_address}] = registers[destination_addr][31:24];
						memory[{7'b0000000, target_address}+1] = registers[destination_addr][23:16];
						memory[{7'b0000000, target_address}+2] = registers[destination_addr][15:8];
						memory[{7'b0000000, target_address}+3] = registers[destination_addr][7:0];
					end
					5'b10110: begin
						result = 32'b00000000000000000000000000000000;
						program_counter = program_counter + jump_target_addr;
					end
				endcase
				registers[destination_addr] = result;
				z = ~(|result);
				$display("Instruction: %b\t", opcode);
				$display("Result: %b\n\n", result);
		
			end
		$display("instructions executed: %d\n", program_counter);
	end
endmodule

