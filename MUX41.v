

module MUX41
	#(	parameter BUS_WIDTH=32)
	(
		input wire [BUS_WIDTH-1:0] 	i_data1	,
		input wire [BUS_WIDTH-1:0] 	i_data2	,
		input wire [BUS_WIDTH-1:0] 	i_data3	,
		input wire [BUS_WIDTH-1:0] 	i_data4	,
		input wire [1:0]					i_sel	 	,
		output reg	[BUS_WIDTH-1:0]	o_data
	);
	
	always@(*) begin
		
		case(i_sel)	
			2'b00		:o_data=i_data1;
			2'b01		:o_data=i_data2;
			2'b10		:o_data=i_data3;
			2'b11		:o_data=i_data4;
			default	:o_data=0		;
		endcase
		
	end
	
endmodule