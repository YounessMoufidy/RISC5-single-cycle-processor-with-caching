module Mux21
	//parameters section
	#(parameter BUS_WIDTH=32) //All parameters have default value
	//Ports section
	(
		input wire	[BUS_WIDTH-1 :0] 		 i_data1 ,
		input wire	[BUS_WIDTH-1 :0] 		 i_data2 ,
		input wire     						 i_sel	,		
		output reg  [BUS_WIDTH-1 :0] 		 o_data
	);
	
	
	
	
	
	always @(*) begin
		case(i_sel)
			1'b0		:o_data=i_data1;
			1'b1		:o_data=i_data2;
			default	:o_data=i_data1;	//default value i_data1
		
		endcase
	
	
	end
	
	
endmodule