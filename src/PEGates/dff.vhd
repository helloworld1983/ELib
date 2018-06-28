library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PELib.all;
use work.PEGates.all;

entity dff is
	Generic (delay : time := 1 ns;
		     logic_family : logic_family_t; -- the logic family of the component
		     gate : component_t; -- the type of the component
			 Cload : real := 0.0; -- capacitive load   
			 active_edge : std_logic := '0'
			);
    Port ( CP, D, Rdn, SDn : in STD_LOGIC;
		   Q, Qn : out STD_LOGIC;
           Vcc :in real ; --supply voltage
		 consumption : out consumption_type := (0.0,0.0));
end dff;

architecture Structural of dff is
	signal RD, SD, Dn, Dnn: std_logic;
	signal C, Cn : std_logic;
	signal t1, t2 : std_logic;
	signal nor1, nor2, nor3, nor4 : std_logic;
begin
	
	dn <= not d;
	dnn <= not dn;
	SD <= not sdn;
	RD <= not rdn;
	Cn <= not CP;
	C <= not Cn;
	--tristate buffer en => C, a => dnn, y => t1
	t1 <= 'Z' when C = active_edge else dnn;
	t1 <= 'Z' when Cn = active_edge else nor1;
	nor2 <= (t1 nor SD)  after delay;
	nor1 <= nor2 nor RD;
	t2 <= 'Z' when Cn = active_edge else nor2;
	t2 <= 'Z' when C = active_edge else nor3;
	nor4 <= (t2  nor RD) after delay;
	nor3 <= nor4 nor SD;
	Qn <= not nor4 after delay;
	Q <= not t2 after delay;
	
	--sum_up ...
	
	cm_i: consumption_monitor generic map ( N => 12, M => 2, logic_family => logic_family, gate => gate, Cload => Cload)
			port map (
			sin(0) => dn,
			sin(1) => dnn,
			sin(2) => SD,
			sin(3) => RD,
			sin(4) => Cn,
			sin(5) => C,
			sin(6) => t1,
			sin(7) => nor1,
			sin(8) => nor2,
			sin(9) => t2,
			sin(10) => nor3,
			sin(11) => nor4,
			sout(0) => nor4,
			sout(1) => t2,
			Vcc => Vcc,
			consumption => consumption);
	
end architecture;