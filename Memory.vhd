library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  

entity Memory is

	generic(	ND : integer := 7;
				delay : time := 1 ns
	);
	port (
		mw, mr: in std_logic;
		mem_mbr: inout std_logic_vector(7 downto 0);
		mar_mem: in  std_logic_vector(7 downto 0)
	);
end Memory;

architecture arch of Memory is

 type ROM_type is array (0 to 4 ) of std_logic_vector(7 downto 0);
  
begin
  
	process(mw, mr)
	
	 variable rom_data: ROM_type:=(
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000"
  );
  
	begin
		if mw='1' then
				rom_data(to_integer(unsigned(mar_mem))) := mem_mbr; --AFTER DELAY
		elsif mr='1' then
			mem_mbr <= rom_data(to_integer(unsigned(mar_mem))) after delay;
		else 
			mem_mbr <= (others=>'Z') after delay;
		end if;
		
	end process;

end arch;