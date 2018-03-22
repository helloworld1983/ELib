----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: And4 gate with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   a,b,c,d
--              - outputs : y 
--              - consumption :  port to monitor dynamic and static consumption
-- Dependencies: none
-- 
-- Revision: 1.0 - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.util.all;

entity and4_gate is
    Generic (delay : time := 1 ns;
            parasitic_capacity : real := 1.0e-12;
            area : real := 1.0e-9);
    Port ( a,b,c,d : in STD_LOGIC;
           y : out STD_LOGIC;
           consumption: out consumption_monitor_type);
end and4_gate;

architecture Behavioral of and4_gate is

signal internal: std_logic;
signal en1,en2,en3,en4,en5 : natural;

begin

internal <= a and b and c and d after delay;
y <= internal;

amon1 : activity_monitor port map (signal_in => a, activity => en1);
amon2 : activity_monitor port map (signal_in => b, activity => en2);
amon3 : activity_monitor port map (signal_in => c, activity => en3);
amon4 : activity_monitor port map (signal_in => d, activity => en4);
amon5 : activity_monitor port map (signal_in => internal, activity => en5);

consumption.dynamic <= real(en1+en2+en3+en4+en5) * parasitic_capacity * Vdd * Vdd;
consumption.static <= Area * Ileackage;

end Behavioral;
