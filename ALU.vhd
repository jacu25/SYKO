library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all; 

entity alu is

	generic(	
		ND : integer := 7;
		delay : time := 3 ns
	);
	port(	x, y : in std_logic_vector (ND downto 0) := (others => 'Z');
			z : out std_logic_vector (ND downto 0) := (others => 'Z');
			flags : out std_logic_vector (4 downto 0) := (others => 'Z')
	);
end alu;

-- flags:	flags(0) = OF,// '1' - overflow
--			flags(1) = CF,// '1' - carry
-- 			flags(2) = SF,// '1' - minus
--			flags(3) = ZF,// '1' - zero
--			flags(4) = PF,// '1' - parity

architecture arch of alu is	
begin
process(x, y)
	variable result : std_logic_vector(ND downto 0) := (others => 'Z');
	variable i : integer := 0 ; --for FOR
	variable carry : std_logic := '0';
	variable flags_buf : std_logic_vector(4 downto 0) := (others => 'Z');
	variable parity_v : std_logic := '0';
begin

	carry := '0';
	flags_buf:=(others=>'0');
	parity_v := '1';
	
	ADD_LOOP: for i in 0 to ND loop
		result(i) := (carry xor x(i)) xor y(i);
		carry := (x(i) and y(i)) or ((x(i) xor y(i)) and carry);
	end loop;
	
	--OF
	if (x(ND)=y(ND) and x(ND)/=result(ND)) then
		flags_buf(0) := '1';
	else
		flags_buf(0) := '0';
	end if;
	
	--CF
	flags_buf(1) := carry;
	
	--ZF
	flags_buf(3) := result(ND);

	--PF
	for i in 0 to ND loop
		parity_v := parity_v xor result(i);
	end loop;
	flags_buf(4) := parity_v;
	
	--flags_out
	flags <= flags_buf;
	
	--OUT
	z <= result after delay;
	
end process;
end arch;
