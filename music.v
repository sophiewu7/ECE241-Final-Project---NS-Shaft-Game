
module music (input CLOCK_50, input enable, output [31:0] sound);

	reg [15:0] crash_addr = 0;
	reg [14:0] hat_addr = 0;
	reg [14:0] snare_addr = 0;
	reg [14:0] kick_addr = 0;

	reg [10:0] crash_counter = 1133, hat_counter = 1133, snare_counter = 1133, kick_counter = 1133;
	reg flag1 = 0, flag2 = 0, flag3 = 0, flag4 = 0;
	wire [23:0]sound1, sound2, sound3, sound4;
	wire counter;


	always@(posedge CLOCK_50)
	begin
	if (enable)
		begin
			crash_addr <= 0;
			crash_counter <= 1134-1;
			flag1 <= 1;
		end
	else if (crash_counter != 0 && flag1 == 1)
		crash_counter <= crash_counter - 1;
	else if (flag1 == 1)
		begin
			crash_counter <= 1134 - 1;
			crash_addr <= crash_addr + 1;
		end

	end

	musicRom mR0 (.address(crash_addr),.clock(CLOCK_50),.q(sound1));

	assign sound = sound1 * 256;

endmodule
