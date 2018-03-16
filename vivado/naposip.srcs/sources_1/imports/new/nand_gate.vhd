----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: And gate with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   a, b - std_logic (1 bit)
--              - outputs : y - a nand b
--                          activity : number of commutations (used to compute power dissipation)
-- Dependencies: none
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nand_gate is
    Generic (delay : time := 1 ns);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC;
           activity: out natural := 0);
end nand_gate;

architecture primitive of nand_gate is

    component activity_monitor is
        Port ( signal_in : in STD_LOGIC;
               activity : out natural);
    end component;
    signal internal : std_logic;
    
begin
    -- behavior
    internal <= a nand b after delay;
    y <= internal;
    --+ activity monitoring
    -- for simulation only
    -- could be removed for syntesiz
    energy: activity_monitor port map (signal_in => internal, activity => activity);
    --- activity monitoring

end primitive;
