library ieee ;
use ieee.std_logic_1164.all;

entity Clock is

	generic( 
		period : time := 0.25 us
	);
	
	port(
		clk : out std_logic := '1'
		);
		
end Clock;

architecture arch of Clock is

begin
	et: 
	process (clk)
	begin
	
		clk <= not clk after 0.5*period;
		
	end process;
end arch;