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
			Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacities
			Icc : real := 1.0e-6 -- questient current at room temperature  
            ); -- set pe_on false to be ignored by synthesizer
    Port ( a,b,c,d,e : in STD_LOGIC;
           y : out STD_LOGIC;
           consumption: out consumption_type);
end and5_gate;

architecture Behavioral of and5_gate is

	signal internal: std_logic;

begin
    internal <= a and b and c and d and e after delay;
    y <= internal; 
    --+ consumption monitoring - this section is intednded only for simulation
	-- pragma synthesis_off
	cm_i : consumption_monitor generic map ( N=>5, M=>1, Cpd =>Cpd, Cin => Cin, Cload => Cload, Icc=>Icc)
		port map (sin(0) => a, sin(1) => b, sin(2) => c, sin(3) => d, sin(4) => e, sout(0) => internal, consumption => consumption);
	-- pragma synthesis_on
    --- consumption monitoring
end Behavioral;
