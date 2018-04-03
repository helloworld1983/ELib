----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: And gate with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   a, b - std_logic (1 bit)
--              - outputs : y - and b
--                          consumption :  port to monitor dynamic and static consumption
-- Dependencies: none
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.util.all;

entity and_gate is
    Generic (delay : time := 1 ns;
             parasitic_capacity : real := 1.0e-12;
             area : real := 1.0e-9);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC;
           consumption : out consumption_monitor_type);
end and_gate;

architecture primitive of and_gate is

    signal internal : std_logic;
    signal act1, act2, act3 : natural;
    
begin
    -- behavior
    internal <= a and b after delay;
    y <= internal;
    --+ consumption monitoring
    -- for simulation only
    -- could be removed for synthezis
     amon1: activity_monitor port map (signal_in => a, activity => act1);
     amon2: activity_monitor port map (signal_in => b, activity => act2);
     amon3: activity_monitor port map (signal_in => internal, activity => act3);
     consumption.dynamic <= real(act1 + act2 + act3) * parasitic_capacity * Vdd;
     consumption.static <= Area * Ileackage;    
    --- consumption monitoring

end primitive;
