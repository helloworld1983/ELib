library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity delay_cell is
    Generic (delay : time :=1 ns);
    Port ( a : in STD_LOGIC;
           y : out STD_LOGIC;
           energy_mon: out natural);
end delay_cell;

architecture Behavioral of delay_cell is

component energy_sum is
    Port ( sum_in : in natural;
           sum_out : out natural;
           energy_mon : in STD_LOGIC);
end component;
begin
y <= not a after delay;

energy: energy_sum port map (sum_in => 0, sum_out => energy_mon, energy_mon => a);
end Behavioral;