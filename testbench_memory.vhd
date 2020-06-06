library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_tb is
end memory_tb;

architecture arch of memory_tb is
    signal data, address : std_logic_vector(7 downto 0);
	signal mw, mr : std_logic;
	
begin

    Memory : entity work.Memory port map(mw => mw, mr => mr, data => data, address => address);

    process
    begin
       
	   -- Badanie stanu domyślnego
	   mw <= '0';
	   mr <= '0';
       wait for 10 ns;
       
	   -- Odczyt spod adresu 0
	   address <= std_logic_vector(to_unsigned(0,8));
	   mr <= '1';
	   wait for 10 ns;
	   
	   -- Odczyt spod adresu 1
	   address <= std_logic_vector(to_unsigned(1,8));
	   mr <= '1';
	   wait for 10 ns;
	   
	   -- Zapis do adresu 1
	   address <= std_logic_vector(to_unsigned(1,8));
	   mw <= '1';
	   wait for 10 ns;
	   
	   -- Odczyt spod adresu 1
	   mw <= '0';
	   address <= std_logic_vector(to_unsigned(1,8));
	   mr <= '1';
	   wait for 10 ns;
	   
	   -- Testowanie zwolnievnia linii danych
	   address <= std_logic_vector(to_unsigned(1,8));
	   mr <= '0';
	   wait for 10 ns;
       wait;
		
    end process;
end arch;