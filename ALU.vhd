library ieee;
use ieee.std_logic_1164.all;

entity alu is

	generic(	ND : integer := 7;
				delay : time := 1 ns
	);
	port(	x, y : in std_logic_vector (ND downto 0);
			z : out std_logic_vector (ND downto 0) := "00000000";
			flags : out std_logic_vector (4 downto 0) := "00000"
	);
end alu;

-- flags:	flags(0) = OF,// '1' - overflow
--				flags(1) = CF,// '1' - carry
-- 			flags(2) = SF,// '1' - minus
--				flags(3) = ZF,// '1' - zero
--				flags(4) = PF,// '1' - parity


architecture behav of alu is
begin
	variable result : std_logic_vector(ND downto 0);
	variable i : integer; --for FOR
	variable carry : std_logic;
	variable flags_buf : std_logic_vector(5 downto 0);
	variable parity_v : std_logic;
	
process(x, y)
begin

	carry := '0';
	flags_buf:="00000";
	parity_v := '1';
	
	ADD_LOOP: for i in 0 to ND loop
		result(i) := (carry xor a(i)) xor b(i);
		carry := (a(i) and b(i)) or ((a(i) xor b(i)) and carry);
	end loop;
	
	--OF
	if (a(ND)=b(ND) and a(ND)/=result(ND)) then
		flags_buf(0) <= '1';
	else
		flags_buf(0) <= '0';
	end if;
	
	--CF
	flags_buf(1) <= carry;
	
	--ZF
	flags_buf(3) <= z(ND);

	--PF
	for i in 0 to ND loop:
		parity_v := parity_v xor result(i);
	end loop;
	flags_buf(4) <= parity_v;
	
	--flags_out
	flags <= flags_buf after delay;
	
	--OUT
	z <= result after delay;
	
end process;
end behav;
