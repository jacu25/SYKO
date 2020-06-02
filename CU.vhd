library ieee;
use ieee.std_logic_1164.all;

entity CU is

	port (clk, RESET: in std_logic; 		--RESET CU-rde
		ird_out : in std_logic_vector (4 downto 0);
		flags : in std_logic_vector (4 downto 0);
		
		--sygnały_bledow : out std_logic_vector (??downto 0);
		
		--sygnały sterujące:
		ie_ACC, ie_buf, ie_REG_1, ie_REG_2, ie_IMR, ie_IR : out std_logic;
		oe_ACC, oe_buf, oe_REG_1, oe_REG_2, oe_IMR, oe_IR : out std_logic;
		re_MBR, we_MBR, mw, mr, jump, incr, lae : out std_logic;
		jump_adr, start_adr, increment : out std_logic_vector (7 downto 0);
		cag : out std_logic_vector (2 downto 0);
		rst : out std_logic
		);
		
end entity;

architecture arch of CU is

type state is (s0, s1, s2, s3, s4, s5);
--s0 start
--s1 praca
--s2 błąd
signal present_state, next_state: state;
signal r_e: std_logic; 
begin

-- ten process zmienia present_state na next_state przy zboczu narastającym oraz
-- ustawia r_e <= ‘1’ przy zboczu narastającym i re <=’0’ przy zboczu opadającym
clock: process (clk, RESET) is
begin
	if (rising_edge(clk) and (RESET = ‘1’)) then
		present_state <= s0;
		r_e<=’1’;
	elsif (rising_edge(clk)) then
		present_state <= next_state;
		r_e<=’1’;
	elsif (falling_edge(clk)) then
		r_e<=’0’;
	end if;
end process clock;

-- ten proces realizuje graf przejść
przejscia: process (present_state, ird_out, flags, r_e) is
begin
-- zerowanie sygnałów wyjściowych

	oe_ACC <= ‘0’;
	ie_ACC <= ‘0’;
	ie_buf <= ‘0’;
	oe_buf <= ‘0’;
	ie_REG_1 <= ‘0’;
	oe_REG_1 <= ‘0’;
	ie_REG_2 <= ‘0’;
	oe_REG_2 <= ‘0’;
	ie_IR <= ‘0’;
	oe_IR <= ‘0’;
	ie_IMR <= ‘0’
	oe_IMR <= ‘0’;
	re_MBR <= ‘0’;
	we_MBR <= ‘0’;
	mr <= ‘0’;
	mw <= ‘0’;
	lae <= ‘0’;
	jump <= ‘1’;
	incr <= ‘0’;

--sygnały_bledu <= wartości odpowiadające brakowi błędu;
--graf przejść
	case present_state is
	
	when s0 =>
	if r_e=’1’ then
		start_adr <= “00000001”; 	--first instruction
		rst <= '0'; 			--wpisanie start adr
		cag <= “011”;			 --PC address
	else --POBRANIE 1 INSTRUKCJ
		rst <= '1';
		next_state <= s1;
	end if;

	when s1 =>
		if r_e=’1’ then
			lae<= ‘1’;
		else
			next_state<= s2;
		end if;

	when s2 =>
		if r_e=’1’ then
			mr <= ‘1’;
			re_MBR <= ’1’;
		else
			re_MBR<=’1’;
			next_state<= s3;
		end if;
	when s3 =>
		if r_e=’1’ then
			ie_IR<=’1’;
		else
			next_state<=s4;
		end if;
	when s4 =>
		next_state <=s5;
	when s5 =>
	--Program zatrzymany, błąd
		next_state <= s5;
	end case;
	
end process przejscia;

end architecture arch;



