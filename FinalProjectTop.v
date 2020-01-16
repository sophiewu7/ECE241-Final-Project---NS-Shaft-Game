
module FinalProjectTop(
		CLOCK_50,						//	On Board 50 MHz
		KEY,								// FPGA KEY
		PS2_CLK,							// PS2'S CLK
		PS2_DAT,							// PS2'S DATA
		SW,								// FPGA SWITCHES
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,					//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		HEX0,
		HEX1,
		HEX3,
		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		FPGA_I2C_SDAT,

		// Outputs
		AUD_XCK,
		AUD_DACDAT,

		FPGA_I2C_SCLK,
	);
	
	input AUD_ADCDAT;

	// Bidirectionals
	inout AUD_BCLK;
	inout AUD_ADCLRCK;
	inout AUD_DACLRCK;
	inout FPGA_I2C_SDAT;

	// Outputs
	output AUD_XCK;
	output AUD_DACDAT;
	output FPGA_I2C_SCLK;
		
	// Internal Wires
	wire audio_in_available;
	wire [31:0] left_channel_audio_in;
	wire [31:0] right_channel_audio_in;
	wire read_audio_in;

	wire audio_out_allowed;
	wire [31:0]	left_channel_audio_out;
	wire [31:0]	right_channel_audio_out;
	wire write_audio_out;
	wire [31:0] sound;

	input			CLOCK_50;	   	//	50 MHz
	input	[5:0]	KEY;				   // FPGA KEY
	input [9:0] SW;			      // FPGA SWITCHES
	inout			PS2_CLK;		   	// PS2'S CLK
	inout			PS2_DAT;				// PS2'S DATA

	// Do not change the following outputs
	output		 VGA_CLK;   		//	VGA Clock
	output		 VGA_HS;			   //	VGA H_SYNC
	output		 VGA_VS;			   //	VGA V_SYNC
	output		 VGA_BLANK_N;	   //	VGA BLANK
	output		 VGA_SYNC_N;	 	//	VGA SYNC
	output [7:0] VGA_R;   		   //	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output [7:0] VGA_G;	 		   //	VGA Green[7:0]
	output [7:0] VGA_B;   		   //	VGA Blue[7:0]
	
	output [6:0] HEX0; 
	output [6:0] HEX1; 
	output [6:0] HEX3;	
	
	// Used to display scores
	wire	 [7:0] score;
	wire   [3:0] heart;
	wire         resetn;          // Reset
	
	assign resetn = KEY[0];
	
	wire   [11:0] colour;         // Colour to VGA
	wire   [8:0] x;               // X to VGA
	wire   [7:0] y;               // Y to VGA
	wire         writeEn;         // Enable to VGA
	
	//PS2 Keyboard
	wire [7:0] ps2_key_data;      // Data received from PS2
	wire ps2_key_pressed;         // Enable from PS2
	reg [7:0] last_data_received; // Store last PS2 output
	
	//Possible User's Actions
	wire left;
	wire right;
	wire enter;          // Reset
	wire start;
	
	always @(posedge CLOCK_50)
	begin
		//Reset
		if (KEY[0] == 1'b0)
			last_data_received <= 8'h00;
		//Store PS2 output
		else if (ps2_key_pressed == 1'b1)
			last_data_received <= ps2_key_data; 
	end
	
	//Keyboard Controller
	PS2_Controller PS2(
		// Inputs
		.CLOCK_50(CLOCK_50),
		.reset(0),
		// Bidirectionals
		.PS2_CLK(PS2_CLK),
		.PS2_DAT(PS2_DAT),
		// Outputs
		.received_data(ps2_key_data),
		.received_data_en(ps2_key_pressed)
	);	

	//Keyboard FSM
	controlKeyboard C0(
        .clk(CLOCK_50),
        .resetn(resetn),
        
        .ps2_key_pressed(ps2_key_pressed),
		  .last_data_received(last_data_received),
        
        .left(left),
		  .right(right),
		  .enter(enter),
		  .startGame(start)
   	);
		
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(1),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "Start_Interface.mif";
				
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	
	//use key first
	Display d1(CLOCK_50, left, right, enter, resetn , x, y, colour, score, SW, heart);
	hex_decoder h0(heart, HEX3);
   hex_decoder h1(score[3:0], HEX0);
	hex_decoder h2(score[7:4], HEX1);
	
	music ms1 (CLOCK_50, enter, sound);
	
	assign read_audio_in = audio_in_available & audio_out_allowed;
	assign left_channel_audio_out	= left_channel_audio_in+sound;
	assign right_channel_audio_out = right_channel_audio_in+sound;
	assign write_audio_out = audio_in_available & audio_out_allowed;

	/*****************************************************************************
	 *                              Internal Modules                             *
	 *****************************************************************************/

	Audio_Controller Audio_Controller (
		// Inputs
		.CLOCK_50 (CLOCK_50),
		.reset (SW[0]),

		.clear_audio_in_memory (),
		.read_audio_in (read_audio_in),
		
		.clear_audio_out_memory (),
		.left_channel_audio_out (left_channel_audio_out),
		.right_channel_audio_out (right_channel_audio_out),
		.write_audio_out (write_audio_out),//(write_audio_out)

		.AUD_ADCDAT	(AUD_ADCDAT),

		// Bidirectionals
		.AUD_BCLK (AUD_BCLK),
		.AUD_ADCLRCK (AUD_ADCLRCK),
		.AUD_DACLRCK (AUD_DACLRCK),

		// Outputs
		.audio_in_available (audio_in_available),
		.left_channel_audio_in (left_channel_audio_in),
		.right_channel_audio_in (right_channel_audio_in),

		.audio_out_allowed (audio_out_allowed),

		.AUD_XCK (AUD_XCK),
		.AUD_DACDAT (AUD_DACDAT)

	);

	avconf #(.USE_MIC_INPUT(1)) avc (
		.FPGA_I2C_SCLK (FPGA_I2C_SCLK),
		.FPGA_I2C_SDAT (FPGA_I2C_SDAT),
		.CLOCK_50 (CLOCK_50),
		.reset (SW[0])
	);
	
endmodule

