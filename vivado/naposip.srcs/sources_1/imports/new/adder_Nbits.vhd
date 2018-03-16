library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_Nbits is
    generic (width: natural := 8);
    Port ( A : in STD_LOGIC_VECTOR (width-1 downto 0);
           B : in STD_LOGIC_VECTOR (width-1 downto 0);
           Cin : in STD_LOGIC;
           Cout : out STD_LOGIC;
           S : out STD_LOGIC_VECTOR (width-1 downto 0);
           energy_mon : out natural);
end adder_Nbits;

architecture Behavioral of adder_Nbits is
    component FA is
        Port ( A : in STD_LOGIC;
               B : in STD_LOGIC;
               Cin : in STD_LOGIC;
               Cout : out STD_LOGIC;
               S : out STD_LOGIC;
               energy_mon : out natural); 
    end component;
    signal Cint: STD_LOGIC_VECTOR(0 to width);

    type en_t is array (0 to width - 1) of natural;
    signal en : en_t;
    type sum_t is array (-1 to width - 1) of natural;
    signal sum: sum_t;

begin

Cint(0) <= Cin;
GEN_FA : for i in 0 to width-1 generate
    FAi: FA port map (A => A(i), B => B(i), Cin => Cint(i), Cout => Cint(i+1), S => S(i), energy_mon => en(i));
end generate GEN_FA;
Cout <= Cint(width);

sum(-1) <= 0;
sum_up_energy : for I in 0 to width-1  generate
      sum_i:    sum(I) <= sum(I-1) + en(I);
end generate sum_up_energy;
energy_mon <= sum(width - 1);
  
end Behavioral;
