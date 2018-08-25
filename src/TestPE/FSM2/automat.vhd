library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.PECore.all;


package automat is
 
	component referinta is 
	generic ( logic_family : logic_family_t := HC);
	port ( clk, clrn: in std_logic;
	       state : out std_logic_vector(3 downto 0);
		   consumption : out consumption_type := cons_zero);
	end component;
	component structural is 
	generic ( logic_family : logic_family_t := HC);
	port ( clk, clrn: in std_logic;
	       state : out std_logic_vector(3 downto 0);
		   consumption : out consumption_type := cons_zero);
	end component;	
	component optimizat is 
	generic ( logic_family : logic_family_t := HC);
	port ( clk, clrn: in std_logic;
	       state : out std_logic_vector(3 downto 0);
		   consumption : out consumption_type := cons_zero);
	end component;	
end package;

-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity referinta is 
	generic ( logic_family : logic_family_t := HCT);
	port ( clk, clrn: in std_logic;
	       state : out std_logic_vector(3 downto 0);
		   consumption : out consumption_type := cons_zero);
end entity;

architecture behavioral of referinta is
	signal cs : std_logic_vector(3 downto 0);
begin
	process (clk, clrn)
	begin
		if clrn = '0' then cs <= "0000";
		elsif rising_edge(clk) then
			case (cs) is
				when "0000"  => cs <= "0001";
				when "0001"  => cs <= "0010";
				when "0010"  => cs <= "0011";
				when "0011"  => cs <= "0100";
				when "0100"  => cs <= "0110";
				when "0110"  => cs <= "0111";
				when "0111"  => cs <= "1000";
				when "1000"  => cs <= "1011";
				when "1011"  => cs <= "1100";
				when "1100"  => cs <= "1111";
				when "1111"  => cs <= "0001";
				when others => assert false report "Case failed" severity note;
			end case;
		end if;
	end process;
	state <= cs;
end architecture;

-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity structural is 
	generic ( logic_family : logic_family_t := HCT);
	port ( clk, clrn: in std_logic;
	       state : out std_logic_vector(3 downto 0);
		   consumption : out consumption_type := cons_zero);
end entity;


architecture behavioral of structural is
	
	signal d3, d2, d1, d0 : std_logic;
	signal q3, q2, q1, q0 : std_logic;
	signal q3n, q2n, q1n, q0n : std_logic;
	signal d0_1,d0_2,d0_3 : std_logic;
	signal d1_2 : std_logic;
	signal d2_1,d2_2 : std_logic;
	signal d3_1,d3_2,d3_3 : std_logic;
	signal cons : consumption_type_array (1 to 17) := ( others => (0.0,0.0,0.0));
	Constant VCC : real := 5.0;
begin

	DFF0 : dff generic map (delay => 1 ns) port map (CP => clk, SDn => '1', RDn => clrn, d => D0, Q => Q0, Qn => Q0n, Vcc => Vcc,  consumption => cons(1));
	DFF1 : dff generic map (delay => 2 ns) port map (CP => clk, SDn => '1', RDn => clrn, d => D1, Q => Q1, Qn => Q1n, Vcc => Vcc,  consumption => cons(2));
	DFF2 : dff generic map (delay => 1.5 ns) port map (CP => clk, SDn => '1', RDn => clrn, d => D2, Q => Q2, Qn => Q2n, Vcc => Vcc,  consumption => cons(3));
	DFF3 : dff generic map (delay => 1.2 ns) port map (CP => clk, SDn => '1', RDn => clrn, d => D3, Q => Q3, Qn => Q3n, Vcc => Vcc,  consumption => cons(4));
    -- products resulted from espresso minimization
	and_d3_1 : and3_gate generic map (delay => 2 ns) port map ( a=> Q3n, b => Q2, c => Q0, y => d3_1, Vcc => Vcc, consumption => cons(5));
	and_d3_2 : and_gate  generic map (delay => 1 ns) port map ( a=> Q3, b => Q0n, y => d3_2, Vcc => Vcc, consumption => cons(6));
	and_d3_3 : and_gate  generic map (delay => 1.5 ns) port map ( a=> Q3, b => Q2n, y => d3_3, Vcc => Vcc, consumption => cons(7));
	and_d2_1 : and3_gate generic map (delay => 2 ns) port map ( a=> Q2n, b => Q1, c => Q0, y => d2_1, Vcc => Vcc, consumption => cons(8));
    and_d2_2 : and_gate generic map (delay => 1 ns) port map ( a=> Q2, b => Q0n, y => d2_2, Vcc => Vcc, consumption => cons(9));
	and_d1_2 : and_gate generic map (delay => 1.2 ns) port map ( a=> Q1n, b => Q0, y => d1_2, Vcc => Vcc, consumption => cons(10));
	and_d0_1 : and_gate generic map (delay => 1 ns) port map ( a=> Q2n, b => Q0n, y => d0_1, Vcc => Vcc, consumption => cons(11));
    and_d0_2 : and_gate generic map (delay => 2 ns) port map ( a=> Q3, b => Q2, y => d0_2, Vcc => Vcc, consumption => cons(12));
    and_d0_3 : and_gate generic map (delay => 1 ns) port map ( a=> Q1, b => Q0n, y => d0_3, Vcc => Vcc, consumption => cons(13));
	--D3
	or_d3: or3_gate generic map (delay => 1 ns) port map ( a=> d3_1, b => d3_2, c => d3_3, y => D3, Vcc => Vcc, consumption => cons(14));
	--D2
	or_d2: or_gate generic map (delay => 1 ns) port map ( a=> d2_1, b => d2_2,  y => D2, Vcc => Vcc, consumption => cons(15));	
	--D1
	or_d1: or4_gate  generic map (delay => 1 ns)port map ( a=> d2_2, b => d1_2, c => d0_3, d =>  d3_2, y => D1, Vcc => Vcc, consumption => cons(16));		
	--D0
	or_d0: or3_gate generic map (delay => 1.5 ns) port map ( a=> d0_1, b => d0_2, c => d0_3, y => D0, Vcc => Vcc, consumption => cons(17));

	state <= Q3&Q2&Q1&Q0;
	
	U13 : sum_up generic map (N=>17) port map (cons => cons, consumption => consumption);
	
