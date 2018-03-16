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
--                          activity : number of commutations (used to compute power dissipation)
-- Dependencies: nand_gate.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FA is
    Generic (delay : time := 1ns );
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Cin : in STD_LOGIC;
           Cout : out STD_LOGIC;
           S : out STD_LOGIC;
           activity: out natural);
end FA;

architecture Structural of FA is

    component nand_gate is
         Generic (delay : time :=1 ns);
         Port ( a : in STD_LOGIC;
              b : in STD_LOGIC;
              y : out STD_LOGIC;
              activity : out natural := 0);
    end component;
    
    signal net: STD_LOGIC_VECTOR(0 to 6);
        --activity monitoring
    type act_t is array (0 to 8) of natural;
    signal act : act_t;
    type sum_t is array (-1 to 8) of natural;
    signal sum : sum_t;

begin
    
    gate1: nand_gate generic map (delay => delay) port map (a => A, b=> B, y => net(0), activity => act(0));
    gate2: nand_gate generic map (delay => delay) port map (a => A, b=> net(0), y => net(1), activity => act(1));
    gate3: nand_gate generic map (delay => delay) port map (a => net(0), b=> B, y => net(2), activity => act(2));
    gate4: nand_gate generic map (delay => delay) port map (a => net(1), b=> net(2), y => net(3), activity => act(3));
    gate5: nand_gate generic map (delay => delay) port map (a => net(3), b=> Cin, y => net(4), activity => act(4));
    gate6: nand_gate generic map (delay => delay) port map (a => net(3), b=> net(4), y => net(5), activity => act(5));
    gate7: nand_gate generic map (delay => delay) port map (a => net(4), b=> Cin, y => net(6), activity => act(6));
    gate8: nand_gate generic map (delay => delay) port map (a => net(4), b=> net(0), y => Cout, activity => act(7));
    gate9: nand_gate generic map (delay => delay) port map (a => net(5), b=> net(6), y => S, activity => act(8));

    --+ activity monitoring
    -- for behavioral simulation only
    sum(-1) <= 0;
    sum_up_energy : for I in 0 to 8 generate
          sum_i:    sum(I) <= sum(I-1) + act(I);
    end generate sum_up_energy;
    activity <= sum(8);
    --- for behavioral simulation only
end Structural;
