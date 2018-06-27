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

library work;
use work.PElib.all;

entity inv_gate is
   Generic (delay : time :=1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload: real := 5.0 -- capacitive load
				 );
     Port ( a : in STD_LOGIC;
            y : out STD_LOGIC;
            Vcc : in real ; -- supply voltage
		    consumption : out consumption_type := (0.0,0.0)
		    );
end inv_gate;

architecture primitive of inv_gate is
    signal internal : std_logic;
begin
    -- behavior
    internal <= not a after delay;
    y<=internal;
	-- consumption monitoring
	-- pragma synthesis_off
	cm_i : consumption_monitor generic map ( N=>1, M=>1, logic_family => logic_family, gate => gate, Cload => Cload)
		port map (sin(0) => a, Vcc => Vcc,  sout(0) => internal, consumption => consumption);
	-- pragma synthesis_on
	
end primitive;