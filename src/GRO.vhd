----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: Gated Ring Oscillator with activity monitoring
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   start - enables the ring osccilator
--              - outputs : CLK - three phase of the clock signal
--                          consumption :  port to monitor dynamic and static consumption
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: PEcode.vhd, PEGates.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all;

entity GRO is
    Generic (delay : time :=1 ns;
            logic_family : logic_family_t := default_logic_family; -- the logic family of the component
           Cload: real := 5.0 -- capacitive load
           );
    Port ( start : in STD_LOGIC;
           CLK : out STD_LOGIC_VECTOR (0 to 2);
           Vcc : in real ; --supply voltage
           consumption : out consumption_type := cons_zero);
end GRO;

architecture Structural of GRO is
    
    signal net: STD_LOGIC_VECTOR (0 to 2);
    --consumption monitoring
    signal cons : consumption_type_array(1 to 3);
 
begin
    nand_1: nand_gate generic map (delay => delay) port map (a => start, b => net(2), y => net(0),Vcc => Vcc, consumption => cons(1));
    inv_1: inv_gate generic map (delay => delay) port map (a => net(0), y => net(1), Vcc => Vcc, consumption => cons(2));
    inv_2: inv_gate generic map (delay => delay) port map (a => net(1), y => net(2), Vcc => Vcc, consumption => cons(3));
    CLK <= net;
    --+ consumption monitoring
    -- for behavioral simulation only
    sum : sum_up generic map (N => 3) port map (cons => cons, consumption => consumption);
    -- for simulation only

end Structural;
