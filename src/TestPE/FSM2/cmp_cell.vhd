
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all; 
use work.Nbits.all;

entity cmp_cell is
     Generic (delay : time := 0 ns;
            logic_family : logic_family_t := default_logic_family; -- the logic family of the component
            Cload: real := 5.0 ; -- capacitive load
            Area: real := 0.0 --parameter area 
             );
    Port ( x : in STD_LOGIC;
           y : in STD_LOGIC;
           EQI : in STD_LOGIC;
           EQO : out STD_LOGIC;
           Vcc : in real  ; -- supply voltage
           consumption : out consumption_type := cons_zero);
end cmp_cell;

architecture Behavioral of cmp_cell is

signal net: std_logic;
signal cons : consumption_type_array(1 to 2) := (others => cons_zero);


begin
xnor_gate1 : xnor_gate generic map (delay => 0 ns, logic_family => logic_family) port map (a => x, b=> y, y => net, Vcc => Vcc, consumption => cons(1));
and_gate1: and_gate generic map(delay => 0 ns, logic_family => logic_family) port map (a => net, b => EQI, y => EQO, Vcc => Vcc, consumption => cons(2));

sum : sum_up generic map (N=>2) port map (cons=>cons, consumption=>consumption);

end Behavioral;
