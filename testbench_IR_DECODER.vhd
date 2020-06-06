library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IRD_tb is
end IRD_tb;

architecture arch of IRD_tb is
    signal ird_in : std_logic_vector(7 downto 0);
    signal ird_out: std_logic_vector(4 downto 0);
begin

    IRD_dec : entity work.IR_DECODER port map(ird_in => ird_in, ird_out => ird_out);

    process
    begin
       

	   ird_in <= (others => 'Z');
       wait for 15 ns;
	   ird_in <= "10000001";
	   wait for 15 ns;
	   

	   ird_in <= "00011001";
	   wait for 15 ns;
	   ird_in <= "00000111";   
	   wait for 15 ns;
	   

	   ird_in <= "00011001";
	   wait for 15 ns;


	   ird_in <="00010111";
	   wait for 15 ns;

	   ird_in <= (others => 'Z');
	   wait for 15 ns;
       wait;
		
    end process;
end arch;