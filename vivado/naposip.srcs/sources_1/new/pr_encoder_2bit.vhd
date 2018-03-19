
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pr_encoder_2bit is
    Port ( I0 : in STD_LOGIC;
           I1 : in STD_LOGIC;
           Y : out STD_LOGIC;
           V : out STD_LOGIC;
           energy_mon : out Integer);
end pr_encoder_2bit;

architecture Behavioral of pr_encoder_2bit is

component delay_cell 
      Generic (delay : time :=1 ns);
      Port ( a : in STD_LOGIC;
             y : out STD_LOGIC;
             energy_mon: out natural);
end component;

component or_gate
    Generic (delay : time :=1 ns);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

component energy_sum is
    Port ( sum_in : in natural;
           sum_out : out natural;
           energy_mon : in STD_LOGIC);
end component;

signal en1, en2, en3: natural;
begin

inv: delay_cell port map (a => I0, y => Y, energy_mon => en1);
or_gate1: or_gate port map (a => I0, b => I1, y => V);
energy1: energy_sum port map (sum_in => 0, sum_out => en2, energy_mon => I0);
energy2: energy_sum port map (sum_in => en2, sum_out => en3, energy_mon => I1);

energy_mon <= en1 + en3;

end Behavioral;