end architecture;		

-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;


entity optimizat is 
	generic ( logic_family : logic_family_t := default_logic_family);
	port ( clk, clrn: in std_logic;
	       state : out std_logic_vector(3 downto 0);
		   consumption : out consumption_type := cons_zero);
end entity;


architecture behavioral of optimizat is
	
	signal d0_1,d0_2,d0_3 : std_logic;
	signal d1_1,d1_2,d1_3,d1_4 : std_logic;
	signal d2_1,d2_2,d2_3 : std_logic;
	signal d3_1,d3_2,d3_3 : std_logic;
	signal clk3, clk2, clk1, clk0 : std_logic;
	signal q3, q2, q1, q0 : std_logic;
	signal q3n, q2n, q1n, q0n : std_logic;
	signal d3, d2, d1, d0 : std_logic;
	signal e3, e2, e1, e0 : std_logic;
	signal lf3, lf2, lf1, lf0 : std_logic;
	signal e0_1,e0_2,e0_3,e0_4 : std_logic;
	signal e1_1,e1_2,e1_3,e1_4 : std_logic;
	signal cons : consumption_type_array (1 to 39) := ( others => (0.0,0.0,0.0));
	Constant VCC : real := 5.0;
begin
-- baseline state mashine
--	DFF0 : dff port map (CP => clk0, SDn => '1', RDn => clrn, d => D0, Q => Q0, Qn => Q0n, Vcc => Vcc, consumption => cons(1));
--	DFF1 : dff port map (CP => clk1, SDn => '1', RDn => clrn, d => D1, Q => Q1, Qn => Q1n, Vcc => Vcc, consumption => cons(2));
	DFF0 : dff generic map (delay => 2 ns) port map (CP => clk, SDn => '1', RDn => clrn, d => D0, Q => Q0, Qn => Q0n, Vcc => Vcc, consumption => cons(1));
	DFF1 : dff generic map (delay => 1.2 ns) port map (CP => clk, SDn => '1', RDn => clrn, d => D1, Q => Q1, Qn => Q1n, Vcc => Vcc, consumption => cons(2));
	DFF2 : dff generic map (delay => 1 ns) port map (CP => clk2, SDn => '1', RDn => clrn, d => D2, Q => Q2, Qn => Q2n, Vcc => Vcc, consumption => cons(3));
	DFF3 : dff generic map (delay => 1.2 ns) port map (CP => clk3, SDn => '1', RDn => clrn, d => D3, Q => Q3, Qn => Q3n, Vcc => Vcc, consumption => cons(4));
    -- products resulted from espresso minimization
    and_d3_1 : and3_gate generic map (delay => 2 ns) port map ( a=> Q3n, b => Q2, c => Q0, y => d3_1, Vcc => Vcc, consumption => cons(5));
    and_d3_2 : and_gate  generic map (delay => 1 ns) port map ( a=> Q3, b => Q0n, y => d3_2, Vcc => Vcc, consumption => cons(6));
    and_d3_3 : and_gate  generic map (delay => 1.5 ns) port map ( a=> Q3, b => Q2n, y => d3_3, Vcc => Vcc, consumption => cons(7));
    and_d2_1 : and3_gate generic map (delay => 2 ns) port map ( a=> Q2n, b => Q1, c => Q0, y => d2_1, Vcc => Vcc, consumption => cons(8));
    and_d2_2 : and_gate generic map (delay => 1 ns) port map ( a=> Q2, b => Q0n, y => d2_2, Vcc => Vcc, consumption => cons(9));
    and_d1_2 : and_gate generic map (delay => 1.2 ns) port map ( a=> Q1n, b => Q0, y => d1_2, Vcc => Vcc, consumption => cons(10));
    and_d0_1 : and_gate generic map (delay => 1 ns) port map ( a=> Q2n, b => Q0n, y => d0_1, Vcc => Vcc, consumption => cons(11));
    and_d0_2 : and_gate generic map (delay => 2 ns) port map ( a=> Q3, b => Q2, y => d0_2, Vcc => Vcc, consumption => cons(12));
    and_d0_3 : and_gate generic map (delay => 1 ns) port map ( a=> Q1, b => Q0n, y => d0_3, Vcc => Vcc, consumption => cons(13));
    --D3
    or_d3: or3_gate generic map (delay => 1 ns) port map ( a=> d3_1, b => d3_2, c => d3_3, y => D3, Vcc => Vcc, consumption => cons(14));
    --D2
    or_d2: or_gate generic map (delay => 1 ns) port map ( a=> d2_1, b => d2_2,  y => D2, Vcc => Vcc, consumption => cons(15));    
    --D1
    or_d1: or4_gate  generic map (delay => 1 ns)port map ( a=> d2_2, b => d1_2, c => d0_3, d =>  d3_2, y => D1, Vcc => Vcc, consumption => cons(16));        
    --D0
    or_d0: or3_gate generic map (delay => 1.5 ns) port map ( a=> d0_1, b => d0_2, c => d0_3, y => D0, Vcc => Vcc, consumption => cons(17));
