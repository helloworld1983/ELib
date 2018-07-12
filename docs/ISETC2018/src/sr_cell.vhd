----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: SR Ring Oscillator with activity monitoring
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   start - enables the ring osccilator
--              - outputs : CLK - three phase of the clock signal
--                          consumption :  port to monitor dynamic and static consumption
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: inv_gate.vhd, nand_gate.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PElib.all;
use work.PEGates.all;
use work.Nbits.all;

entity sr_cell is
    Generic (delay : time :=10 ns;
            logic_family : logic_family_t := HC; -- the logic family of the component
           --gate : component_t; -- the type of the component
           Cload: real := 5.0 -- capacitive load
           );
    Port ( 
           start : in STD_LOGIC;
           CLK : out STD_LOGIC_VECTOR (0 to 2);
           Vcc : in real := 5.0 ; --supply voltage
           consumption : out consumption_type := (0.0,0.0));
end sr_cell;

architecture Behavioral of sr_cell is

    signal net: STD_LOGIC_VECTOR (1 to 6) := "010101";
    --consumption monitoring
    signal cons : consumption_type_array(1 to 3) := (others => (0.0,0.0));
    
begin



latch1: latchSR generic map (delay => delay, logic_family => logic_family) port map (S => net(5), R => net(6), Q => net(1), Qn => net(2), Vcc => Vcc, consumption => cons(1));
latch2: latchSR generic map (delay => delay, logic_family => logic_family) port map (S => net(1), R => net(2), Q => net(3), Qn => net(4), Vcc => Vcc, consumption => cons(2));
latch3: latchSR generic map (delay => delay, logic_family => logic_family) port map (S => net(3), R => net(4), Q => net(5), Qn => net(6), Vcc => Vcc, consumption => cons(3));

CLK(0) <= net(2);
CLK(0) <= net(4);
CLK(0) <= net(5);

sum : sum_up generic map (N => 3) port map (cons => cons, consumption => consumption);

end Behavioral;
