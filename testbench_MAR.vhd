library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MAR_tb is
	generic( 
		period : time := 30 ns
	);
end MAR_tb;

architecture arch of MAR_tb is
    signal mar_out : std_logic_vector(7 downto 0) := (others => 'Z'); 
	signal mar_in : std_logic_vector(7 downto 0) := (others => 'Z');
	
	signal lae, rst : std_logic := '0';
	signal clk : std_logic := '0';
	
type state is (s0, s1, s2, s3, s4, s5);

signal next_state: state;
signal present_state: state := s0; 
signal r_e : std_logic := '0';


begin
	clk <= not clk after 0.5*period;
	
    MAR : entity work.MAR port map(clk => clk, rst => rst, lae => lae, mar_out => mar_out, mar_in => mar_in);
	
	clock: process (clk) is
		begin
			if rising_edge(clk) then
				r_e<= '1';
				present_state<=next_state;
			elsif falling_edge(clk) then
				r_e<= '0';
			end if;
	end process;
	
	process(r_e, rst, mar_out, mar_in, lae)
		begin
		
		case present_state is 
			when s0 =>
				if r_e = '1' then
					rst <= '0';
					lae <= '0';
				else
					next_state <= s1;
				end if;
			when s1 =>
				if r_e = '1' then
					rst <= '1';
					lae <= '1';
					mar_in <= std_logic_vector(to_signed(10,8));
				else
					next_state <= s2;
				end if;	
			when s2 =>
				if r_e = '1' then
					lae <= '0';
					mar_in <= std_logic_vector(to_signed(10,8));
				else
					next_state <= s3;
				end if;
			when s3 =>
				if r_e = '1' then
					lae <= '1';
					mar_in <= std_logic_vector(to_signed(10,8));
				else
					next_state <= s4;
				end if;	
			when s4 =>
				if r_e = '1' then
					lae <= '0';
					mar_in <= std_logic_vector(to_signed(10,8));
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