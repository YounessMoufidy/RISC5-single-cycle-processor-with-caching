
//The main memory is Word addressable

module MainMemory
	#(
		parameter BLOCK_SIZE			=128				,
		parameter ADDRESS_WIDTH		=10				,
		parameter MAIN_MEM_DEPTH	=1024				,
		parameter MAIN_MEM_WIDTH	=32				

	)
	(
		input wire 								i_clk						,
		input wire 								i_aresetn				,
		input wire 	[ADDRESS_WIDTH-1:0]	i_AddressCpu			,
		input wire 	[BLOCK_SIZE-1:0] 		i_DataFromcache		,
		input wire 								i_WriteEnable			,
		input wire 								i_ReadEnable			,
		input wire 	[ADDRESS_WIDTH-1:0]	i_AddressCache			,

		
		output wire 							o_MemReady				,
		output reg [BLOCK_SIZE-1:0] 		o_DataToCache			
	);

	reg [MAIN_MEM_WIDTH-1:0] DataMemArray [0:MAIN_MEM_DEPTH-1];

	reg r_DoneRead;
	reg r_DoneWrite;

	//Here we assign value that will go to the cache
	always @(negedge i_clk or negedge i_aresetn) begin
			
		if(!i_aresetn)	 begin
			o_DataToCache					<= 128'b0;
			r_DoneRead						<=	1'b0																	;	
		end
		else begin
			r_DoneRead						<=	1'b0																	;	
			if(i_ReadEnable) begin
				o_DataToCache[31:0]	 	<= DataMemArray[{i_AddressCpu[ADDRESS_WIDTH-1:2],2'b00}]	;
				o_DataToCache[63:32] 	<= DataMemArray[{i_AddressCpu[ADDRESS_WIDTH-1:2],2'b01}]	;
				o_DataToCache[95:64] 	<= DataMemArray[{i_AddressCpu[ADDRESS_WIDTH-1:2],2'b10}]	;
				o_DataToCache[127:96]	<= DataMemArray[{i_AddressCpu[ADDRESS_WIDTH-1:2],2'b11}]	;
				r_DoneRead					<= 1'b1																	;
			end
		end
	end
	always @(negedge i_clk or negedge i_aresetn) begin
		if(!i_aresetn)	begin
			$readmemh("MainMemory_init.hex",DataMemArray,0,MAIN_MEM_DEPTH-1);
			r_DoneWrite						<=	1'b0																	;
		end
		else begin
			r_DoneWrite<=1'b0;
			if(i_WriteEnable) begin
				DataMemArray[{i_AddressCache[ADDRESS_WIDTH-1:2],2'b00}]<=i_DataFromcache[31:0]	;
				DataMemArray[{i_AddressCache[ADDRESS_WIDTH-1:2],2'b01}]<=i_DataFromcache[63:32]	;
	         DataMemArray[{i_AddressCache[ADDRESS_WIDTH-1:2],2'b10}]<=i_DataFromcache[95:64]	;
			   DataMemArray[{i_AddressCache[ADDRESS_WIDTH-1:2],2'b11}]<=i_DataFromcache[127:96]	;
				r_DoneWrite													  <=1'b1							;
			end
		end
	end


	assign o_MemReady=r_DoneRead|r_DoneWrite;
endmodule