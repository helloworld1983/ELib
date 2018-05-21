----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: Nand9 gate with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   x(i), i=(0:8)
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

entity nand9_gate is
    Generic (delay : time :=1 ns;
             Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
             Icc : real := 1.0e-6 -- questient current at room temperature
			 );
    Port ( x : in STD_LOGIC_VECTOR(8 downto 0);
           y : out STD_LOGIC;
           consumption: out consumption_type);
end nand9_gate;

architecture Behavioral of nand9_gate is

 signal internal : STD_LOGIC;
 type en_t is array (0 to 9 ) of natural;
 signal en : en_t;
 signal sum : natural:=0;
begin

	internal <= x(0) and x(1) and x(2) and x(3) and x(4) and x(5) and x(6) and x(7) and x(8) after delay;
	y <= not internal;

    --+ consumption monitoring - this section is intednded only for simulation
	-- pragma synthesis_off
	cm_i : consumption_monitor generic map ( N=>9, M=>1, Cpd =>Cpd, Cin => Cin, Cload => Cload, Icc=>Icc)
		port map (sin=> x, sout(0) => internal, consumption => consumption);
	-- pragma synthesis_on
    --- consumption monitoring

end Behavioral;
