library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity unit_cell_tdc is
    Generic (delay : time :=1 ns;
              active_front : boolean := true);
    Port ( inB : in STD_LOGIC;
           Ck : in STD_LOGIC;
           Rn : in STD_LOGIC;
           outB : out STD_LOGIC;
           Q, Qn : out STD_LOGIC;
           energy_mon: out natural);
end unit_cell_tdc;

architecture Behavioral of unit_cell_tdc is
signal net: STD_LOGIC;
signal en1, en2 : natural;

component delay_cell
    Generic (delay : time :=1 ns); 
    Port ( a : in STD_LOGIC;
           y : out STD_LOGIC;
           energy_mon: out natural);
end component;

component dff
     Generic ( active_front : boolean := true;
                dff_delay: time := 0 ns);
     Port ( D : in STD_LOGIC;
          Ck : in STD_LOGIC;
          Rn : in STD_LOGIC;
          Q , Qn : out STD_LOGIC;
          energy_mon: out natural);
end component;

begin
   delay1: delay_cell generic map (delay => delay) port map (a => inB, y => net, energy_mon => en1);
   dff1: dff generic map (active_front => active_front, dff_delay => 1 ns) port map (D => net, Ck => Ck, Rn => Rn, Q => Q, Qn => Qn, energy_mon => en2);
   outB <= net;
   energy_mon <= en1 + en2;
end Behavioral;
