library ieee;
use ieee.std_logic_1164.all;

entity System is
end System;

architecture arch of System is

constant clk_period : time := 8 ns ;

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

constant ClockPeriod : time := 8ns;

begin

clk <= not clk after ClockPeriod / 2;

et2: entity work.PC(arch)
port map(start_adr => start_adr, increment => increment, jump_adr => jump_adr, 
incr => incr, jump => jump, pc_ag => pc_ag, clk=>clk, rst=>rst); 

et3: entity work.AG(arch)
port map(ag_out => addressBus , pc_ag => pc_ag, r1_ag => r1_ag, r2_ag => r2_ag, imr_ag => imr_ag, cag => cag);

et4: entity work.REG(arch)
port map(ie=>ie_REG_1, oe => oe_REG_1, clk => clk, rst=>rst, reg_out=>r1_ag, reg_io=>dataBus);

et5: entity work.REG(arch)
port map(ie=>ie_REG_2, oe => oe_REG_2, clk => clk, rst=>rst, reg_out=>r2_ag, reg_io=>dataBus);
	
et6: entity work.IR(arch)
port map(ie => ie_IR, oe => oe_IR, clk => clk, rst => rst, ir_in => dataBus, ir_out =>IR_IRD);

et7: entity work.ACC(arch)
port map(ie => ie_ACC, oe => oe_ACC, clk => clk, rst => rst, acc_io=> dataBus, acc_alu =>y);

et8: entity work.alu(arch)
port map(x => dataBus, y => y, z=>z, flags=>flags);

et9: entity work.MBR(arch)
port map(re => re_MBR, we => we_MBR, clk => clk, rst => rst, mem_mbr => mem_mbr, mbr_data => dataBus);

et10: entity work.MAR(arch)
port map(lae => lae, clk => clk, rst => rst, mar_mem=> mar_mem, mar_in=>addressbus);

et11: entity work.CU(arch)
	port map(clk => clk, RESET => RESET, oe_buf=>oe_buf, ie_buf=>ie_buf, oe_REG_1=>oe_REG_1, oe_REG_2=>oe_REG_2, ird_out => IRD_CU, flags => flags, ie_ACC => ie_ACC, oe_ACC => oe_ACC, ie_REG_1 => ie_REG_1, ie_REG_2 => ie_REG_2,
ie_IMR => ie_IMR, oe_IMR => oe_IMR, ie_IR => ie_IR, oe_IR => oe_IR, re_MBR => re_MBR, we_MBR => we_MBR, mw => mw, mr => mr, jump => jump, incr => incr, lae => lae, jump_adr => jump_adr, start_adr=>start_adr, increment => increment, cag => cag, rst => rst);

et12: entity work.Memory(arch)
port map(mw=>mw, mr => mr, mem_mbr => mem_mbr, mar_mem=> mar_mem);

et13: entity work.buf(arch)
port map(ie => ie_buf, oe=>oe_buf, clk => clk, rst => rst,buf_in=> z, buf_out=>dataBus);

et14: entity work.IR_DECODER(arch)
port map(ir_in=>IR_IRD, ir_out=>IRD_CU);

et15: entity work.IMR(arch)
port map(ie =>ie_imr, oe => oe_imr, clk => clk, rst=> rst, imr_ag => imr_ag, imr_io => dataBus); 

end arch;