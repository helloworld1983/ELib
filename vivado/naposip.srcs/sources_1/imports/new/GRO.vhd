library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity GRO is
    Generic (delay : time :=1 ns);
    Port ( start : in STD_LOGIC;
           CLK : out STD_LOGIC_VECTOR (0 to 2);
           energy_mon : out natural);
end GRO;

architecture Behavioral of GRO is
component nand_gate is
    Generic (delay : time :=1 ns);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC); 
end component;

component delay_cell is
    Generic (delay : time :=1 ns);
    Port ( a : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

component energy_sum is
    Generic( mult: natural:=1);
    Port ( sum_in : in natural;
           sum_out : out natural;
           energy_mon : in STD_LOGIC);
end component;

 signal net: STD_LOGIC_VECTOR (0 to 2);
 signal en1, en2, en3 : natural;
 
begin
nand_gate_1: nand_gate generic map (delay => delay) port map (a => start, b => net(2), y => net(0));
delay_cell_1: delay_cell generic map (delay => delay) port map (a => net(0), y => net(1));
delay_cell_2: delay_cell generic map (delay => delay) port map (a => net(1), y => net(2));
energy_1: energy_sum port map (sum_in => 0, sum_out => en1, energy_mon => start);
energy_2: energy_sum port map (sum_in => en1, sum_out => en2, energy_mon => net(0));
energy_3: energy_sum port map (sum_in => en2, sum_out => en3, energy_mon => net(1));
energy_4: energy_sum port map (sum_in => en3, sum_out => energy_mon, energy_mon => net(2));
CLK <= net;
end Behavioral;
