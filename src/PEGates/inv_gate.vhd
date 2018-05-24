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

use work.PElib.all;

entity inv_gate is
    Generic (delay : time :=1 ns;
             Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacities
             Icc : real := 2.0e-6 -- questient current at room temperature  
             );
    Port ( a : in STD_LOGIC;
           y : out STD_LOGIC;
           consumption: out consumption_type := (0.0,0.0));
end inv_gate;

architecture primitive of inv_gate is

    signal internal : std_logic;

begin
    -- behavior
    internal <= not a after delay;
    y<=internal;
	-- consumption monitoring
	-- pragma synthesis_off
	cm_i : consumption_monitor generic map ( N=>1, M=>1, Cpd =>Cpd, Cin => Cin, Cload => Cload, Icc=>Icc)
		port map (sin(0) => a, sout(0) => internal, consumption => consumption);
	-- pragma synthesis_on
	
end primitive;