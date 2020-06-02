library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity REG_1 is
 
	generic(	ND : integer := 7;
				delay : time := 1 ns
	);
	
	port( 
		ie, oe, clk, rst : in std_logic;
		r1_ag : out std_logic_vector(ND downto 0);
		r1_io : inout std_logic_vector(ND downto 0)
	);
		
end REG_1;

architecture arch of REG_1 is
begin 
	
	process (clk, ie, oe, rst)

	variable store : std_logic_vector (ND downto 0);
	begin
		if rising_edge(clk) then
			if (rst='0') then
				store := (other=>'0');
			elsif (ie='1') then
				store := r1_io;
			end if;
		elsif falling_edge(clk) then
			if (oe='1') then
				r1_io <= (store) after delay;
			else
				r1_io <= (other=>'Z') after delay;
			end if;
				r1_ag	<= (store) after delay;
		end if;
		
	end process;
end arch;