library ieee;
use ieee.std_logic_1164.all;

entity System is
end System;

architecture architectur of System is
constant period : time := 8 ns ;

--BUSES
signal dataBus : std_logic_vector(7 downto 0);
signal addressBus : std_logic_vector(7 downto 0);

signal rst, clk : std_logic :='1';
signal RESET : std_logic := '1';

--ALU
signal y, z : std_logic_vector(7 downto 0);
signal flags : std_logic_vector(4 downto 0);

--ACC
signal ie_ACC, oe_ACC : std_logic;

--buf
signal oe_buf, ie_buf: std_logic;

--MEMORY
signal lae, re_MBR, we_MBR, mw, mr : std_logic;
signal mar_mem, mem_mbr : std_logic_vector(7 downto 0);

--AG
signal r1_ag, r2_ag, pc_ag, imr_ag : std_logic_vector(7 downto 0);
signal cag : std_logic_vector(2 downto 0);

--REG_1
signal oe_REG_1, ie_REG_1: std_logic;
--REG_2
signal oe_REG_2, ie_REG_2: std_logic;
--IR
signal oe_IR, ie_IR : std_logic;

--IR_DECODER
signal IR_IRD : std_logic_vector(7 downto 0);
signal IRD_CU : std_logic_vector(4 downto 0);

--IMR
signal oe_IMR, ie_IMR: std_logic;

--PC
signal jump_adr, increment, start_adr : std_logic_vector(7 downto 0);
signal jump, incr : std_logic;

component CU is
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
end component;

component IR_DECODER is
	generic(	
				delay : time := 1 ns
	);
	port (
		ir_in : in std_logic_vector (7 downto 0);
		ir_out : out std_logic_vector (4 downto 0)
	);
end component;

component MAR is
	generic(	ND : integer := 7;
				delay : time := 1 ns
	);
	port( 
		lae, clk, rst : in std_logic;
		mar_mem : out std_logic_vector(ND downto 0);
		mar_in : in std_logic_vector(ND downto 0)
	);	
end component;

component buf is
	generic(
		delay : time := 1 ns
	);
	port( 
		ie, oe, clk, rst : in std_logic;
		buf_in : in std_logic_vector(7 downto 0);
		buf_out : inout std_logic_vector(7 downto 0)
	);
end component;

component MBR is
	generic(	ND : integer := 7;
				delay : time := 1 ns
	);
	port( 
		re, we, clk, rst : in std_logic;
		mem_mbr : inout std_logic_vector(ND downto 0);
		mbr_data : inout std_logic_vector(ND downto 0)
	);	
end component;

component alu is
	generic(	ND : integer := 7;
				delay : time := 1 ns
	);
	port(	x, y : in std_logic_vector (ND downto 0);
			z : out std_logic_vector (ND downto 0) := "00000000";
			flags : out std_logic_vector (4 downto 0) := "00000"
	);
end component;

component REG is
	generic(	ND : integer := 7;
				delay : time := 1 ns
	);
	port( 
		ie, oe, clk, rst : in std_logic;
		reg_out : out std_logic_vector(ND downto 0);
		reg_io : inout std_logic_vector(ND downto 0)
	);
end component;

component IR is
	generic(	ND : integer := 7;
				delay : time := 1 ns
	);
	port( 
		ie, oe, clk, rst : in std_logic;
		ir_in :in std_logic_vector(ND downto 0);
		ir_out : out std_logic_vector(ND downto 0)
	);
end component;

component PC is
	generic( 
		NA : integer := 7;
		delay : time :=  2 ns
	);
	port( 
		clk, rst, incr, jump : in std_logic;
		pc_ag : inout std_logic_vector (NA downto 0);
		start_adr : in std_logic_vector (NA downto 0);	
		increment : in std_logic_vector (NA downto 0);
		jump_adr : in std_logic_vector (NA downto 0)
		);
end component;

component Clock is
	generic( 
		period : time := 0.25 us
	);	
port(
		clk : out std_logic := '1'
		);	
end component;

component AG is
	generic( delay : time := 1 ns );
	port( 
		cag : in std_logic_vector (2 downto 0);
		imr_ag : in std_logic_vector (7 downto 0);
		r1_ag : in std_logic_vector (7 downto 0);
		r2_ag : in std_logic_vector (7 downto 0);
		pc_ag : in std_logic_vector (7 downto 0);
		ag_out : out std_logic_vector (7 downto 0)
	);
end component;

component Memory is
	generic(	ND : integer := 7;
				delay : time := 1 ns
	);
	port (
		mw, mr: in std_logic;
		mem_mbr: inout std_logic_vector(7 downto 0);
		mar_mem: in  std_logic_vector(7 downto 0)
	);
end component;

constant ClockPeriod : time := 8ns;

begin

clk <= not clk after ClockPeriod / 2;

c14: IR_DECODER port map(ir_in=>IR_IRD, ir_out=>IRD_CU);
c13: buf port map(ie => ie_buf, oe=>oe_buf, clk => clk, rst => rst,buf_in=> z, buf_out=>dataBus);
c12: Memory port map(mw=>mw, mr => mr, mem_mbr => mem_mbr, mar_mem=> mar_mem);
c11 : CU port map(clk => clk, RESET => RESET, oe_buf=>oe_buf, ie_buf=>ie_buf, oe_REG_1=>oe_REG_1, oe_REG_2=>oe_REG_2, ird_out => IRD_CU, flags => flags, ie_ACC => ie_ACC, oe_ACC => oe_ACC, ie_REG_1 => ie_REG_1, ie_REG_2 => ie_REG_2,
ie_IMR => ie_IMR, oe_IMR => oe_IMR, ie_IR => ie_IR, oe_IR => oe_IR, re_MBR => re_MBR, we_MBR => we_MBR, mw => mw, mr => mr, jump => jump, incr => incr, lae => lae, jump_adr => jump_adr, start_adr=>start_adr, increment => increment, cag => cag, rst => rst);
c10: MAR port map(lae => lae, clk => clk, rst => rst, mar_mem=> mar_mem, mar_in=>addressBus);
c9 : MBR port map(re => re_MBR, we => we_MBR, clk => clk, rst => rst, mem_mbr => mem_mbr, mbr_data => dataBus);
c8: ALU port map(x => dataBus, y => y, z=>z, flags=>flags);
c7:	REG port map(ie => ie_IR, oe => oe_IR, clk => clk, rst => rst, reg_io => dataBus, reg_out =>IR_IRD);
c6: IR port map(ie => ie_IR, oe => oe_IR, clk => clk, rst => rst, ir_in => dataBus, ir_out =>IR_IRD);
c5: REG port map(ie=>ie_REG_2, oe => oe_REG_2, clk => clk, rst=>rst, reg_out=>r2_ag, reg_io=>dataBus);
c4: REG port map(ie=>ie_REG_2, oe => oe_REG_2, clk => clk, rst=>rst, reg_out=>r2_ag, reg_io=>dataBus);
c3: AG port map(ag_out => addressBus , pc_ag => pc_ag, r1_ag => r1_ag, r2_ag => r2_ag, imr_ag => imr_ag, cag => cag);
c2: PC port map(start_adr => start_adr, increment => increment, jump_adr => jump_adr, 
incr => incr, jump => jump, pc_ag => pc_ag, clk=>clk, rst=>rst); 
c1: Clock port map ( clk => clk);
c0: REG port map(ie =>ie_imr, oe => oe_imr, clk => clk, rst=> rst, reg_out => imr_ag, reg_io => dataBus); 

end architectur;


