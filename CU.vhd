library ieee;
use ieee.std_logic_1164.all

entity CU is

	port (clk, RESET: in std_logic;
		ird_out : in std_logic_vector (3 downto 0);
		flags : in std_logic_vector (4 downto 0);
		
		--sygnały_bledow : out std_logic_vector (??downto 0);
		
		--sygnały sterujące:
		ie_ACC, ie_buf, ie_REG_1, ie_REG_2, ie_IMR, ie_IR : out std_logic;
		oe_ACC, oe_buf, oe_REG_1, oe_REG_2, oe_IMR, oe_IR : out std_logic;
		re, we, mw, mr, jump : out std_logic;
		jump_adr, start_adr, increment : out std_logic_vector (7 downto 0);
		cag : out std_logic_vector (2 downto 0);
		rst : out std_logic
		);
		
end entity CU;

architecture arch of CU is

type state is (s0, s1, s2);
--s0 start
--s1 praca
--s2 błąd
signal present_state, next_state: state;
signal re: bit; 
begin

-- ten process zmienia present_state na next_state przy zboczu narastającym oraz
-- ustawia re <= ‘1’ przy zboczu narastającym i re <=’0’ przy zboczu opadającym
clock: process (clk, RESET) is
begin
	if rising_edge(clk) and rst = ‘1’ then
	present_state <= s0;
	re<=’1’;
	elsif rising_edge(clk) then
	present_state <= next_state;
	re<=’1’;
	elsif falling_edge(clk) then
	re<=’0’;
	end if;
end process clock;

-- ten proces realizuje graf przejść
przejscia: process (present_state, sygnały_dekodera, znaczniki, re)
begin
-- zerowanie sygnałów wyjściowych
	sygnały_sterujące_blokami <= wartości odpowiadające brakowi działania układu;
	sygnały_bledu <= wartości odpowiadające brakowi błędu;
	
--graf przejść
	case present_state is
	
	when s0 =>
	if (re=’1’) then
		rst <= '0';
	else
		rst <= '1';
		next_state <= s1;
	end
	
	when s1 =>
		if (re = ’1’ and sygnały_dekodera = "0000") then
			-- obsługa LOAD	R1
		elsif (re = ’1’ and sygnały_dekodera = "0001") then
			-- obsługa LOAD	R2
		else
			next_state <= s2; --BŁĄD
		end if;
	
	when s2 =>
	--Program zatrzymany, błąd
		next_state <= s2;
	end case;
	
end process przejścia;


