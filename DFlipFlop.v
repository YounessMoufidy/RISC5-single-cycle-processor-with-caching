


module DFlipFlop (

	input wire 	i_clk			,
	input wire 	i_aresetn	,
	input wire 	i_data		,
	output reg 	q				,
	output wire	qn
);
	
	//	The flip flop depends on the rising edge of the clock
	// aresetn is asynchronous with the clock signal
	
	// we use non blocking operator for sequential logic
	
	always @(posedge i_clk or negedge i_aresetn) begin
		
		if(!i_aresetn)
			q<=1'b0;
		else
			q<=i_data;
		
	end

	assign qn=~q;






endmodule