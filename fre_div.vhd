---------------------------------------------
--Design Unit	: Frequence divider 
--File Name  	: Fre_div.vhdl
--Description	: Generate proper frequence for
--				  all units
--Limitation 	: None
--Author  		: YangJianming
---------------------------------------------
Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity fre_div is
	port(
		clk			:in std_logic;--50M clock frequence
		control		:in std_logic_vector(1 downto 0);
		clk_1khz	:out std_logic;--scan dot matrix
		clk_100hz	:out std_logic;--scan the digital tube 
		clk_5hz		:out std_logic;--scan whether the button is pressed
		clk_1hz		:out std_logic--scan the moving pipes 
		);
end fre_div;

architecture fre_div_arc of fre_div is
	--the four frequence division factors
	signal count1							:integer range 0 to 24999;
	signal count2							:integer range 0 to 4;
	signal count3							:integer range 0 to 9;
	signal count4							:integer range 0 to 49;
	--the temp of the new four frequence
	signal tmpclk1,tmpclk2,tmpclk3,tmpclk4	:std_logic;
begin
	clock_1khz:process(clk)--1khz
	begin
		if rising_edge(clk) then
			if (count1=24999) then 
				count1<=0;
				tmpclk1<=not tmpclk1;
			else
				count1<=count1+1;
			end if;
		end if;
	end process clock_1khz;
	
	clock_100hz:process(tmpclk1)--100hz
	begin
		if rising_edge(tmpclk1)then
			if (count2=4) then 
				count2<=0;
				tmpclk2<=not tmpclk2;
			else
				count2<=count2+1;
			end if;
		end if;
	end process clock_100hz;
	
	clock_5hz:process(tmpclk2)--5hz
	begin
		if rising_edge(tmpclk2) then
			if (count3=9) then 
				count3<=0;
				tmpclk3<=not tmpclk3;
			else
				count3<=count3+1;
			end if;
		end if;
	end process clock_5hz;
	
	clock_1hz:process(tmpclk2,control)--1hz
		variable speed :integer range 0 to 49;
	begin
		case control IS
			when "00" => speed := 49;	--1 s
			when "01" => speed := 39;	--0.8 s
			when "10" => speed := 24;	--0.5 s
			when "11" => speed := 14;	--0.3 s
		end case;
		if rising_edge(tmpclk2) then
			if (count4=speed) then --default:1hz
				count4<=0;
				tmpclk4<=not tmpclk4;
			else
				count4<=count4+1;
			end if;
		end if;
	end process clock_1hz;
	
	clk_1khz	<=tmpclk1;
	clk_100hz	<=tmpclk2;
	clk_5hz		<=tmpclk3;
	clk_1hz		<=tmpclk4;
end fre_div_arc;
	
		