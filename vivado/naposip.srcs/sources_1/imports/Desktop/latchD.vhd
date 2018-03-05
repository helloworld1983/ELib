library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity latchD is
 Generic ( active_front : boolean := true;
            dff_delay : time := 1 ns);
   Port ( D : in STD_LOGIC;
          Ck : in STD_LOGIC;
          R : in STD_LOGIC;
          Q, Qn : out STD_LOGIC;
          energy_mon : out integer);
end latchD;

architecture Behavioral of latchD is
component nand_gate is
    Generic (delay : time :=1 ns);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

component nand3_gate is
    Generic (delay : time := 1 ns);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           c : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

component energy_sum is
    Generic( mult: integer:=1);
    Port ( sum_in : in integer;
           sum_out : out integer;
           energy_mon : in STD_LOGIC);
end component;

component  delay_cell is
    Generic (delay : time :=1 ns);
    Port ( a : in STD_LOGIC;
           y : out STD_LOGIC;
           energy_mon: out integer);
end component;

signal net: STD_LOGIC_VECTOR (1 to 4);
type en_t is array (0 to 7 ) of integer;
signal en : en_t;
signal sum: integer := 0;
signal clk: STD_LOGIC;
begin
 rising_active: if (active_front) generate
                           clk <= Ck;
end generate rising_active;

falling_active: if (not active_front) generate
                        inv_label: delay_cell generic map (delay => 0 ns) port map (a => Ck, y => clk, energy_mon => en(7));
end generate falling_active ;



gate1: nand_gate port map (a => D, b =>clk, y => net(1));
gate2: nand_gate port map (a => net(1), b => Ck, y => net(2));
gate3: nand_gate port map (a => net(1), b => net(4), y => net(3));
gate4: nand3_gate port map (a => net(3), b => net(2),c => R, y => net(4));

energy1: energy_sum port map (sum_in => 0, sum_out => en(0), energy_mon => D);
energy2: energy_sum generic map (mult => 2) port map (sum_in => en(0), sum_out => en(1), energy_mon => Ck);
energy3: energy_sum generic map (mult => 2) port map (sum_in => en(1), sum_out => en(2), energy_mon => net(1));
energy4: energy_sum port map (sum_in => en(2), sum_out => en(3), energy_mon => net(3));
energy5: energy_sum port map (sum_in => en(3), sum_out => en(4), energy_mon => net(4));
energy6: energy_sum port map (sum_in => en(4), sum_out => en(5), energy_mon => net(2));
energy7: energy_sum port map (sum_in => en(5), sum_out => en(6), energy_mon => R);


energy_mon <= en(6) + en(7);
Q <= net(3) after dff_delay;
Qn <= net(4) after dff_delay;

end Behavioral;
