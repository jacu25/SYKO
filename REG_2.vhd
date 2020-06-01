library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity REG_2 is
 
	generic(	ND : integer := 7;
				delay : time := 1 ns
	);
	
	port( 
		ie, oe, clk, rst : in std_logic;
		r2_ag : out std_logic_vector(ND downto 0);
		r2_io : inout std_logic_vector(ND downto 0)
	);
		
end REG_2;

architecture arch of REG_2 is
begin 
	 
	process (clk, ie, oe, rst)

	variable store : std_logic_vector (ND downto 0);
	begin
		if rising_edge(clk) then
			if (rst=’0’) then
				store := “00000000”;
			elsif (ie=’1’) then
				store := r2_io;
			end if;
		elsif falling_edge(clk) then
			if (oe='1') then
				r2_io <= store after delay;
			else
				r2_io <= “ZZZZZZZZ” after delay;
			end if
			r2_ag	<= store after delay;
		end if;
		
	end process;
end arch;