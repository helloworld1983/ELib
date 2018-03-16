
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nand_gate is
    Generic (delay : time :=0 ns);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC);
end nand_gate;

architecture Behavioral of nand_gate is
component and_gate is
    Generic (delay : time := 1 ns);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC);
end component;
component delay_cell is
    Generic (delay : time :=1 ns);
    Port ( a : in STD_LOGIC;
           y : out STD_LOGIC);
end component;
signal net: STD_LOGIC;
begin

and_gate1 : and_gate generic map (delay => delay) port map (a => a, b => b, y => net);
delay_cell1 : delay_cell generic map ( delay => delay) port map (a => net, y => y);
end Behavioral;
