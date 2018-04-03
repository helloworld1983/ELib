
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nand9_gate is
    Generic (delay : time :=1 ns);
    Port ( x : in STD_LOGIC_VECTOR(8 downto 0);
           y : out STD_LOGIC;
           energy_mon : out integer);
end nand9_gate;

architecture Behavioral of nand9_gate is
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

 signal net: STD_LOGIC;
 type en_t is array (1 to 10 ) of natural;
 signal en : en_t;
begin

net <= x(0) and x(1) and x(2) and x(3) and x(4) and x(5) and x(6) and x(7) and x(8) after delay;
delay_cell1 : delay_cell generic map ( delay => delay) port map (a => net, y => y, energy_mon => en(10));

energy_1: energy_sum port map (sum_in => 0, sum_out => en(1), energy_mon => x(0));
energy_2: energy_sum port map (sum_in => en(1), sum_out => en(2), energy_mon => x(1));
energy_3: energy_sum port map (sum_in => en(2), sum_out => en(3), energy_mon => x(2));
energy_4: energy_sum port map (sum_in => en(3), sum_out => en(4), energy_mon => x(3));
energy_5: energy_sum port map (sum_in => en(4), sum_out => en(5), energy_mon => x(4));
energy_6: energy_sum port map (sum_in => en(5), sum_out => en(6), energy_mon => x(5));
energy_7: energy_sum port map (sum_in => en(6), sum_out => en(7), energy_mon => x(6));
energy_8: energy_sum port map (sum_in => en(7), sum_out => en(8), energy_mon => x(7));
energy_9: energy_sum port map (sum_in => en(8), sum_out => en(9), energy_mon => x(8));
energy_mon <= en(9)+ en(10);
end Behavioral;
