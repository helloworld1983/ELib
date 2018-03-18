library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and_gate is
    Generic (delay : time := 1 ns);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC;
           energy_mon: out natural);
end and_gate;

architecture Behavioral of and_gate is
component energy_sum is
    Generic( mult: natural:=1);
    Port ( sum_in : in natural;
           sum_out : out natural;
           energy_mon : in STD_LOGIC);
end component;

signal en1, en2 : natural;
begin
y <= a and b after delay;

energy1: energy_sum port map (sum_in => 0, sum_out => en1, energy_mon => a);
energy2: energy_sum port map (sum_in => en1, sum_out => energy_mon, energy_mon => b);

end Behavioral;
