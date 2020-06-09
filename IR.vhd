library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity IR is
 
	generic(	
		ND : integer := 7;
		delay : time := 3 ns
	);

	port( 
		ie, clk, rst : in std_logic;
		ir_in :in std_logic_vector(ND downto 0) := (others =>'Z');
		ir_out : out std_logic_vector(ND downto 0) := (others =>'Z')
	);
		
end IR;

architecture arch of IR is
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
	
	
	process (r_e, ie, rst)

	variable store : std_logic_vector (ND downto 0) := (others =>'Z');
	begin
		if r_e = '1' then
			if rst='0' then
				store := (others=>'0');
			elsif ie='1' then
				store := ir_in;
			end if;
		elsif r_e ='0' then
			ir_out <= store after delay;
		end if;
	end process;
end arch;
