----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: Counter 74163 with activity monitoring 
--              - inputs:  CK, CLRN, LOADN, PT, D ,C ,B ,A -std_logic  
--              - outputs : Qd, Qc, Qb, Qa, RCO-std_logic
--              - consumption :  port to monitor dynamic and static consumption
-- Dependencies: none
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use work.PELib.all;

entity num74163 is
    Generic (delay : time := 1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 --gate : component_t; -- the type of the component
				 Cload : real := 5.0 -- capacitive load 
                );
        Port ( CLK, CLRN, LOADN, P, T, D ,C ,B ,A : in std_logic;
                 Qd, Qc, Qb, Qa, RCO: out std_logic;
                 Vcc : in real ; -- supply voltage
		         consumption : out consumption_type := (0.0,0.0)
		         );
end num74163;

architecture Behavioral of num74163 is
signal counter : std_logic_vector (3 downto 0);
signal ck,cl,ld,en,dd,cc,bb,aa,qdd,qcc,qbb,qaa,rrco: std_logic;
begin
ck <= CLK;
cl <= CLRN;
ld <= LOADN;
en <= P;
dd <= D;
cc <= C;
bb <= B;
aa <= A;
functionare: process(ck,cl)
             begin
             if cl = '0' then
                   counter <= "0000";
             elsif rising_edge(ck) then
             if (ld = '0') then
                   counter <= dd & cc & bb & aa;
             elsif ( en = '1') then 
                   counter <= counter + 1;
       end if;
   end if;
end process;

qdd <= counter(3) after delay;
qcc <= counter(2) after delay;
qbb <= counter(1) after delay;
qaa <= counter(0) after delay;
rrco <= '1' after delay when (en = '1' and counter = "1111") else '0' after delay;

RCO <= rrco;
Qd <= qdd;
Qc <= qcc;
Qb <= qbb;
Qa <= qaa;

cm_i : consumption_monitor generic map ( N=>8, M=>5, logic_family => logic_family, gate => gate, Cload => Cload)
		port map (sin(0) => ck, sin(1) => cl, sin(2) => ld, sin(3) => en, sin(4) => dd, sin(5) => cc, sin(6) => bb, sin(7) => aa, Vcc => Vcc, sout(0) => qdd, sout(1) => qcc, sout(2) => qbb, sout(3) => qaa, sout(4) => rrco, consumption => consumption);


end Behavioral;


architecture Structural of num74163 is
-- implementation follows schematic in https://assets.nexperia.com/documents/data-sheet/74HC_HCT163.pdf
	signal cons : consumption_type_array(1 to 5);
	signal CPn , MR, PE : std_logic;
	signal DFF0Qn, DFF1Qn, DFF2Qn, DFF3Qn : std_logic;
	signal DFF0Q, DFF1Q, DFF2Q, DFF3Q : std_logic;
	signal D0, D1, D2, D3 : std_logic;
	signal DFF0, DFF1, DFF2, DFF3 : std_logic;
	signal D01, D11, D21, D31 : std_logic;
	signal D02, D12, D22, D32 : std_logic;
	signal C0, C1, C2, C3 : std_logic;
	signal L0, L1, L2, L3, L31, L32 : std_logic;
	signal CET, CEP, TC, CE, Load, Reset : std_logic;
