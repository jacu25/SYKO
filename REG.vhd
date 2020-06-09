library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity REG is
 
	generic(
		delay : time := 3 ns
	);
	
	port( 
		ie, oe, clk, rst : in std_logic;
		reg_out : out std_logic_vector(7 downto 0) := (others => 'Z');
		reg_io : inout std_logic_vector(7 downto 0) := (others => 'Z')
	);
		
end REG;

architecture arch of REG is
signal r_e : std_logic := '0';
begin 

	clock: process (clk) is

		begin
			if rising_edge(clk) then
				r_e<= '1';
			elsif falling_edge(clk) then
				r_e<= '0';
			end if;
	end process;
	
	process (r_e, ie, oe, rst, reg_io)

	variable store : std_logic_vector (7 downto 0) := (others => 'Z');
	begin
		if r_e='1' then
			if rst='0' then
				store := (others=>'0');
			elsif ie='1' then
				store := reg_io;
			end if;
		elsif r_e='0' then
			if oe='1' then
				reg_io <= store after delay;
			else
				reg_io <= (others=>'Z') after delay;
			end if;
				reg_out	<= store after delay;
		end if;
	end process;
end arch;