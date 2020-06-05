library ieee;
use ieee.std_logic_1164.all;

entity IR_DECODER is

	generic(
		delay : time := 1 ns
	);
	port(
			ird_in : in std_logic_vector (7 downto 0);
			ird_out :out std_logic_vector (4 downto 0)
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

	if ird_in(4 downto 3)="11" or (not ird_in(7 downto 6)="000") then
		ird_out <= (others => '1');	--ERROR
	else
		ird_out <= ird_in(1 downto 0)&ird_in(3)&ird_in(4 downto 3);
	end if;
	
end process;
end arch;