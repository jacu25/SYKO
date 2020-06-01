library ieee;
use ieee.std_logic_1164.all;

entity IR_DECODER is

	generic(	
				delay : time := 1 ns
	);
	
	port (
		ir_in : out std_logic_vector (7 downto 0);
		ir_out : out std_logic_vector (4 downto 0)
	);
		
end entity IR_DECODER;

architecture arch of IR_DECODER is
begin
	process(ir_in)
	begin

	with ir_in select ir_out 	<=	
				"00001" after delay when  “00-11000”,
				"00010" after delay when  “00-11100”,
				"00011" after delay when  “00-11001”,
				"00100" after delay when  “00-11101”,
				"00101" after delay when  “00-11-10”,
				"00110" after delay when  “00-11-11”,
				"00111" after delay when  “01-11000”,
				"01000" after delay when  “01-11100”,
				"01001" after delay when  “01-11001”,
				"01010" after delay when  “01-11101”,
				"01011" after delay when  “01-11-10”,
				"01100" after delay when  “01-11-11”,
				"01101" after delay when  “10-11000”,
				"01110" after delay when  “10-11100”,
				"01111" after delay when  “10-11-11”,
				"00000" after delay when others;
				--ADD MORE
	end process;
end arch;