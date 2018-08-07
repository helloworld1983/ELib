----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: SR Ring Oscillator with activity monitoring
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   start - enables the ring osccilator
--              - outputs : CLK - three phase of the clock signal
--                          consumption :  port to monitor dynamic and static consumption
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: PEcode.vhd, PEGates.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision: 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity sr_cell is
    Generic (delay : time :=1 ns;
            logic_family : logic_family_t := HC; -- the logic family of the component
           Cload: real := 5.0 -- capacitive load
           );
    Port ( 
           start : in STD_LOGIC;
           CLK : out STD_LOGIC_VECTOR (1 to 6);
           Vcc : in real := 5.0 ; --supply voltage
           consumption : out consumption_type := cons_zero);
end sr_cell;

architecture Behavioral of sr_cell is

    signal net: STD_LOGIC_VECTOR (1 to 6);
    --consumption monitoring
    signal cons : consumption_type_array(1 to 6) := (others => cons_zero);
    
begin


gate1: nand3_gate generic map (delay => delay, logic_family => logic_family) port map (a => '1' , b => net(5), c => net(2), y => net(1), Vcc => Vcc, consumption => cons(1));
gate2: nand3_gate generic map (delay => delay, logic_family => logic_family) port map (a => start , b => net(6), c => net(1), y => net(2), Vcc => Vcc, consumption => cons(2));
gate3: nand3_gate generic map (delay => delay, logic_family => logic_family) port map (a => start , b => net(1), c => net(4), y => net(3), Vcc => Vcc, consumption => cons(3));
gate4: nand3_gate generic map (delay => delay, logic_family => logic_family) port map (a => '1' , b => net(2), c => net(3), y => net(4), Vcc => Vcc, consumption => cons(4));
gate5: nand3_gate generic map (delay => delay, logic_family => logic_family) port map (a => '1' , b => net(3), c => net(6), y => net(5), Vcc => Vcc, consumption => cons(5));
gate6: nand3_gate generic map (delay => delay, logic_family => logic_family) port map (a => start , b => net(4), c => net(5), y => net(6), Vcc => Vcc, consumption => cons(6));

CLK <= net;

sum : sum_up generic map (N => 6) port map (cons => cons, consumption => consumption);

end Behavioral;
