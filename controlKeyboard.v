
module controlKeyboard(
    input clk,
    input resetn,
	 input ps2_key_pressed,
	 input [7:0] last_data_received,
    output reg  left, right, enter, startGame
    );
	 
	 
	
    reg [2:0] current_state, next_state; 
    localparam S_IDLE = 3'b000,
					S_MAKE = 3'b001,
					S_BREAKCODE1 = 3'b010,
					S_BREAKCODE2 = 3'b100;
					
			
    always@(*)
    begin: state_table 
        case (current_state)
					S_IDLE: next_state = ps2_key_pressed ? S_MAKE : S_IDLE; //enable signal that high when new data received
					S_MAKE: next_state = (last_data_received != 8'b11110000) ? S_MAKE : S_BREAKCODE1;
					S_BREAKCODE1: next_state = (last_data_received != 8'b11110000) ? S_BREAKCODE2 : S_BREAKCODE1;
					S_BREAKCODE2: next_state = ps2_key_pressed ? S_BREAKCODE2 : S_IDLE;
					default: next_state = S_IDLE;
        endcase
    end // state_table
	reg onetimething=1;

    always @(*)
    begin: enable_signals
		if (onetimething)
		begin
		  left = 1'b0;
		  right = 1'b0;
		  enter = 1'b0;
		  startGame = 1'b0;
		  onetimething=0;
		end 
        case (current_state)
		  
				S_IDLE: 
				begin
					left = 1'b0;
					right = 1'b0;
					enter = 1'b0;
				end
				S_MAKE: 
				begin
					if(last_data_received == 8'b00011100)
					begin
						left = 1'b1;
					end
					else if(last_data_received == 8'b00100011)
					begin
						right = 1'b1;
					end
					else if(last_data_received == 8'b01011010)
					begin
						enter = 1'b1;
						startGame = 1'b1;
					end
				end
				S_BREAKCODE2:
				begin
					left = 1'b0;
					right = 1'b0;
					enter = 1'b0;
					startGame=1'b1;
				end
		
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
            current_state <= next_state;
    end // state_FFS
endmodule
