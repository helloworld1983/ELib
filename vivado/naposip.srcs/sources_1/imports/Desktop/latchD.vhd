library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity latchD is
 Generic ( active_front : boolean := true;
            dff_delay : time := 1 ns);
   Port ( D : in STD_LOGIC;
          Ck : in STD_LOGIC;
          Rn : in STD_LOGIC;
          --Q, Qn : out STD_LOGIC;
          Q, Qn : inout STD_LOGIC;
          energy_mon : out natural);
end latchD;

architecture Behavioral of latchD is
component nand_gate is
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

component energy_sum is
    Generic( mult: integer:=1);
    Port ( sum_in : in natural;
           sum_out : out natural;
           energy_mon : in STD_LOGIC);
end component;

component  delay_cell is
    Generic (delay : time :=1 ns);
    Port ( a : in STD_LOGIC;
           y : out STD_LOGIC;
           energy_mon: out natural);
end component;

component latchSR
    Port ( S : in STD_LOGIC;
       R : in STD_LOGIC;
       Q : inout STD_LOGIC;
       Qn : inout STD_LOGIC;
       energy_mon : out natural);
end component;

signal net: STD_LOGIC_VECTOR (1 to 4);
type en_t is array (1 to 5) of natural;
signal en : en_t;
signal sum: natural := 0;
signal clk: STD_LOGIC;
begin
 rising_active: if (active_front) generate
                           clk <= Ck;
end generate rising_active;

--falling_active: if (not active_front) generate
--                        inv_label: delay_cell generic map (delay => 0 ns) port map (a => Ck, y => clk, energy_mon => en(0));
--end generate falling_active ;

gate1: nand_gate generic map (delay => 0 ns) port map (a => D, b =>clk, y => net(1));
gate2: nand_gate generic map (delay => 0 ns) port map (a => net(1), b => clk, y => net(2));
gate3: and_gate generic map (delay => 0 ns) port map (a => Rn, b => net(2), y => net(3));
latch4: latchSR port map (S=>net(1), R=>net(3), Q=>Q, Qn=>Qn);

energy1: energy_sum port map (sum_in => 0, sum_out => en(1), energy_mon => D);
energy2: energy_sum generic map (mult => 2) port map (sum_in => en(1), sum_out => en(2), energy_mon => Ck);
energy3: energy_sum generic map (mult => 2) port map (sum_in => en(2), sum_out => en(3), energy_mon => net(1));
energy4: energy_sum port map (sum_in => en(3), sum_out => en(4), energy_mon => net(2));
energy5: energy_sum port map (sum_in => en(4), sum_out => en(5), energy_mon => net(3));

energy_mon <= en(5);


end Behavioral;
