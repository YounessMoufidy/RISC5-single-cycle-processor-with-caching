

module Register_PIPO 
	#(parameter BUS_WIDTH=32)
	(
		input wire i_clk,
		input wire i_aresetn,
		input wire i_enablen,
		input wire [BUS_WIDTH-1:0] i_data,
		output reg [BUS_WIDTH-1:0] o_data

	);
	
	always@(posedge i_clk or negedge i_aresetn) begin
		if(!i_aresetn)
			o_data<=0;
		else
			if(!i_enablen)
				o_data<=i_data;
	end




endmodule