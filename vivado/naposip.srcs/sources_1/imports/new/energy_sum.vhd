library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity energy_sum is
    Generic( mult: natural:=1);
    Port ( sum_in : in natural;
           sum_out : out natural;
           activity : in STD_LOGIC);
end energy_sum;

architecture Behavioral of energy_sum is
component activity_monitor is
     Port ( signal_in : in STD_LOGIC;
          activity : out natural);
end component;

signal net: natural;
begin

energy_count1:activity_monitor port map(signal_in => activity, activity => net); 
sum_out <= (net*mult + sum_in);

end Behavioral;
