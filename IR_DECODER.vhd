library ieee;
use ieee.std_logic_1164.all;

entity IR_DECODER is

	generic(
		delay : time := 1 ns
	);
	port(
			ir_in : in std_logic_vector (7 downto 0);
			ir_out :out std_logic_vector (4 downto 0)
	);

end IR_DECODER;

architecture arch of IR_DECODER is	
begin

	with ir_in select ir_out <= 
		"00001" when "00-11000",
		"00010" when "00-11100",
		"00011" when "00-11001",
		"00100" when "00-11101",
		"00101" when "00-11-10",
		"00110" when "00-11-11",
		"00111" when "01-11000",
		"01000" when "01-11100",
		"01001" when "01-11001",
		"01010" when "01-11101",
		"01011" when "01-11-10",
		"01100" when "01-11-11",
		"01101" when "10-11000",
		"01110" when "10-11100",
		"01111" when "10-11-11",
		(others => '0') when others;
		
end arch;