
module RegFile
	#(
		parameter BUS_WIDTH=32,
		parameter REG_DEPTH=32,
		parameter ADDRESS_WIDTH=$clog2(REG_DEPTH))
	(
		input 	wire 							 i_clk		      ,
		input 	wire 							 i_aresetn		   ,
		input    wire							 i_RegWrite			,	
		input 	wire [ADDRESS_WIDTH-1:0] i_Read_Address1	,
		input 	wire [ADDRESS_WIDTH-1:0] i_Read_Address2	,
		input 	wire [ADDRESS_WIDTH-1:0] i_Write_Address	,
		input 	wire [BUS_WIDTH-1:0] 	 i_Write_data		,
		output 	wire  [BUS_WIDTH-1:0] 	 o_Read_data1		,
		output 	wire  [BUS_WIDTH-1:0] 	 o_Read_data2		
	);
	//declare the regfile array
	reg [BUS_WIDTH-1:0] RegFileArray[0:REG_DEPTH-1];
	//initialization of the register file
	initial begin
		$readmemh("RF_init.hex",RegFileArray,0,REG_DEPTH-1);
	end
	
	//
	
	always @(posedge i_clk or negedge  i_aresetn) begin
		if(!i_aresetn)
			$readmemh("RF_init.hex",RegFileArray,0,REG_DEPTH-1);
		else
			if(i_RegWrite==1'b1)
				if(i_Write_Address==0)
					RegFileArray[i_Write_Address]<=0;
				else
					RegFileArray[i_Write_Address]<=i_Write_data;
	end

	assign o_Read_data1=RegFileArray[i_Read_Address1];
	assign o_Read_data2=RegFileArray[i_Read_Address2];

endmodule