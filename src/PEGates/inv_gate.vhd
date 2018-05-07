----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: Delay cell with activity monitoring 
--              -  the smallest delay in CMOS is an inverter gate
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   a - std_logic (1 bit)
--              - outputs : y - not a
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

entity inv_gate is
    Generic (delay : time :=1 ns;
             Cpd: real := 20.0e-12; --power dissipation capacity
             Icc : real := 2.0e-6; -- questient current at room temperature  
             pe_on : boolean := true );
    Port ( a : in STD_LOGIC;
           y : out STD_LOGIC;
           consumption: out consumption_type := (0.0,0.0));
end inv_gate;

architecture primitive of inv_gate is

    signal internal : std_logic;
    signal act1, act2 : natural;
begin
    -- behavior
    internal <= not a after delay;
    y<=internal;
    --+ consumption monitoring
    -- for simulation only
    -- could be removed for syntezis
     amon1 : activity_monitor port map (signal_in => a, activity => act1);
     --amon2 : activity_monitor port map (signal_in => internal, activity => act2);
	 act2 <= 0;
     consumption_estimation_on: if pe_on generate 
        consumption.dynamic <= real(act1 + act2) * Cpd * Vcc * Vcc;
        consumption.static <= Vcc * Icc;
     end generate;
    --- consumption monitoring
end primitive;