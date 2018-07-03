library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PELib.all;
use work.PEGates.all;

entity dff is
	Generic (delay : time := 1 ns;
	         active_edge : boolean := FALSE;
		     logic_family : logic_family_t; -- the logic family of the component
		     gate : component_t; -- the type of the component
			 Cload : real := 5.0 -- capacitive load    
			);
    Port ( CP, D, Rdn, SDn : in STD_LOGIC;
		   Q, Qn : out STD_LOGIC;
           Vcc : in real ; --supply voltage
		   consumption : out consumption_type := (0.0,0.0)
		  );
end entity;

architecture Structural of dff is
	signal RD, SD, Dn, Dnn: std_logic;
	signal C, Cn : std_logic;
	signal t1, t2 : std_logic;
	signal nor1, nor2, nor3, nor4 : std_logic;
	signal cons : consumption_type_array(1 to 16);
	--signal cons : consumption_type;

begin
	
	inv1: inv_gate generic map (delay => 0 ns, logic_family => logic_family, gate => inv_comp) port map (a => d, Vcc => Vcc, y => dn, consumption => cons(1));  --dn <= not d;
	inv2: inv_gate generic map (delay => 0 ns, logic_family => logic_family, gate => inv_comp) port map (a => dn, Vcc => Vcc, y => dnn, consumption => cons(2));  --dnn <= not dn;
	inv3: inv_gate generic map (delay => 0 ns, logic_family => logic_family, gate => inv_comp) port map (a => sdn, Vcc => Vcc, y => SD, consumption => cons(3));   --SD <= not sdn;
	inv4: inv_gate generic map (delay => 0 ns, logic_family => logic_family, gate => inv_comp) port map (a => rdn, Vcc => Vcc, y => RD, consumption => cons(4));    --RD <= not rdn;
	inv5: inv_gate generic map (delay => 0 ns, logic_family => logic_family, gate => inv_comp) port map (a => CP, Vcc => Vcc, y => Cn, consumption => cons(5));  --Cn <= not CP;
	inv6: inv_gate generic map (delay => 0 ns, logic_family => logic_family, gate => inv_comp) port map (a => Cn, Vcc => Vcc, y => C, consumption => cons(6));  --C <= not Cn;
	
	tristate1: tristate_buf generic map (delay => 0 ns, logic_family => logic_family, gate => tristate_comp) port map (a => dnn, en => C,  Vcc => Vcc, y => t1, consumption => cons(7)); --t1 <= 'Z' when C = '1' else dnn;
	tristate2: tristate_buf generic map (delay => 0 ns, logic_family => logic_family, gate => tristate_comp) port map (a => nor1, en => Cn,  Vcc => Vcc, y => t1, consumption => cons(8)); --t1 <= 'Z' when Cn = '1' else nor1;
	
	nor_gate1: nor_gate generic map (delay => delay, logic_family => logic_family, gate => nor_comp) port map ( a => t1, b => SD, y => nor2, Vcc => Vcc, consumption => cons(9));  --nor2 <= (t1 nor SD)  after delay;
	nor_gate2: nor_gate generic map (delay => 0 ns, logic_family => logic_family, gate => nor_comp) port map ( a => nor2, b => RD, y => nor1, Vcc => Vcc, consumption => cons(10)); --	nor1 <= nor2 nor RD;
	
	tristate3: tristate_buf generic map (delay => 0 ns, logic_family => logic_family, gate => tristate_comp) port map (a => nor3, en => C,  Vcc => Vcc, y => t2, consumption => cons(11));   --t2 <= 'Z' when C = '1' else nor3;
    tristate4: tristate_buf generic map (delay => 0 ns, logic_family => logic_family, gate => tristate_comp) port map (a => nor2, en => Cn,  Vcc => Vcc, y => t2, consumption => cons(12));  --t2 <= 'Z' when Cn = '1' else nor2;
    
    nor_gate3: nor_gate generic map (delay => delay, logic_family => logic_family, gate => nor_comp) port map ( a => t2, b => RD, y => nor4, Vcc => Vcc, consumption => cons(13));  --	nor4 <= (t2  nor RD) after delay;
    nor_gate4: nor_gate generic map (delay => 0 ns, logic_family => logic_family, gate => nor_comp) port map ( a => nor4, b => SD, y => nor3, Vcc => Vcc, consumption => cons(14)); --	nor3 <= nor4 nor SD;

    inv7: inv_gate generic map (delay => delay, logic_family => logic_family, gate => inv_comp) port map (a => nor4, Vcc => Vcc, y => Qn, consumption => cons(15));  --	Qn <= not nor4 after delay;
	inv8: inv_gate generic map (delay => delay, logic_family => logic_family, gate => inv_comp) port map (a => t2, Vcc => Vcc, y => Q, consumption => cons(16));  --	Q <= not t2 after delay;

    sum : sum_up generic map (N => 16) port map (cons => cons, consumption => consumption);
	
	-- cm_i: consumption_monitor generic map ( N => 12, M => 2, logic_family => logic_family, gate => none_comp, Cload => Cload)
			-- port map (
			-- sin(0) => dn,
			-- sin(1) => dnn,
			-- sin(2) => SD,
			-- sin(3) => RD,
			-- sin(4) => Cn,
			-- sin(5) => C,
			-- sin(6) => t1,
			-- sin(7) => nor1,
			-- sin(8) => nor2,
			-- sin(9) => t2,
			-- sin(10) => nor3,
			-- sin(11) => nor4,
			-- sout(0) => nor4,
			-- sout(1) => t2,
			--consumption => cons);
	
end architecture;