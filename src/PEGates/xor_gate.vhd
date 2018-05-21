----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: xor gate with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   a, b - std_logic (1 bit)
--              - outputs : y - a xor b
--                          consumption :  port to monitor dynamic xor static consumption
-- Dependencies: PElib.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.PElib.all;

entity xor_gate is
    Generic (delay : time := 1 ns;
             Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
             Icc : real := 1.0e-6 -- questient current at room temperature  
             );
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC;
           consumption : out consumption_type := (0.0,0.0) );
end xor_gate;

architecture primitive of xor_gate is

    signal internal : std_logic;
    
begin
    -- behavior
    internal <= a xor b after delay;
    y <= internal;
    --+ consumption monitoring - this section is intednded only for simulation
	-- pragma synthesis_off
	cm_i : consumption_monitor generic map ( N=>2, M=>1, Cpd =>Cpd, Cin => Cin, Cload => Cload, Icc=>Icc)
		port map (sin(0) => a, sin(1) => b, sout(0) => internal, consumption => consumption);
	-- pragma synthesis_on
    --- consumption monitoring

end primitive;
