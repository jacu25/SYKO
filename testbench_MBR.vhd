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
type state is (s0, s1, s2, s3, s4, s5);

signal next_state: state;
signal present_state: state := s0; 
signal r_e : std_logic := '0';
begin
	clk <= not clk after 0.5*period;
	
    MBR : entity work.MBR port map(storex => storex ,we => we, re => re, clk => clk, mbr_data => mbr_data, mbr_mem => mbr_mem, rst => rst);

	clock: process (clk) is

		begin
			if rising_edge(clk) then
				r_e<= '1';
				present_state<=next_state;
			elsif falling_edge(clk) then
				r_e<= '0';
			end if;
	end process;
	
	process(r_e, we, re ,rst, mbr_mem, mbr_data)
		begin
		
		case present_state is 
			when s0 =>
				if r_e = '1' then
					rst <= '1';
					re <='0';
					we <='0';
					
				else
					next_state <= s1;

				end if;
				mbr_mem <= std_logic_vector(to_signed(20,8));

			when s1 =>
				if r_e = '1' then
					re <='1';
					
				else
					next_state <= s2;
				end if;	
			when s2 =>
				if r_e = '1' then

					mbr_mem <= (others =>'Z');
				else
					we <= '0';
					next_state <= s3;
				end if;
			when s3 =>
				if r_e = '1' then
					we <= '0';
					re <='0';
				else
					re <= '0';
					next_state <= s4;
				end if;	
			when s4 =>
				if r_e = '1' then
					rst <= '0';
				else
					next_state <= s5;
				end if;	
			when s5 =>
				if falling_edge(clk) then
					next_state <= s5;
				end if;	
		end case;
    end process;
end arch;