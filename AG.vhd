library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity AG is

	generic( 
		ND : integer := 7;
		delay : time := 3 ns
	);
	
	port( 
		cag : in std_logic_vector (2 downto 0) := (others =>'Z');
		imr : in std_logic_vector (ND downto 0) := (others =>'Z'); --IMR
		reg1 : in std_logic_vector (ND downto 0) := (others =>'Z'); --REG_1
		reg2 : in std_logic_vector (ND downto 0) := (others =>'Z'); --REG_2
		pc : in std_logic_vector (ND downto 0) := (others =>'Z'); --PC
		ag_out : out std_logic_vector (ND downto 0) := (others =>'Z')
	);
	
end AG;

architecture arch of AG is

begin

	with cag select
		ag_out  <=	imr 			after delay when "000",
					reg1			after delay when "001",
					reg2 			after delay when "010",
					pc 			after delay when "011",
					(others=>'Z') 	after delay when others;
end arch;


