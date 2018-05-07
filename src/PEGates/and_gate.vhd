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
use xil_defaultlib.PElib.all;

entity and_gate is
    Generic (delay : time := 1 ns;
             Cpd: real := 20.0e-12; --power dissipation capacity
             Icc : real := 1.0e-6; -- questient current at room temperature  
             pe_on : boolean := true );
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC;
           consumption : out consumption_type := (0.0,0.0) );
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
     --amon3: activity_monitor port map (signal_in => internal, activity => act3);
     act3 <=0;
	 consumption_estimation_on: if pe_on generate 
        consumption.dynamic <= real(act1 + act2 + act3) * Cpd * Vcc;
        consumption.static <= Vcc * Icc;
     end generate;    
    --- consumption monitoring

end primitive;
