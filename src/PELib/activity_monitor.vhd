library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use ieee.std_logic_arith.all;

entity activity_monitor is
    Port ( signal_in : in STD_LOGIC;
           activity : out natural := 0);
end activity_monitor;

architecture Behavioral of activity_monitor is
signal C: natural := 0;
begin
energy_counter : process(signal_in)               
                begin
                    C <= C + 1;
                end process; 
    activity <= C; 
end Behavioral;
