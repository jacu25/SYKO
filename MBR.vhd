library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity MBR is
 
	generic(	ND : integer := 7;
				delay : time := 1 ns
	);
	
	port( 
		re, we, clk, rst : in std_logic;
		mem_mbr : inout std_logic_vector(ND downto 0);
		mbr_data : inout std_logic_vector(ND downto 0)
	);
		
end MBR;

architecture arch of REG_1 is
begin 
	
	process (clk, re, we, rst)

	variable store : std_logic_vector (7 downto 0);
	begin
		if (rising_edge(clk)) then
			if rst='0' then
				store := (other=>'0');
		elsif ie='1' then
				store := mem_mbr;
			elsif we='1' then
				store := mbr_data;
			end if;
			
		elsif falling_edge(clk) then
			if (re='1') then
				mbr_data <= store after delay;
			elsif (we='1') then
				mem_mbr <= store after delay;
			else
				mbr_data <= (other=>'Z') after delay;
			end if;
		end if;
		
	end process;
end arch;
			