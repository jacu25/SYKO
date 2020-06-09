library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity buf is
 
	generic(
		ND : integer := 7;
		delay : time := 3 ns
	);
	
	port( 
		ie, oe, clk, rst : in std_logic;
		buf_in : in std_logic_vector(ND downto 0) := (others => 'Z');
		buf_out : out std_logic_vector(ND downto 0) := (others => 'Z')
	);
		
		
end buf;

architecture arch of buf is
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
	
	process (r_e, ie, oe, rst)

	variable store : std_logic_vector (ND downto 0) := (others => 'Z');
	begin
		if r_e='1'	then
			if rst='0' then
				store := (others => '0');
			elsif ie='1' then
				store := buf_in;
			end if;
		elsif r_e='0' then
			if oe='1' then
				buf_out <= store after delay;
			else
				buf_out <= (others=>'Z') after delay;
			end if;
		end if;		
	end process;

end arch;