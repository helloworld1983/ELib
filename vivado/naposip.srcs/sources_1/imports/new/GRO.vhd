----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: Gated Ring Oscillator with activity monitoring
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   start - enables the ring osccilator
--              - outputs : CLK - three phase of the clock signal
--                          activity : number of commutations (used to compute power dissipation)
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: delay_cell.vhd, nand_gate.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity GRO is
    Generic (delay : time :=1 ns);
    Port ( start : in STD_LOGIC;
           CLK : out STD_LOGIC_VECTOR (0 to 2);
           activity : out natural);
end GRO;

architecture Structural of GRO is
    component nand_gate is
        Generic (delay : time :=1 ns);
        Port ( a : in STD_LOGIC;
               b : in STD_LOGIC;
               y : out STD_LOGIC;
               activity : out natural := 0); 
    end component;
    
    component delay_cell is
        Generic (delay : time :=1 ns);
        Port ( a : in STD_LOGIC;
               y : out STD_LOGIC;
               activity : out natural := 0);
    end component;
    
    signal net: STD_LOGIC_VECTOR (0 to 2);
    --activity monitoring
    type act_t is array (1 to 3) of natural;
    signal act : act_t;
    type sum_t is array (0 to 3) of natural;
    signal sum : sum_t;
 
begin
    nand_gate_1: nand_gate generic map (delay => delay) port map (a => start, b => net(2), y => net(0), activity => act(1));
    delay_cell_1: delay_cell generic map (delay => delay) port map (a => net(0), y => net(1), activity => act(2));
    delay_cell_2: delay_cell generic map (delay => delay) port map (a => net(1), y => net(2), activity => act(3));
    CLK <= net;
    --+ activity monitoring
    -- for behavioral simulation only
    sum(0) <= 0;
    sum_up_energy : for I in 1 to 3 generate
          sum_i:    sum(I) <= sum(I-1) + act(I);
    end generate sum_up_energy;
    activity <= sum(3);
    -- for simulation only

end Structural;
