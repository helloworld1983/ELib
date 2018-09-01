library IEEE;
use IEEE.std_logic_1164.all;
use work.PECore.all;

package automat is

	component automat_implementare1 is 
	port ( clk, clrn, ina, inb: in std_logic;
	       state:out std_logic_vector(2 downto 0);
		   consumption : out consumption_type := cons_zero);
	end component;
	
	component automat_implementare2 is 
	port ( clk, clrn, ina, inb: in std_logic;
	       state:out std_logic_vector(2 downto 0);
		   consumption : out consumption_type := cons_zero);
	end component;
	
	component automat_referinta is
	port( clk, clrn , ina , inb : in std_logic;
		state_ref: out std_logic_vector(2 downto 0));
		
	end component;	
	
end package;

--------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.PECore.all;
use work.PEGates.all;

entity automat_implementare1 is 
	port ( clk, clrn, ina, inb: in std_logic;
	       state:out std_logic_vector(2 downto 0);
		   consumption : out consumption_type := cons_zero);
end entity;

architecture structural of automat_implementare1 is


	signal inpt,inld,qa,qb,qc,a,b,c: std_logic;
	signal net1, net2, net3 : std_logic;
	signal bn,qan,qbn: std_logic;
	
	signal cons : consumption_type_array (1 to 10) := ( others => (0.0,0.0,0.0));
	Constant VCC : real := 5.0;
begin

	U0:entity work.num74163(Behavioral) generic map(delay => 1 ns, Cload => 5.0e-12) port map (clk=>clk, clrn=>clrn, loadn=>inld, p => inpt, t => inpt, d=>'0', c=>c, b=>b, a=>a, qd => open, qc=>qc, qb=>qb, qa=>qa, VCC => VCC, consumption => cons(10));

	--C
	U1:entity work.mux4_1(Behavioral) generic map(delay => 1 ns, Cload => 5.0e-12) port map(I(0)=>'0',I(1)=>qan, I(2)=>'0', I(3)=>'0',A(1)=>qc, A(0)=>qb, Y=>c, VCC => VCC,  consumption => cons(1));

	--B
	U2: b<='0';

	--A
	U3: a<=qbn;

	--LD
	U4: or_gate generic map(delay => 1.2 ns, Cload => 5.0e-12) port map (a=>bn, b=>qa,y=>net1, VCC => VCC, consumption => cons(2));
	U5:entity work. mux4_1(Behavioral) generic map(delay => 1.5 ns, Cload => 5.0e-12) port map(I(0)=>'1', I(1)=>'0', I(2)=>bn, I(3)=>'0', A(1)=>qc, A(0)=>qb, Y=>inld, VCC => VCC, consumption => cons(3));

	--PT
	U6: or_gate generic map(delay => 1.5 ns, Cload => 5.0e-12)  port map (a=>ina, b=>qa,y=>net2, VCC => VCC, consumption => cons(4));
	U7: or_gate generic map(delay => 1 ns, Cload => 5.0e-12)  port map (a=>ina, b=>qan, y=>net3, VCC => VCC, consumption => cons(5));
	U8:entity work.mux4_1(Behavioral) generic map(Cload =>0.0e-12) port map (I(0)=>net2, I(1)=>'0', I(2)=>net3, I(3)=>'0',A(1)=>qc, A(0)=>qb, Y=>inpt, VCC => VCC, consumption => cons(6));
	--U8:entity work.mux4_1(Behavioral) generic map(Cload =>0.0e-12) port map (I(0)=>ina, I(1)=>'0', I(2)=>ina, I(3)=>'0',A(1)=>qc, A(0)=>qb, Y=>inpt, consumption => cons(6));

	--inv--
	U10:inv_gate generic map(delay => 1.1 ns, Cload => 5.0e-12) port map (a=>inb, y=>bn, VCC => VCC,  consumption => cons(7));
	U11:inv_gate generic map(delay => 1.2 ns, Cload => 5.0e-12) port map (a=>qa, y=>qan, VCC => VCC, consumption => cons(8));
	U12:inv_gate generic map(delay => 1.3 ns, Cload => 5.0e-12) port map (a=>qb, y=>qbn, VCC => VCC, consumption => cons(9));
	
	state<= qc & qb & qa;

	U13 : sum_up generic map (N=>10) port map (cons => cons, consumption => consumption);
	
