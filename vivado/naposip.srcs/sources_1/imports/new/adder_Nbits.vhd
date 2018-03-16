----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: N bit adder with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--                          width - the width of the number to be added
--              - inputs :  A, B - N bit operands
--                          Cin - Carry input
--              - outpus :  S - sum of A and B
--                          Cout - Carry out
--                          activity : number of commutations (used to compute power dissipation)
-- Dependencies: FA.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_Nbits is
    generic (delay: time:= 0 ns;
            width: natural := 8);
    Port ( A : in STD_LOGIC_VECTOR (width-1 downto 0);
           B : in STD_LOGIC_VECTOR (width-1 downto 0);
           Cin : in STD_LOGIC;
           Cout : out STD_LOGIC;
           S : out STD_LOGIC_VECTOR (width-1 downto 0);
           activity : out natural);
end adder_Nbits;

architecture Behavioral of adder_Nbits is
    component FA is
        Generic ( delay : time := 0 ns);
        Port ( A : in STD_LOGIC;
               B : in STD_LOGIC;
               Cin : in STD_LOGIC;
               Cout : out STD_LOGIC;
               S : out STD_LOGIC;
               activity : out natural); 
    end component;
    signal Cint: STD_LOGIC_VECTOR(0 to width);
    --activity monitoring signals
    type act_t is array (0 to width - 1) of natural;
    signal act : act_t;
    type sum_t is array (-1 to width - 1) of natural;
    signal sum: sum_t;

begin

    Cint(0) <= Cin;
    GEN_FA : for i in 0 to width-1 generate
        FAi: FA port map (A => A(i), B => B(i), Cin => Cint(i), Cout => Cint(i+1), S => S(i), activity => act(i));
    end generate GEN_FA;
    Cout <= Cint(width);
    
    --+ activity monitoring
    -- for simualtion only
    sum(-1) <= 0;
    sum_up_energy : for I in 0 to width-1  generate
          sum_i:    sum(I) <= sum(I-1) + act(I);
    end generate sum_up_energy;
    activity <= sum(width - 1);
    -- for simulation only
  
end Behavioral;
