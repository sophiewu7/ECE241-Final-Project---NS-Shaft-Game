
module start(
    input clk,
    input resetn,
	 input enter,
	 input gameEnd,
    output reg  start
    );

    reg [2:0] current_state, next_state; 
    localparam S_IDLE = 3'b000,
					S_STAY = 3'b001;
					//S_STAY = 3'b010;
			
    always@(*)
    begin: state_table 
        case (current_state)
					S_IDLE: next_state = (enter) ? S_STAY : S_IDLE;
					S_STAY: next_state = (gameEnd) ? S_IDLE : S_STAY;
					default: next_state = S_IDLE;
        endcase
    end // state_table

	 
	 
    always @(*)
    begin: enable_signals
        		  
        case (current_state)
		  
				S_IDLE: 
				begin
					start = 0;
				end
				S_STAY:
				begin
					start = 1;
				end
		
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
            current_state <= next_state;
    end // state_FFS
endmodule

