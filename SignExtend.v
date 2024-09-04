

module SignExtend

	#(parameter BUS_WIDTH=32)
	(
		input wire [1:0] i_ImmSrc								,
		input wire [BUS_WIDTH-1:7] i_ImmToBeExtended	,
		output reg	[BUS_WIDTH-1:0] o_ImmExt		
	);
	
	
	always@(*) begin
	
		case(i_ImmSrc)
			
			//I Type instruction
			
			2'b00		:	o_ImmExt={{20{i_ImmToBeExtended[31]}},i_ImmToBeExtended[31:20]};
			
			//S Type instruction
			
			2'b01		:	o_ImmExt={{20{i_ImmToBeExtended[31]}},i_ImmToBeExtended[31:25],i_ImmToBeExtended[11:7]};
			
			//B Type instruction
			
			2'b10		:	o_ImmExt={{20{i_ImmToBeExtended[31]}},i_ImmToBeExtended[7],i_ImmToBeExtended[30:25],i_ImmToBeExtended[11:8],1'b0};
		
			//J Type instruction
			
			2'b11		:	o_ImmExt={{12{i_ImmToBeExtended[31]}},i_ImmToBeExtended[19:12],i_ImmToBeExtended[20],i_ImmToBeExtended[30:21],1'b0};
			
			
			
			default	: o_ImmExt={{12{i_ImmToBeExtended[31]}},i_ImmToBeExtended[19:12],i_ImmToBeExtended[20],i_ImmToBeExtended[30:21],1'b0};
		
		endcase
	
	end


endmodule