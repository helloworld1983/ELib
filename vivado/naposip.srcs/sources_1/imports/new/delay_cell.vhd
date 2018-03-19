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
use xil_defaultlib.util.all;

entity delay_cell is
    Generic (delay : time :=1 ns;
             parasitic_capacity : real := 1.0e-12;
             area : real := 1.0e-9);
    Port ( a : in STD_LOGIC;
           y : out STD_LOGIC;
           consumption: out consumption_monitor_type);
end delay_cell;

architecture primitive of delay_cell is

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
     amon2 : activity_monitor port map (signal_in => internal, activity => act2);
     consumption.dynamic <= real(act1 + act2) * parasitic_capacity * Vdd * Vdd;
     consumption.static <= Area * Ileackage;
    --- consumption monitoring
end primitive;