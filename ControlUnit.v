


module ControlUnit
	#(parameter BUS_WIDTH=32)
	(
		input  wire  [6:0]  		i_OpCode				,
	   input  wire 				i_ZeroFlag			,
		input 	wire 		  		i_Function7_5		,
		input 	wire [2:0] 		i_Function3			,
		output wire			  		o_PcSrc				,
		output wire	 [1:0]		o_ResultSrc			,
		output wire					o_MemWrite			,
		output wire					o_MemRead			,
		output wire					o_AluSrc				,
		output wire	 [1:0]		o_ImmSrc				,
		output wire					o_RegWrite			,
		output wire  [2:0]		o_AluControl	 		
	);
	
	wire [1:0] w_AluOp;
	
	// Instantiation of main decoder
	MainDecoder
	#(.BUS_WIDTH(BUS_WIDTH))
	MainDecoder0
	(
		.i_OpCode		(i_OpCode),	
	   .i_ZeroFlag		(i_ZeroFlag),
	   .o_PcSrc			(o_PcSrc),
	   .o_ResultSrc	(o_ResultSrc),	
	   .o_MemWrite		(o_MemWrite),
		.o_MemRead		(o_MemRead)	,
	   .o_AluSrc		(o_AluSrc),	
	   .o_ImmSrc		(o_ImmSrc),	
	   .o_RegWrite		(o_RegWrite),
	   .o_AluOp			(w_AluOp)
	);

	// Instantiation of the ALU decoder
	AluDecoder AluDecoder0
	(
		.i_OpCode_5		(i_OpCode[5])	,
	   .i_AluOp			(w_AluOp)		,
	   .i_Function7_5	(i_Function7_5),
	   .i_Function3	(i_Function3)	,	
	   .o_AluControl	(o_AluControl)	
	
	
	);
	






endmodule