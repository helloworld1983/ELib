----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: or4 gate with activity monitoring 
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
use xil_defaultlib.PElib.all;

entity or4_gate is
    Generic (delay : time :=1 ns;
			Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
			Icc : real := 2.0e-6 -- questient current at room temperature  
             );
    Port ( a,b,c,d : in STD_LOGIC;
            y: out STD_LOGIC;
            consumption: out consumption_type := (0.0,0.0));
end or4_gate;

architecture Behavioral of or4_gate is

	signal internal: std_logic;

begin

    internal <= a or b or c or d after delay;
    y <= internal;
   
    --+ consumption monitoring - this section is intednded only for simulation
	-- pragma synthesis_off
	cm_i : consumption_monitor generic map ( N=>4, M=>1, Cpd =>Cpd, Cin => Cin, Cload => Cload, Icc=>Icc)
		port map (sin(0) => a, sin(1) => b, sin(2) => c, sin(3) => d, sout(0) => internal, consumption => consumption);
	-- pragma synthesis_on
    --- consumption monitoring
end Behavioral;
