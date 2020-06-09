library ieee;
use ieee.std_logic_1164.all;

entity System is

	generic( 
		period : time := 30 ns
	);
	
end System;

architecture architectur of System is

--type state is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, ERROR);
--signal present_state: state; 

--BUSES
signal dataBus : std_logic_vector(7 downto 0) := (others=>'Z');
signal addressBus : std_logic_vector(7 downto 0) := (others=>'Z');
signal clk : std_logic :='0';
signal rst : std_logic :='1';
signal RESET : std_logic := '1';

--ALU
signal y, z : std_logic_vector(7 downto 0) := (others=>'Z');
signal flags : std_logic_vector(4 downto 0) := (others=>'Z');

--ACC
signal ie_ACC, oe_ACC : std_logic := '0';

--buf
signal oe_buf, ie_buf: std_logic :=  '0';

--MEMORY
signal lae, re_MBR, we_MBR, mw, mr : std_logic := '0';
signal mar_mem, mem_mbr : std_logic_vector(7 downto 0) := (others=>'Z');

--AG
signal r1_ag, r2_ag, pc_ag, imr_ag : std_logic_vector(7 downto 0) := (others=>'Z');
signal cag : std_logic_vector(2 downto 0) := "011";

--REG_1
signal oe_REG_1, ie_REG_1: std_logic := '0';
--REG_2
signal oe_REG_2, ie_REG_2: std_logic := '0';
--IR
signal ie_IR : std_logic := '0';

--IR_DECODER
signal ir_ird : std_logic_vector(7 downto 0) := (others=>'Z');
signal ird_cu : std_logic_vector(4 downto 0) := (others=>'Z');

--IMR
signal oe_IMR, ie_IMR: std_logic := '0';

--PC
signal increment, start_adr : std_logic_vector(7 downto 0) := (others=>'Z');
signal jump, incr : std_logic := '0';

component CU is
	port (clk, RESET: in std_logic; 		--RESET CU-rde
		ird : in std_logic_vector (4 downto 0) := (others =>'Z');
		flags : in std_logic_vector (4 downto 0) := (others =>'Z');
		
		--sygnały_bledow : out std_logic_vector (??downto 0);
		
		--sygnały sterujące:
		ie_ACC, ie_buf, ie_REG_1, ie_REG_2, ie_IMR, ie_IR : out std_logic;
		oe_ACC, oe_buf, oe_REG_1, oe_REG_2, oe_IMR : out std_logic;
		re_MBR, we_MBR, mw, mr, jump, incr, lae : out std_logic;
		start_adr, increment : out std_logic_vector (7 downto 0) := (others =>'Z');
		cag : out std_logic_vector (2 downto 0) := (others =>'Z');
		rst : out std_logic
		);	
end component;

component IR_DECODER is
	generic(
		delay : time := 1 ns
	);
	port(
			ird_in : in std_logic_vector (7 downto 0) := (others =>'Z');
			ird_out :out std_logic_vector (4 downto 0) := (others =>'Z')
	);
end component;

component MAR is
	generic(	ND : integer := 7;
				delay : time := 1 ns
	);
	port( 
		lae, clk, rst : in std_logic;
		mar_out : out std_logic_vector(7 downto 0) := (others =>'Z');
		mar_in : in std_logic_vector(7 downto 0) := (others =>'Z')
	);	
end component;

component BUF is
	generic(
		delay : time := 1 ns
	);
	port( 
		ie, oe, clk, rst : in std_logic;
		buf_in : in std_logic_vector(7 downto 0) := (others =>'Z');
		buf_out : out std_logic_vector(7 downto 0) := (others =>'Z')
	);
end component;

component MBR is
	generic(
		delay : time := 1 ns
	);
	port( 
		re, we, clk, rst : in std_logic;
		mbr_mem : inout std_logic_vector(7 downto 0) := (others =>'Z');
		mbr_data : inout std_logic_vector(7 downto 0) := (others =>'Z')
	);
end component;

component ALU is
	generic(	ND : integer := 7;
				delay : time := 1 ns
	);
	port(	x, y : in std_logic_vector (ND downto 0);
			z : out std_logic_vector (ND downto 0) := (others =>'Z');
			flags : out std_logic_vector (4 downto 0) := (others =>'Z')
	);
end component;

component REG is
	generic(
		delay : time := 1 ns
	);
	port( 
		ie, oe, clk, rst : in std_logic;
		reg_out : out std_logic_vector(7 downto 0) := (others =>'Z');
		reg_io : inout std_logic_vector(7 downto 0) := (others =>'Z')
	);
