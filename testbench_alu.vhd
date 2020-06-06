
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity alu_tb is
end alu_tb;

architecture behav of alu_tb is
    signal x, y, z : std_logic_vector(7 downto 0);
	signal flags : std_logic_vector(4 downto 0);


begin

    alu : entity work.alu port map(x => x, y => y, z => z, flags => flags);

    process
    begin
        -- initial values
        x <= std_logic_vector(to_signed(20,8));
        y <= std_logic_vector(to_signed(20,8));

        wait for 10 ns;
       
		x <= std_logic_vector(to_signed(-20,8));
        y <= std_logic_vector(to_signed(10,8));
		
        wait for 10 ns;
		
		x <= std_logic_vector(to_signed(120,8));
        y <= std_logic_vector(to_signed(20,8));
		
		wait for 10 ns;
		
		x <= std_logic_vector(to_signed(-20,8));
        y <= std_logic_vector(to_signed(20,8));
		
		wait for 10 ns;
		
		x <= std_logic_vector(to_signed(-20,8));
        y <= std_logic_vector(to_signed(21,8));
		
		wait for 10 ns;
		
		x <= std_logic_vector(to_signed(-120,8));
        y <= std_logic_vector(to_signed(-21,8));

        wait;
		
    end process;
end behav;