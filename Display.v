
//Display
module Display(
		clk, 
		left, 
		right,
		enter,
		resetn, 
		x, 
		y, 
		color, 
		score, 
		SW,
		heart,
	);
	
	//inputs
	input clk, resetn, left, right, enter;
	input [9:0]SW;
	
	//outputs
	output reg [8:0] x;
	output reg [7:0] y;
	output reg [8:0] color;
	output reg [7:0] score = 8'b0000000;
	output reg[3:0] heart;
	
	//"Press enter to start"
	wire startGame;
	start s0(
        clk,
        resetn,
        enter,
        gameEnd,
        startGame
    );
	 
	reg gameEnd = 0; //check if game end

	//Interfaces//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//background
	wire [16:0] address_background;
	wire [3:0] color_background;
	assign address_background = 320*y + x;
	Background b1 (address_background, clk, color_background); 

	//start interface
	wire [16:0] address_start;
	wire [3:0] color_start;
	assign address_start = 320*y + x;
	StartInterface s1 (address_start, clk, color_start);
	
	//win interface
	wire [16:0] address_win;
	wire [3:0] color_win;
	assign address_win = 320*y + x;
	WinInterface w1 (address_win, clk, color_win);
	
	//loss interface
	wire [16:0] address_loss;
	wire [3:0] color_loss;
	assign address_loss = 320*y + x;
	LossInterface g1 (address_loss, clk, color_loss);
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	
	
	//platforms///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	reg platformcounter;
	
	//////////platform 1//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	wire [8:0] randomx1;
	lfsr l1 (randomx1, 1, clk, 0);
	
	wire [2:0] color_platform1;
	wire [7:0] address_platform1;
	
	assign address_platform1 = (x >= platform_x1 &&  x <= (platform_x1 + 36) 
										  && y >= platform_y1 && y <= (platform_y1 + 4)) ? (36 * (y-platform_y1) + (x - platform_x1)) : 7'b0;
	
	Platform p1(
		address_platform1, 
		clk, 
		color_platform1
	);
	
	reg[8:0] platform_x1 = 9'd80;
	reg[7:0] platform_y1 = 8'd180;
	
	always@(posedge clk)
	begin
		if((platformcounter) && !gameEnd && startGame) 
		begin
			 if (platform_y1 >= 12)
			 begin
				platform_y1 <= platform_y1 - 1;
			 end 
			 if (platform_y1 <= 12)
			 begin
				platform_y1 <= 8'd240;
				platform_x1	<= randomx1;
			 end 
			 if (platform_x1 < 1)
			platform_x1 <= 1;
		end
	end
	
	//////////platform 2//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	wire [8:0] randomx2;
	lfsr2 l2 (randomx2, 1, clk, 0);
	
	wire [2:0] color_platform2;
	wire [7:0] address_platform2;

	break p2(
		address_platform2,
		clk,
		color_platform2
	);
	
	assign address_platform2 = (x >= platform_x2 &&  x <= (platform_x2 + 36) 
										  && y >= platform_y2 && y <= (platform_y2 + 8)) ? (36 * (y-platform_y2) + (x - platform_x2)) : 7'b0;
	
	reg[8:0] platform_x2 = 9'd0;
	reg[7:0] platform_y2 = 8'd130;
	
	always@(posedge clk)
	begin
		if ((platformcounter) && !gameEnd && startGame) 
		begin
			if (platform_y2 >= 12)
			begin
				platform_y2 <= platform_y2 - 1;
			end 
			if (platform_y2 <= 12)
			begin
				platform_y2 <= 8'd240;
				platform_x2 <= randomx2;
			end 
			if (platform_x2 < 1)
			platform_x2 <= 1;
		end
	end

	//////////platform 3//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	wire [8:0] randomx3;
	lfsr3 l3 (randomx3, 1, clk, 0);
	
	wire [2:0] color_platform3;
	wire [7:0] address_platform3;

	Platform p3(
		address_platform3,
		clk,
		color_platform3
	);
	
	assign address_platform3 = (x >= platform_x3 &&  x <= (platform_x3 + 36) 
										  && y >= platform_y3 && y <= (platform_y3 + 4)) ? (36 * (y-platform_y3) + (x - platform_x3)) : 7'b0;
	
	reg[8:0] platform_x3 = 9'd150;
	reg[7:0] platform_y3 = 8'd50;
	
	always@(posedge clk)
	begin
		if ((	platformcounter) && !gameEnd && startGame) 
		begin
			if (platform_y3 >= 12)
			begin
				platform_y3 <= platform_y3 - 1;
			end 
			if (platform_y3 <= 12)
			begin
				platform_y3 <= 8'd240;
				platform_x3 <= randomx2;
			end 
			if (platform_x3 < 1)
			platform_x3 <= 1;
		end
	end
	
	//////////platform 4//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	wire [8:0] randomx4;
	lfsr4 l4 (randomx4, 1, clk, 0);
	
	wire [2:0] color_platform4;
	wire [7:0] address_platform4;

	Platform p4(
		address_platform4,
		clk,
		color_platform4
	);
	
	assign address_platform4 = (x >= platform_x4 &&  x <= (platform_x4 + 36) 
										  && y >= platform_y4 && y <= (platform_y4 + 4)) ? (36 * (y-platform_y4) + (x - platform_x4)) : 7'b0;
	
	reg[8:0] platform_x4 = 9'd240;
	reg[7:0] platform_y4 = 8'd100;
	
	always@(posedge clk)
	begin
	 if ((platformcounter) && !gameEnd && startGame) 
		begin
			if (platform_y4 >= 12)
			begin
				platform_y4 <= platform_y4 - 1;
			end 
			if (platform_y4 <= 12)
			begin
				platform_y4 <= 8'd240;
				platform_x4 <= randomx4;
			end 
			if (platform_x4 < 1)
			platform_x4 <= 1;
		end
	end
	
		
	//////////platform 5//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	reg initialized5 = 1;
	wire [8:0] randomx5;
	lfsr5 l5 (randomx5, 1, clk, 0);
	
	wire [2:0] color_platform5;
	wire [7:0] address_platform5;
	
	Platform p5(
		address_platform5,
		clk,
		color_platform5
	);
	
	assign address_platform5 = (x >= platform_x5 &&  x <= (platform_x5 + 36) 
										  && y >= platform_y5 && y <= (platform_y5 + 4)) ? (36 * (y-platform_y5) + (x - platform_x5)) : 7'b0;

	reg[8:0] platform_x5 = 9'd280;
	reg[7:0] platform_y5 = 8'd220;
	
	always@(posedge clk)
	begin
	  if ((platformcounter) && !gameEnd && startGame) 
		begin
			if (platform_y5 >= 12)
			begin
				platform_y5 <= platform_y5 - 1;
			end 
			if (platform_y5 <= 12)
			begin
				platform_y5 <= 8'd240;
				platform_x5 <= randomx5;
				score <= score + 1'd1;
			end
			if (platform_x5 < 1)
			platform_x5 <= 1;
		end
	end
	
	////roller platforms////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	////roller platform going left//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	wire [2:0] color_rollerLeft;
	wire [8:0] address_rollerLeft;
	reg[8:0] rollerLeft_x;
	reg[7:0] rollerLeft_y; 
	
	rollerLeft roll1(
		address_rollerLeft,
		clk,
		color_rollerLeft
	);
	
	assign address_rollerLeft = (x >= rollerLeft_x &&  x <= (rollerLeft_x + 36) 
										  && y >= rollerLeft_y && y <= (rollerLeft_y + 8)) ? (36 * (y-rollerLeft_y) + (x - rollerLeft_x)) : 9'b0;
										  
	always@(posedge clk)
	begin
	  if ((platformcounter) && !gameEnd && startGame) 
	  begin				 					  
			if (score == 4 || score == 8 || score == 12 || score == 16 || score == 20 || score == 24)
			begin
				rollerLeft_y <= platform_y5;
				rollerLeft_x <= platform_x5;
			end
			if (rollerLeft_y <= 12)
				rollerLeft_y <= 8'd240;
		end
	end
	
	////roller platform going right////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	wire [2:0] color_rollerRight;
	wire [8:0] address_rollerRight;
	
	reg[8:0] rollerRight_x;
	reg[7:0] rollerRight_y; 
	
	rollerRight r0ll2(
		address_rollerRight,
		clk,
		color_rollerRight
	);
	
	assign address_rollerRight = (x >= rollerRight_x &&  x <= (rollerRight_x + 36) 
										  && y >= rollerRight_y && y <= (rollerRight_y + 8)) ? (36 * (y-rollerRight_y) + (x - rollerRight_x)) : 9'b0;
											  
	always@(posedge clk)
	begin
	  if ((platformcounter) && !gameEnd && startGame) 
	  begin									  
			if (score == 2 || score == 6 || score == 10 || score == 14 || score == 18 || score == 22 || score == 26)
			begin
				rollerRight_y <= platform_y5;
				rollerRight_x <= platform_x5;
			end
			if (rollerRight_y <= 12)
				rollerRight_y <= 8'd240;
		end
	end
	
	always@(posedge clk)
	begin
	if (score <= 10)
		platformcounter = count001;
		else if(score > 10 && score < 20) 
		platformcounter = count003;
		else if (score >= 20)
		platformcounter = count004;
	end
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	
	//player//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	wire [8:0] address_player;
	wire [8:0] address_player_poked;
	reg[8:0] player_x;
	reg[7:0] player_y;
	wire [3:0] color_player;
	wire [3:0] color_player_poked;

	reg onetimething=1;
	reg secondtimething=1;
	reg leftpoked = 1;
	reg fourlife = 1;
	reg threelife = 0;
	reg twolife = 0;
	reg onelife = 0;
	reg zerolife = 0;
	reg temp2=1;
	
	Player S5(
		address_player,
		clk,
		color_player
	);
	
	playerPoked s6(address_player_poked,
		clk,
		color_player_poked
	);

	assign address_player = (x >= player_x &&  x <= (player_x + 16) 
									  && y >= player_y && y <= (player_y + 20)) ? (16 * (y-player_y) + (x - player_x)) : 9'b0;
									  
	assign address_player_poked = (x >= player_x &&  x <= (player_x + 16) 
									  && y >= player_y && y <= (player_y + 20)) ? (16 * (y-player_y) + (x - player_x)) : 9'b0;

	//player movement 
	always@(posedge clk)
	begin
		if(onetimething)
		begin
			player_y <= 8'd160;
			player_x <= 9'd90;
			onetimething <= 0;
			heart <= 4'b0101;
		end
		else if((count002) && !gameEnd && startGame) 
		begin
		
			if(left)
			begin
				if (player_x < 9'd2 && player_y <= 8'd220)
				begin
					player_x <= 9'd1;
					player_y <= player_y + 1;
				end
				else if (((player_x >= platform_x1 - 16) || (player_x >= platform_x1)) && (player_x <= platform_x1 + 36)
							  && (player_y <= platform_y1 - 19) && (player_y >= platform_y1 - 22))
					begin
						player_y <= platform_y1 - 21;
						player_x <= player_x - 2;
					end 
				else if (((player_x >= platform_x2 - 16) || (player_x >= platform_x2)) && (player_x <= platform_x2 + 36)
								&& (player_y <= platform_y2 - 19) && (player_y >= platform_y2 - 22))
					begin
					if (temp2)
					begin
						player_y <= platform_y2 - 21; 
						player_x <= player_x - 2;
						temp2=0;
					end
					else if(!temp2)
					begin
						player_y <= player_y ;
						player_x <= player_x - 2;
						temp2=1;
					end
					end
				else if (((player_x >= platform_x3 - 16) || (player_x >= platform_x3)) && (player_x <= platform_x3 + 36)
								&& (player_y <= platform_y3 - 19) && (player_y >= platform_y3 - 22))
					begin
						player_y <= platform_y3 - 21;
						player_x <= player_x - 2;
					end
				else if (((player_x >= platform_x4 - 16) || (player_x >= platform_x4)) && (player_x <= platform_x4 + 36)
								&& (player_y <= platform_y4 - 19) && (player_y>=platform_y4 - 22))
					begin
						player_y <= platform_y4 - 21;
						player_x <= player_x - 2;
					end
				else if (((player_x >= platform_x5 - 16) || (player_x >= platform_x5)) && (player_x <= platform_x5 + 36)
								&& (player_y <= platform_y5 - 19) && (player_y >= platform_y5 - 22))
					begin
						player_y <= platform_y5 - 21;
						player_x <= player_x - 2;
					end
				else 
					begin
						player_x <= player_x - 2;
						player_y <= player_y + 1;
					end 
			end 
			
			else if(right)
			begin
				if (player_x > 9'd303 && player_y <= 8'd220)
				begin 
					player_x <= 9'd303;
					player_y <= player_y + 1;
				end 
				else if (((player_x >= platform_x1 - 16) || (player_x >= platform_x1)) && (player_x <= platform_x1 + 36)
								&& (player_y <= platform_y1 - 19) && (player_y >= platform_y1 - 22))
					begin
						player_y <= platform_y1 - 21;
						player_x <= player_x + 2;
					end 
				else if (((player_x >= platform_x2 - 16)||(player_x >= platform_x2)) && (player_x <= platform_x2 + 36)
								&& (player_y <= platform_y2 - 19) && (player_y >= platform_y2 - 22))
					begin
					if (temp2)
					begin
						player_y <= platform_y2 - 21; 
						player_x <= player_x + 2;
						temp2=0;
					end
					else if(!temp2)
					begin
						player_y <= player_y;
						player_x <= player_x + 2;
						temp2=1;
					end
					end
				else if (((player_x >= platform_x3 - 16) || (player_x >= platform_x3)) && (player_x <= platform_x3 + 36)
								&& (player_y <= platform_y3 - 19) && (player_y >= platform_y3 - 22))
					begin
						player_y <= platform_y3 - 21;
						player_x <= player_x + 2;
					end
				else if (((player_x >= platform_x4 - 16) || (player_x >= platform_x4)) && (player_x <= platform_x4 + 36)
								&& (player_y <= platform_y4 - 19) && (player_y >= platform_y4 - 22))
					begin
						player_y <= platform_y4 - 21;
						player_x <= player_x + 2;
					end
				else if (((player_x >= platform_x5 - 16) || (player_x >= platform_x5)) && (player_x <= platform_x5 + 36)
								&& (player_y <= platform_y5 - 19) && (player_y >= platform_y5 - 22))
					begin
						player_y <= platform_y5 - 21;
						player_x <= player_x + 2;
					end
				else 
					begin
						player_x <= player_x + 2;
						player_y <= player_y + 1;
					end 
			end
			else 
			begin
				if (((player_x >= platform_x1 - 16) || (player_x >= platform_x1)) && (player_x <= platform_x1 + 36)
						 && (player_y <= platform_y1 - 19) && (player_y >= platform_y1 - 22))
					begin
						player_y <= platform_y1 - 21;
						player_x <= player_x;
					end 
				else if (((player_x >= platform_x2 - 16) || (player_x >= platform_x2)) && (player_x <= platform_x2 + 36)
								&& (player_y <= platform_y2-19) && (player_y >= platform_y2 - 22))
					begin
					if (temp2)
					begin
						player_y <= platform_y2 - 21; 
						player_x <= player_x;
						temp2=0;
					end
					else if(!temp2)
					begin
						player_y <= player_y;
						player_x <= player_x;
						temp2=1;
					end
					end
				else if (((player_x >= platform_x3 - 16) || (player_x >= platform_x3)) && (player_x <= platform_x3 + 36)
								&& (player_y <= platform_y3 - 19) && (player_y >= platform_y3 - 22))
					begin
						player_y <= platform_y3 - 21;
						player_x <= player_x;
					end
				else if (((player_x >= platform_x4 - 16) || (player_x >= platform_x4)) && (player_x <= platform_x4 + 36)
								&& (player_y <= platform_y4 - 19)&&(player_y >= platform_y4 - 22))
					begin
						player_y <= platform_y4 - 21;
						player_x <= player_x;
					end 
				else if (((player_x >= platform_x5 - 16) || (player_x >= platform_x5)) && (player_x <= platform_x5 + 36)
								&& (player_y <= platform_y5 - 19) && (player_y >= platform_y5 - 22))
					begin
						player_y <= platform_y5 - 21;
						player_x <= player_x;
					end
					
				else 
					begin
						player_y <= player_y + 1;
						player_x <= player_x;
					end
			end

			end
			else if (((player_x >= rollerLeft_x - 16) || (player_x >= rollerLeft_x)) && (player_x <= rollerLeft_x + 36)
							&&(player_y <= rollerLeft_y - 19)&&(player_y >= rollerLeft_y - 22))
			begin
				if(count003)
				begin
					player_x <= player_x - 2;
					player_y <= rollerLeft_y - 21;
				end
				else 
					player_y <= rollerLeft_y - 21;
			end 
			else if (((player_x >= rollerRight_x - 16) || (player_x >= rollerRight_x)) && (player_x <= rollerRight_x + 36)
							&& (player_y <= rollerRight_y - 19) && (player_y >= rollerRight_y - 22))
			begin
				if(count003)
				begin
					player_x <= player_x + 2;
					player_y <= rollerRight_y - 21;
					end
				else 
					player_y <= rollerRight_y - 21;
			end 
			else if (player_y + 20 >= 8'd240 || heart == 4'b0)
				gameEnd = 1;
			else if(score == 30)
				gameEnd = 1;
			else if(player_y < 12 && fourlife)
			begin
				heart <= heart - 4'b0001;
				leftpoked = 0;
				fourlife = 0;
				threelife = 1;
				twolife = 0;
				onelife = 0;
				zerolife = 0;
			end 
			else if (player_y > 12)
				leftpoked = 1;
			else if(player_y < 12 && threelife && leftpoked)
			begin
				heart <= heart - 4'b0001;
				leftpoked = 0;
				fourlife = 0;
				threelife = 0;
				twolife = 1;
				onelife = 0;
				zerolife = 0;
			end 
			else if(player_y < 12 && twolife && leftpoked)
			begin
				heart <= heart - 4'b0001;
				leftpoked = 0;
				fourlife = 0;
				threelife = 0;
				twolife = 0;
				onelife = 1;			
				zerolife = 0;
			end 
			else if(player_y < 12 && onelife && leftpoked)
			begin
				heart <= heart - 4'b0001;
				leftpoked = 0;
				fourlife = 0;
				threelife = 0;
				twolife = 0;
				onelife = 0;
				zerolife = 1;
			end 
			else if(player_y < 12 && zerolife && leftpoked)
			begin
				heart <= heart - 4'b0001;
				leftpoked = 0;
				fourlife = 0;
				threelife = 0;
				twolife = 0;
				onelife = 0;
				zerolife = 0;	
			end
			
	end
		
		
