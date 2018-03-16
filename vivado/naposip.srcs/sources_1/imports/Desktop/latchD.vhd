----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: D type latch with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   D - data bit
--                          Ck - clock, active '1' high
--              - outputs : Q, Qn - a nand b
--                          activity : number of commutations (used to compute power dissipation)
-- Dependencies: nand_gate.vhd, and_gate.vhd, delay_cell.vhd, latchSR.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity latchD is
 Generic ( delay : time := 1 ns);
   Port ( D : in STD_LOGIC;
          Ck : in STD_LOGIC;
          Rn : in STD_LOGIC;
          Q, Qn : inout STD_LOGIC;
          activity : out natural);
end latchD;

architecture Behavioral of latchD is

    component nand_gate is
        Generic (delay : time :=1 ns);
        Port ( a : in STD_LOGIC;
               b : in STD_LOGIC;
               y : out STD_LOGIC;
               activity : out natural := 0);
    end component;
    
    component and_gate is
        Generic (delay : time := 1 ns);
        Port ( a : in STD_LOGIC;
               b : in STD_LOGIC;
               y : out STD_LOGIC;
               activity : out natural := 0);
    end component;
    
    component  delay_cell is
        Generic (delay : time :=1 ns);
        Port ( a : in STD_LOGIC;
               y : out STD_LOGIC;
               activity: out natural);
    end component;
    
    component latchSR
        Port ( S : in STD_LOGIC;
           R : in STD_LOGIC;
           Q : inout STD_LOGIC;
           Qn : inout STD_LOGIC;
           activity : out natural);
    end component;
    
    signal net: STD_LOGIC_VECTOR (1 to 4);
    type act_t is array (1 to 4) of natural;
    signal act : act_t;
    type sum_t is array (0 to 4) of natural;
    signal sum : sum_t;

begin


    gate1: nand_gate generic map (delay => delay) port map (a => D, b =>Ck, y => net(1), activity => act(1));
    gate2: nand_gate generic map (delay => delay) port map (a => net(1), b => Ck, y => net(2), activity => act(2));
    gate3: and_gate generic map (delay => delay) port map (a => Rn, b => net(2), y => net(3), activity => act(3));
    latch4: latchSR port map (S=>net(1), R=>net(3), Q=>Q, Qn=>Qn, activity => act(4));
    
    --+ activity monitoring
    -- for behavioral simulation only
    sum(0) <= 0;
    sum_up_energy : for I in 1 to 4 generate
          sum_i:    sum(I) <= sum(I-1) + act(I);
    end generate sum_up_energy;
    activity <= sum(4);
    --- for behavioral simulation only

end Behavioral;
