----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: And5 gate with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   a,b,c,d,e
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
use xil_defaultlib.PElib.all;

entity and5_gate is
    Generic (delay : time := 1 ns;
			Cpd: real := 20.0e-12; --power dissipation capacity
			Icc : real := 1.0e-6; -- questient current at room temperature  
             pe_on : boolean := true );
    Port ( a,b,c,d,e : in STD_LOGIC;
           y : out STD_LOGIC;
           consumption: out consumption_type);
end and5_gate;

architecture Behavioral of and5_gate is

signal internal: std_logic;
signal en1,en2,en3,en4,en5, en6 : natural;

begin
    internal <= a and b and c and d and e after delay;
    y <= internal; 
    
    amon1 : activity_monitor port map (signal_in => a, activity => en1);
    amon2 : activity_monitor port map (signal_in => b, activity => en2);
    amon3 : activity_monitor port map (signal_in => c, activity => en3);
    amon4 : activity_monitor port map (signal_in => d, activity => en4);
    amon5 : activity_monitor port map (signal_in => e, activity => en5);
    --amon6 : activity_monitor port map (signal_in => internal, activity => en6);
    en6 <= 0;
    consumption_estimation_on: if pe_on generate 
        consumption.dynamic <= real(en1+en2+en3+en4+en5+en6) * Cpd * Vcc * Vcc;
        consumption.static <= Vcc * Icc;
    end generate;
end Behavioral;
