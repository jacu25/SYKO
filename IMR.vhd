library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity IMR is
 
	generic(	ND : integer := 7;
				delay : time := 1 ns
	);
	
	port( 
		ie, oe, clk, rst : in std_logic;
		imr_ag : out std_logic_vector(ND downto 0);
		imr_io : inout std_logic_vector(ND downto 0)
	);
		
end IMR;

architecture arch of IMR is
begin 
	
	process (clk, ie, oe, rst)

	variable store : std_logic_vector (ND downto 0);
	begin
		if rising_edge(clk) then
			if (rst=’0’) then
				store := “00000000”;
			elsif (ie=’1’) then
				store := imr_io;
			end if;
		elsif falling_edge(clk) then
			if (oe='1') then
				imr_io <= store after delay;
			else
				imr_io <= “ZZZZZZZZ” after delay;
			end if
				imr_ag	<= store after delay;
		end if;
		
	end process;
end arch;