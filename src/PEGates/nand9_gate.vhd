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

library work;
use work.PElib.all;

entity nand9_gate is
   Generic (delay : time :=1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload: real := 5.0 -- capacitive load 
             );
		Port ( x : in STD_LOGIC_VECTOR(8 downto 0);
			   y : out STD_LOGIC;
			   Vcc : in real ; -- supply voltage
		       consumption : out consumption_type := (0.0,0.0)
		       );
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
	cm_i : consumption_monitor generic map ( N=>9, M=>1, logic_family => logic_family, gate => gate, Cload => Cload)
		port map (sin => x, Vcc => Vcc, sout(0) => internal, consumption => consumption);
	-- pragma synthesis_on
    --- consumption monitoring

end Behavioral;
