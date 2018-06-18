----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description:  Priority encoder on 8 bits with activity monitoring (74148)
--              - inputs: I(i), i=(0:7) ; EI(Enable Input) 
--              - outputs : Y, EO(Enable output), GS(Group select)
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: PElib.vhd, PEgates.vhd
-- Revision: 1.0 - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.PElib.all;
use xil_defaultlib.PEGates.all;

entity pr_encoder_8bit is
       Port (  I : in STD_LOGIC_VECTOR(7 DOWNTO 0);
               EI: in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(2 DOWNTO 0);
               GS,EO : out STD_LOGIC;
               consumption: out consumption_type := (0.0,0.0));
end pr_encoder_8bit;

architecture Behavioral of pr_encoder_8bit is

    signal net: std_logic_vector (18 downto 1);
    signal cons : consumption_type_array(1 to 22) := (others => (0.0,0.0));

begin

    inv1: inv_gate generic map(delay => 0 ns) port map(a => I(2), y => net(1), consumption => cons(1)); 
    inv2: inv_gate generic map(delay => 0 ns) port map(a => I(4), y => net(2), consumption => cons(2)); 
    inv3: inv_gate generic map(delay => 0 ns) port map(a => I(5), y => net(3), consumption => cons(3)); 
    inv4: inv_gate generic map(delay => 0 ns) port map(a => I(6), y => net(4), consumption => cons(4)); 
    nor8_gate1: nor8_gate generic map(delay => 0 ns) port map (x(0) => I(0), x(1) => I(1), x(2) => I(2) , x(3) => I(3) , x(4) => I(4) , x(5) => I(5) , x(6) => I(6) , x(7) => I(7),  y => net(5) , consumption => cons(5)); 
    and_gate1: and_gate generic map(delay => 0 ns) port map(a => EI, b => I(7), y => net(6), consumption => cons(6));
    and_gate2: and_gate generic map(delay => 0 ns) port map(a => EI, b => I(6), y => net(7), consumption => cons(7));
    and_gate3: and_gate generic map(delay => 0 ns) port map(a => EI, b => I(5), y => net(8), consumption => cons(8));
    and_gate4: and_gate generic map(delay => 0 ns) port map(a => EI, b => I(4), y => net(9), consumption => cons(9));
    and_gate5: and_gate generic map(delay => 0 ns) port map(a => EI, b => I(7), y => net(10), consumption => cons(10));
    and_gate6: and_gate generic map(delay => 0 ns) port map(a => EI, b => I(6), y => net(11), consumption => cons(11));
    and_gate7: and_gate generic map(delay => 0 ns) port map(a => EI, b => I(7), y => net(12), consumption => cons(12));
    and_gate8: and_gate generic map(delay => 0 ns) port map(a => EI, b => net(5), y => net(18), consumption => cons(18));
    and3_gate1: and3_gate generic map(delay => 0 ns) port map(a => EI, b => net(4), c => I(5), y => net(13), consumption => cons(13));
    and4_gate1: and4_gate generic map(delay => 0 ns) port map(a => EI, b => net(3), c => net(2), d => I(3), y => net(14), consumption => cons(14));
    and4_gate2: and4_gate generic map(delay => 0 ns) port map(a => EI, b => net(3), c => net(2), d => I(2), y => net(15), consumption => cons(15));
    and4_gate3: and4_gate generic map(delay => 0 ns) port map(a => EI, b => net(4), c => net(2), d => I(3), y => net(16), consumption => cons(16));
    and5_gate1: and5_gate generic map(delay => 0 ns) port map(a => EI, b => net(4), c => net(2), d => net(1),e => I(1), y => net(17), consumption => cons(17));
    or4_gate1: or4_gate generic map(delay => 0 ns) port map(a => net(6), b => net(7), c => net(8), d => net(9), y => Y(2), consumption => cons(19));
    or4_gate2: or4_gate generic map(delay => 0 ns) port map(a => net(10), b => net(11), c => net(14), d => net(15), y => Y(1), consumption => cons(20));
    or4_gate3: or4_gate generic map(delay => 0 ns) port map(a => net(12), b => net(13), c => net(16), d => net(17), y => Y(0), consumption => cons(21));
    xor_gate1: xor_gate generic map(delay => 0 ns) port map(a => EI, b => net(18), y => GS, consumption => cons(22));
    
    EO <= net(18);
      
    --+ summing up consumption
    -- pragma synthesis_off
	sum_up_i : sum_up generic map (N=>22) port map (cons => cons, consumption => consumption);
    -- pragma synthesis_on
 

end Behavioral;
