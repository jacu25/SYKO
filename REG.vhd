library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity REG is
 
	generic(
		delay : time := 3 ns
	);
	
	port( 
		ie, oe, clk, rst : in std_logic;
		reg_out : out std_logic_vector(7 downto 0);
		reg_io : inout std_logic_vector(7 downto 0)
	);
		
end REG;

architecture arch of REG is
begin 
	
	process (clk, ie, oe, rst)

	variable store : std_logic_vector (7 downto 0);
	begin
		if rising_edge(clk) then
			if rst='0' then
				store := (others=>'0');
			elsif ie='1' then
				store := reg_io;
			end if;
		elsif falling_edge(clk) then
			if oe='1' then
				reg_io <= store after delay;
			else
				reg_io <= (others=>'Z') after delay;
			end if;
				reg_out	<= store after delay;
		end if;
	end process;
end arch;