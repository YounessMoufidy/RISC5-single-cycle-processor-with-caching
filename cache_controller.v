
module cache_controller
	
	#
	(
		parameter BUS_WIDTH		=32					,
		parameter Address_WIDTH	=10					,
		parameter TAG_SIZE		=3
	)
	(
		input wire i_clk									,
		input wire i_aresetn								,
		input wire i_MemRead								,
		input wire i_MemWrite							,
		input wire i_DirtyFromCache					,
		input wire i_ValidFromCache					,
		input wire [TAG_SIZE-1:0] i_TagFromCache	,
		input wire i_MemReady							,	
		input wire [Address_WIDTH-1:0] i_Address	,
		
		output reg o_WriteEnableCache				,
		output reg o_WriteEnableMainMemory			,
		output reg o_Replace							,
		output reg	o_ReadEnable						,
		output wire o_Hit_Or_Miss						, // 1 for hit and 0 for miss
		output reg o_Stall								

	);
	
	
	parameter s_IDLE=6'b000001,s_COMPARE=6'b000010,s_READ=6'b000100,s_WRITE=6'b001000,s_WRITE_BACK=6'b010000,s_ALLOCATE=6'b100000;
				 
	reg [5:0] r_state;
	reg r_hit=0;
	reg r_done_Write=0;//if write in the cache is done
	reg r_done_Read=0;//if Read in the cache is done
	
	reg [1:0] r_var_test=0;
	always @(*) begin
		//if(i_MemRead||i_MemWrite && (!r_done_Write||!r_done_Read))
		if( (i_MemRead&&!r_done_Read) || (i_MemWrite&&!r_done_Write))
			o_Stall=1'b1;
		else
			o_Stall=1'b0;
	end
	assign o_Hit_Or_Miss=r_hit;
	always@(*) begin
		r_hit=(i_TagFromCache==i_Address[9:7]) && i_ValidFromCache;
	end
	
	
	
	always @(posedge i_clk or negedge i_aresetn) begin
		
		
		
		if(!i_aresetn) begin
			r_state<=s_IDLE;
			o_WriteEnableCache		<=1'b0;
		   o_WriteEnableMainMemory	<=1'b0;
		   o_Replace					<=1'b0;
		   o_ReadEnable				<=1'b0;
			r_done_Read					<=1'b0;
			r_done_Write				<=1'b0;
		end
		else begin
			o_WriteEnableCache		<=1'b0;
		   o_WriteEnableMainMemory	<=1'b0;
		   o_Replace					<=1'b0;
		   o_ReadEnable				<=1'b0;
			r_done_Read					<=1'b0;
			r_done_Write				<=1'b0;
			
			case(r_state) 
			
				s_IDLE:	begin
								r_var_test<=0;

								if(i_MemRead||i_MemWrite)begin
									r_state<=s_COMPARE;
								end
								else begin
										r_var_test<=0;
										r_state<=s_IDLE;
								end
							end
				
				
				
				s_COMPARE:	begin 
									if(r_hit&i_MemRead) begin
										r_state<=s_READ;
									end
									else if(r_hit&&i_MemWrite) begin
										r_var_test<=r_var_test+1'b1;
										r_state<=s_WRITE;
										//o_WriteEnableCache<=1'b1;
									end
									else if(!r_hit&&i_DirtyFromCache) begin
										r_state<=s_WRITE_BACK;
										o_WriteEnableMainMemory<=1'b1;
									end
									else if(!r_hit&&!i_DirtyFromCache) begin
										r_state<=s_ALLOCATE;
										o_ReadEnable<=1'b1;
									end
									else begin
										r_state<=s_IDLE;
									end
								end
				
				
				
				s_READ	:	begin 
									r_state<=s_IDLE;
									r_done_Read<=1'b1;
								end
				s_WRITE:		begin 
									r_state<=s_COMPARE;
									if(i_MemWrite&& r_hit)	begin
										o_WriteEnableCache<=1'b1;
									end
									if(r_var_test==2) begin
										r_done_Write<=1'b1;
										r_var_test<=0;
									end
								   else if(i_DirtyFromCache) begin
										r_done_Write<=1'b1;
									end
//	
								end
				s_WRITE_BACK:	begin 
										if(i_MemReady) begin
											r_state<=s_ALLOCATE;
											o_ReadEnable<=1'b1;
											
										end else
											r_state<=s_WRITE_BACK;
											
									end
				
				
				s_ALLOCATE:	begin 
									o_Replace<=1'b1;

									if(i_MemReady) begin
											r_var_test<=r_var_test+1;

											r_state<=s_WRITE;
									end else
											r_state<=s_ALLOCATE;
									
									end
			
			
			
			endcase
		
		
		
		
		
		
		
		
		
		
		end
		
		
		
	
	end
	
	
	
	
	
	
	
	
endmodule