library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ag_tb is
end ag_tb;

architecture arch of alu_tb is

	signal cag : std_logic_vector(2 downto 0);
	signal we_0, we_1, we_2, we_3 : std_logic_vector(7 downto 0);
	signal ag_out: std_logic_vector(7 downto 0);

begin

    ag : entity work.AG port map(cag => cag, we_0 => we_0, we_1 => we_1, we_2 => we_2, we_3 => we_3, ag_out=>ag_out);

    process
    begin
	
		we_0 <= std_logic_vector(to_signed(1,8));
		we_1 <= std_logic_vector(to_signed(2,8));
		we_2 <= std_logic_vector(to_signed(3,8));
		we_3 <= std_logic_vector(to_signed(4,8));
		
        -- Wyj 0
		cag <= "000";

        wait for 10 ns;
       
		-- Wyj 1
		cag <= "001";
		
        wait for 10 ns;
		
		-- Wyj 2
		cag <= "010";
		
		wait for 10 ns;
		
		-- Wyj 3
		cag <= "011";
		
		wait for 10 ns;
		
		-- Stan HIZ
		cag <= "100";

        wait;
		
    end process;
end arch;