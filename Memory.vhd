library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  

entity Memory is

	generic(
		delay : time := 5 ns
	);
	port (
		mw, mr: in std_logic;
		data: inout std_logic_vector(7 downto 0) := (others =>'Z');
		address: in  std_logic_vector(7 downto 0) := (others =>'Z')
	);
end Memory;

architecture arch of Memory is

 type ROM_type is array (0 to 4 ) of std_logic_vector(7 downto 0);
  
begin
  
	process(mw, mr, address, data)
	
	 variable rom_data: ROM_type:=(
	"00000001",
	"00001010",
	"00001111",
	"00000000",
	"00000000"
  );
  
	begin
		if mw='1' then
			rom_data(to_integer(unsigned(address))) := data;
		elsif mr='1' then
			data <= rom_data(to_integer(unsigned(address))) after delay;
		else 
			data <= (others=>'Z') after delay;
		end if;
		
	end process;

end arch;