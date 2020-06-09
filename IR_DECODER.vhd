library ieee;
use ieee.std_logic_1164.all;

entity IR_DECODER is

	generic(
		delay : time := 3 ns
	);
	port(
			ird_in : in std_logic_vector (7 downto 0) := (others =>'Z');
			ird_out :out std_logic_vector (4 downto 0) := (others =>'Z')
	);

end IR_DECODER;

architecture arch of IR_DECODER is	
begin

--WDOBYWAMY:
--	tryb adresowania	"------**" 
--	nr rejestry			"-----*--" R1-0, R2-1
--	instrukcja			"---**---" LOAD-00, ADD-01, JNOF-10

process(ird_in) is
begin

	if ird_in(7 downto 5) = "000" then
		if ird_in(4 downto 3)="11" then
			ird_out <= (others => '1') after delay;
		else 
			ird_out <= ird_in(1 downto 0)&ird_in(2)&ird_in(4 downto 3) after delay;
		end if;
	else
		ird_out <= (others => '1') after delay;
	end if;

end process;
end arch;