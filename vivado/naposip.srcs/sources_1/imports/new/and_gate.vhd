library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and_gate is
    Generic (delay : time := 1 ns);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC);
end and_gate;

architecture Behavioral of and_gate is

begin
y <= a and b after delay;
end Behavioral;
