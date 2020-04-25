library ieee ;
use ieee . std_logic_1164 . all ;

entity PC is

	generic( 
		NA : integer := 7;
		delay : time :=  2 ns
	);

	port( 
		clk, rst, incr, jump : in std_logic;
		pc_ag : inout std_logic_vector (NA downto 0);
		start_adr : in std_logic_vector (NA downto 0);	
		increment : in std_logic_vector (NA downto 0));
		jump_adr : in std_logic_vector (NA downto 0));

end PC;

architecture arch of PC is

begin

	process(clk, rst, incr)
	variable ch : std_logic_vector(NA downoto 0);
	variable ces: std_logic;

	begin

		if reset='0' then
			pc_ag <= start_adr;
		elsif falling_edge(clk) and incr='0' then
			ces := '0';
			for i in0 to NA loop
				ch(i) := (ces xor pc_ag(i)) xor increment(i);
				ces := (pc_ag(i) and increment(i)) or ((pc_ag(i) xor increment(i)) and ces;
			end loop;
			pc_ag <= ch after delay;
		elsif falling_edge(clk) and jump='0' then 
			pc_ag <= jump_adr after delay
		end if;
		
	end  process;
	
end arch; 