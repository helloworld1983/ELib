library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pr_encoder_8bit is
       Port (  I : in STD_LOGIC_VECTOR(7 DOWNTO 0);
               EI: in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(2 DOWNTO 0);
               GS,EO : out STD_LOGIC;
              energy_mon : out Integer);
end pr_encoder_8bit;

architecture Behavioral of pr_encoder_8bit is

component delay_cell is
    Generic (delay : time :=1 ns);
    Port ( a : in STD_LOGIC;
           y : out STD_LOGIC;
           energy_mon: out natural);
end component;

component and_gate is
    Generic (delay : time := 1 ns);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC;
           energy_mon: out natural);
end component;

component and3_gate is
    Generic (delay : time := 1 ns);
    Port ( a,b,c : in STD_LOGIC;
           y : out STD_LOGIC;
           energy_mon: out integer);
end component;

component and4_gate is
    Generic (delay : time := 1 ns);
    Port ( a,b,c,d : in STD_LOGIC;
           y : out STD_LOGIC;
           energy_mon: out integer);
end component;

component and5_gate is
    Generic (delay : time := 1 ns);
    Port ( a,b,c,d,e : in STD_LOGIC;
           y : out STD_LOGIC;
           energy_mon: out integer);
end component;

component nand_gate is
    Generic (delay : time :=1 ns);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

component nand9_gate is
    Generic (delay : time :=1 ns);
    Port ( x : in STD_LOGIC_VECTOR(8 downto 0);
           y : out STD_LOGIC;
           energy_mon : out integer);
end component;

component nor4_gate is
    Generic (delay : time :=1 ns);
    Port ( a,b,c,d : in STD_LOGIC;
            y: out STD_LOGIC;
            energy_mon: out natural);
end component;

component energy_sum is
    Generic( mult: natural:=1);
    Port ( sum_in : in natural;
           sum_out : out natural;
           energy_mon : in STD_LOGIC);
end component;

signal p1,p2 : natural;
signal net: std_logic_vector (26 downto 1);
type en_t is array (1 to 28 ) of natural;
signal en : en_t;
 signal sum : natural:=0;

begin

inv1: delay_cell port map(a => I(1), y => net(1), energy_mon => en(1)); 
inv2: delay_cell port map(a => I(2), y => net(2), energy_mon => en(2)); 
inv3: delay_cell port map(a => net(2), y => net(3), energy_mon => en(3)); 
inv4: delay_cell port map(a => I(3), y => net(4), energy_mon => en(4)); 
inv5: delay_cell port map(a => I(4), y => net(5), energy_mon => en(5)); 
inv6: delay_cell port map(a => net(5), y => net(6), energy_mon => en(6));
inv7: delay_cell port map(a => I(5), y => net(7), energy_mon => en(7)); 
inv8: delay_cell port map(a => net(7), y => net(8), energy_mon => en(8));
inv9: delay_cell port map(a => I(6), y => net(9), energy_mon => en(9)); 
inv10: delay_cell port map(a => net(9), y => net(10), energy_mon => en(10));
inv11: delay_cell port map(a => I(7), y => net(11), energy_mon => en(11)); 
inv12: delay_cell port map(a => EI, y => net(12), energy_mon => en(12));
nand9_gate1: nand9_gate port map (x(0) => I(0), x(1) => I(1), x(2) => I(2) , x(3) => I(3) , x(4) => I(4) , x(5) => I(5) , x(6) => I(6) , x(7) => I(7), x(8) => net(12), y => net(13) , energy_mon => en(28)); 
and_gate1: and_gate port map(a => net(12), b => net(11), y => net(14), energy_mon => en(13));
and_gate2: and_gate port map(a => net(12), b => net(9), y => net(15), energy_mon => en(14));
and_gate3: and_gate port map(a => net(12), b => net(7), y => net(16), energy_mon => en(15));
and_gate4: and_gate port map(a => net(12), b => net(5), y => net(17), energy_mon => en(16));
and_gate5: and_gate port map(a => net(12), b => net(11), y => net(18), energy_mon => en(17));
and_gate6: and_gate port map(a => net(12), b => net(9), y => net(19), energy_mon => en(18));
and_gate7: and_gate port map(a => net(12), b => net(11), y => net(20), energy_mon => en(19));
and3_gate1: and3_gate port map(a => net(12), b => net(10), c => net(7), y => net(21), energy_mon => en(20));
and4_gate1: and4_gate port map(a => net(12), b => net(8), c => net(6), d => net(4), y => net(22), energy_mon => en(21));
and4_gate2: and4_gate port map(a => net(12), b => net(8), c => net(6), d => net(2), y => net(23), energy_mon => en(22));
and4_gate3: and4_gate port map(a => net(12), b => net(10), c => net(6), d => net(4), y => net(24), energy_mon => en(23));
and5_gate1: and5_gate port map(a => net(12), b => net(10), c => net(6), d => net(3),e => net(1), y => net(25), energy_mon => en(24));
nand_gate1: nand_gate port map(a => net(12), b => net(13), y => net(26));
energy1: energy_sum port map (sum_in => 0, sum_out => p1, energy_mon => net(12));
energy2: energy_sum port map (sum_in => p1, sum_out => p2, energy_mon => net(13));
nor4_gate1: nor4_gate port map(a => net(14), b => net(15), c => net(16), d => net(17), y => Y(2), energy_mon => en(25));
nor4_gate2: nor4_gate port map(a => net(18), b => net(19), c => net(22), d => net(23), y => Y(1), energy_mon => en(26));
nor4_gate3: nor4_gate port map(a => net(20), b => net(21), c => net(24), d => net(25), y => Y(0), energy_mon => en(27));

EO <= net(13);
GS <= net(26);

process(en)
                  begin
                  label1: for I in 1 to 28 loop
                              sum <= (sum + en(I));
                          end loop;
                  end process;
energy_mon <= sum + p2;

end Behavioral;
