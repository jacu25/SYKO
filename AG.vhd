library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity AG is

	generic( 
		ND : integer := 7;
		delay : time := 1 ns
	);
	
	port( 
		cag : in std_logic_vector (2 downto 0);
		imr_ag : in std_logic_vector (ND downto 0);
		r1_ag : in std_logic_vector (ND downto 0);
		r2_ag : in std_logic_vector (ND downto 0);
		pc_ag : in std_logic_vector (ND downto 0);
		ag_out : out std_logic_vector (ND downto 0)
	);
	
end AG;

architecture arch of AG is

begin

	with cag select
		ag_out  <=	imr_ag 			after delay when "000",
					r1_ag 			after delay when "001",
					r2_ag 			after delay when "010",
					pc_ag 			after delay when "011",
					(others=>'Z') 	after delay when others;
end arch;