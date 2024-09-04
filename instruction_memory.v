

module instruction_memory
	#(
		parameter BUS_WIDTH					=32									,
		parameter INST_MEM_WIDTH			=8										,
		parameter INST_MEM_DEPTH			=32									,
		parameter INST_MEM_ADDR_WIDTH		=$clog2(INST_MEM_DEPTH)
	 )
	(
		input	 wire [INST_MEM_WIDTH-1:0] i_InstructionAddress	,
		output reg  [INST_MEM_DEPTH-1:0] o_Instruction			 	
	);
	
	
	// Declare the memory array
	reg [INST_MEM_WIDTH-1:0] InstMemArray [0:INST_MEM_DEPTH-1];
	
	
	initial begin
		// add $3,$0,$2
		
		InstMemArray[0]=8'h00;
		InstMemArray[1]=8'h20;
		InstMemArray[2]=8'h01;
		InstMemArray[3]=8'hB3;
		
		// sub $1,$3,$2
		InstMemArray[4]=8'h40;
		InstMemArray[5]=8'h21;
		InstMemArray[6]=8'h80;
		InstMemArray[7]=8'hB3;
		
		
		// add $31,$30,$1
		InstMemArray[8]=8'h00;
		InstMemArray[9]=8'h1F;
		InstMemArray[10]=8'h0F;
		InstMemArray[11]=8'hB3;
		
		// Lw $30,8($0)
		InstMemArray[12]=8'h00;
		InstMemArray[13]=8'h80;
		InstMemArray[14]=8'h2F;
		InstMemArray[15]=8'h03;
		
		// Sw $30,0($4)
		InstMemArray[16]=8'h01;
		InstMemArray[17]=8'hE2;
		InstMemArray[18]=8'h20;
		InstMemArray[19]=8'h23;
			
		// add $31,$30,$1
		InstMemArray[20]=8'h00;
		InstMemArray[21]=8'h1F;
		InstMemArray[22]=8'h0F;
		InstMemArray[23]=8'hB3;
		
		// Sw $29,0($4)
		InstMemArray[24]=8'h01;
		InstMemArray[25]=8'hD2;
		InstMemArray[26]=8'h20;
		InstMemArray[27]=8'h23;
		
		
		
		//others=>0
		//InstMemArray[8:INST_MEM_DEPTH-1]=0;

	end
	
	always @(*) begin
		
		o_Instruction<={InstMemArray[i_InstructionAddress],InstMemArray[i_InstructionAddress+1],InstMemArray[i_InstructionAddress+2],InstMemArray[i_InstructionAddress+3]};
	
	end


endmodule