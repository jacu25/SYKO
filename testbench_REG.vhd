library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REG_tb is
	generic( 
		period : time := 30 ns
	);
end REG_tb;

architecture arch of REG_tb is
    signal reg_io, reg_out : std_logic_vector(7 downto 0);
	signal ie, oe, rst : std_logic;
	signal clk : std_logic := '0';
type state is (s0, s1, s2, s3, s4, s5);
--s0 start
--s1 praca
--s2 błąd
signal next_state: state;
signal present_state: state := s0; 

begin
	clk <= not clk after 0.5*period;
	
    REG : entity work.REG port map(ie => ie, oe => oe, clk => clk, reg_io => reg_io, reg_out => reg_out, rst => rst);

	clock: process (clk) is

		begin

		if falling_edge(clk) then
			present_state<=next_state;
		end if;
	end process;
	
	process(clk)
		begin
		
		case present_state is 
			when s0 =>
				if rising_edge(clk) then
					rst <= '1';
					oe <='0';
					ie <='0';
				else
					next_state <= s1;
				end if;
			when s1 =>
				if rising_edge(clk) then
					rst <= '1';
					reg_io <= std_logic_vector(to_signed(20,8));
					ie <='1';
				else
					next_state <= s2;
				end if;	
			when s2 =>
				if rising_edge(clk) then
					reg_io <= (others =>'Z');
				else
					next_state <= s3;
					ie <= '0';
				end if;
			when s3 =>
				if rising_edge(clk) then
					rst <= '1';
					ie <= '0';
					oe <= '1';
				else
					next_state <= s4;
				end if;	
			when s4 =>
				if rising_edge(clk) then
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