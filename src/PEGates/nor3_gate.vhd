----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: nor3 gate with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   a,b,c
--              - outputs : y 
--              - consumption :  port to monitor dynamic and static consumption
-- Dependencies: none
-- 
-- Revision: 1.0 - Botond Snoror Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PElib.all;

entity nor3_gate is
    Generic (delay : time := 1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload : real := 5.0 -- capacitive load
             );
		Port ( a,b,c : in STD_LOGIC;
			   y : out STD_LOGIC;
			   Vcc : in real ; -- supply voltage
		       consumption : out consumption_type := (0.0,0.0)
		       );
end nor3_gate;

architecture Behavioral of nor3_gate is

signal internal: std_logic;


begin
	internal <= not (a or b or c) after delay;
	y <= internal;
    --+ consumption monitoring - this section is intednded only for simulation
	-- pragma synthesis_off
	cm_i : consumption_monitor generic map ( N=>3, M=>1, logic_family => logic_family, gate => gate, Cload => Cload)
		port map (sin(0) => a, sin(1) => b, sin(2) => c, Vcc => Vcc, sout(0) => internal, consumption => consumption);
	-- pragma synthesis_on
    --- consumption monitoring
	
end Behavioral;