-- circuit overhead for clock gating
--	L0 : mux2_1 port map (I(1) => E0, I(0) => LF0, A => clk, Y => LF0, Vcc => Vcc, consumption => cons(18));
--	L1 : mux2_1 port map (I(1) => E1, I(0) => LF1, A => clk, Y => LF1, Vcc => Vcc, consumption => cons(19));
--	L2 : mux2_1 port map (I(1) => E2, I(0) => LF2, A => clk, Y => LF2, Vcc => Vcc, consumption => cons(20));
--	L3 : mux2_1 port map (I(1) => E3, I(0) => LF3, A => clk, Y => LF3, Vcc => Vcc, consumption => cons(21));
	L2 : latchD generic map ( delay => 1 ns, clock_polarity => '0') port map (Rn => clrn, Ck => clk, D => E2, Q => LF2, Qn => open, Vcc => Vcc, consumption => cons(20));
	L3 : latchD generic map ( delay => 1 ns, clock_polarity => '0') port map (Rn => clrn, Ck => clk, D => E3, Q => LF3, Qn => open, Vcc => Vcc, consumption => cons(21));
--	G0 : and_gate port map (a => lf0 , b => clk, y => clk0, Vcc => Vcc, consumption => cons(22));
--	G1 : and_gate port map (a => lf1 , b => clk, y => clk1, Vcc => Vcc, consumption => cons(23));
	G2 : and_gate port map (a => lf2 , b => clk, y => clk2, Vcc => Vcc, consumption => cons(24));
	G3 : and_gate port map (a => lf3 , b => clk, y => clk3, Vcc => Vcc, consumption => cons(25));
	--E3
	and_e3 :  and_gate port map (a => Q2, b => Q1, Y => E3, Vcc => Vcc, consumption => cons(26));
	--E2
	and_e2 :  and_gate port map (a => Q1, b => Q0, Y => E2, Vcc => Vcc, consumption => cons(27));	
--	--E1
--	and_e1_1 : and_gate port map ( a=> Q2, b => Q1n, y => e1_1, Vcc => Vcc, consumption => cons(28));
--	and_e1_2 : and_gate port map ( a=> Q1, b => Q0, y => e1_2, Vcc => Vcc, consumption => cons(29));
--	and_e1_3 : and_gate port map ( a=> Q3, b => Q0n, y => e1_3, Vcc => Vcc, consumption => cons(30));
--	and_e1_4 : and_gate port map ( a=> Q3n, b => Q0, y => e1_4, Vcc => Vcc, consumption => cons(31));
--	or_e1: or4_gate port map ( a=> e1_1, b => e1_2, c => e1_3, d =>  e1_4, y => e1, Vcc => Vcc, consumption => cons(32));	
--	--E0
--	and_e0_1 : and_gate port map ( a=> Q3n, b => Q0, y => e0_1, Vcc => Vcc, consumption => cons(33));
--	and_e0_2 : and_gate port map ( a=> Q3, b => Q0n, y =>  e0_2, Vcc => Vcc, consumption => cons(34));
--	and_e0_4 : and_gate port map ( a=> Q1, b => Q0n, y => e0_4, Vcc => Vcc, consumption => cons(35));
--	or_e0: or4_gate port map ( a=> e0_1, b => e0_2, c => Q2n, d =>  e0_4, y => e0, Vcc => Vcc, consumption => cons(36));

	state <= Q3&Q2&Q1&Q0;
	
	SUM : sum_up generic map (N=>39) port map (cons => cons, consumption => consumption);
	
end architecture;	