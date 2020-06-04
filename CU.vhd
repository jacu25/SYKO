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

type state is (s0, s1, s2, s3, s4, s5, s6);
--s0 start
--s1 praca
--s2 błąd
signal next_state: state;
signal present_state: state; 
signal r_e: std_logic := '0'; 

begin

-- ten process zmienia present_state na next_state przy zboczu narastającym oraz
-- ustawia r_e <= ‘1’ przy zboczu narastającym i re <=’0’ przy zboczu opadającym

clock: process (clk, RESET) is

begin

	if rising_edge(clk) and RESET='1' then
		r_e<= '1';
		present_state<=s0;
	elsif rising_edge(clk) then
		r_e<= '1';
	elsif falling_edge(clk) then
		present_state<=next_state;
		r_e<= '0';
	end if;
	
end process;

-- ten proces realizuje graf przejść
przejscia :process(present_state, ird_out, flags, r_e)
begin

	--oe_ACC <='0';
	--ie_ACC <='0';
	--ie_REG_1 <= '0';
	--oe_REG_1 <= '0';
	--ie_REG_2 <= '0';
	--oe_REG_2 <= '0';
	--ie_IR <= '0';
	--oe_IR <= '0';
	--ie_IMR <= '0';
	--oe_IMR <= '0';
	--re_MBR <= '0';
	--we_MBR <= '0';
	--mr <= '0';
	--mw <= '0';
	--lae <= '0';
	--jump <= '0';
	--incr <= '0';

--sygnały_bledu <= wartości odpowiadające brakowi błędu;
--graf przejść
	case present_state is
	
	when s0 =>
	if r_e = '1' then
		start_adr <= "00000001"; 	--first instruction
		rst <= '0'; 			--wpisanie start adr
		cag <= "011";
		oe_ACC <='0';
		ie_ACC <='0';
		ie_REG_1 <= '0';
		oe_REG_1 <= '0';
		ie_REG_2 <= '0';
		oe_REG_2 <= '0';
		ie_IR <= '0';
		oe_IR <= '0';
		ie_IMR <= '0';
		oe_IMR <= '0';
		re_MBR <= '0';
		we_MBR <= '0';
		mr <= '0';
		mw <= '0';
		lae <= '0';
		jump <= '0';
		incr <= '0';	--PC address
	else --POBRANIE 1 INSTRUKCJ
		rst <= '1';
		next_state <= s1;
	end if;

	when s1 => --
		if r_e = '1' then
			cag <= "011";
			lae<= '1'; 
			ie_ACC <='0';
			oe_REG_1 <= '0';
			oe_REG_2 <= '0';
			oe_IMR <= '0';
			oe_IR <= '0';
		else
			next_state<= s2;
		end if;

	when s2 => --odczyt z pamięci
		if r_e = '1' then
			mr <= '1';
			re_MBR <= '1';
		else
			re_MBR<= '1';
			lae <= '0';
			next_state<= s3;
		end if;
	when s3 => --zapis do rejestru instrukcji
		if r_e = '1' then		
			increment <= "00000001";
			ie_IR<= '1';
		else			
			oe_IR <= '1';
			re_MBR <='0';
			incr <= '1';
			next_state <= s4;
		end if;
			
	when s4 =>
		if r_e then
			case ird_out is
				when "00001" => ie_ACC <= '1';		--LOAD R1
				when "00010" => ie_ACC <= '1';		--LOAD R2
				when "00011" => cag <= "001";  		--LOAD [R1]
								lae<= '1'; 
				when "00100" => cag <= "010";		--LOAD [R2]
								lae<= '1'; 
				when "00101" =>
				when "00111" =>
				when "01000" =>
			end case;
		else 
			case ird_out is
				when "00001" => oe_REG_1 <= '1';	--LOAD R1
								next_state <= s1;
				when "00010" => oe_REG_2 <= '1'; 	--LOAD R2
								next_state <= s1;
				when "00011" =>	oe_REG_1 <= '1';	--LOAD [R1]
								next_state <= s5;
				when "00100" => oe_REG_2 <= '1';	--LOAD [R2]
								next_state <= s5;
				when "00101" =>
				when "00111" =>
				when "01000" =>
			end case;
		end if;
		next_state <= s5;
	
	when s5 => 	--odczyt z pamięci
		if r_e then			
			mr <= '1';
			re_MBR <= '1';
		else
			re_MBR<= '1';
			lae <= '0';
			next_state<= s6;
		end if;
	when s6 => 	--zapis danych do Acc
		if r_e then			
			ie_ACC <= '1';
		else
			next_state<= s1;
		end if;
				
	end case;
	
end process;

end arch;



