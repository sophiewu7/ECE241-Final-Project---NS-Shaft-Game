# NS-Shaft Game

In a team of two, built a video game similar to NS-Shaft using Verilog with an FPGA board, a PS2 keyboard, a VGA adaptor and a monitor as the final project for ECE241 (Digital Systems).

Through three weeks of work, we have successfully build a video game where a player (snowman)
can jump down three different types of randomly moving (both speed and position) platforms to
reach the 30th level (every 5 platforms count as 1 level) to win the game.

## 1.0 Introduction

The goal of this design project was to apply what we have learned in ECE241 to create a game similar to NS-SHAFT. Through three weeks of hard work, we have successfully build a fully functional game by using a PS2 keyboard, an FPGA board, a monitor and a speaker.

Our game consists of four interfaces: start interface, game interface, win interface, and loss interface. In our game, a player (a snowman) goes down the screen by jumping onto 4 different types of platforms while the background is keep moving upwards. Once the player moves down 30 levels, the player wins the game. At the top of the screen, there is a line of spikes where the player will lose 1 heart if he/she hits the spikes. The player will have 5 hearts in total, once he/she lose all his/her life, he/she lose the game. Also, if the player did not land on any platform, he/she will fall off the screen and the game will be over.

## 2.0 Design

The following sections are descriptions of our main game logics.

### 2.1 Block Diagram

The following two figures are the block diagrams of our design.

![overall design](/img/figure1.jpg)
Figure 2.0 - The block Diagram of the overall design

![display module](/img/figure2.jpg)

### 2.2 Functions

#### Top Module (FinalProjectTop.v)
Our top module, FinalProjectTop, acts as a connection for our game logic and the VGA adaptor, keyboard controller and the audio controller. In this module, we instantiate the VGA adaptor, keyboard controller, audio controller and the HEX displays that allow us to see score and hearts not only on the screen but also on the FPGA board.

#### Game Logic (Display.v)
Most of our codes are contained in this module. This module, as shown in Figure 2.1, receives CLOCK_50, resetn, left, right, enter, start as inputs and gives x(VGAx), y(VGAy), colour back to the top module as outputs. This module consists of over 1000 lines of code, to describe it more organically, we will divide this module into the following sections:

**Interfaces:**
The resolution for our game is 320*240. We have 4 different interfaces as mentioned before: start interface, game interface, win interface and loss interface. These 4 interfaces are images using 1 colour channel imported as ROM. How we switches interfaces will be explain in the later section of the report.

**Platforms:**
In this game, we will always display 5 platforms on the screen randomly using 5 different linear feedback shift registers [1]. We used the linear feedback shift register code [1] that we found online and changed the size of the number and changed the seeds to generate random numbers that best fit our game. In this module, we call the ROM that we created to generate 5 normal platforms (yellow) and the ROMs that contains the two roller platform as well as the ROM that contains the blue platform that will break once the player stands on it. And we will have the colour and x, y position of each platform stored in different wire to use later when we start plotting.

**Player:**
Since it is wintertime, our player is a snowman. Due to the spikes that we have on the top of the screen, our player has two modes: poked and unpoked. When the player has reached the top of the screen, the snowman will turn red (displaying ROM that stores red snowman) and the player will lose 1 heart. In other situations, a white snowman (ROM that stores white snowman) will be displayed on the monitor.

**Score:**
In this game, the score is counted by how many levels have the player go down. We have defined 5 platforms as 1 level. As 5 platforms roll over the screen, the player will gain 1 score. And the score number will be displayed on the right bottom of the screen and the FPGA board using HEX0 and HEX1. When the player loses a game, the score will also be shown on the loss interface. Whereas, when the player reaches the 30th level, the player wins the game, win interface will be shown but no score will be displayed on the screen.

**Heart:**
In this game, the player will have 5 hearts to start. These 5 hearts are 1 single image stored in a ROM and are displayed on the left bottom of the screen. Once the player hits the spikes on the top of the screen, he/she will lose 1 heart. And we will erase heart according to the heart lost. Once the player lost all 5 hearts, the game is over and the loss interface will be shown.

#### Start Game (Start.v)
In our game, we prompt the user to press enter on the keyboard to start the game which is switching from the start interface to the game interface. To achieve this, we wrote an FSM to switch interfaces by pressing enter and stays in the game interface.

#### Keyboard (FinalProjectTop.v & controlKeyboard.v) [2]
We want once the user releases the key on the keyboard, the player stops action (left or right). In order to achieve this, we wrote an FSM that reset left, right, and enter once the player releases the key.

#### Rate Divider (rateDivider.v)
This module is a down-counter that helps us to plot images and control the speed of the
platform. 

#### VGA adaptor [2] 
We used the VGA adaptor code [2] that was provided in Lab7 to display our game on the monitor.

#### Audio [2]
We implemented background music for our game by modifying the code that was provided on the eecg website [2]. We convert our 1-second audio as ROM and wrote music.v that loops the music and output the frequency to the Audio Controller.

### 3.0 Report on Success
All our goals were achieved. We successfully displayed all 4 interfaces on the monitor.

![](/img/figure3.jpg)

![](/img/figure4.jpg)

![](/img/figure5.jpg)

![](/img/figure6.jpg)

When the player hits the spikes on the top of the screen, the snowman will turn red. And as you can see in this picture, normal platforms are the yellow thin platform and the blue platform is the platform that will break if the player steps on it.

![](/img/figure7.jpg)

We also successfully implemented the roller left and roller right platform. As the player steps  onto these two kinds of platforms, it will be pushed toward the direction that the arrow is pointed at. Also, in the figure below, you can see that the score is displayed on the bottom right of the screen where the heart is displayed on the bottom left of the screen. And we tried to make all our images transparent. You can see the blue platform behind the score in the figure below.

![](/img/figure8.jpg)

### 4.0 What would you do differently
If we have more time, we would divide Display.v into different files and maybe put in some FSM to make it more organized. Also, we will improve the audio of our game to makes it longer (around 3s and loops it). Moreover, the original NS-SHAFT game has 100 levels. If we have more time, we would like to add more levels and more types of platforms to make our game closer to the original game.

### 5.0 References

[1] "Random Counter (LFSR)", Asic-world.com , 2019. [Online]. Available:
http://www.asic-world.com/examples/verilog/lfsr.html. [Accessed: 13 Nov 2019]

[2] "IP cores for the Altera DE1-SoC board", Eecg.toronto.edu , 2019. [Online]. Available:
http://www.eecg.toronto.edu/~pc/courses/241/DE1_SoC_cores/. [Accessed: 12 Nov 2019].