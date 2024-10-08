

module CacheUnit


	#
	(

		parameter BUS_WIDTH			=32				,
 		parameter BLOCK_SIZE			=128				,
		parameter TAG_SIZE   		=3				   ,
		parameter ADDRESS_WIDTH		=10				,
		parameter INDEX_SIZE 		=5					,
		parameter CACHE_MEM_WIDTH	=128				,
		parameter CACHE_MEM_DEPTH	=2**INDEX_SIZE	,
		parameter MAIN_MEM_DEPTH	=1024				,
		parameter MAIN_MEM_WIDTH	=32					
	)
	
	(
		input i_clk,
		input i_aresetn,
		input i_MemRead,	
		input i_MemWrite,
		input [ADDRESS_WIDTH-1:0]i_AddressCpu,
		input [BUS_WIDTH-1:0] 	 i_data,
		output [BUS_WIDTH-1:0] 	 o_DataToCpu,
		output o_Hit_Or_Miss,
		output o_stall
	);
	
	
	
	wire r_DirtyFromCache	;
	wire r_ValidFromCache	;
	wire [TAG_SIZE-1:0] r_TagFromCache	;
	wire r_MemReady			;
	
	
	
	//Cache related
	wire [BLOCK_SIZE-1:0] r_datafrommemory;
	wire r_WriteEnableCache;
	wire r_Replace;
	wire [BLOCK_SIZE-1:0] r_data_to_mem;
	//Memory related
	wire r_WriteEnableMainMemory;
	wire r_ReadEnable;
	wire [ADDRESS_WIDTH-1:0] r_AddressInCache;
	
	//Cache controller instantiation
	cache_controller
	#
	(
		.BUS_WIDTH		(BUS_WIDTH		),
	   .Address_WIDTH	(ADDRESS_WIDTH	),	
	   .TAG_SIZE		(TAG_SIZE		)		
	)
	CacheController0
	(
		
		
		.i_clk							(i_clk		)					,	
		.i_aresetn						(i_aresetn	)					,		
		.i_MemRead						(i_MemRead)						,	
		.i_MemWrite						(i_MemWrite)					,
		.i_DirtyFromCache				(r_DirtyFromCache)			,
		.i_ValidFromCache				(r_ValidFromCache)			,
		.i_TagFromCache				(r_TagFromCache)				,
		.i_MemReady						(r_MemReady)					,
		.i_Address						(i_AddressCpu)					,
		.o_WriteEnableCache			(r_WriteEnableCache)			,
		.o_WriteEnableMainMemory	(r_WriteEnableMainMemory)	,	
		.o_Replace						(r_Replace)						,
		.o_ReadEnable					(r_ReadEnable)					,
		.o_Hit_Or_Miss					(o_Hit_Or_Miss)				,
		.o_Stall							(o_stall)	
		
	);
	
	//Cache Memory instantiation

	Cache_mem
	#
	(
		.BUS_WIDTH			(BUS_WIDTH),
	   .TAG_SIZE   		(TAG_SIZE),
	   .ADDRESS_WIDTH		(ADDRESS_WIDTH),
	   .INDEX_SIZE 		(INDEX_SIZE),
	   .CACHE_MEM_WIDTH	(CACHE_MEM_WIDTH),
	   .CACHE_MEM_DEPTH	(CACHE_MEM_DEPTH)
	)
	Cache_mem0
	(
		
		 .i_clk	(i_clk)									,		
		 .i_aresetn	(i_aresetn)							,	
		 .i_Address	(i_AddressCpu)							,	
		 .i_data_memory(r_datafrommemory)			,	
		 .i_data_cpu(i_data)								,		
		 .i_write_enable(r_WriteEnableCache)		,
		 .i_replace	(r_Replace)							,
		 .o_data_cpu(o_DataToCpu)						,	
		 .o_data_to_mem(r_data_to_mem)				, 
		 .o_Tag		(r_TagFromCache)					,	
		 .o_valid	(r_ValidFromCache)				,	
		 .o_dirty	(r_DirtyFromCache)				,
		 .o_AddressInCache(r_AddressInCache)
	
	);

	//Main Memory instantiation
	MainMemory
	#
	(
		.BLOCK_SIZE		(BLOCK_SIZE),
	   .ADDRESS_WIDTH	(ADDRESS_WIDTH),
	   .MAIN_MEM_DEPTH(MAIN_MEM_DEPTH),
	   .MAIN_MEM_WIDTH(MAIN_MEM_WIDTH)
	
	)
	MainMemory0
	(
		.i_clk		(i_clk	),		
	   .i_aresetn	(i_aresetn),	
	   .i_AddressCpu	(i_AddressCpu),	
		.i_AddressCache(r_AddressInCache),
	   .i_DataFromcache(r_data_to_mem),
	   .i_WriteEnable	(r_WriteEnableMainMemory),
	   .i_ReadEnable	(r_ReadEnable),
	   
	   
	   .o_MemReady		(r_MemReady),
	   .o_DataToCache	(r_datafrommemory)
	
	
	
	
	
	
	
	);






endmodule