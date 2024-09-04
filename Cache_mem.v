


module Cache_mem
	#
	(
		parameter BUS_WIDTH			=32				,
		parameter TAG_SIZE   		=3				   ,
		parameter ADDRESS_WIDTH		=10				,
		parameter INDEX_SIZE 		=5					,
		parameter CACHE_MEM_WIDTH	=128				,
		parameter CACHE_MEM_DEPTH	=2**INDEX_SIZE
	)
	(
		input  wire								 	 i_clk				,
		input  wire								 	 i_aresetn			,	
		input  wire [ADDRESS_WIDTH	 -1:0] 	 i_Address			,
		input  wire [CACHE_MEM_WIDTH -1:0] 	 i_data_memory		,
		input  wire [BUS_WIDTH		 -1:0]	 i_data_cpu			,//In the case of SW
		input  wire									 i_write_enable	,
		input  wire									 i_replace			,
//		input  wire 								 i_hit_miss			,
//		input  wire								    i_MemWrite			,
//		input  wire								    i_MemRead			,	
		output wire  [BUS_WIDTH		 -1:0]    o_data_cpu			,
		output reg  [CACHE_MEM_WIDTH		 -1:0]    o_data_to_mem			,
		output wire [TAG_SIZE	    -1:0]    o_Tag				,
		output wire 								  o_valid			,
		output wire 								  o_dirty			,
		output wire	[ADDRESS_WIDTH-1:0]			o_AddressInCache		
		
	);
	
	//Declare the memory array
	reg [CACHE_MEM_WIDTH-1:0] CacheMemArray  [0:CACHE_MEM_DEPTH-1];
	//Tag & valid & dirty bits array
	reg [TAG_SIZE+1+1-1:0] 		CacheTagArray [0:CACHE_MEM_DEPTH-1];
	
	//word offset
	reg 	[1:0] 			r_WordOffset;
	//TAG
	reg [TAG_SIZE-1:0] 	r_tag;
	//Index
	reg [INDEX_SIZE-1:0] r_index;
	
	integer r_loop_index=0;
	
	assign o_AddressInCache={CacheTagArray[r_index][TAG_SIZE-1:0],r_index,r_WordOffset};
	
	always @(*) begin
		 r_WordOffset	=   i_Address[1:0];//THe main memory is word addressable
		 r_index			=	 i_Address[6:2];
		 r_tag			=	 i_Address[9:7]; //dirty valid Tag
	end
	//Write is sequential
	always @(posedge i_clk or negedge i_aresetn) begin
		if(!i_aresetn) begin
			for(r_loop_index=0;r_loop_index<CACHE_MEM_DEPTH;r_loop_index=r_loop_index+1) begin
				CacheMemArray[r_loop_index][127:0]<=0;
				CacheTagArray[r_loop_index][TAG_SIZE+1+1-1:0]<=0;
			end
		end
			
		else
			//writing
			if(i_write_enable==1'b1) begin
				case(r_WordOffset)
					2'b00:CacheMemArray[r_index][31:0]  <=i_data_cpu;
					2'b01:CacheMemArray[r_index][63:32] <=i_data_cpu;
					2'b10:CacheMemArray[r_index][95:64] <=i_data_cpu;
					2'b11:CacheMemArray[r_index][127:96]<=i_data_cpu;
					
				endcase
				CacheTagArray[r_index][TAG_SIZE+1+1-1]<=1'b1;//The block is dirty
			end
			//Replacing the data
			else if(i_replace==1'b1) begin
				CacheMemArray[r_index]<=i_data_memory;
				CacheTagArray[r_index][TAG_SIZE-1:0]	<=r_tag;
				CacheTagArray[r_index][TAG_SIZE+1-1]	<=1'b1;//valid=1
				CacheTagArray[r_index][TAG_SIZE+1+1-1] <=1'b0;//The block is not dirty anymore
			
			end
	
	end
	
	//The read of data is not done with the clock
	MUX41
	#(.BUS_WIDTH(BUS_WIDTH))
	mux41_0
	(
		.i_data1	(CacheMemArray[r_index][31:0]),
	   .i_data2	(CacheMemArray[r_index][63:32]),
	   .i_data3	(CacheMemArray[r_index][95:64]),
		.i_data4	(CacheMemArray[r_index][127:96]),
      .i_sel	(r_WordOffset),
		.o_data	(o_data_cpu)
	);

	assign o_Tag	=CacheTagArray[r_index][TAG_SIZE-1:0]	;
	assign o_valid	=CacheTagArray[r_index][TAG_SIZE+1-1]	;
	assign o_dirty	=CacheTagArray[r_index][TAG_SIZE+1+1-1];
	always @(*) begin
		o_data_to_mem=CacheMemArray[r_index];
	end

endmodule