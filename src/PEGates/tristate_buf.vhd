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

entity tristate_buf is
    Generic (delay : time :=1 ns;
			 logic_family : logic_family_t; -- the logic family of the component
			 gate : component_t; -- the type of the component
			 Cload : real := 0.0; -- capacitive load and supply voltage
			 Vcc : real := 5.0 -- capacitive load and supply voltage 
			);
    Port ( a, en : in STD_LOGIC;
           y : out STD_LOGIC;
           Vcc : real ; 
		 consumption : out consumption_type := (0.0,0.0));
end tristate_buf;

architecture primitive of tristate_buf is

    signal internal : std_logic;
    signal act1, act2, act3 : natural;
begin
    -- behavior
    internal <= a after delay when en = '1' else 'Z' after delay ;
    y<=internal;
    --+ consumption monitoring - this section is intednded only for simulation
	-- pragma synthesis_off
	cm_i : consumption_monitor generic map ( N=>2, M=>1, logic_family => logic_family, gate => gate, Cload => Cload)
		port map (sin(0) => a, sin(1) => en, sout(0) => internal, consumption => consumption);
	-- pragma synthesis_on
    --- consumption monitoring
end primitive;