begin

	dff0_I : dff generic map (delay => 1 ns, Cpd => Cpd, Cload => Cload) port map (CP => CPn, D => DFF0, RDn => '1', SDn => '1', Qn => DFF0Q, Q => DFF0Qn, consumption => cons(1));
	dff1_I : dff generic map (delay => 2 ns, Cpd => Cpd, Cload => Cload) port map (CP => CPn, D => DFF1, RDn => '1', SDn => '1', Qn => DFF1Q, Q => DFF1Qn, consumption => cons(2));
	dff2_I : dff generic map (delay => 1 ns, Cpd => Cpd, Cload => Cload) port map (CP => CPn, D => DFF2, RDn => '1', SDn => '1', Qn => DFF2Q, Q => DFF2Qn, consumption => cons(3));
	dff3_I : dff generic map (delay => 2 ns, Cpd => Cpd, Cload => Cload) port map (CP => CPn, D => DFF3, RDn => '1', SDn => '1', Qn => DFF3Q, Q => DFF3Qn, consumption => cons(4));
	
	--CPn <= not clk;
	inv1: inv_gate generic map (...) port map (..., consumption => cons(5));
	Qa <= not DFF0Qn;
	Qb <= not DFF1Qn;
	Qc <= not DFF2Qn;
	Qd <= not DFF3Qn;
	MR <= not CLRN;
	PE <= LOADN;
	D0 <= A; --not A;
	--tristate Buffer, En => '1'
	tristate_buf_1 : tristate_buf generic map () port mao ()
	D1 <= B; --not B;
	D2 <= C; --not C;
	D3 <= D; --not D;
	CET <= T;
	CEP <= P;
	RCO <= not TC;
	TC <= (DFF0Q and DFF1Q and DFF2Q and DFF3Q and CET);
	CE <=  CET nand CEP;
	LOAD <= MR nor PE;
	Reset <= Load nor MR;
	C0 <= not CE;
	C1 <= CE nor DFF0Qn;
	C2 <= not (CE or DFF0Qn or DFF1Qn);
	C3 <= not (CE or DFF0Qn or DFF1Qn or DFF2Qn);
	L0 <= C0 xnor DFF0Qn;
	L1 <= C1 xnor DFF1Qn;
	L2 <= C2 xnor DFF2Qn;
	L3 <= L31 or L32;
	--L3 <= C3 xnor DFF3Qn;
	L31 <= C3 and DFF3Qn;
	L32 <= C3 nor DFF3Qn;
	D01 <= D0 and load;
	D11 <= D1 and load;
	D21 <= D2 and load;
	D31 <= D3 and load;
	D02 <= L0 and Reset;
	D12 <= L1 and Reset;
	D22 <= L2 and Reset;
	D32 <= L3 and Reset;
	DFF0 <= D01 nor D02;
	DFF1 <= D11 nor D12;
	DFF2 <= D21 nor D22;
	DFF3 <= D31 nor D32;
	
	-- cm_i : consumption_monitor generic map (N=> 51, M => 5, Cin => Cin, Cpd => Cpd, Cload => Cload, Icc => Icc) port map (

	-- sin(0) => CPn	,
	-- sin(1) => DFF0Qn ,
	-- sin(2) => DFF1Qn ,
	-- sin(3) => DFF2Qn ,
	-- sin(4) => DFF3Qn ,
	-- sin(5) => DFF0Q  ,
	-- sin(6) => DFF1Q  ,
	-- sin(7) => DFF2Q  ,
	-- sin(8) => DFF3Q  ,
	-- sin(9) => MR     ,
	-- sin(10) => PE     ,
	-- sin(11) => D0     ,
	-- sin(12) => D1     ,
	-- sin(13) => D2     ,
	-- sin(14) => D3     ,
	-- sin(15) => CET    ,
	-- sin(16) => CEP    ,
	-- sin(17) => TC     ,
	-- sin(18) => CE     ,
	-- sin(19) => LOAD   ,
	-- sin(20) => Reset  ,
	-- sin(21) => C0     ,
	-- sin(22) => C1     ,
	-- sin(23) => C2     ,
	-- sin(24) => C3     ,
	-- sin(25) => L0     ,
	-- sin(26) => L1     ,
	-- sin(27) => L2     ,
	-- sin(28) => L3     ,
	-- sin(29) => L31    ,
	-- sin(30) => L32    ,
	-- sin(31) => D01    ,
	-- sin(32) => D11    ,
	-- sin(33) => D21    ,
	-- sin(34) => D31    ,
	-- sin(35) => D02    ,
	-- sin(36) => D12    ,
	-- sin(37) => D22    ,
	-- sin(38) => D32    ,
	-- sin(39) => DFF0   ,
	-- sin(40) => DFF1   ,
	-- sin(41) => DFF2   ,
	-- sin(42) => DFF3   ,
	-- sin(43) => CLK   ,
	-- sin(44) => CLRN  ,
	-- sin(45) => P ,
	-- sin(46) => T ,
	-- sin(47) => A ,
	-- sin(48) => B ,
	-- sin(49) => C ,
	-- sin(50) => D ,
	-- sout(0) => DFF0Qn , -- instead of Qa    ,
	-- sout(1) => DFF1Qn , -- instead of Qb    ,
	-- sout(2) => DFF2Qn , -- instead of Qc    ,
	-- sout(3) => DFF3Qn , -- instead of Qd    ,
	-- sout(4) => TC     , -- instead of RCO   ,
	-- consumption => cons(5));
	
	sum : sum_up generic map (N=>5) port map (cons => cons, consumption => consumption );
	
end architecture;
