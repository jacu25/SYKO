library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_tb is
	generic( 
		period : time := 30 ns
	);
end PC_tb;

architecture arch of PC_tb is
    signal pc_out : std_logic_vector(7 downto 0) := (others => 'Z');
	signal start_adr : std_logic_vector(7 downto 0) := (others => '0');
	signal increment : std_logic_vector(7 downto 0) := std_logic_vector(to_signed(1,8));
	signal jump_adr : std_logic_vector(7 downto 0) := (others => 'Z');
	signal rst : std_logic := '0';
	signal clk,incr,jump : std_logic := '0';
type state is (s0, s1, s2, s3, s4, s5, s6);

signal next_state: state;
signal present_state: state := s0; 
signal r_e : std_logic;
begin
	clk <= not clk after 0.5*period;
	
    PC : entity work.PC port map(incr => incr, jump => jump, clk => clk, increment => increment, jump_adr => jump_adr, start_adr => start_adr, pc_out => pc_out, rst => rst);

	clock: process (clk) is

		begin
			if rising_edge(clk) then
				r_e<= '1';
				present_state<=next_state;
			elsif falling_edge(clk) then
				r_e<= '0';
			end if;
	end process;
	
	process(r_e, rst, incr, start_adr, jump)
		begin
		
		case present_state is 
			when s0 =>
				if r_e = '1' then
					rst <= '0';

				else
					next_state <= s1;

				end if;
			when s1 =>
				if r_e = '1' then
					rst <= '1';

				else
					incr <= '1';
					next_state <= s2;
				end if;	
			when s2 =>
				if r_e = '1' then
					incr <= '0';
				else
					next_state <= s3;
				end if;
			when s3 =>
				if r_e = '1' then
				else			
					jump_adr <= std_logic_vector(to_unsigned(8,8));
					jump <= '1';
					next_state <= s4;
				end if;	
			when s4 =>
				if r_e = '1' then
					jump <= '0';
					jump_adr <= (others => 'Z');
				else
					next_state <= s5;
				end if;	
			when s5 =>
				if r_e = '1' then
					jump <= '0';
					rst <= '0';
				else
					next_state <= s6;
				end if;	
			when s6 =>
				if falling_edge(clk) then
					next_state <= s6;
				end if;	
		end case;
    end process;
end arch;