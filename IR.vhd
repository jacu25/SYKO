library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity IR is
 
	generic(
		delay : time 
	);
	
	port( 
		ie, oe, clk, rst : in std_logic;
		ir_in :in std_logic_vector(7 downto 0);
		ir_out : out std_logic_vector(7 downto 0)
	);
		
		
end IR;

architecture arch of PC is
begin 
	p1: 
	process (clk, ie, oe, rst)

	variable store : std_logic_vector (7 downto 0);
	begin
		if rising_edge(clk) then
			if rst=’0’ then
				store := “00000000”;
			elsif ie=’1’ then
				store := ir_in;
			end if;
		elsif falling_edge(clk) then
			if oe='1' then
				ir_out <= store after delay;
			else
				ir_ir <= “ZZZZZZZZ” after delay;
			end if
		end if;
	end process;
end arch;