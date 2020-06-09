library ieee ;
use ieee.std_logic_1164 . all ;

entity PC is

	generic( 
		ND : integer := 7;
		delay : time := 3 ns
	);

	port( 
		clk, rst, incr, jump : in std_logic;
		pc_out : inout std_logic_vector (ND downto 0);
		start_adr : in std_logic_vector (ND downto 0);	
		increment : in std_logic_vector (ND downto 0);
		jump_adr : in std_logic_vector (ND downto 0)
		);

end PC;

architecture arch of PC is

signal r_e : std_logic := '0';
begin 

	clock: process (clk) is

		begin
			if rising_edge(clk) then
				r_e<= '1';
			elsif falling_edge(clk) then
				r_e<= '0';
			end if;
	end process;

	process(r_e, rst, incr ,jump)
	variable ch : std_logic_vector(ND downto 0);
	variable ces: std_logic;

	begin

		if (rst='0') then
			pc_out <= start_adr;
		elsif r_e='0' and incr='1' then
			ces := '0';
			for i in 0 to ND loop
				ch(i) := (ces xor pc_out(i)) xor increment(i);
				ces := (pc_out(i) and increment(i)) or ((pc_out(i) xor increment(i)) and ces);
			end loop;
			pc_out <= ch after delay;
		elsif  r_e='0' and jump='1' then 
			pc_out <= jump_adr after delay;
		end if;
		
	end  process;
	
end arch; 