library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity MAR is
 
	generic(	
		ND : integer := 7;
		delay : time := 3 ns
	);
	
	port( 
		lae, clk, rst : in std_logic;
		mar_out, storex: out std_logic_vector(ND downto 0) := (others => 'Z');
		mar_in : in std_logic_vector(ND downto 0) := (others => 'Z')
	);
	signal store : std_logic_vector (ND downto 0) := (others => 'Z');		
end MAR;

architecture arch of MAR is
signal r_e : std_logic := '0';
begin 

	clock: process (clk) is

		begin
			if rising_edge(clk) then
				r_e <= '1';
			elsif falling_edge(clk) then
				r_e <= '0';
			end if;
	end process;
	
	process (r_e, rst, lae, mar_in)
	begin
		if r_e='1' then
			if rst='0' then
				store <= (others=>'0');
			elsif lae='1' then
				store <= mar_in;
			end if;
		elsif r_e='0' then
			mar_out <= store after delay;
		end if;
		storex <= store;
	end process;
end arch;