library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is
end alu_tb;

architecture arch of alu_tb is
    signal x, y, z : std_logic_vector(7 downto 0);
	signal flags : std_logic_vector(4 downto 0);

begin

    ALU : entity work.ALU port map(x => x, y => y, z => z, flags => flags);

    process
    begin
	
        -- Krok 1
        x <= std_logic_vector(to_signed(20,8));
        y <= std_logic_vector(to_signed(20,8));

        wait for 10 ns;
       
	   -- Krok 2
		x <= std_logic_vector(to_signed(-20,8));
        y <= std_logic_vector(to_signed(10,8));
		
        wait for 10 ns;
		
		-- Krok 3
		x <= std_logic_vector(to_signed(120,8));
        y <= std_logic_vector(to_signed(20,8));
		
		wait for 10 ns;
		
		-- Krok 4
		x <= std_logic_vector(to_signed(-20,8));
        y <= std_logic_vector(to_signed(20,8));
		
		wait for 10 ns;
		
		-- Krok 5
		x <= std_logic_vector(to_signed(-20,8));
        y <= std_logic_vector(to_signed(21,8));
		
		wait for 10 ns;
		
		-- Krok 6
		x <= std_logic_vector(to_signed(-120,8));
        y <= std_logic_vector(to_signed(-21,8));

        wait;
		
    end process;
end arch;