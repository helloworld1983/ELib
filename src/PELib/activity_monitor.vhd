----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description: activity_monitor is detecting the transitions of a node .
--				(the number of times a capacitor is charged/discharged)
-- Dependencies: none
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity activity_monitor is
    Port ( signal_in : in STD_LOGIC;
           activity : out natural := 0);
end activity_monitor;

architecture Behavioral of activity_monitor is
signal NrOFTransitions: natural := 0;
begin
energy_counter : process(signal_in)               
                begin
                    NrOFTransitions <= NrOFTransitions + 1;
                end process; 
    activity <= NrOFTransitions; 
end Behavioral;
