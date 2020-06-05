library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity AG is

	generic( 
		ND : integer := 7;
		delay : time := 1 ns
	);
	
	port( 
		cag : in std_logic_vector (2 downto 0);
		we_0 : in std_logic_vector (ND downto 0);
		we_1 : in std_logic_vector (ND downto 0);
		we_2 : in std_logic_vector (ND downto 0);
		we_3 : in std_logic_vector (ND downto 0);
		ag_out : out std_logic_vector (ND downto 0)
	);
	
end AG;

architecture arch of AG is

begin

	with cag select
		ag_out  <=	we_0 			after delay when "000",
					we_1			after delay when "001",
					we_2 			after delay when "010",
					we_3 			after delay when "011",
					(others=>'Z') 	after delay when others;
end arch;


