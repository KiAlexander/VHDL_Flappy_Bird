---------------------------------------------
--Design Unit	: Game Control Unit
--File Name  	: Game.vhdl
--Description	: Control the game in order
--Limitation 	: None
--Author  		: YangJianming
---------------------------------------------
Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity game is
	port(
		clk_1khz		:in std_logic;--1khz
		reset			:in std_logic;
		game_order		:in integer range 0 to 6; --to control the order of game
		pipe1			:in std_logic_vector(7 downto 0); --the 1st pipe
		pipe2			:in std_logic_vector(7 downto 0); --the 2nd pipe
		pipe3			:in std_logic_vector(7 downto 0); --the 3rd pipe
		pipe4			:in std_logic_vector(7 downto 0); --4th pipe
		bird_position	:in integer range 1 to 8; --the current position of bird
		number_pipe		:in integer range 0 to 4; --the number of the pipe in the screen
		colume_pipe		:in std_logic_vector(7 downto 0); --the message of pipe
		score			:out integer range 0 to 13;
		row_mark		:out std_logic_vector(7 downto 0);	--row scan
		col_red			:out std_logic_vector(7 downto 0);	--red control
		col_green		:out std_logic_vector(7 downto 0)	--green control

		);
end game;

architecture game_arc of game is	
	signal score_tmp: integer range 0 to 13;	--the player's score_tmp
	signal order_control: integer range 0 to 6;	--control the order of the game
begin
	move:process(clk_1khz,reset)
		variable row_tmp: std_logic_vector(7 downto 0);	
		variable column_red: 	std_logic_vector(7 downto 0);
		variable column_green: std_logic_vector(7 downto 0);
		variable bird_flag: integer range 0 to 1;--indicate the bird is being scanned
		variable compute_flag:	integer range 0 to 1;
		variable count: integer range 0 to 8;	
--		variable ring_temp: std_logic;
	begin
		if reset = '1' then 
			count			:= 0;
			compute_flag	:= 0;
			row_tmp			:= "01111111";
			column_red 		:= "00000000";
			column_green	:= "00000000";
			order_control 	<= 0;
			score_tmp 		<= 0;
			
			row_mark 		<= "01111111";
			col_red 		<= "00000000";
			col_green 		<= "00000000";
			score 			<= 0;

----			ring_temp:= '0';
		elsif rising_edge(clk_1khz) then
			order_control <= game_order;
			
			row_tmp := row_tmp(6 downto 0) & row_tmp(7);--scan row from down to up
			if count = 8 then count:= 1;--no.1~8 row 
			else count:= count+1;
			end if;
			
			--start_up screen picture:5s countingdown--
			if(order_control /= 6) then
				case count is
					when 8 => column_green:= "11111111"; 
					when 7 => column_green:= "10000001"; 
					when 6 => column_green:= "10000001"; 
					when 5 => column_green:= "10000001"; 
					when 4 => column_green:= "10000001"; 
					when 3 => column_green:= "10000001"; 
					when 2 => column_green:= "10000001"; 
					when 1 => column_green:= "11111111"; 
					when others => null;
				end case;
			end if;
		
			if(order_control = 1) then	--display the number "5"
				case count is
					when 8 => column_red:= "00000000"; 
					when 7 => column_red:= "00111100"; 
					when 6 => column_red:= "00000100"; 
					when 5 => column_red:= "00111100"; 
					when 4 => column_red:= "00100000"; 
					when 3 => column_red:= "00100000"; 
					when 2 => column_red:= "00111100"; 
					when 1 => column_red:= "00000000"; 
					when others => null;
				end case;
			elsif(order_control = 2) then	--display the number "4"
				case count is
					when 8 => column_red:= "00000000"; 
					when 7 => column_red:= "00100100"; 
					when 6 => column_red:= "00100100"; 
					when 5 => column_red:= "00100100"; 
					when 4 => column_red:= "00111100"; 
					when 3 => column_red:= "00100000"; 
					when 2 => column_red:= "00100000"; 
					when 1 => column_red:= "00000000"; 
					when others => null;
				end case;
			elsif(order_control = 3) then	--display the number "3"
				case count is
					when 8 => column_red:= "00000000"; 
					when 7 => column_red:= "00111100"; 
					when 6 => column_red:= "00100000"; 
					when 5 => column_red:= "00111100"; 
					when 4 => column_red:= "00100000"; 
					when 3 => column_red:= "00100000"; 
					when 2 => column_red:= "00111100"; 
					when 1 => column_red:= "00000000"; 
					when others => null;
				end case;
			elsif(order_control = 4) then	--display the number "2"
				case count is
					when 8 => column_red:= "00000000"; 
					when 7 => column_red:= "00111100"; 
					when 6 => column_red:= "00100000"; 
					when 5 => column_red:= "00111100"; 
					when 4 => column_red:= "00000100"; 
					when 3 => column_red:= "00000100"; 
					when 2 => column_red:= "00111100"; 
					when 1 => column_red:= "00000000"; 
					when others => null;
				end case;
			elsif(order_control = 5) then	--display the number "1"
				case count is
					when 8 => column_red:= "00000000"; 
					when 7 => column_red:= "00001000"; 
					when 6 => column_red:= "00001100"; 
					when 5 => column_red:= "00001000"; 
					when 4 => column_red:= "00001000"; 
					when 3 => column_red:= "00001000"; 
					when 2 => column_red:= "00011100"; 
					when 1 => column_red:= "00000000"; 
					when others => null;
				end case;
			elsif(order_control = 6) then--the game start
		
				column_green:= "00000000";
										
				if score_tmp = 13 then 	--fail:"X"
