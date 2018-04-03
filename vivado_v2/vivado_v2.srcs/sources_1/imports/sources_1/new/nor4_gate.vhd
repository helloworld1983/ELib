
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nor4_gate is
    Generic (delay : time :=1 ns);
    Port ( a,b,c,d : in STD_LOGIC;
            y: out STD_LOGIC;
            energy_mon: out natural);
end nor4_gate;

architecture Behavioral of nor4_gate is

component delay_cell is
    Generic (delay : time :=1 ns);
    Port ( a : in STD_LOGIC;
           y : out STD_LOGIC;
           energy_mon: out natural );
end component;

component energy_sum is
    Port ( sum_in : in natural;
           sum_out : out natural;
           energy_mon : in STD_LOGIC);
end component;

signal net: std_logic;
signal en1,en2,en3,en4,en5: natural;
begin

net <= a or b or c or d after delay;
delay_cell1 : delay_cell generic map ( delay => delay) port map (a => net, y => y, energy_mon => en5);
energy_1: energy_sum port map (sum_in => 0, sum_out => en1, energy_mon => a);
energy_2: energy_sum port map (sum_in => en1, sum_out => en2, energy_mon => b);
energy_3: energy_sum port map (sum_in => en2, sum_out => en3, energy_mon => c);
energy_4: energy_sum port map (sum_in => en3, sum_out => en4, energy_mon => d);

energy_mon <= en5+en4;

end Behavioral;
