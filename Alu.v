

module Alu
	#(parameter BUS_WIDTH=32											)
	(
		input 	wire [BUS_WIDTH-1:0] 	i_SrcA				,
		input 	wire [BUS_WIDTH-1:0] 	i_SrcB				,
		input 	wire [2:0]					i_AluControl		,
		output 	wire							o_overflow_flag	,
		output 	wire  [BUS_WIDTH-1:0]	o_Result				,
		output 	reg							o_ZeroFlag

	);
	
	reg   [BUS_WIDTH-1:0]	r_Result	=0;
	
	
	assign o_overflow_flag=(((i_SrcA[BUS_WIDTH-1]==i_SrcB[BUS_WIDTH-1])&&(r_Result[BUS_WIDTH-1]!=i_SrcA[BUS_WIDTH-1])) || (i_SrcA[BUS_WIDTH-1]!=i_SrcB[BUS_WIDTH-1])&&(r_Result[BUS_WIDTH-1]!=i_SrcA[BUS_WIDTH-1])) ? 1'b1 :1'b0;
	
	
	assign o_Result=r_Result;
	
	always @(*) begin
		o_ZeroFlag= (r_Result==0)?1'b1 : 1'b0;
	end
	
	always @(*) begin
		
		case(i_AluControl)
			
			//ADD
			3'b000		:	r_Result=	i_SrcA+i_SrcB;
			
			// Substract
			3'b001		:	r_Result=	i_SrcA-i_SrcB;
			
			//set less than
			3'b101		:	begin
									if(i_SrcA<=i_SrcB)
										r_Result=1;
									else
										r_Result=0;
								end
			
			//OR
			3'b011		:	r_Result=	i_SrcA | i_SrcB;
			
			// And
			3'b010		: 	r_Result=	i_SrcA & i_SrcB;
			
			default		: 	r_Result=0;
		
		
		endcase
	
	
	
	
	
	
	end









endmodule