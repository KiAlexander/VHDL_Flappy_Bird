---------------------------------------------
--Design Unit	: state judge unit
--File Name  	: speed_control.vhdl
--Description	: The rules of games
--Limitation 	: None
--Author  		: YangJianming
--Revision   	: Version 1.1 2016.10.15
---------------------------------------------
Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity speed_control is
	port(
		control		:in std_logic_vector(1 downto 0);
		speed		:out integer range 0 to 500
		);
end speed_control;

architecture speed_control_arc of speed_control is
begin	
	btn:process(control)	--To control the speed of the watertubes
	begin	
		case control IS
			when "00" => speed <= 499;	--1 s
			when "01" => speed <= 399;	--0.8 s
			when "10" => speed <= 249;	--0.5 s
			when "11" => speed <= 149;	--0.3 s
		end case;
	end process btn;
end speed_control_arc;