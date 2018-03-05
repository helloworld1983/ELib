library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;

entity energy_count is
    Port ( in_en : in STD_LOGIC;
           out_en : out natural);
end energy_count;

architecture Behavioral of energy_count is
signal C: natural:=0;
begin
energy_counter : process(in_en)               
                begin
                if rising_edge(in_en) then
                    C <= C + 1;
                end if;
                if falling_edge(in_en) then
                    C <= C + 1;
                end if;
                end process; 
    out_en <= C; 
end Behavioral;
