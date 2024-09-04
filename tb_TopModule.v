`timescale 1us/1ns
module tb_TopModule();



	parameter BUS_WIDTH					=32									;
   parameter INST_MEM_WIDTH			=8										;
   parameter INST_MEM_DEPTH			=32									;
   parameter INST_MEM_ADDR_WIDTH		=$clog2(INST_MEM_DEPTH)			;	
   parameter REG_DEPTH					=32									;
   parameter ADDRESS_WIDTH				=$clog2(REG_DEPTH)				;
   parameter BLOCK_SIZE					=128									;
   parameter TAG_SIZE   				=3				   					;
   parameter ADDRESS_WIDTH_CACHE		=10									;	
   parameter INDEX_SIZE 				=5										;
   parameter CACHE_MEM_WIDTH			=128									;
   parameter CACHE_MEM_DEPTH			=2**INDEX_SIZE						;
   parameter MAIN_MEM_DEPTH			=1024									;
   parameter MAIN_MEM_WIDTH			=32									;


	reg 	tb_clk							=0	;
	reg 	tb_aresetn						=0	;
	wire 	tb_overflow_flag_PC			=0	;
	wire 	tb_overflow_flag_PC_Branch	=0	;
	wire 	tb_overflow_flag_ALU			=0	;
	
	

	//Instantiation
	TopModule
	#
	(
		.BUS_WIDTH				(BUS_WIDTH				),
	   .INST_MEM_WIDTH		(INST_MEM_WIDTH		),
	   .INST_MEM_DEPTH		(INST_MEM_DEPTH		),
	   .INST_MEM_ADDR_WIDTH	(INST_MEM_ADDR_WIDTH	),
	   .REG_DEPTH				(REG_DEPTH				),
	   .ADDRESS_WIDTH			(ADDRESS_WIDTH			),
	   .BLOCK_SIZE				(BLOCK_SIZE				),
	   .TAG_SIZE   			(TAG_SIZE   			),
	   .ADDRESS_WIDTH_CACHE	(ADDRESS_WIDTH_CACHE	),
	   .INDEX_SIZE 			(INDEX_SIZE 			),
	   .CACHE_MEM_WIDTH		(CACHE_MEM_WIDTH		),
	   .CACHE_MEM_DEPTH		(CACHE_MEM_DEPTH		),
	   .MAIN_MEM_DEPTH		(MAIN_MEM_DEPTH		),
	   .MAIN_MEM_WIDTH		(MAIN_MEM_WIDTH		)
	)
	DUT
	(
		.i_clk									(tb_clk)								,	
	   .i_aresetn								(tb_aresetn)						,
	   .o_overflow_flag_PC					(tb_overflow_flag_PC)			,
	   .o_overflow_flag_PC_Branch			(tb_overflow_flag_PC_Branch)	,
	   .o_overflow_flag_ALU					(tb_overflow_flag_ALU)
	);
	

	//clock generation
	always begin
		#0.5 tb_clk=~tb_clk;
	end

	//Stimulus and monitor the output
	initial begin
	
		$monitor($time,"tb_overflow_flag_PC=%b,tb_overflow_flag_PC_Branch=%b,tb_overflow_flag_ALU=%b",tb_overflow_flag_PC,tb_overflow_flag_PC_Branch,tb_overflow_flag_ALU);
		tb_aresetn=0;
		#5 tb_aresetn=1;
		#40 $finish;
	
	
	
	
	
	
	
	end








endmodule