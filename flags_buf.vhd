library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity flags_buf is
 
	generic(
		ND : integer := 4;
		delay : time := 3 ns
	);
	
	port( 
		ie, rst : in std_logic;
		flags_in : in std_logic_vector(4 downto 0) := (others => 'Z');
		flags_out : out std_logic_vector(4 downto 0) := (others => 'Z')
	);
		
		
end flags_buf;

architecture arch of flags_buf is
begin 
	
	process (ie, rst)

	variable store : std_logic_vector (ND downto 0) := (others => 'Z');
	begin
		if rst=0 then
			store := (others => '0');
		elsif ie=1	then
			store := flags_in;
		end if;
			flags_out <= store after delay;
	end process;

end arch;