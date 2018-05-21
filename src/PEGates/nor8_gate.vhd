----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: Nor8 gate with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   x(i), i=(0:7)
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

entity nor8_gate is
    Generic (delay : time :=1 ns;
             Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
             Icc : real := 1.0e-6 -- questient current at room temperature  
             );
    Port ( x : in STD_LOGIC_VECTOR(7 downto 0);
           y : out STD_LOGIC;
           consumption: out consumption_type := (0.0,0.0));
end nor8_gate;

architecture Behavioral of nor8_gate is

	signal internal : STD_LOGIC;

begin

	internal <= x(0) or x(1) or x(2) or x(3) or x(4) or x(5) or x(6) or x(7) after delay;
	y <= not internal;
    --+ consumption monitoring - this section is intednded only for simulation
	-- pragma synthesis_off
	cm_i : consumption_monitor generic map ( N=>8, M=>1, Cpd =>Cpd, Cin => Cin, Cload => Cload, Icc=>Icc)
		port map (sin=> x, sout(0) => internal, consumption => consumption);
	-- pragma synthesis_on
    --- consumption monitoring

end Behavioral;
