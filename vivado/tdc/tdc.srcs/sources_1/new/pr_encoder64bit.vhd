library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pr_encoder64bit is
          Port (I: in STD_LOGIC_VECTOR(7 DOWNTO 0);
               EI: in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(2 DOWNTO 0);
               GS,EO : out STD_LOGIC;
              energy_mon : out Integer);
end pr_encoder64bit;

architecture Behavioral of pr_encoder64bit is

begin


end Behavioral;