//////score display//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	wire [2:0] color_0;
	wire [7:0] address_0;
	
	number0 n0(
		address_0,
		clk,
		color_0
	);
	
	assign address_0 = 12*(y - 8'd220) + (x - 9'd303);
	
	wire [2:0] color_00;
	wire [7:0] address_00;
		number0 n00(
		address_00,
		clk,
		color_00
	);
	
	assign address_00 = 12*(y - 8'd220) + (x - 9'd287);
		
	wire [2:0] color_1;
	wire [7:0] address_1;
	number1 n1(
		address_1,
		clk,
		color_1
	);

	assign address_1 = 12*(y - 8'd220) + (x - 9'd303);
	
	wire [2:0] color_10;
	wire [7:0] address_10;
		number1 n10(
		address_10,
		clk,
		color_10
	);
	
	assign address_10 = 12*(y - 8'd220) + (x - 9'd287);
	
	wire [2:0] color_2;
	wire [7:0] address_2;
	number2 n2(
		address_2,
		clk,
		color_2
	);

	assign address_2 = 12*(y - 8'd220) + (x - 9'd303);
		
	wire [2:0] color_20;
	wire [7:0] address_20;
		number2 n20(
		address_20,
		clk,
		color_20
	);
	
	assign address_20 = 12*(y - 8'd220) + (x - 9'd287);
	
	wire [2:0] color_3;
	wire [7:0] address_3;
	number3 n3(
		address_3,
		clk,
		color_3
	);

	assign address_3 = 12*(y - 8'd220) + (x - 9'd303);
		
	wire [2:0] color_4;
	wire [7:0] address_4;
	number4 n4(
		address_4,
		clk,
		color_4
	);

	assign address_4 = 12*(y - 8'd220) + (x - 9'd303);
	
	wire [2:0] color_5;
	wire [7:0] address_5;
	number5 n5(
		address_5,
		clk,
		color_5
	);

	assign address_5 = 12*(y - 8'd220) + (x - 9'd303);
	
	wire [2:0] color_6;
	wire [7:0] address_6;
	number6 n6(
		address_6,
		clk,
		color_6
	);

	assign address_6 = 12*(y - 8'd220) + (x - 9'd303);
	
	wire [2:0] color_7;
	wire [7:0] address_7;
	number7 n7(
		address_7,
		clk,
		color_7
	);

	assign address_7 = 12*(y - 8'd220) + (x - 9'd303);
	
	wire [2:0] color_8;
	wire [7:0] address_8;
	number8 n8(
		address_8,
		clk,
		color_8
	);

	assign address_8 = 12*(y - 8'd220) + (x - 9'd303);

	wire [2:0] color_9;
	wire [7:0] address_9;
	number9 n9(
		address_9,
		clk,
		color_9
	);

	assign address_9 = 12*(y - 8'd220) + (x - 9'd303);	
	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	wire [2:0] color_r0;
	wire [7:0] address_r0;
	
	red0 b0(
		address_r0,
		clk,
		color_r0
	);
	
	assign address_r0 = 12*(y - 8'd170) + (x - 9'd184);
	
	wire [2:0] color_r00;
	wire [7:0] address_r00;
		red0 b00(
		address_r00,
		clk,
		color_r00
	);
	
	assign address_r00 = 12*(y - 8'd170) + (x - 9'd169);
		
	wire [2:0] color_r1;
	wire [7:0] address_r1;
	red1 b11(
		address_r1,
		clk,
		color_r1
	);

	assign address_r1 = 12*(y - 8'd170) + (x - 9'd184);
	
	wire [2:0] color_r10;
	wire [7:0] address_r10;
		red1 b10(
		address_r10,
		clk,
		color_r10
	);
	
	assign address_r10 = 12*(y - 8'd170) + (x - 9'd169);
	
	wire [2:0] color_r2;
	wire [7:0] address_r2;
	red2 b2(
		address_r2,
		clk,
		color_r2
	);

	assign address_r2 = 12*(y - 8'd170) + (x - 9'd184);
		
	wire [2:0] color_r20;
	wire [7:0] address_r20;
		red2 b20(
		address_r20,
		clk,
		color_r20
	);
	
	assign address_r20 = 12*(y - 8'd170) + (x - 9'd169);
	
	wire [2:0] color_r3;
	wire [7:0] address_r3;
	red3 b3(
		address_r3,
		clk,
		color_r3
	);

	assign address_r3 = 12*(y - 8'd170) + (x - 9'd184);
	
	wire [2:0] color_r4;
	wire [7:0] address_r4;
	red4 b4(
		address_r4,
		clk,
		color_r4
	);
	assign address_r4 = 12*(y - 8'd170) + (x - 9'd184);
	
	wire [2:0] color_r5;
	wire [7:0] address_r5;
	red5 b5(
		address_r5,
		clk,
		color_r5
	);

	assign address_r5 = 12*(y - 8'd170) + (x - 9'd184);
	
	wire [2:0] color_r6;
	wire [7:0] address_r6;
	red6 b6(
		address_r6,
		clk,
		color_r6
	);

	assign address_r6 = 12*(y - 8'd170) + (x - 9'd184);
	
	wire [2:0] color_r7;
	wire [7:0] address_r7;
	red7 b7(
		address_r7,
		clk,
		color_r7
	);

	assign address_r7 = 12*(y - 8'd170) + (x - 9'd184);
	
	wire [2:0] color_r8;
	wire [7:0] address_r8;
	red8 b8(
		address_r8,
		clk,
		color_r8
	);

	assign address_r8 = 12*(y - 8'd170) + (x - 9'd184);

	wire [2:0] color_r9;
	wire [7:0] address_r9;
	red9 b9(
		address_r9,
		clk,
		color_r9
	);

	assign address_r9 = 12*(y - 8'd170) + (x - 9'd184);	

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	wire [2:0] color_heart;
	wire [9:0] address_heart;
	
	Life h1(
		address_heart,
		clk,
		color_heart
	);
	
	assign address_heart = 80*(y - 8'd220) + (x-9'd3);
	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	//display to VGA
	always@(posedge clk) 
		begin
		if (enter) 
		begin
			x <= 9'b0;
			y <= 8'b0;
		end
		else 
		begin
			if(x == 9'b100111111) 
			begin
				x <= 9'b0;
				if(y == 8'b11101111)
					y <= 8'b0;
				else
					y <= y + 1;
			end
			else 
				x <= x + 1;
		 end
	end
	
	reg temp=0;
	
	//Colour for VGA	
	always@(*) 
	begin
	if (startGame)
		begin
			if(x >= player_x && x <= (player_x + 16) && y >= player_y && y <= (player_y + 20))
			begin
				if (player_y < 3'd12 && color_player_poked != 3'b001)
					color = color_player_poked;
				else if (color_player != 3'b001)
				begin
					color = color_player;
					if (x > 9'd3 && (x <= 9'd83) && y > 8'd219 && y <= (8'd232))
						color = color_heart;
				end
				else 
					color = color_background; 
			end
			else if ((heart == 5) && (x > 9'd3 && (x <= 9'd83) && y > 8'd219 && y <= (8'd232)))
			begin
				if ((x > 9'd71 && (x <= 9'd75))&& (y > 8'd230 && y <= (8'd233)))
					color = 3'b000;
				if ((x > 9'd77 && (x <= 9'd81))&& (y > 8'd230 && y <= (8'd233)))
					color = 3'b000;
				if((x > 9'd75 && (x <= 9'd77))&& (y > 8'd231 && y <= (8'd232)))
					color = 3'b111;
				else 
					color = color_heart;
			end
			else if ((heart == 4) &&(x > 9'd3 && (x <= 9'd67) && y > 8'd219 && y <= (8'd232)))
				color = color_heart;
			else if ((heart == 3) && (x > 9'd3 && (x <= 9'd51) && y > 8'd219 && y <= (8'd232)))
				color = color_heart;
			else if ((heart == 2) && (x > 9'd3 && (x <= 9'd35) && y > 8'd219 && y <= (8'd232)))
				color = color_heart;
			else if ((heart == 1) && (x > 9'd3 && (x <= 9'd19) && y > 8'd219 && y <= (8'd232)))
				color = color_heart;
			else if (x > 9'd287 && (x <= 9'd299) && y >= 8'd220 && y <= (8'd239))
			begin
				if(score >= 0 && score < 10)
					color = color_00;
				else if (score >= 10 && score < 20)
					color = color_10;
				else if (score >= 20)
					color = color_20;
			end
			else if (x > 9'd303 && (x <= 9'd315) && y >= 8'd220 && y <= (8'd239))
			begin
				if(score == 0)
					color = color_0;
				else if (score == 1)
					color = color_1;
				else if (score == 2)
					color = color_2;
				else if (score == 3)
					color = color_3;
				else if (score == 4)
					color = color_4;
				else if (score == 5)
					color = color_5;
				else if (score == 6)
					color = color_6;
				else if (score == 7)
					color = color_7;
				else if (score == 8)
					color = color_8;
				else if (score == 9)
					color = color_9;
				else if (score == 10)
					color = color_0;
				else if (score == 11)
					color = color_1;
				else if (score == 12)
					color = color_2;
				else if (score == 13)
					color = color_3;
				else if (score == 14)
					color = color_4;
				else if (score == 15)
					color = color_5;
				else if (score == 16)
					color = color_6;
				else if (score == 17)
					color = color_7;
				else if (score == 18)
					color = color_8;
				else if (score == 19)
					color = color_9;
				else if (score == 20)
					color = color_0;
				else if (score == 21)
					color = color_1;
				else if (score == 22)
					color = color_2;
				else if (score == 23)
					color = color_3;
				else if (score == 24)
					color = color_4;
				else if (score == 25)
					color = color_5;
				else if (score == 26)
					color = color_6;
				else if (score == 27)
					color = color_7;
				else if (score == 28)
					color = color_8;
				else if (score == 29)
					color = color_9;
			end
			else if (x >= platform_x1 && x <= (platform_x1 + 36) && y >= platform_y1 && y <= (platform_y1 + 4) && platform_y1 >= 12)
			begin
				color = color_platform1;
			end
			else if (x >= platform_x2 && x <= (platform_x2 + 36) && y >= platform_y2 && y <= (platform_y2 + 8) && platform_y2 >= 12)
			begin
				if(((player_x >= platform_x2 - 16) || (player_x >= platform_x2)) && (player_x <= platform_x2 + 36)
						&& (player_y <= platform_y2 - 19) && (player_y >= platform_y2 - 22) && temp2 == 0)
				begin
					temp = 1;
				end
				if (platform_y2 >= 8'd239)
					temp = 0;
				if(temp == 1)
					color = 3'b000;
				else
					color = color_platform2;
			end
			else if (x >= platform_x3 && x <= (platform_x3 + 36) && y >= platform_y3 && y <= (platform_y3 + 4) && platform_y3 >= 12)
			begin
				color = color_platform3;
			end
			else if (x >= platform_x4 && x <= (platform_x4 + 36) && y >= platform_y4 && y <= (platform_y4 + 4) && platform_y4 >= 12)
			begin
				color = color_platform4;
			end
			else if (x >= platform_x5 &&  x <= (platform_x5 + 36) && y >= platform_y5 && y <= (platform_y5 + 4) && platform_y5 >= 12)
			begin
				if (score == 4 || score == 8 || score == 12 || score == 16 || score == 20 || score == 24)
					color = color_rollerLeft;
				else if (score == 2 || score == 6 || score == 10 || score == 14 || score == 18 || score == 22 || score == 26)
					color = color_rollerRight;
				else 
				color = color_platform5;
			end
			else if (x >= rollerRight_x && x <= (rollerRight_x + 36) && y >= rollerRight_y && y <= (rollerRight_y + 8) && rollerRight_y >= 12)
			begin
				color = color_rollerRight;
			end
			else if (x >= rollerLeft_x && x <= (rollerLeft_x + 36) && y >= rollerLeft_y && y <= (rollerLeft_y + 8) && rollerLeft_y >= 12)
			begin
				color = color_rollerLeft;
			end
			else 
			begin
				color = color_background; // background
			end
		end
		if (score == 30 && gameEnd)
		begin
			color = color_win;
		end
		if (gameEnd && (player_y + 20 >= 8'd240) || (heart == 0))
		begin
		if (x > 9'd169 && (x <= 9'd181) && y >= 8'd170 && y <= (8'd189))
			begin
				if(score >= 0 && score < 10)
				color = color_r00;
				else if (score >= 10 && score < 20)
				color = color_r10;
				else if (score >= 20)
				color = color_r20;
			end
			else if (x > 9'd184 && (x <= 9'd196) && y >= 8'd170 && y <= (8'd189))
			begin
				if(score == 0)
				color = color_r0;
				else if (score == 1)
				color = color_r1;
				else if (score == 2)
				color = color_r2;
				else if (score == 3)
				color = color_r3;
				else if (score == 4)
				color = color_r4;
				else if (score == 5)
				color = color_r5;
				else if (score == 6)
				color = color_r6;
				else if (score == 7)
				color = color_r7;
				else if (score == 8)
				color = color_r8;
				else if (score == 9)
				color = color_r9;
				else if (score == 10)
				color = color_r0;
				else if (score == 11)
				color = color_r1;
				else if (score == 12)
				color = color_r2;
				else if (score == 13)
				color = color_r3;
				else if (score == 14)
				color = color_r4;
				else if (score == 15)
				color = color_5;
				else if (score == 16)
				color = color_r6;
				else if (score == 17)
				color = color_r7;
				else if (score == 18)
				color = color_r8;
				else if (score == 19)
				color = color_r9;
				else if (score == 20)
				color = color_r0;
				else if (score == 21)
				color = color_r1;
				else if (score == 22)
				color = color_r2;
				else if (score == 23)
				color = color_r3;
				else if (score == 24)
				color = color_r4;
				else if (score == 25)
				color = color_r5;
				else if (score == 26)
				color = color_r6;
				else if (score == 27)
				color = color_r7;
				else if (score == 28)
				color = color_r8;
				else if (score == 29)
				color = color_r9;
			end
			else 
				color = color_loss;
		end
		if (!gameEnd && !startGame)
		begin 
			color = color_start;
		end 
	end


	//counters speed controller 

	wire count001;
	wire count002;
	wire count003;
	wire count004;
	
	rateDivider r0(clk, resetn, 24'd999999, count001);
	rateDivider r1(clk, resetn, 27'd1199999, count002);
	rateDivider r2(clk, resetn, 27'd799999, count003);
	rateDivider r3(clk, resetn, 27'd599999, count004);	
	
endmodule
