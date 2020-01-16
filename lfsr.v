//Linear Feedback Shift Register (Reference see Final Report Document
module lfsr(
		out,  		// Output of the counter
		enable,  	// Enable  for counter
		clk,  		// clock input
		reset       // reset input
	);

	//----------Output Ports--------------
	output [8:0] out;
	//------------Input Ports--------------
	input enable, clk, reset;
	//------------Internal Variables--------
	reg [8:0] out;
	wire linear_feedback;

	//-------------Code Starts Here-------
	assign linear_feedback = !(out[6] ^ out[3] ^ out[2] ^ out[1] ^ out[0]);

	always@(posedge clk)
	begin
		if (reset) 
		begin // active high reset
			out <= 9'b0 ;
		end 
		else if (enable) 
		begin
			out <= {out[5],
			out[4],out[3],
		   out[2],out[1],
		   out[7],out[6],
		   out[0], linear_feedback};
		   if (out > 9'd320)
		   out <= out - 9'd258;
		end
	end
	
endmodule 

