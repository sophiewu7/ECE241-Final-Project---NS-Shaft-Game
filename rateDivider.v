module rateDivider( clk, resetn, rate, counter);

    output reg counter;
    input clk;
    input [28:0] rate;
    input resetn;
    reg [28:0]count;
	 
    always @(posedge clk)
	 begin: Rate_Divider
		if (!resetn)
		begin
			count = rate; 
			counter = 1'b0;
      end
      else 
		begin
			if (count == 29'b0)
			begin
				count = rate;
				counter = 1'b1;
			end
			else if (count)
			begin
				count = count - 29'b1;
				counter = 1'b0;
			end
		end
	end
	
endmodule