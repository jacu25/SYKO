library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Acc is
 
	generic(	ND : integer := 7;
				delay : time := 1 ns
	);
	
	port( 
		ie, oe, clk, rst : in std_logic;
		acc_alu : out std_logic_vector(ND downto 0);
		acc_io : inout std_logic_vector(ND downto 0)
	);
		
end Acc;

architecture arch of Acc is
begin 
	
	process (clk, ie, oe, rst)

	variable store : std_logic_vector (ND downto 0);
	begin
		if rising_edge(clk) then
			if (rst=’0’) then
				store := “00000000”;
			elsif (ie=’1’) then
				store := acc_io;
			end if;
		elsif falling_edge(clk) then
			if (oe='1') then
				acc_io <= store after delay;
			else
				acc_io <= “ZZZZZZZZ” after delay;
			end if
				acc_alu <= store after delay;
		end if;
		
	end process;
end arch;