---------------------------------------------
--Design Unit	: Main Unit
--File Name  	: Flappy_bird.vhdl
--Description	: Combine all units into a 
--				  whole project
--Limitation 	: None
--Author  		: YangJianming
---------------------------------------------
Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity flappy_bird is
	port(
		clk			:in std_logic;--50M system clock
		reset		:in std_logic;--restart
		--speed control by sw7 and sw 6---
		--"00" means pipes move forward per 1s
		--"01" means pipes move forward per 0.8s
		--"10" means pipes move forward per 0.5s
		--"11" means pipes move forward per 0.3s
		control		:in std_logic_vector(1 downto 0);
		btn0		:in std_logic;	--1:down 2:null
		btn1		:in std_logic;	--1:up   2:null
		row_mark	:out std_logic_vector(7 downto 0);--conrol the display row
		col_red		:out std_logic_vector(7 downto 0);--conrol the display  red colume
		col_green	:out std_logic_vector(7 downto 0);--conrol the display green colum
		seg 		:out std_logic_vector(6 downto 0);--show the score
		cat			:out std_logic_vector(7 downto 0)
		);
end flappy_bird;

architecture flappy_bird_arc of flappy_bird is
	
component bird--key:5hz scan:1khz 
	port(
		clk_5hz			:in std_logic;--5hz
		reset			:in std_logic;
		btn0			:in std_logic;	--1:down 2:null
		btn1			:in std_logic;	--1:up   2:null
		bird_position	:out integer range 1 to 8--output the current position of bird
	);
end component bird;

component pipe 
	port(
		clk_1hz			:in std_logic;--1hz
		reset			:in std_logic;
		pipe1			:out std_logic_vector(7 downto 0);	--the 1st pipe
		pipe2			:out std_logic_vector(7 downto 0);	--the 2nd pipe
		pipe3			:out std_logic_vector(7 downto 0);	--the 3rd pipe
		pipe4			:out std_logic_vector(7 downto 0);	--the 4th pipe
		colume_pipe		:out std_logic_vector(7 downto 0);	--the message of pipe
		game_order		:out integer range 0 TO 6;--to control the order of game
		number_pipe		:out integer range 0 TO 4--the number of the pipe in the screen
	);
end component pipe;

component digital_tube--display the player's score in the tubes 
	port(
		clk_100hz	:in std_logic;--100hz
		reset		:in std_logic;
		score		:in integer range 0 to 13;--the player's score
		cat 		:out std_logic_vector(7 downto 0);
		seg  		:out std_logic_vector(6 downto 0)--show the score
		);
end component digital_tube;

component fre_div--3 frequences 1hz 5hz 1khz and speed control
	port(
		clk			:in std_logic;--50mhz
		control		:in std_logic_vector(1 downto 0);--speed control by sw7 sw 6
		clk_1khz	:out std_logic;--1khz
		clk_100hz	:out std_logic;--100hz
		clk_5hz		:out std_logic;--5hz
		clk_1hz		:out std_logic--1hz
	);
end component fre_div;

component game --gameover and state show
	port(
		clk_1khz		:in std_logic;--1khz
		reset			:in std_logic;
		game_order		:in integer range 0 TO 6;--order_control?
		pipe1			:in std_logic_vector(7 downto 0);--the 1st pipe
		pipe2			:in std_logic_vector(7 downto 0);--the 2nd pipe
		pipe3			:in std_logic_vector(7 downto 0);--the 3rd pipe
		pipe4			:in std_logic_vector(7 downto 0);--the 4th pipe
		bird_position	:in integer range 1 to 8;--the row where bird is
		number_pipe		:in integer range 0 TO 4;--the number of the pipe in the screen
		colume_pipe		:in std_logic_vector(7 downto 0);--the message of pipe
		score			:out integer range 0 to 13;
		row_mark		:out std_logic_vector(7 downto 0);--row scan
		col_red			:out std_logic_vector(7 downto 0);--red control
		col_green		:out std_logic_vector(7 downto 0)--green control
	);
end component game;

	signal  clk_1khz,clk_100hz,clk_5hz,clk_1hz	:std_logic;
	signal 	bird_position						:integer range 1 to 8;
	signal  pipe1								:std_logic_vector(7 downto 0);
	signal  pipe2								:std_logic_vector(7 downto 0);
	signal  pipe3								:std_logic_vector(7 downto 0);
	signal  pipe4								:std_logic_vector(7 downto 0);
	signal  number_pipe							:integer range 0 TO 4;
	signal  colume_pipe							:std_logic_vector(7 downto 0);
	signal  game_order							:integer range 0 TO 6;
	signal 	score								:integer range 0 to 13;


begin
	u1:bird port map(clk_5hz,reset,btn0,btn1,bird_position);
	
	u2:pipe port map(clk_1hz,reset,pipe1,pipe2,pipe3,pipe4,colume_pipe,game_order,number_pipe);
	
	u3:digital_tube port map(clk_100hz,reset,score,cat,seg);
	
	u4:fre_div port map(clk,control,clk_1khz,clk_100hz,clk_5hz,clk_1hz);
	
	u6:game port map(clk_1khz,reset,game_order,pipe1,pipe2,pipe3,pipe4,bird_position,number_pipe,colume_pipe,score,row_mark,col_red,col_green);
	
end flappy_bird_arc;