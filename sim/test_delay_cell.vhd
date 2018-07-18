library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.PECore.all;

entity test_inv is
end test_inv;

architecture Behavioral of test_inv is
    component inv_gate is
        Generic (delay : time :=1 ns;
                     logic_family : logic_family_t; -- the logic family of the component
                     gate : component_t; -- the type of the component
                     Cload: real := 5.0 -- capacitive load
                     );
         Port ( a : in STD_LOGIC;
                y : out STD_LOGIC;
                Vcc : in real ; -- supply voltage
                consumption : out consumption_type := cons_zero
                );
    end component;
    signal intr, y1, y2 : std_logic;
    signal vcc : real := 5.0;
    signal cons1, cons2 : consumption_type;
begin
    process
    begin
        intr <= '0';
        wait for 10 ns;
        intr <= '1';
        wait for 10 ns;
    end process;
    
    d1 : inv_gate generic map ( delay => 1 ns, logic_family => HC, gate => inv_comp) port map (a => intr, y => y1, Vcc => vcc, consumption => cons1);
    d2 : inv_gate generic map ( delay => 2 ns, logic_family => HC, gate => inv_comp) port map (a => intr, y => y2, Vcc => vcc, consumption => cons2);
         
end Behavioral;
