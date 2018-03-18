library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity energy_sum is
    Generic( mult: natural:=1);
    Port ( sum_in : in natural;
           sum_out : out natural;
           energy_mon : in STD_LOGIC);
end energy_sum;

architecture Behavioral of energy_sum is
component energy_count is
     Port ( in_en : in STD_LOGIC;
          out_en : out natural);
end component;

signal net: natural;
begin

energy_count1:energy_count port map(in_en => energy_mon, out_en => net); 
sum_out <= (net*mult + sum_in);

end Behavioral;
