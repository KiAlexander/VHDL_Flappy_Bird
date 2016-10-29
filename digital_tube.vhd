---------------------------------------------
--Design Unit	: Digital Tube Unit
--File Name  	: Digital_tube.vhdl
--Description	: Show the numberss in the 
--				  digital tube
--Limitation 	: None
--Author  		: YangJianming
---------------------------------------------
Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity digital_tube is
	port(
		clk_100hz	:in std_logic;--100hz
		reset		:in std_logic;
		score		:in integer range 0 to 13;
		cat 		:out std_logic_vector(7 downto 0);
		seg  		:out std_logic_vector(6 downto 0)
		);
end digital_tube;

architecture digital_tube_arc of digital_tube is
	signal cattmp:std_logic_vector(7 downto 0);
begin 
	scan:process(clk_100hz,cattmp,reset)
	begin
		if reset = '1' then 
			cattmp <= "11111110";
		elsif rising_edge(clk_100hz) then
			case cattmp is
				when "11111110" => cattmp <= "11111101";
				when "11111101" => cattmp <= "11111110";
				when others => null;
			end case;
		end if;
		cat <= cattmp;
	end process scan;

	decode:process(clk_100hz,score)	--to decode the score to display
		variable num: std_logic_vector(6 downto 0);
	begin
		if rising_edge(clk_100hz) then
			case score is
				when 0 =>
					if	 (cattmp = "11111110") then num:= "1111110";	--0
					elsif(cattmp = "11111101") then num:= "1111110";    --0
					end if;
				when 1 =>
					if	 (cattmp = "11111110") then num:= "1111110";	--0
					elsif(cattmp = "11111101") then num:= "0110000";	--1
					end if;
				when 2 =>
					if	 (cattmp = "11111110") then num:= "1111110";	--0
					elsif(cattmp = "11111101") then num:= "1101101";	--2
					end if;
				when 3 =>
					if	 (cattmp = "11111110") then num:= "1111110";	--0
					elsif(cattmp = "11111101") then num:= "1111001";	--3
					end if;
				when 4 =>
					if	 (cattmp = "11111110") then num:= "1111110";	--0
					elsif(cattmp = "11111101") then num:= "0110011";	--4
					end if;
				when 5 =>
					if	 (cattmp = "11111110") then num:= "1111110";	--0
					elsif(cattmp = "11111101") then num:= "1011011";	--5
					end if;
				when 6 =>
					if	 (cattmp = "11111110") then num:= "1111110";	--0
					elsif(cattmp = "11111101") then num:= "1011111";	--6
					end if;
				when 7 =>
					if	 (cattmp = "11111110") then num:= "1111110";	--0
					elsif(cattmp = "11111101") then num:= "1110000";	--7
					end if;
				when 8 =>
					if	 (cattmp = "11111110") then num:= "1111110";	--0
					elsif(cattmp = "11111101") then num:= "1111111";	--8
					end if;
				when 9 =>
					if	 (cattmp = "11111110") then num:= "1111110";	--0
					elsif(cattmp = "11111101") then num:= "1111011";	--9
					end if;
				when 10 =>
					if	 (cattmp = "11111110") then num:= "0110000";	--1
					elsif(cattmp = "11111101") then num:= "1111110";	--0
					end if;
				when 11 =>
					if	 (cattmp = "11111110") then num:= "0110000";	--1
					elsif(cattmp = "11111101") then num:= "0110000";	--1
					end if;
				when 12 =>
					if	 (cattmp = "11111110") then num:= "0110000";	--1
					elsif(cattmp = "11111101") then num:= "1101101";	--2
					end if;
				when others => --fail
					if	 (cattmp = "11111110") then num:= "1111110";	--0
					elsif(cattmp = "11111101") then num:= "1111110";    --0
					end if;
			end case;
		end if;
		seg <= num;
	end process decode;

end digital_tube_arc;