library ieee;
use ieee.std_logic_1164.all;

entity IR_DECODER is

	generic(	
				delay : time := 1 ns
	);
	
	port (
		ir_in : in std_logic_vector (7 downto 0);
		ir_out : out std_logic_vector (4 downto 0)
	);
		
end IR_DECODER;

architecture bech of IR_DECODER is
begin

	with ir_in select
	ir_out <= "00001"  when (“00-11000”)
				 else "00010"  when (“00-11100")
				 else "00011"  when (“00-11001")
				 else "00100"  when (“00-11101")
				 else "00101"  when (“00-11-10")
				 else "00110"  when (“00-11-11")
				 else "00111"  when (“01-11000")
				 else "01000"  when (“01-11100")
				 else "01001"  when (“01-11001")
				 else "01010"  when (“01-11101")
				 else "01011"  when (“01-11-10")
				 else "01100"  when (“01-11-11")
				 else "01101"  when (“10-11000")
				 else "01110"  when (“10-11100")
				 else "01111"  when (“10-11-11”)
				 else "00000";
				 
				--ADD MORE
end bech;