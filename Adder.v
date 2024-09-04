


module Adder
	// parameter section
	#(parameter BUS_WIDTH=32)
	// Ports section
	(
		input  wire [BUS_WIDTH-1:0] i_operand1			,
		input  wire [BUS_WIDTH-1:0] i_operand2			,
		output wire [BUS_WIDTH-1:0] o_result			,
		output reg						 o_overflow_flag	
	);

	reg [BUS_WIDTH-1:0] r_result=0;

	
	always @(*) begin
	 r_result<=i_operand1+i_operand2;
	 if((i_operand1[BUS_WIDTH-1]==i_operand2[BUS_WIDTH-1]) &&(i_operand1[BUS_WIDTH-1]!=r_result[BUS_WIDTH-1]))
		o_overflow_flag<=1'b1;
	 else
		o_overflow_flag<=1'b0;
	end

	assign o_result=r_result;














endmodule