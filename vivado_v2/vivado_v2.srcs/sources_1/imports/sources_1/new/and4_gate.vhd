library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and4_gate is
    Generic (delay : time := 1 ns);
    Port ( a,b,c,d : in STD_LOGIC;
           y : out STD_LOGIC;
           energy_mon: out integer);
end and4_gate;

architecture Behavioral of and4_gate is
component energy_sum is
    Port ( sum_in : in natural;
           sum_out : out natural;
           energy_mon : in STD_LOGIC);
end component;
signal en1,en2,en3,en4 : natural;
begin
y <= a and b and c and d after delay;
 energy_1: energy_sum port map (sum_in => 0, sum_out => en1, energy_mon => a);
 energy_2: energy_sum port map (sum_in => 0, sum_out => en2, energy_mon => b);
 energy_3: energy_sum port map (sum_in => 0, sum_out => en3, energy_mon => c);
 energy_4: energy_sum port map (sum_in => 0, sum_out => en4, energy_mon => d);
 energy_mon <= en1 + en2 + en3 + en4;

end Behavioral;
