-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Random number module.

library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;
use ieee.numeric_std.all ;

entity pRNG is
    generic (
				V_RES  : integer := 12    -- Vertical Resolution
			) ;
	port (   
			 seed   : in std_logic_vector (4 downto 0) ;
			 rand   : out integer range 0 to (V_RES/2 - 1) ;
			 clock  : in  std_logic
		 ) ;
end pRNG ;

architecture behavior of pRNG is
begin
   process (clock)
     variable lfsr : std_logic_vector (4 downto 0) := "10011" ;
      begin
		if rising_edge(clock) then
		 lfsr(0)                   := lfsr(4) xor (lfsr(3) and lfsr(2));                      
		 lfsr(4 downto 1)          := lfsr(3 downto 0); 
		end if ;
	 rand <= to_integer(unsigned(lfsr)) + 16 ;	
    end process ; 
end behavior ;