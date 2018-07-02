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

library work;
use work.PEGates.all; 
use work.PELib.all;

entity FA is
        Generic (delay : time := 1 ns;
		         logic_family : logic_family_t; -- the logic family of the component
                 gate : component_t; -- the type of the component
                 Cload: real := 5.0 -- capacitive load
                 );
		Port ( A : in STD_LOGIC;
			   B : in STD_LOGIC;
			   Cin : in STD_LOGIC;
			   Cout : out STD_LOGIC;
			   S : out STD_LOGIC;
			   Vcc : in real ; --supply voltage
			   consumption : out consumption_type := (0.0,0.0)
			   );
end FA;

architecture Structural of FA is

    signal net: STD_LOGIC_VECTOR(0 to 6);
    signal cons : consumption_type_array(1 to 9); 

begin
    
    gate1: nand_gate generic map (delay => 0 ns, logic_family => logic_family, gate => nand_comp) port map (a => A, b=> B, y => net(0), Vcc => Vcc, consumption => cons(9));
    gate2: nand_gate generic map (delay => 0 ns, logic_family => logic_family, gate => nand_comp) port map (a => A, b=> net(0), y => net(1), Vcc => Vcc, consumption => cons(1));
    gate3: nand_gate generic map (delay => 0 ns, logic_family => logic_family, gate => nand_comp) port map (a => net(0), b=> B, y => net(2), Vcc => Vcc, consumption => cons(2));
    gate4: nand_gate generic map (delay => 0 ns, logic_family => logic_family, gate => nand_comp) port map (a => net(1), b=> net(2), y => net(3), Vcc => Vcc, consumption => cons(3));
    gate5: nand_gate generic map (delay => 0 ns, logic_family => logic_family, gate => nand_comp) port map (a => net(3), b=> Cin, y => net(4), Vcc => Vcc, consumption => cons(4));
    gate6: nand_gate generic map (delay => 0 ns, logic_family => logic_family, gate => nand_comp) port map (a => net(3), b=> net(4), y => net(5), Vcc => Vcc, consumption => cons(5));
    gate7: nand_gate generic map (delay => 0 ns, logic_family => logic_family, gate => nand_comp) port map (a => net(4), b=> Cin, y => net(6), Vcc => Vcc, consumption => cons(6));
    gate8: nand_gate generic map (delay => 0 ns, logic_family => logic_family, gate => nand_comp) port map (a => net(4), b=> net(0), y => Cout, Vcc => Vcc, consumption => cons(7));
    gate9: nand_gate generic map (delay => 0 ns, logic_family => logic_family, gate => nand_comp) port map (a => net(5), b=> net(6), y => S, Vcc => Vcc, consumption => cons(8));

    --+ summing up consumptions
    -- pragma synthesis_off
	sum_up_i : sum_up generic map (N => 9) port map (cons => cons, consumption => consumption);
    -- pragma synthesis_on
end Structural;
