---------------------------------------------
--Design Unit	: Bird Control Unit
--File Name  	: Bird.vhdl
--Description	: Control bird flap or nor
--Limitation 	: None
--Author  		: YangJianming
---------------------------------------------
Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bird is
	port(
		clk_5hz			:in std_logic;
		reset			:in std_logic;
		btn0			:in std_logic;	--1:down 2:null
		btn1			:in std_logic;	--1:up   2:null
		--to output the current position of bird,the bottom means the first row
		bird_position	:out integer range 1 to 8
		);
end bird;

architecture bird_arc of bird is
	type state_type is (S0,S1,S2,S3,S4,S5,S6,S7);	--7 row numbers
	signal position: integer range 1 to 8;	--the temp of bird_position
begin
	P3:process(clk_5hz,reset)	--to control the bird's position by buttons
		variable position_state: state_type:=S5;
		variable row_bird: std_logic_vector(7 downto 0);--position of the bird
	begin
		if reset = '1' then 
			row_bird := "11101111";
			position_state:=S5;
			bird_position<=6;
		elsif rising_edge(clk_5hz) then 
			case position_state is
			when S0 => 
				if(btn0 = '0' and btn1 = '1') 	then position_state := S1; 	row_bird := "11111101";
				else position_state := S0; 							 		row_bird := "11111110";
				end if;
			when S1 => 
				if(btn0 = '0' and btn1 = '1') 	then position_state := S2; 	row_bird := "11111011";
				elsif(btn0 = '1' and btn1 = '0')then position_state := S0; 	row_bird := "11111110";
				else position_state := S1; 							    	row_bird := "11111101";
				end if;
			when S2 => 
				if(btn0 = '0' and btn1 = '1') 	then position_state := S3;  row_bird := "11110111";
				elsif(btn0 = '1' and btn1 = '0')then position_state := S1; 	row_bird := "11111101";
				else position_state := S2; 							 		row_bird := "11111011";
				end if;
			when S3 => 
				if(btn0 = '0' and btn1 = '1') 	then position_state := S4; 	row_bird := "11101111";
				elsif(btn0 = '1' and btn1 = '0')then position_state := S2; 	row_bird := "11111011";
				else position_state := S3; 							 		row_bird := "11110111";
				end if;
			when S4 =>
				if(btn0 = '0' and btn1 = '1') 	then position_state := S5; 	row_bird := "11011111";
				elsif(btn0 = '1' and btn1 = '0')then position_state := S3; 	row_bird := "11110111";
				else position_state := S4; 							 		row_bird := "11101111";
				end if;
			when S5 => 
				if(btn0 = '0' and btn1 = '1') 	then position_state := S6; 	row_bird := "10111111";
				elsif(btn0 = '1' and btn1 = '0')then position_state := S4; 	row_bird := "11101111";
				else position_state := S5; 							 		row_bird := "11011111";
				end if;
			when S6 => 
				if(btn0 = '0' and btn1 = '1') 	then position_state := S7; 	row_bird := "01111111";
				elsif(btn0 = '1' and btn1 = '0')then position_state := S5; 	row_bird := "11011111";
				else position_state := S6; 							 		row_bird := "10111111";
				end if;
			when S7 => 
				if(btn0 = '1' and btn1 = '0') 	then position_state := S6; 	row_bird := "10111111";
				else position_state := S7; 									row_bird := "01111111";
				end if;
			end case;
	 
		case row_bird is
			when "11111110" => bird_position <= 1;
			when "11111101" => bird_position <= 2;
			when "11111011" => bird_position <= 3;
			when "11110111" => bird_position <= 4;
			when "11101111" => bird_position <= 5;
			when "11011111" => bird_position <= 6;
			when "10111111" => bird_position <= 7;
			when "01111111" => bird_position <= 8;
			when others => null;
		end case;
	end if;
	
	end process P3;

end bird_arc;