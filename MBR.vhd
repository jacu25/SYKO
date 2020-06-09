library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity MBR is
 
	generic(
		delay : time := 3 ns
	);
	
	port( 
		re, we, clk, rst : in std_logic;
		mbr_mem : inout std_logic_vector(7 downto 0):= (others =>'Z');
		mbr_data : inout std_logic_vector(7 downto 0) := (others =>'Z')
	);
		
end MBR;

architecture arch of MBR is

signal r_e : std_logic := '0';
begin 

	clock: process (clk) is

		begin
			if rising_edge(clk) then
				r_e<= '1';
			elsif falling_edge(clk) then
				r_e<= '0';
			end if;
	end process;
	
	
	process (r_e, re, we, rst, mbr_mem, mbr_data)

	variable store : std_logic_vector (7 downto 0):= (others => 'Z');
	begin
		if r_e='1' then
			if rst='0' then
				store := (others=>'0');
			elsif re='1' then
				store := mbr_mem;
			elsif we='1' then
				store := mbr_data;
			end if;
			
		elsif r_e = '0' then
			if re='1' then
				mbr_data <= store after delay;
			elsif we='1' then
				mbr_mem <= store after delay;
			else
				mbr_data <= (others=>'Z') after delay;
			end if;
		end if;	
	end process;

end arch;