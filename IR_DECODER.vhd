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

--WDOBYWAMY:
--	tryb adresowania	"------**" 
--	nr rejestry			"-----*--" R1-0, R2-1
--	instrukcja			"**------" LOAD-00, ADD-01, JNOF-10
process(ir_in) is
begin
	if ir_in(7 downto 6)="11" then
		ir_out <= (others => '1');	--ERROR
	else
		ir_out <= ir_in(1 downto 0)&ir_in(3)&ir_in(7 downto 6);
	end if;
end process;
end arch;