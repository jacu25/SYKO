library ieee;
use ieee.std_logic_1164.all

entity IR_DECODE is

	port (
		ir_in : out std_logic_vector (7 downto 0);
		ir_out : out std_logic_vector (3 downto 0);
	);
		
end entity IR_DECODE;

architecture arch of IR_DECODE is
begin
	process(ir_in)
	begin

	with ir_in select
	ir_out 	<=	"0001" after delay when  “00-11000”,
				"0010" after delay when  “00-11100”,
				"0011" after delay when  “00-11001”,
				"0100" after delay when  “00-11101”,
				"0101" after delay when  “00-11-10”,
				"0110" after delay when  “00-11-11”,
				"0111" after delay when  “01-11000”,
				"1000" after delay when  “01-11100”,
				"1001" after delay when  “01-11001”,
				"1010" after delay when  “01-11101”,
				"1011" after delay when  “01-11-10”,
				"1100" after delay when  “01-11-11”,
				"1101" after delay when  “10-11000”,
				"1110" after delay when  “10-11100”,
				"1111" after delay when  “10-11-11”,
				"0000" after delay when others;
			
	end process;
end arch;