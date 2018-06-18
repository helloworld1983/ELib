----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: Full adder flop with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   A, B - data bit
--                          Cin - input carry
--              - outputs : S - sum of A and B
--                          Cout - carry out
--                          consumption :  port to monitor dynamic and static consumption
-- Dependencies: nand_gate.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.PEGates.all; 
use xil_defaultlib.PELib.all;

entity FA is
    Generic (delay : time := 1ns );
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Cin : in STD_LOGIC;
           Cout : out STD_LOGIC;
           S : out STD_LOGIC;
           consumption : out consumption_type := (0.0,0.0));
end FA;

architecture Structural of FA is

    signal net: STD_LOGIC_VECTOR(0 to 6);
    signal cons : consumption_type_array(1 to 8) := (others => (0.0,0.0)); 

begin
    
    gate1: nand_gate generic map (delay => delay) port map (a => A, b=> B, y => net(0), consumption => cons(0));
    gate2: nand_gate generic map (delay => delay) port map (a => A, b=> net(0), y => net(1), consumption => cons(1));
    gate3: nand_gate generic map (delay => delay) port map (a => net(0), b=> B, y => net(2), consumption => cons(2));
    gate4: nand_gate generic map (delay => delay) port map (a => net(1), b=> net(2), y => net(3), consumption => cons(3));
    gate5: nand_gate generic map (delay => delay) port map (a => net(3), b=> Cin, y => net(4), consumption => cons(4));
    gate6: nand_gate generic map (delay => delay) port map (a => net(3), b=> net(4), y => net(5), consumption => cons(5));
    gate7: nand_gate generic map (delay => delay) port map (a => net(4), b=> Cin, y => net(6), consumption => cons(6));
    gate8: nand_gate generic map (delay => delay) port map (a => net(4), b=> net(0), y => Cout, consumption => cons(7));
    gate9: nand_gate generic map (delay => delay) port map (a => net(5), b=> net(6), y => S, consumption => cons(8));

    --+ summing up consumptions
    -- pragma synthesis_off
	sum_up_i : sum_up generic map (N=>8) port map (cons => cons, consumption => consumption);
    -- pragma synthesis_on
end Structural;
