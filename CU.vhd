library ieee;
use ieee.std_logic_1164.all;

entity CU is
		--type state is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, ERROR);

	port (clk, RESET: in std_logic := '0'; 		--RESET CU
		ird : in std_logic_vector (4 downto 0) := (others =>'Z');
		flags : in std_logic_vector (4 downto 0) := (others =>'Z');

		--sygnały sterujące:
		ie_ACC, ie_buf, ie_REG_1, ie_REG_2, ie_IMR, ie_IR, ie_flags : out std_logic := '0';
		oe_ACC, oe_buf, oe_REG_1, oe_REG_2, oe_IMR : out std_logic := '0';
		re_MBR, we_MBR, mw, mr, jump, incr, lae : out std_logic := '0';
		start_adr, increment : out std_logic_vector (7 downto 0) := (others =>'Z');
		cag : out std_logic_vector (2 downto 0) := (others =>'Z');
		rst : out std_logic := '1';
		
		stateX : out integer
		);
		
end entity;

architecture arch of CU is

type state is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, ERROR);
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
		present_state<=next_state;
	elsif falling_edge(clk) then
		r_e<= '0';
	end if;
	
end process;

-- ten proces realizuje graf przejść
przejscia :process(present_state, ird, flags, r_e)

	variable a_mode : std_logic_vector(1 downto 0);	--tryb adresowania
	variable reg  : std_logic;	--rejestr
	variable instr : std_logic_vector(1 downto 0);	--instrukcja
	
begin

	--oe_ACC <='0';
	--ie_ACC <='0';
	--ie_REG_1 <= '0';
	--oe_REG_1 <= '0';
	--ie_REG_2 <= '0';
	--oe_REG_2 <= '0';
	--ie_IR <= '0';
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
		stateX <= 0;
			if r_e = '1' then
				start_adr <= "00000000"; 	--first instruction
				rst <= '0'; 			--wpisanie start adr
				cag <= "011";
				oe_ACC <='0';
				ie_ACC <='0';
				ie_REG_1 <= '0';
				oe_REG_1 <= '0';
				ie_REG_2 <= '0';
				oe_REG_2 <= '0';
				ie_IR <= '0';
				ie_IMR <= '0';
				oe_IMR <= '0';
				re_MBR <= '0';
				we_MBR <= '0';
				oe_buf <= '0';
				ie_buf <= '0';
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
		stateX <= 1;
			if r_e = '1' then
				incr <= '0';
				oe_buf <= '0';
				ie_buf <= '0';
				cag <= "011";
				lae <= '1'; 
				ie_ACC <='0';
				oe_REG_1 <= '0';
				oe_REG_2 <= '0';
				oe_IMR <= '0';
				jump <= '0';
			else
				next_state<= s2;
			end if;

		when s2 => --odczyt z pamięci pierwszy
		stateX <= 2;
			if r_e = '1' then
				mr <= '1';
				re_MBR <= '1';
			else
				mr <= '0';
				re_MBR<= '1';
				lae <= '0';
				next_state<= s3;
			end if;
		when s3 => --zapis do rejestru instrukcji
		stateX <= 3;
			if r_e = '1' then		
				increment <= "00000001";
				ie_IR<= '1';
			else			
				re_MBR <='0';
				incr <= '1';
				ie_IR <= '0';
				a_mode := ird(4 downto 3); --addressing mode
				reg := ird(2);			--register
				instr := ird(1 downto 0); --instruction

				next_state <= s4;
				
				if instr="11" then		--ERROR
					next_state <= ERROR;
				end if;
			end if;
				
		when s4 =>
		stateX <= 4;
			if r_e = '1' then	
				incr <= '0';
				case a_mode is
				
					when "00" =>		--rejestrowy						
						if reg = '0' then 	--reg 1
							oe_REG_1 <= '1';
							--lae <= '1';
						else				--reg 2
							oe_REG_2 <= '1';
							--lae <= '1';
						end if;
						
					when "01" =>	--bazowy
						if reg = '0' then 	--reg_1
							cag <= "001";
						else				--reg_2
							cag <= "010";
						end if;
					when others	=> lae <= '1'; --natychmiastowy/przemieszczenie
					
				end case;
			else
				case a_mode is
					when "00" => 		--rejestrowy
						if instr = "10" then
							if flags(0)='0' then --sprawdzanie flagi OF
								jump <= '1';
							end if;
							next_state <= s1; 	--jnof
						else
							next_state <= s5;	--load, add
						end if;
					when others => 		--bazowy/natychmiast/przemieszczeniowy
						next_state <= s7;
				end case;
			end if;
		
		when s5 =>	--OPERACJE LOAD i ADD
		stateX <= 5;
			if r_e = '1' then	
				case instr is
					when "00" => ie_ACC <= '1';	--LOAD
					when "01" => 
						ie_buf <= '1';	--ADD
						ie_flags <= '1';
					when others => next_state <= ERROR;
				end case;
			else
				case instr is
					when "00" => 
						next_state <= s1; --LOAD
					when "01" => 
						ie_flags <= '0';
						ie_buf <= '0';
						oe_IMR <= '0';
						oe_REG_1 <= '0';
						oe_IMR <= '0';
						oe_REG_2 <= '0';
						next_state <= s6;
					when others => 
						next_state <= ERROR;
				end case;
			end if;
			
		when s6 =>	--OPERACJE CZ2 - ADD
		stateX <= 6;
			if r_e = '0' then	
				ie_ACC <= '1';
				oe_buf <= '1';
				next_state <= s1;
			end if;	
		
		when s7 =>	--memory read 
		stateX <= 7;
			if r_e = '1' then
				mr <= '1';
				re_MBR <= '1';
			else
				mr <= '0';
				re_MBR<= '1';
				lae <= '0';
				if a_mode = "11" or a_mode = "10" then --tryb natychmiastowy/przemiesczeniowy
					next_state <= s8;
				elsif instr = "10" then --JNOF tryb bazowy
					if flags(0)='0' then --sprawdzanie flagi OF
						jump <= '1';
					end if;
					next_state <= s1; 
				else
					next_state <= s5; --add, load tryb bazowy 
					
				end if;
			end if;
		when s8 => -- tryb natychmiastowy.2/przemieszczeniowy.2
		stateX <= 8;
			if r_e = '1' then
				ie_IMR <= '1';				
			else
				ie_IMR <= '0';	
				re_MBR<= '0';
				oe_IMR <= '1';
				if instr = "10" then --jnof
					if flags(0)='0' then --sprawdzanie flagi OF
						jump <= '1';
					end if;
					next_state <= s1;
				elsif a_mode = "10" then
					cag <= "000";
					lae <= '1';
					next_state <= s9; --memory_read
				else
					next_state <= s5; --add, load
				end if;
			end if;
		
		when s9 => -- tryb przemieszczeniowy.3
		stateX <= 9;
			if r_e = '1' then
				mr <= '1';
				re_MBR <= '1';
			else
				oe_IMR <= '0';
				re_MBR<= '1';
				lae <= '0';
				next_state <= s5;
			end if;	
			
		when ERROR => 
		stateX <= 10;
			incr <= '0';
			next_state <= ERROR;
	end case;
end process;

end arch;



