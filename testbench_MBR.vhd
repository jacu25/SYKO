library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MBR_tb is
	generic( 
		period : time := 30 ns
	);
end MBR_tb;

architecture arch of MBR_tb is
    signal mbr_mem, mbr_data, storex: std_logic_vector(7 downto 0) := (others =>'Z');
	signal we, re : std_logic := '0';
	signal rst : std_logic := '1';
	signal clk : std_logic := '0';


begin
	clk <= not clk after 0.5*period;
	
    MBR : entity work.MBR port map(storex => storex ,we => we, re => re, clk => clk, mbr_data => mbr_data, mbr_mem => mbr_mem, rst => rst);
	process is
	begin
		wait for 15 ns;
		mbr_mem <= std_logic_vector(to_signed(20,8));
		re <= '1';
		wait for 30 ns;
		mbr_mem <= (others => 'Z');
	wait for 30 ns;
	wait;
    end process;
end arch;