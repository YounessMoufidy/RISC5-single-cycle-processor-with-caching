
module TopModule
	#
	(	
		parameter BUS_WIDTH					=32									,
		parameter INST_MEM_WIDTH			=8										,
		parameter INST_MEM_DEPTH			=32									,
		parameter INST_MEM_ADDR_WIDTH		=$clog2(INST_MEM_DEPTH)			,		
		parameter REG_DEPTH					=32									,
		parameter ADDRESS_WIDTH				=$clog2(REG_DEPTH)				,
		parameter BLOCK_SIZE					=128									,
		parameter TAG_SIZE   				=3				   					,
		parameter ADDRESS_WIDTH_CACHE		=10									,
		parameter INDEX_SIZE 				=5										,
		parameter CACHE_MEM_WIDTH			=128									,
		parameter CACHE_MEM_DEPTH			=2**INDEX_SIZE						,
		parameter MAIN_MEM_DEPTH			=1024									,
		parameter MAIN_MEM_WIDTH			=32														
		
		
		
		
		
		
		
		
	)
	(
		input wire  i_clk											,
		input wire  i_aresetn									,
		output wire o_overflow_flag_PC						,
		output wire o_overflow_flag_PC_Branch				,
		output wire o_overflow_flag_ALU

	);
	
	//Program counter related
	wire [BUS_WIDTH-1:0]  w_PCTarget	;
	wire [BUS_WIDTH-1:0] w_PCPlus4	;
	wire [BUS_WIDTH-1:0] w_PCNext		;
	wire [BUS_WIDTH-1:0] w_pc			;
	
	//Instruction memory
	wire [BUS_WIDTH-1:0] w_Instruction				;
	//Control unit related
	wire w_PCSrc								;
	
	reg [6:0] r_OpCode						;
	reg r_Function7_5							;
	reg [2:0] r_Function3					;
	wire	 [1:0]		w_ResultSrc			;
	wire					w_MemWrite			;
	wire					w_MemRead			;
	wire					w_AluSrc				;
	wire	 [1:0]		w_ImmSrc				;
	wire					w_RegWrite			;
	wire  [2:0]			w_AluControl	 	;	
	//Register file addresses
	wire [ADDRESS_WIDTH-1:0]	w_Read_Address1;
	wire [ADDRESS_WIDTH-1:0]	w_Read_Address2;
	wire [ADDRESS_WIDTH-1:0]	w_Write_Address;
	wire [BUS_WIDTH-1:0] w_Read_data1;	
	wire [BUS_WIDTH-1:0] w_Read_data2;	
	
	wire [BUS_WIDTH-1:0] w_Write_data;
	//Sign extend 
	wire [BUS_WIDTH-1:0] w_ImmExt;
	
	//ALU related
	wire[BUS_WIDTH-1:0] w_SrcA;
	wire[BUS_WIDTH-1:0] w_SrcB;
	wire[BUS_WIDTH-1:0] w_ALUResult;
	wire 					 w_ZeroFlag;
	
	
	//Cache
	wire [BUS_WIDTH-1:0]w_ReadData;
	wire w_Hit_Or_Miss;
	wire w_stall;

	//Register file 
	assign w_Read_Address1=w_Instruction[19:15];
	assign w_Read_Address2=w_Instruction[24:20];
	assign w_Write_Address=w_Instruction[11:7] ;

	//Control unit inputs 
	always @(*) begin
		r_OpCode=w_Instruction[6:0]      ;
		r_Function7_5=w_Instruction[30]  ;
		r_Function3=w_Instruction[14:12] ;
	end
	assign w_SrcA=w_Read_data1;
	Mux21
	#(.BUS_WIDTH(BUS_WIDTH))
	Mux21_selectPC
	(
		.i_data1 (w_PCPlus4) ,
	   .i_data2 (w_PCTarget),
	   .i_sel	(w_PCSrc)	,
		.o_data	(w_PCNext)
	
	);

	//The D FLIP FLOP
	
	Register_PIPO
	#
	(
		.BUS_WIDTH(BUS_WIDTH)
	)
	PC_Register
	(
		.i_clk(i_clk			)	,
		.i_aresetn(i_aresetn	)	,
		.i_enablen(w_stall	)	,
		.i_data(w_PCNext		)	,
		.o_data(w_pc)
	);

	//Adder
	Adder
	#(.BUS_WIDTH(BUS_WIDTH))
	AdderPcPLUS4
	(
		.i_operand1			(w_pc)					,
	   .i_operand2			(32'd4)				   ,
	   .o_result			(w_PCPlus4)				,//it is valid because o_result is of type wire
	   .o_overflow_flag	(o_overflow_flag_PC)
	);
	
	//Instruction memory

	instruction_memory
	#(
		.BUS_WIDTH				(BUS_WIDTH				)	,
	   .INST_MEM_WIDTH		(INST_MEM_WIDTH		)	,
	   .INST_MEM_DEPTH		(INST_MEM_DEPTH		)	,
	   .INST_MEM_ADDR_WIDTH	(INST_MEM_ADDR_WIDTH	)
	
	)
	IM
	(
		.i_InstructionAddress	(w_pc[7:0]		   ),
	   .o_Instruction				(w_Instruction	)
	);
	
	
	
	//Control unit
	ControlUnit
	#
	(
		.BUS_WIDTH(BUS_WIDTH)
	)
	ControlUnit0
	(
		
		.i_OpCode		(r_OpCode			),	
		.i_ZeroFlag		(w_ZeroFlag			),
		.i_Function7_5	(r_Function7_5		),
		.i_Function3	(r_Function3		),	
		.o_PcSrc			(w_PCSrc				),
		.o_ResultSrc	(w_ResultSrc		),	
	   .o_MemRead	   (w_MemRead        ),
		.o_MemWrite		(w_MemWrite			),
	   .o_AluSrc		(w_AluSrc			),	
	   .o_ImmSrc		(w_ImmSrc			),	
	   .o_RegWrite		(w_RegWrite			),
	   .o_AluControl	(w_AluControl		)
	
	);
	
	// The register file
	RegFile
	#
	(
		 .BUS_WIDTH		(BUS_WIDTH		),
	    .REG_DEPTH		(REG_DEPTH		),
	    .ADDRESS_WIDTH(ADDRESS_WIDTH	)
	
	)
	RF0
	(
		 .i_clk		      (i_clk				)		,
	    .i_aresetn		   (i_aresetn			)		,
	    .i_RegWrite		(w_RegWrite			)		,	
	    .i_Read_Address1	(w_Read_Address1	)		,
	    .i_Read_Address2	(w_Read_Address2	)		,
	    .i_Write_Address	(w_Write_Address	)		,
	    .i_Write_data		(w_Write_data     )		,
	    .o_Read_data1		(w_Read_data1     )		,
	    .o_Read_data2		(w_Read_data2     )
	
	
	
	);
	
	//The sign extend
	SignExtend
	#(
		.BUS_WIDTH(BUS_WIDTH)
	)
	SignExtend0
	(
		.i_ImmSrc(w_ImmSrc)										,
		.i_ImmToBeExtended(w_Instruction[BUS_WIDTH-1:7]),
		.o_ImmExt(w_ImmExt)
	);
	
	//The PC Target Branch or jump
	Adder
	#
	(
		.BUS_WIDTH(BUS_WIDTH)
	)
	Adder0
	(
		.i_operand1			(w_ImmExt)						,	
	   .i_operand2			(w_pc)							,	
	   .o_result			(w_PCTarget)					,
	   .o_overflow_flag	(o_overflow_flag_PC_Branch)
	);
	
	//Mux before the ALU
	Mux21
	#
	(
		.BUS_WIDTH(BUS_WIDTH)
	)
	Mux21_ALU
	(
		.i_data1(w_Read_data2)	,
	   .i_data2(w_ImmExt)		,
	   .i_sel  (w_AluSrc)		,
		.o_data (w_SrcB)
	);
	//The ALU
	Alu
	#(.BUS_WIDTH(BUS_WIDTH))
	Alu0
	(
		.i_SrcA				(w_SrcA)					,		
	   .i_SrcB				(w_SrcB)					,		
	   .i_AluControl		(w_AluControl)			,	
	   .o_overflow_flag	(o_overflow_flag_ALU),
	   .o_Result			(w_ALUResult)			,
		.o_ZeroFlag			(w_ZeroFlag)
	);
	//Cache
	CacheUnit
	#
	(
		.BUS_WIDTH			(BUS_WIDTH					),
		.BLOCK_SIZE			(BLOCK_SIZE					),
		.TAG_SIZE   		(TAG_SIZE   				),
		.ADDRESS_WIDTH		(ADDRESS_WIDTH_CACHE		),
		.INDEX_SIZE 		(INDEX_SIZE 				),
		.CACHE_MEM_WIDTH	(CACHE_MEM_WIDTH			),
		.CACHE_MEM_DEPTH	(CACHE_MEM_DEPTH			),
		.MAIN_MEM_DEPTH	(MAIN_MEM_DEPTH			),
		.MAIN_MEM_WIDTH	(MAIN_MEM_WIDTH			)
	 )
	 memory_cache
	 (
		.i_clk		(i_clk	)							,
	   .i_aresetn	(i_aresetn)							,
	   .i_MemRead	(w_MemRead)							,
	   .i_MemWrite(w_MemWrite)							,
		.i_AddressCpu(w_ALUResult[9:0])				,
		.i_data	 (w_Read_data2)						,
		.o_DataToCpu(w_ReadData)						,
		.o_Hit_Or_Miss	(w_Hit_Or_Miss)				,
		.o_stall	 		(w_stall)
	 
	 );
	
	//mux31 to the register file
	MUX41
	
	#(.BUS_WIDTH(BUS_WIDTH))
	MuxToRegFile
	(
		.i_data1	(w_ALUResult)	,
		.i_data2	(w_ReadData)	,
		.i_data3	(w_PCPlus4)		,
		.i_data4	(32'b0)			,
	   .i_sel	(w_ResultSrc)	, 	
		.o_data  (w_Write_data)
	
	
	);
	
	
	
endmodule