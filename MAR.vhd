library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity MAR is
 
	generic(	
		ND : integer := 7;
		delay : time := 3 ns
	);
	
	port( 
		lae, clk, rst : in std_logic;
		mar_out : out std_logic_vector(ND downto 0) := (others => 'Z');
		mar_in : in std_logic_vector(ND downto 0)
	);
		
end MAR;

architecture arch of MAR is
begin 
	
	process (clk, rst, lae, mar_in)

	variable store : std_logic_vector (ND downto 0) := (others => '0');
	begin
		if rising_edge(clk) then
			if rst='0' then
				store := (others=>'0');
			elsif lae='1' then
				store := mar_in;
			end if;
		elsif falling_edge(clk) then
			mar_out <= store after delay;
		end if;
		
	end process;
end arch;