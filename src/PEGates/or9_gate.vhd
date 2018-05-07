----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: or9 gate with activity monitoring 
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

entity or9_gate is
    Generic (delay : time :=1 ns;
             Cpd: real := 48.0e-12; --power dissipation capacity
             Icc : real := 2.0e-6; -- questient current at room temperature
			 pe_on : boolean := true);
    Port ( x : in STD_LOGIC_VECTOR(8 downto 0);
           y : out STD_LOGIC;
           consumption: out consumption_type);
end or9_gate;

architecture Behavioral of or9_gate is

 signal internal1: STD_LOGIC;
 type en_t is array (0 to 9 ) of natural;
 signal en : en_t;
 signal sum : natural:=0;
begin

	internal <= x(0) or x(1) or x(2) or x(3) or x(4) or x(5) or x(6) or x(7) or x(8) after delay;
	y <= internal;

	amon0: activity_monitor port map (signal_in => x(0), activity => en(0));
	amon1: activity_monitor port map (signal_in => x(1), activity => en(1));
	amon2: activity_monitor port map (signal_in => x(2), activity => en(2));
	amon3: activity_monitor port map (signal_in => x(3), activity => en(3));
	amon4: activity_monitor port map (signal_in => x(4), activity => en(4));
	amon5: activity_monitor port map (signal_in => x(5), activity => en(5));
	amon6: activity_monitor port map (signal_in => x(6), activity => en(6));
	amon7: activity_monitor port map (signal_in => x(7), activity => en(7));
	amon8: activity_monitor port map (signal_in => x(8), activity => en(8));
	--amon9: activity_monitor port map (signal_in => internal, activity => en(9));
	en(9) <= 0;
	process(en)
	  begin
	   label1: for I in 0 to 9 loop
					sum <= (sum + en(I));
			 end loop;
	end process;

	consumption_estimation_on: if pe_on generate 
		consumption.dynamic <= real(sum) * Cpd * Vcc * Vcc;
		consumption.static <= Vcc * Icc; 
	end generate;

end Behavioral;
