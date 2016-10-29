---------------------------------------------
--Design Unit	: Pipe Move Unit
--File Name  	: Pipe.vhdl
--Description	: Generate pipe randomly 
--Limitation 	: None
--Author  		: YangJianming
---------------------------------------------
Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pipe is
	port(
		clk_1hz		:in std_logic;--1hz
		reset		:in std_logic;
		pipe1		:out std_logic_vector(7 downto 0);	--the 1st pipe
		pipe2		:out std_logic_vector(7 downto 0);	--the 2nd pipe
		pipe3		:out std_logic_vector(7 downto 0);	--the 3rd pipe
		pipe4		:out std_logic_vector(7 downto 0);	--the 4th pipe
		colume_pipe	:out std_logic_vector(7 downto 0);	--the message of pipe
		game_order	:out integer range 0 to 6;--to control the order of game
		number_pipe	:out integer range 0 to 4--the number of the pipe in the screen
		);
end pipe;

architecture pipe_arc of pipe is
	signal number	: integer range 0 to 4;		   --the amount of the pipe
	signal rowA		: std_logic_vector(7 downto 0); --to store the 1st pipe
	signal rowB		: std_logic_vector(7 downto 0);	--to store the 2nd pipe
	signal rowC		: std_logic_vector(7 downto 0);	--to store the 3rd pipe
	signal rowD		: std_logic_vector(7 downto 0);	--to store the 4th pipe
	signal order_control: integer range 0 to 6;	--to control the order of the game
begin 
	pi:process(clk_1hz,reset)
		variable number1: integer range 0 to 6;--generate different messages of pipe
		variable zero	: std_logic;--to move the pipe in order
		variable temp	: std_logic_vector(7 downto 0);--the temp of pipr i
		variable T2		: integer range 0 to 2;--decide when generate one new pipe
		variable column_temp: std_logic_vector(7 downto 0);
		variable temp_flag	: integer range 0 to 2;
	begin
		if reset = '1' then 
			zero:= '0';
			number1:= 0;
			temp_flag:= 0;
			T2:= 0;
			number <= 0;
			column_temp := "00000000";
			order_control <= 0;
			rowA <= "11111111";
			rowB <= "11111111";
			rowC <= "11111111";
			rowD <= "11111111";
			
			number_pipe <= 0;
			colume_pipe <= "00000000";
			pipe1 <= "11111111";
			pipe2 <= "11111111";
			pipe3 <= "11111111";
			pipe4 <= "11111111";
			game_order <= 0;
		elsif rising_edge(clk_1hz) then
			if order_control /= 6 then
				order_control <= order_control+1;
			else
			T2:= T2+1;
			column_temp := zero & column_temp(7 downto 1);--pipe move from right to left 
			if(T2 = 2) then
				column_temp := column_temp or "10000000";--create one new pipe
				T2 := 0;
				if number1 = 6 then number1:=0;
				else number1:= number1+1; end if;
				
				if temp_flag = 0 then--pipe begin to move
					case number1 is
					 when 0 => temp := "11111111";--create the message of the new pipe
					 when 1 => temp := "11111111";
					 when 2 => temp := "11111111";
					 when 3 => temp := "11111111";
					 when 4 => temp := "00111000";
					 when 5 => temp := "00011100";
					 when 6 => temp := "00000111";
					end case;
					if number1 = 6 then temp_flag:= temp_flag+1; end if;
				else
					case number1 is
					 when 0 => temp := "01110000";--create the message of the new pipe
					 when 1 => temp := "00000111";
					 when 2 => temp := "11100000";
					 when 3 => temp := "00001110";
					 when 4 => temp := "00111000";
					 when 5 => temp := "00011100";
					 when 6 => temp := "00000111";
					end case;
				end if;

				case number is
				 when 0 => rowA <= temp;  number <= number+1; 
				 when 1 => rowB <= temp;  number <= number+1; 
				 when 2 => rowC <= temp;  number <= number+1; 
				 when 3 => rowD <= temp;  number <= number+1; 
				 when 4 => rowA <= rowB;  rowB <= rowC; rowC <= rowD; rowD <= temp;
				end case;
			end if;
		end if;
		pipe1 <= rowA;
		pipe2 <= rowB;  
		pipe3 <= rowC;
		pipe4 <= rowD;
		number_pipe <= number;
		game_order	<= order_control;
		colume_pipe <= column_temp;
	end if;

	end process pi;

end pipe_arc;

