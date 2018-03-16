library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity GRO_TDC is
    Generic (delay : time :=1 ns;
            width : natural := 4);
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (width-1 downto 0);
           energy_mon : out natural);
end GRO_TDC;

architecture Behavioral of GRO_TDC is

component GRO is
    Generic (delay : time :=1 ns);
    Port ( start : in STD_LOGIC;
           CLK : out STD_LOGIC_VECTOR (0 to 2);
           energy_mon : out natural);
end component;

component counter_reset is
    generic (active_front : boolean := TRUE;
            width : natural := 8);
    Port ( CLK : in STD_LOGIC;
           Rn : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (width-1 downto 0);
           energy_mon : out natural);
end component;

component adder_Nbits is
    generic (width : natural := 8);
    Port ( A : in STD_LOGIC_VECTOR (0 to width-1);
           B : in STD_LOGIC_VECTOR (0 to width-1);
           Cin : in STD_LOGIC;
           Cout : out STD_LOGIC;
           S : out STD_LOGIC_VECTOR (0 to width-1);
           energy_mon : out natural);
end component;

component reg_Nbits is
    generic (width : natural := 8);
    Port ( D : in STD_LOGIC_VECTOR (0 to width-1);
           Ck : in STD_LOGIC;
           Rn : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (0 to width-1);
           Qn : out STD_LOGIC_VECTOR (0 to width-1);
           energy_mon : out natural);
end component;

signal ck: STD_LOGIC_VECTOR(0 to 2);
signal C1, C2, C3, C12, C123: STD_LOGIC_VECTOR(width - 1 downto 0);
signal carry: STD_LOGIC;
type en_t is array (0 to 6) of natural;
signal en : en_t;
type sum_t is array (-1 to 6) of natural;
signal sum : sum_t;
signal Rn : std_logic;

begin

Rn <=  start;

gro_cell: GRO generic map(delay => delay) port map (start => start, CLK => ck, energy_mon => en(0));
counter1: counter_reset generic map (active_front => FALSE, width => width) port map (CLK => ck(0), Rn => Rn, Q => C1 ,energy_mon => en(1));
counter2: counter_reset generic map (active_front => FALSE, width => width) port map (CLK => ck(1), Rn => Rn, Q => C2, energy_mon => en(2));
counter3: counter_reset generic map (active_front => FALSE, width => width) port map (CLK => ck(2), Rn => Rn, Q => C3, energy_mon => en(3));
adder1: adder_Nbits generic map (width => width) port map (Cin => '0', A => C1, B => C2, Cout => carry, S => C12, energy_mon => en(4));
adder2: adder_Nbits generic map (width => width) port map (Cin => carry, A => C12, B => C3, S => C123, energy_mon => en(5));
reg: reg_nbits generic map (width => width) port map (D => C123, Ck => stop, Rn => '0', Q => Q, energy_mon => en(6));

--+ energy monitoring
-- for behavioral simulation only
sum(-1) <= 0;
sum_up_energy : for I in 0 to 6 generate
      sum_i:    sum(I) <= sum(I-1) + en(I);
end generate sum_up_energy;
energy_mon <= sum(width - 1);
--- for behavioral simulation only
end Behavioral;
