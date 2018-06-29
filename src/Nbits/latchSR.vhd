----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description: SR type latch with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   S - set, active logic '0'
--                          R - reset, active logic '0' 
--              - outputs : Q, Qn - 
--                          consumption :  port to monitor dynamic and static consumption
-- Dependencies: nand_gate.vhd, Nbits.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PEGates.all; 
use work.PELib.all;

entity latchSR is

    Generic(delay : time := 1 ns);
    Port ( S : in STD_LOGIC;
           R : in STD_LOGIC;
           Q, Qn : inout STD_LOGIC;
           consumption : out consumption_type := (0.0,0.0));
end latchSR;

architecture Strcutural of latchSR is

    signal cons : consumption_type_array(1 to 2) := (others => (0.0,0.0)); 

begin

    nand_gate1_1 : nand_gate generic map (delay => delay) port map ( a => Qn, b => S, y => Q, consumption =>cons(1));
    nand_gate1_2 : nand_gate generic map (delay => 0.1 ns) port map ( a => Q, b => r, y => Qn, consumption =>cons(2));
    --+ summing up consumptions
    -- pragma synthesis_off
	sum_up_i : sum_up generic map (N=>2) port map (cons => cons, consumption => consumption);
    -- pragma synthesis_on
end Strcutural;