end component;

component IR is
	generic(
		delay : time := 1 ns
	);
	port( 
		ie, clk, rst : in std_logic;
		ir_in :in std_logic_vector(7 downto 0) := (others =>'Z');
		ir_out : out std_logic_vector(7 downto 0):= (others =>'Z')
	);
end component;

component PC is
	generic( 
		ND : integer := 7;
		delay : time := 1 ns
	);
	port( 
		clk, rst, incr, jump : in std_logic;
		pc_out : inout std_logic_vector (ND downto 0) := (others =>'Z');
		start_adr : in std_logic_vector (ND downto 0) := (others =>'Z');	
		increment : in std_logic_vector (ND downto 0) := (others =>'Z');
		jump_adr : in std_logic_vector (ND downto 0) := (others =>'Z')
		);
end component;

component AG is
	generic( 
		ND : integer := 7;
		delay : time := 1 ns
	);
	port( 
		cag : in std_logic_vector (2 downto 0) := (others =>'Z');
		imr : in std_logic_vector (ND downto 0) := (others =>'Z'); --IMR
		reg1 : in std_logic_vector (ND downto 0) := (others =>'Z'); --REG_1
		reg2 : in std_logic_vector (ND downto 0) := (others =>'Z'); --REG_2
		pc : in std_logic_vector (ND downto 0) := (others =>'Z'); --PC
		ag_out : out std_logic_vector (ND downto 0) := (others =>'Z')
	);
end component;

component Memory is
	generic(
		delay : time := 1 ns
	);
	port (
		mw, mr: in std_logic;
		data: inout std_logic_vector(7 downto 0) := (others =>'Z');
		address: in  std_logic_vector(7 downto 0) := (others =>'Z')
	);
end component;

begin

clk <= not clk after 0.5*period;
RESET <= '0' after 50 ns;

E_ACC: REG port map(ie=>ie_ACC, oe => oe_ACC, clk => clk, rst => rst, reg_out => y, reg_io => dataBus);
E_ALU: ALU port map(x => dataBus, y => y, z => z, flags => flags);
E_BUFFOR: buf port map(ie => ie_buf, oe => oe_buf, clk => clk, rst => rst, buf_in => z, buf_out => dataBus);

E_AG: AG port map(ag_out => addressBus, imr => imr_ag, reg1 => r1_ag, reg2 => r2_ag, pc => pc_ag, cag => cag);
E_REG_1: REG port map(ie=>ie_REG_1, oe => oe_REG_1, clk => clk, rst => rst, reg_out => r1_ag, reg_io => dataBus);
E_REG_2: REG port map(ie=>ie_REG_2, oe => oe_REG_2, clk => clk, rst => rst, reg_out => r2_ag, reg_io => dataBus);
E_IMR: REG port map(ie => ie_IMR, oe => oe_IMR, clk => clk, rst => rst, reg_io => dataBus, reg_out =>imr_ag);
E_PC: PC port map(start_adr => start_adr, increment => increment, jump_adr => dataBus, incr => incr,
				jump => jump, pc_out => pc_ag, clk=>clk, rst=>rst); 
E_IR: IR port map(ie => ie_IR, clk => clk, rst => rst, ir_in => dataBus, ir_out =>ir_ird);
E_IR_RECODER: IR_DECODER port map(ird_in=>ir_ird, ird_out=>ird_cu);
E_CU : CU port map(clk => clk, RESET => RESET, oe_buf => oe_buf, ie_buf => ie_buf, oe_REG_1 => oe_REG_1,
				oe_REG_2 => oe_REG_2, ird => ird_cu, flags => flags, ie_ACC => ie_ACC, oe_ACC => oe_ACC,
				ie_REG_1 => ie_REG_1, ie_REG_2 => ie_REG_2, ie_IMR => ie_IMR, oe_IMR => oe_IMR, ie_IR => ie_IR,
				re_MBR => re_MBR, we_MBR => we_MBR, mw => mw, mr => mr, jump => jump, incr => incr,
				lae => lae, start_adr => start_adr, increment => increment, cag => cag,
				rst => rst);
				
E_MAR: MAR port map(lae => lae, clk => clk, rst => rst, mar_out => mar_mem, mar_in => addressBus);
E_MBR: MBR port map(re => re_MBR, we => we_MBR, clk => clk, rst => rst, mbr_mem => mem_mbr, mbr_data => dataBus);
E_MEMORY: Memory port map(mw => mw, mr => mr, data => mem_mbr, address => mar_mem);

end architectur;


