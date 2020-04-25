ibrary IEEE;
use IEEE.STD_LOGIC_1164.all;

entity IR is
 
	generic(
		DELAY : time );
	
	port( 
		ie, oe, clk, rst : in std_logic;
		ir_in :in std_logic_vector(7 downto 0);
		ir_out : out std_logic_vector(7 downto 0));
end