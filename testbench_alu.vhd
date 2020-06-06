
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity alu_tb is
end alu_tb;

architecture behav of alu_tb is
    signal a, b, c : std_logic_vector(7 downto 0);
	signal flags : std_logic_vector(4 downto 0);


begin

    alu : entity work.alu port map(x => a, y => b, z => c, flags => flags);

    process
    begin
        -- initial values
        a <= std_logic_vector(to_signed(20,8));
        b <= std_logic_vector(to_signed(20,8));

        wait for 10 ns;
       
		a <= std_logic_vector(to_signed(-20,8));
        b <= std_logic_vector(to_signed(10,8));
		
        wait for 10 ns;
		
		a <= std_logic_vector(to_signed(120,8));
        b <= std_logic_vector(to_signed(20,8));
		
		wait for 10 ns;
		
		a <= std_logic_vector(to_signed(-20,8));
        b <= std_logic_vector(to_signed(20,8));
		
		wait for 10 ns;
		
		a <= std_logic_vector(to_signed(-20,8));
        b <= std_logic_vector(to_signed(21,8));
		
		wait for 10 ns;
		
		a <= std_logic_vector(to_signed(-120,8));
        b <= std_logic_vector(to_signed(-21,8));

        wait;
		
    end process;
end behav;