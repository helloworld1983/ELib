library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FA is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Cin : in STD_LOGIC;
           Cout : out STD_LOGIC;
           S : out STD_LOGIC;
           energy_mon: out natural);
end FA;

architecture Behavioral of FA is

component nand_gate is
     Generic (delay : time :=1 ns);
     Port ( a : in STD_LOGIC;
          b : in STD_LOGIC;
          y : out STD_LOGIC);
end component;

component energy_sum is
    Generic( mult: natural:=1);
    Port ( sum_in : in natural;
           sum_out : out natural;
           energy_mon : in STD_LOGIC);
end component;
signal net: STD_LOGIC_VECTOR(0 to 6);
type en_t is array (0 to 9) of natural;
signal en : en_t;


begin

gate1: nand_gate generic map (delay => 0 ns) port map (a => A, b=> B, y => net(0));
gate2: nand_gate generic map (delay => 0 ns) port map (a => A, b=> net(0), y => net(1));
gate3: nand_gate generic map (delay => 0 ns) port map (a => net(0), b=> B, y => net(2));
gate4: nand_gate generic map (delay => 0 ns) port map (a => net(1), b=> net(2), y => net(3));
gate5: nand_gate generic map (delay => 0 ns) port map (a => net(3), b=> Cin, y => net(4));
gate6: nand_gate generic map (delay => 0 ns) port map (a => net(3), b=> net(4), y => net(5));
gate7: nand_gate generic map (delay => 0 ns) port map (a => net(4), b=> Cin, y => net(6));
gate8: nand_gate generic map (delay => 0 ns) port map (a => net(4), b=> net(0), y => Cout);
gate9: nand_gate generic map (delay => 0 ns) port map (a => net(5), b=> net(6), y => S);
energy_1: energy_sum generic map (mult => 2)port map (sum_in => 0, sum_out => en(0), energy_mon => A );
energy_2: energy_sum port map (sum_in => en(0), sum_out => en(1), energy_mon => net(1));
energy_3: energy_sum generic map (mult => 2) port map (sum_in => en(1), sum_out => en(2), energy_mon =>net(3));
energy_4: energy_sum generic map (mult => 3) port map (sum_in => en(2), sum_out => en(3), energy_mon => net(4));
energy_5: energy_sum port map (sum_in => en(3), sum_out => en(9), energy_mon => net(6));
energy_6: energy_sum generic map (mult => 2) port map (sum_in => 0, sum_out => en(4), energy_mon => B);
energy_7: energy_sum generic map (mult => 3) port map (sum_in => en(4), sum_out => en(5), energy_mon => net(0));
energy_8: energy_sum port map (sum_in => en(5), sum_out => en(6), energy_mon => net(2));
energy_9: energy_sum generic map (mult => 2) port map (sum_in => en(6), sum_out => en(7), energy_mon => Cin);
energy_10: energy_sum port map (sum_in => en(7), sum_out => en(8), energy_mon => net(5));

energy_mon <= en(8) + en(9);
end Behavioral;
