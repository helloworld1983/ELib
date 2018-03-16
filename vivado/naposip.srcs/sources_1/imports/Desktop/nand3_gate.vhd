
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nand3_gate is
    Generic (delay : time := 0 ns);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           c : in STD_LOGIC;
           y : out STD_LOGIC);
end nand3_gate;

architecture Behavioral of nand3_gate is
component delay_cell is
    Generic (delay : time :=1 ns);
    Port ( a : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

signal net: STD_LOGIC;

begin
net <= a and b and c after delay;
inv: delay_cell generic map ( delay => delay) port map (a => net, y => y);

end Behavioral;
