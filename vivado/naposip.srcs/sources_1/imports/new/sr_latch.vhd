library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sr_latch is
    Port ( S : in STD_LOGIC;
           R : in STD_LOGIC;
           Q : out STD_LOGIC;
           Qn : out STD_LOGIC;
           energy_mon : out natural);
end sr_latch;

architecture Behavioral of sr_latch is
component nand_gate is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

component energy_sum is
    Port ( sum_in : in natural;
           sum_out : out natural;
           energy_mon : in STD_LOGIC);
end component;

signal net1, net2 : STD_LOGIC;
signal en1, en2, en3 : natural;
begin

gate1: nand_gate port map (a => S, b => net2, y => net1);
gate2: nand_gate port map (a => net1, b => R, y => net2);
Q <= net1;
Qn <= net2;

energy_1: energy_sum port map (sum_in => 0, sum_out => en1, energy_mon => S);
energy_2: energy_sum port map (sum_in => en1, sum_out => en2, energy_mon => R);
energy_3: energy_sum port map (sum_in => en2, sum_out => en1, energy_mon => net2);
energy_4: energy_sum port map (sum_in => en3, sum_out => energy_mon , energy_mon => net1);

end Behavioral;
