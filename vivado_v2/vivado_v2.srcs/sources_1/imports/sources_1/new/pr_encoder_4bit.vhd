
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pr_encoder_4bit is
    Port ( I0,I1,I2,I3 : in STD_LOGIC;
           Y1,Y2 : out STD_LOGIC;
           V : out STD_LOGIC;
           energy_mon : out Integer);
end pr_encoder_4bit;

architecture Behavioral of pr_encoder_4bit is

component delay_cell is
      Generic (delay : time :=1 ns);
      Port ( a : in STD_LOGIC;
             y : out STD_LOGIC;
             energy_mon: out natural);
end component;

component or_gate is 
    Generic (delay : time :=1 ns);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

component and_gate is
    Generic (delay : time := 1 ns);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

component or3_gate is
    generic (delay : time := 1 ns);
    Port ( a,b,c: in STD_LOGIC;
           y : out STD_LOGIC;
           energy_mon : out natural);
end component;

component energy_sum is
    Generic( mult: natural:=1);
    Port ( sum_in : in natural;
           sum_out : out natural;
           energy_mon : in STD_LOGIC);
end component;

signal net1,net2,net3 : std_logic;
type en_t is array (1 to 6 ) of natural;
signal en : en_t;
begin

inv1: delay_cell port map (a => I2, y => net1, energy_mon => en(1));
and_gate1: and_gate port map (a => net1, b => I1, y => net3);
or_gate1: or_gate port map (a => I3, b => I2, y => net2);
or_gate2: or_gate port map (a => I3, b => net3, y => Y1); 
or3_gate1: or3_gate port map (a => net2, b => I1, c => I0, y => V, energy_mon => en(2)); 
 
 Y2 <= net2;
 
 energy_sum1: energy_sum generic map (mult => 2) port map (sum_in => 0, sum_out => en(3), energy_mon => I3);
 energy_sum2: energy_sum port map (sum_in => en(3), sum_out => en(4), energy_mon => net3);
 energy_sum3: energy_sum port map (sum_in => en(4), sum_out => en(5), energy_mon => I1);
 energy_sum4: energy_sum port map (sum_in => en(5), sum_out => en(6), energy_mon => I2);

energy_mon <= en(1) + en(2) + en(6);

end Behavioral;
