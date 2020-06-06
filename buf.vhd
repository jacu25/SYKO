library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity buf is
 
	generic(
		ND : integer := 7;
		delay : time := 3 ns
	);
	
	port( 
		ie, oe, clk, rst : in std_logic;
		buf_in : in std_logic_vector(ND downto 0);
		buf_out : out std_logic_vector(ND downto 0)
	);
		
		
end buf;

architecture arch of buf is
begin 
	 
	process (clk, ie, oe, rst)

	variable store : std_logic_vector (ND downto 0);
	begin
		if (rising_edge(clk)) then
			if rst='0' then
				store := (others=>'0');
		elsif ie='1' then
				store := buf_in;
			end if;
		elsif falling_edge(clk) then
			if oe='1' then
				buf_out <= store after delay;
			else
				buf_out <= (others=>'Z') after delay;
			end if;
		end if;
		
	end process;
end arch;