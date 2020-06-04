library ieee ;
use ieee.std_logic_1164 . all ;

entity PC is

	generic( 
		ND : integer := 7;
		delay : time := 1 ns
	);

	port( 
		clk, rst, incr, jump : in std_logic;
		pc_io : inout std_logic_vector (ND downto 0);
		start_adr : in std_logic_vector (ND downto 0);	
		increment : in std_logic_vector (ND downto 0);
		jump_adr : in std_logic_vector (ND downto 0)
		);

end PC;

architecture arch of PC is

begin

	process(clk, rst, incr, start_adr, jump)
	variable ch : std_logic_vector(ND downto 0);
	variable ces: std_logic;

	begin

		if (rst='0') then
			pc_io <= start_adr;
		elsif falling_edge(clk) and incr='1' then
			ces := '0';
			for i in 0 to ND loop
				ch(i) := (ces xor pc_io(i)) xor increment(i);
				ces := (pc_io(i) and increment(i)) or ((pc_io(i) xor increment(i)) and ces);
			end loop;
			pc_io <= ch after delay;
		elsif falling_edge(clk) and jump='1' then 
			pc_io <= jump_adr after delay;
		end if;
		
	end  process;
	
end arch; 