--				ring_temp:= '1';
					case count is
						when 8 => column_red:= "00000000"; 
						when 7 => column_red:= "01000010"; 
						when 6 => column_red:= "00100100"; 
						when 5 => column_red:= "00011000"; 
						when 4 => column_red:= "00011000"; 
						when 3 => column_red:= "00100100"; 
						when 2 => column_red:= "01000010"; 
						when 1 => column_red:= "00000000"; 
						when others => null;
					end case;
				elsif score_tmp = 12 then 	--success:"V"
					case count is
						when 8 => column_red:= "00000000"; 
						when 7 => column_red:= "01000010"; 
						when 6 => column_red:= "01000010"; 
						when 5 => column_red:= "01000010"; 
						when 4 => column_red:= "00100100"; 
						when 3 => column_red:= "00100100"; 
						when 2 => column_red:= "00011000"; 
						when 1 => column_red:= "00000000"; 
						when others => null;
					end case;
				
				else
					--when the row which th bird is in is scanned,set the 5th colume high
					if bird_position = count then column_red:= "00010000"; bird_flag:= 1;
					else column_red:= "00000000"; bird_flag:= 0;    	   end if;
				    --according to the number of pipes,to control the green colume
					if(number_pipe = 0) then
						if colume_pipe(7) = '1' then column_green(7):= not pipe1(count-1);
						elsif colume_pipe(6) = '1' then	column_green(6):= not pipe1(count-1);
						end if;
				 
					elsif(number_pipe = 1) then
						if colume_pipe(5) = '1' then	
							column_green(5):= not pipe1(count-1);
							column_green(7):= not pipe2(count-1);
						elsif colume_pipe(4) = '1' then
							if(pipe1(count-1) = '1') then 
								if pipe1 /= "11111111" then
									if(compute_flag = 0) then
										score_tmp <= score_tmp + 1;
										compute_flag:= compute_flag+1;	 
									end if;
								end if;
								column_green(6):= not pipe2(count-1);
							elsif pipe1(count-1) = '0' then
								if bird_flag = 1 then score_tmp <= 13;
								else 
									column_green(4):= not pipe1(count-1);
									column_green(6):= not pipe2(count-1);
								end if;
							end if;
						end if;
				
					elsif(number_pipe = 2) then
						if colume_pipe(3) = '1' then 
							column_green(3):= not pipe1(count-1);
							column_green(5):= not pipe2(count-1);
							column_green(7):= not pipe3(count-1);
							compute_flag:= 0;		
						elsif colume_pipe(2) = '1' then
							if(pipe2(count-1) = '1') then --if fly through a pipe
								if pipe2 /= "11111111" then--empty colume
									if(compute_flag = 0) then--if bird survive
										score_tmp <= score_tmp + 1;--add score
										compute_flag:= compute_flag+1;	 
									end if;
								end if;
								column_green(2):= not pipe1(count-1);
								column_green(6):= not pipe3(count-1);
							elsif pipe2(count-1) = '0' then--if run into a pipe
								if bird_flag = 1 then score_tmp <= 13;--fail
								else 
									column_green(2):= not pipe1(count-1);
									column_green(4):= not pipe2(count-1);
									column_green(6):= not pipe3(count-1);
								end if;
							end if;
						end if;
					
					elsif(number_pipe = 3) then
						if colume_pipe(1) = '1' then 
							column_green(1):= not pipe1(count-1);
							column_green(3):= not pipe2(count-1);
							column_green(5):= not pipe3(count-1);
							column_green(7):= not pipe4(count-1);
							compute_flag:= 0;		
						elsif colume_pipe(0) = '1' then
							if(pipe3(count-1) = '1') then 
								if pipe3 /= "11111111" then
									if(compute_flag = 0) then
										score_tmp <= score_tmp + 1;
										compute_flag:= compute_flag+1;	 
									end if;
								end if;
							column_green(0):= not pipe1(count-1);
							column_green(2):= not pipe2(count-1);
							column_green(6):= not pipe4(count-1);
							elsif pipe3(count-1) = '0' then
								if bird_flag = 1 then score_tmp <= 13;
								else 
									column_green(0):= not pipe1(count-1);
									column_green(2):= not pipe2(count-1);
									column_green(4):= not pipe3(count-1);
									column_green(6):= not pipe4(count-1);
								end if;
							end if;
						end if;
					
					elsif(number_pipe = 4) then
						if colume_pipe(1) = '1' then 
							column_green(1):= not pipe1(count-1);
							column_green(3):= not pipe2(count-1);
							column_green(5):= not pipe3(count-1);
							column_green(7):= not pipe4(count-1);
							compute_flag:= 0;		
						elsif colume_pipe(0) = '1' then
							if(pipe3(count-1) = '1') then
								if pipe3 /= "11111111" then
									if(compute_flag = 0) then
										score_tmp <= score_tmp + 1;
										compute_flag:= compute_flag+1;	
									end if;
								end if;
								column_green(0):= not pipe1(count-1);
								column_green(2):= not pipe2(count-1);
								column_green(6):= not pipe4(count-1);
							elsif pipe3(count-1) = '0' then
								if bird_flag = 1 then score_tmp <= 13;
								else 
									column_green(0):= not pipe1(count-1);
									column_green(2):= not pipe2(count-1);
									column_green(4):= not pipe3(count-1);
									column_green(6):= not pipe4(count-1);
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;
		score 		<= score_tmp;
		row_mark 	<= row_tmp;
		col_red		<= column_red;
		col_green 	<= column_green;
--		Ring <= ring_temp;
		 end if;
	
	end process move;

end game_arc;
