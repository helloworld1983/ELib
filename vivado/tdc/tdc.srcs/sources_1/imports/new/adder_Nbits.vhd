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
--                          consumption :  port to monitor dynamic and static consumption
-- Dependencies: FA.vhd, util.vhd
-- 
-- Revision: 1.0 - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.util.all;

entity adder_Nbits is
    generic (delay: time:= 0 ns;
            width: natural := 8);
    Port ( A : in STD_LOGIC_VECTOR (width-1 downto 0);
           B : in STD_LOGIC_VECTOR (width-1 downto 0);
           Cin : in STD_LOGIC;
           Cout : out STD_LOGIC;
           S : out STD_LOGIC_VECTOR (width-1 downto 0);
           consumption : out consumption_monitor_type);
end adder_Nbits;

architecture Behavioral of adder_Nbits is
    component FA is
        Generic ( delay : time := 0 ns);
        Port ( A : in STD_LOGIC;
               B : in STD_LOGIC;
               Cin : in STD_LOGIC;
               Cout : out STD_LOGIC;
               S : out STD_LOGIC;
               consumption : out consumption_monitor_type); 
    end component;
    signal Cint: STD_LOGIC_VECTOR(0 to width);
    --consumption monitoring signals
    type cons_t is array (0 to width - 1) of consumption_monitor_type;
    signal cons : cons_t;
    type sum_t is array (-1 to width - 1) of consumption_monitor_type;
    signal sum: sum_t;

begin

    Cint(0) <= Cin;
    GEN_FA : for i in 0 to width-1 generate
        FAi: FA port map (A => A(i), B => B(i), Cin => Cint(i), Cout => Cint(i+1), S => S(i), consumption => cons(i));
    end generate GEN_FA;
    Cout <= Cint(width);
    
    --+ consumption monitoring
    -- for simualtion only
    sum(-1) <= (0.0,  0.0);
    sum_up_energy : for I in 0 to width-1  generate
          sum_i:    sum(I) <= sum(I-1) + cons(I);
    end generate sum_up_energy;
    consumption <= sum(width - 1);
    -- for simulation only
  
end Behavioral;