end architecture;	

--------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity automat_implementare2 is 
	port ( clk, clrn, ina, inb: in std_logic;
	       state:out std_logic_vector(2 downto 0);
		   consumption : out consumption_type := cons_zero);
end entity;

architecture structural of automat_implementare2 is

	signal d2, d1, d0 : std_logic;
	signal q2, q1, q0 : std_logic;
	signal q2n, q1n, q0n : std_logic;
	signal p : std_logic_vector(1 to 7);
	signal inan,inbn : std_logic;
	signal cons : consumption_type_array (1 to 15) := ( others => (0.0,0.0,0.0));
	Constant VCC : real := 5.0;
begin
	-- D flip flops
	DFF0 : dff generic map (delay => 2 ns) port map (CP => clk, SDn => '1', RDn => clrn, d => D0, Q => Q0, Qn => Q0n, Vcc => Vcc, consumption => cons(1));
	DFF1 : dff generic map (delay => 1.2 ns) port map (CP => clk, SDn => '1', RDn => clrn, d => D1, Q => Q1, Qn => Q1n, Vcc => Vcc, consumption => cons(2));
	DFF2 : dff generic map (delay => 1 ns) port map (CP => clk, SDn => '1', RDn => clrn, d => D2, Q => Q2, Qn => Q2n, Vcc => Vcc, consumption => cons(3));
	-- inverters
	I1 : inv_gate port map ( a => ina, y => inan,Vcc => Vcc, consumption => cons(4));
	I2 : inv_gate port map ( a => inb, y => inbn,Vcc => Vcc, consumption => cons(5));
	-- products
	A1 : and3_gate port map ( a => Q2n, b => q1, c=> Q0n, y => p(1), Vcc => Vcc, consumption => cons(6));
	A2 : and3_gate port map ( a => Q1n, b => q0, c=> ina, y => p(2), Vcc => Vcc, consumption => cons(7));
	A3 : and3_gate port map ( a => Q1n, b => q0n, c=> ina, y => p(3), Vcc => Vcc, consumption => cons(8));
	A4 : and3_gate port map ( a => Q2n, b => q1n, c=> Q0, y => p(4), Vcc => Vcc, consumption => cons(9));
	A5 : and3_gate port map ( a => Q2, b => q1n, c=> inan, y => p(5), Vcc => Vcc, consumption => cons(10));
	A6 : and3_gate port map ( a => Q2, b => q1n, c=> inbn, y => p(6), Vcc => Vcc, consumption => cons(11));
	A7 : and3_gate port map ( a => Q2, b => q1n, c=> Q0n, y => p(7), Vcc => Vcc, consumption => cons(12));
	--sums
	O1: or3_gate port map (a => p(1), b => p(6), c => p(7) , y=> d2, Vcc => Vcc, consumption => cons(13));
	O2: or_gate port map (a => p(2), b => p(4), y=> d1, Vcc => Vcc, consumption => cons(14));
	O3: or_gate port map (a => p(3), b => p(5), y=> d0, Vcc => Vcc, consumption => cons(15));
	-- output
	state<= q2 & q1 & q0;
	-- pragma synthesis_off
	U13 : sum_up generic map (N=>15) port map (cons => cons, consumption => consumption);
	-- pragma synthesis_on

end architecture;	

--------------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;

entity automat_referinta is
port( clk, clrn , ina , inb : in std_logic;
	state_ref: out std_logic_vector(2 downto 0));
	
end entity;

architecture behavior of automat_referinta is
  signal current_state , next_state:std_logic_vector(2 downto 0);

begin
reg: process (CLK)
	begin
	if (clrn = '0') then
		current_state <= "000";
	elsif rising_edge(CLK) then
		current_state <= next_state;
	end if;
end process;

sel:process (current_state,ina,inb)
begin
	case current_state is
		when "000" => if ina ='1' then
				next_state<= "001";
			else
				next_state<= "000";
			end if;

		when "001" => next_state<= "010";

		when "010" => next_state<= "100";

		when "100" => if inb='1' then
				next_state<="001";
				else
				next_state<="101";
				end if;

		when "101" => if ina = '0' then
				next_state<= "101";
				else
				next_state<= "110";
				end if;
		when "110" => next_state <="000";
		when others => next_state <= "000";
	end case;
end process;

state_ref<= current_state;

end behavior ;	