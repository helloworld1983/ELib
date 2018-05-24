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

use work.PELib.all;
use work.PEGates.all;

entity mux2_1 is
    Generic (delay : time := 1 ns;
            Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
            Icc : real := 2.0e-6 -- questient current at room temperature  
            );
    Port ( I : in STD_LOGIC_VECTOR (0 to 1);
           A : in STD_LOGIC;
           Y : out STD_LOGIC;
           consumption : out consumption_type := (0.0,0.0));
end mux2_1;

architecture Behavioral of mux2_1 is
      signal addr : STD_LOGIC;
      signal internal: STD_LOGIC;
begin

addr <= A;
internal <= I(0) when addr = '0'
       else I(1) when addr = '1';
Y <= internal;

cm_i : consumption_monitor generic map ( N=>2, M=>1, Cpd =>Cpd, Cin => Cin, Cload => Cload, Icc=>Icc)
		port map (sin(0) => I(0), sin(1) => I(1), sout(0) => internal, consumption => consumption);

end Behavioral;

architecture Structural of mux2_1 is

 signal net1,net2,net3: std_logic;
 signal c1,c2,c3,c4 : consumption_type;
begin

inv1: inv_gate generic map(delay => 0 ns) port map (a => A, y =>net1, consumption => c1 );
and1: and_gate generic map(delay => 0 ns) port map (a => net1, b => I(0), y => net2, consumption => c2 );
and2: and_gate generic map(delay => 0 ns) port map (a => A, b => I(1), y => net3, consumption => c3 );
or1: or_gate generic map(delay => 0 ns) port map (a => net2, b => net3, y => Y, consumption => c4 );
consumption <= (c1 + c2 + c3 + c4);
end Structural;
