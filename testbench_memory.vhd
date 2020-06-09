library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_tb is
end memory_tb;

architecture arch of memory_tb is
    signal data, address : std_logic_vector(7 downto 0) := (others =>'Z');
	signal mw, mr : std_logic := '0';

begin

    Memory : entity work.Memory port map(mw => mw, mr => mr, data => data, address => address);

    process
    begin
       
	   -- Badanie stanu domyślnego
	   mw <= '0';
	   mr <= '0';
	   data <= (others => 'Z');
       wait for 15 ns;
       
	   -- Odczyt spod adresu 1
	   address <= std_logic_vector(to_unsigned(0,8));
	   mr <= '1';
	   wait for 15 ns;
	   
	   -- Odczyt spod adresu 2
	   address <= std_logic_vector(to_unsigned(2,8));
	   wait for 15 ns;
	   
	   mr <= '0';
	   wait for 5 ns;
	   
	   -- Zapis do adresu 2 liczby 20
	   mw <= '1';
	   address <= std_logic_vector(to_unsigned(1,8));
	   data <= std_logic_vector(to_unsigned(20,8));
	   wait for 15 ns;
	   
	   -- Odczyt spod adresu 2
	   mr <= '1';
	   address <= std_logic_vector(to_unsigned(1,8));
	   data <= (others => 'Z');
	   mw <= '0';
	   wait for 15 ns;
	   
	   -- Testowanie zwolnievnia linii danych
	   mr <= '0';
	   wait for 15 ns;
       wait;
		
    end process;
end arch;