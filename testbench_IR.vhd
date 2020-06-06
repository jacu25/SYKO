library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IR_tb is
	generic( 
		period : time := 30 ns
	);
end IR_tb;

architecture arch of IR_tb is
    signal ir_out, ir_in : std_logic_vector(7 downto 0);
	signal ie, rst : std_logic;
	signal clk : std_logic := '0';
type state is (s0, s1, s2, s3, s4, s5);

signal next_state: state;
signal present_state: state := s0; 
signal r_e : std_logic;
begin
	clk <= not clk after 0.5*period;
	
    IR : entity work.IR port map(ie => ie, clk => clk, ir_in => ir_in, ir_out => ir_out, rst => rst);

	clock: process (clk) is

		begin
			if rising_edge(clk) then
				r_e<= '1';
				present_state<=next_state;
			elsif falling_edge(clk) then
				r_e<= '0';
			end if;
	end process;
	
	process(clk, ie, rst)
		begin
		
		case present_state is 
			when s0 =>
				if r_e = '1' then

				else
					next_state <= s1;
					rst <= '1';
					ie <='0';
				end if;
			when s1 =>
				if r_e = '1' then
					ie <='1';
					ir_in <= std_logic_vector(to_signed(20,8));
				else
					next_state <= s2;
				end if;	
			when s2 =>
				if r_e = '1' then
					ie <='0';
					ir_in <= (others =>'Z');
				else
					next_state <= s3;
				end if;
			when s3 =>
				if r_e = '1' then
					ie <= '0';
				else
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