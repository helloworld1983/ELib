----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: Multiplexor with 2 inputs and activity monitoring 
--              - inputs:   I(0:1) - std_logic_vector 
--              - address inputs: A-std_logic_vector 
--              - outputs : Y-std_logic
--              - consumption :  port to monitor dynamic and static consumption
-- Dependencies: inv_gate.vhd, and_gate.vhd, or_gate.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.PELib.all;
use work.PEGates.all;

entity mux2_1 is
    Generic (delay : time := 1 ns;
                logic_family : logic_family_t; -- the logic family of the component
                --gate : component_t; -- the type of the component
                Cload : real := 5.0 -- capacitive load 
               );
       Port ( I : in STD_LOGIC_VECTOR (0 to 1);
              A : in STD_LOGIC;
              Y : out STD_LOGIC;
              Vcc : in real ; -- supply voltage
              consumption : out consumption_type := (0.0,0.0)
              );
end mux2_1;

architecture Structural of mux2_1 is
	signal net1,net2,net3: std_logic;
	signal cons : consumption_type_array(1 to 4);
begin

	inv1: inv_gate generic map(delay => 0 ns, logic_family => logic_family, gate => inv_comp ) port map (a => A, Vcc => Vcc, y =>net1, consumption => cons(1) );
	and1: and_gate generic map(delay => 0 ns, logic_family => logic_family, gate => and_comp) port map (a => net1, b => I(0), Vcc => Vcc, y => net2, consumption => cons(2) );
	and2: and_gate generic map(delay => 0 ns, logic_family => logic_family, gate => and_comp) port map (a => A, b => I(1), Vcc => Vcc, y => net3, consumption => cons(3) );
	or1: or_gate generic map(delay => 0 ns, logic_family => logic_family, gate => or_comp) port map (a => net2, b => net3, Vcc => Vcc,  y => Y, consumption => cons(4) );
	sum : sum_up generic map (N => 3) port map (cons => cons, consumption => consumption);
end Structural;

-- architecture Behavioral of mux2_1 is
      -- signal addr : STD_LOGIC;
      -- signal internal: STD_LOGIC;
-- begin
	-- addr <= A;
	-- internal <= I(0) when addr = '0'
		   -- else I(1) when addr = '1';
	-- Y <= internal;

	-- cm_i : consumption_monitor generic map ( N=>3, M=>1, logic_family => logic_family, gate => gate, Cload => Cload)
            -- port map (sin(0) => I(0), sin(1) => I(1), sin(2) => addr, Vcc => Vcc , sout(0) => internal, consumption => consumption);

-- end Behavioral;


