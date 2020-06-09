library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REG_tb is
	generic( 
		period : time := 30 ns
	);
end REG_tb;

architecture arch of REG_tb is
    signal reg_io : std_logic_vector(7 downto 0) := (others => 'Z');
	signal reg_out : std_logic_vector(7 downto 0) := (others => 'Z');
	signal ie, oe : std_logic;
	signal rst : std_logic := '1';
	signal clk : std_logic := '0';
type state is (s0, s1, s2, s3, s4, s5);

signal next_state: state;
signal present_state: state := s0; 
signal r_e : std_logic;
begin

	clk <= not clk after 0.5*period;
	
    REG : entity work.REG port map(ie => ie, oe => oe, clk => clk, reg_io => reg_io, reg_out => reg_out, rst => rst);

	clock: process (clk) is

		begin
			if rising_edge(clk) then
				r_e<= '1';
				present_state<=next_state;
			elsif falling_edge(clk) then
				r_e<= '0';
			end if;
	end process;
	
	process(r_e, ie, oe ,rst)
		begin
		
		case present_state is 
			when s0 =>
				if r_e = '1' then
					rst <= '1';
					oe <='0';
					ie <='0';
				else
					next_state <= s1;

				end if;
			when s1 =>
				if r_e = '1' then
					ie <='1';
					reg_io <= std_logic_vector(to_signed(20,8));
				else
					next_state <= s2;
				end if;	
			when s2 =>
				if r_e = '1' then
					ie <='0';
					reg_io <= (others =>'Z');
				else
					oe <= '1';
					next_state <= s3;
				end if;
			when s3 =>
				if r_e = '1' then
					ie <= '0';
				else
					oe <= '0';
					next_state <= s4;
				end if;	
			when s4 =>
				if r_e = '1' then
					rst <= '0';
				else
					rst <= '1';
					next_state <= s5;
				end if;	
			when s5 =>
					next_state <= s5;
		end case;
    end process;
end arch;