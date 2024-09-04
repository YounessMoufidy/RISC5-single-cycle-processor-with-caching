
module AluDecoder
	(
		input    wire			i_OpCode_5		,
		input 	wire [1:0] 	i_AluOp			,
		input 	wire 		  	i_Function7_5	,
		input 	wire [2:0] 	i_Function3		,
		output 	reg  [2:0]	o_AluControl	 		
	
	);
	
	wire [1:0] w_OpCode_function7;
	
	assign w_OpCode_function7={i_OpCode_5,i_Function7_5};
	always @(*) begin
		case(i_AluOp) 
			2'b00	:	o_AluControl=3'b000;//Add (lw sw)
			2'b01	:	o_AluControl=3'b001;//Substract (Beq)
			2'b10	:	begin
							if(i_Function3==3'b000)
							
								if(w_OpCode_function7==2'b00 || w_OpCode_function7==2'b01 || w_OpCode_function7==2'b10)
									o_AluControl=3'b000;//Add
								else
									o_AluControl=3'b001; //SUB
							
							else if(i_Function3==3'b010)
								o_AluControl=3'b101;	// Set less than
							else if(i_Function3==3'b110)
								o_AluControl=3'b011;	// or
							else if(i_Function3==3'b111)
								o_AluControl=3'b010;	// AND
							else
								o_AluControl=3'b000;//Add
			
						 end
			default:  o_AluControl=3'b111;
		
		
		endcase
		
	end











endmodule