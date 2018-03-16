library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vernier_cell is
    Generic (delay1 : time :=1 ns;
             delay2 : time :=1 ns;
             active_front : boolean := true);
    Port ( Vin : in STD_LOGIC;
           Ck : in STD_LOGIC;
           Rn : in STD_LOGIC;
           Vout : out STD_LOGIC;
           Q : out STD_LOGIC;
           Qn : out STD_LOGIC;
           ck_out: out STD_LOGIC;
           energy_mon: out natural);
end vernier_cell;

architecture Behavioral of vernier_cell is
component delay_cell
    Generic (delay : time :=1 ns); 
    Port ( a : in STD_LOGIC;
           y : out STD_LOGIC;
           energy_mon: out natural);
end component;

component unit_cell_tdc
    Generic (delay : time :=1 ns;
             active_front : boolean := true);
    Port ( inB : in STD_LOGIC;
           Ck : in STD_LOGIC;
           Rn : in STD_LOGIC;
           outB : out STD_LOGIC;
           Q, Qn : out STD_LOGIC;
           energy_mon: out natural); 
end component;

signal net: STD_LOGIC;
signal en1, en2:natural ;

begin
     delaycell: delay_cell generic map (delay => delay2) port map (a => Ck, y => net, energy_mon => en1);
     unit_cell_tdc1:  unit_cell_tdc generic map (active_front => active_front, delay => delay1) port map (inB => Vin, Ck => net, Rn => Rn, outB => Vout, Q => Q, Qn => Qn, energy_mon => en2);
     ck_out <= net;
     energy_mon <= en1 + en2;
end Behavioral;
