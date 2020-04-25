library ieee;
use ieee.std_logic_1164.all;

entity alu is
	generic(ND : integer := 7;
	delay : time := 1 ns);
	port(	x, y : in std_logic_vector (ND downto 0);
			z : out std_logic_vector (7 downto 0) := "000000";
			flags : out std_logic_vector (5 downto 0) := "000000";
	);
-- flags:	flags(0) = OF,
--				flags(1) = CF,
-- 			flags(2) = SF,
--				flags(3) = ZF, 
--				flags(4) = PF,//partity
--				flags(5) = AF;
end alu;

architecture behav of alu is
begin
variable i : integer;
variable ces : std_logic;
variable ch : std_logic_vector(ND downto 0);
begin

	ces := '0';
	L1: for i in 0 to ND loop
		ch(i) := (ces xor a(i)) xor b(i);
		ces := (a(i) and b(i)) or ((a(i) xor b(i)) and ces);
		end loop;
	--OUT
	z <= ch after delay;
	
	ce <= ces after delay;
	 --OF
	if (a(ND)=b(ND) and a(ND)/=ch(ND)) then
		flags(0) <= '1' after delay;
	else
		flags(0) <= '0' after delay;
	end if;
	
	if (z(ND)=1) then
		flags(0) <= '1' after delay;
	else
		flags(0) <= '0' after delay;
	end if;
end process;
end behav;
