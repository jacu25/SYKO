library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity flags_buf is
 
	generic(
		ND : integer := 4;
		delay : time := 3 ns
	);
	
	port( 
		ie, rst, clk : in std_logic;
		flags_in : in std_logic_vector(4 downto 0) := (others => 'Z');
		flags_out : out std_logic_vector(4 downto 0) := (others => 'Z')
	);
		
end flags_buf;

architecture arch of flags_buf is
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
	
	process (r_e, ie, rst, flags_in)

	variable store : std_logic_vector (4 downto 0) := (others => 'Z');
	begin
		if r_e='1' then
			if rst='0' then
				store := (others=>'0');
			elsif ie='1' then
				store := flags_in;
			end if;
		elsif r_e='0' then
				flags_out	<= store after delay;
		end if;
	end process;
end arch;