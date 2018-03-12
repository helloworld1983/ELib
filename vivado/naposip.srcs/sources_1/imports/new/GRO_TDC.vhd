library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity GRO_TDC is
    Generic (delay : time :=1 ns;
            width : natural := 4);
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           M : out STD_LOGIC_VECTOR (0 to width-1);
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
           R : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (0 to width-1);
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
           R : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (0 to width-1);
           Qn : out STD_LOGIC_VECTOR (0 to width-1);
           energy_mon : out natural);
end component;

signal ck: STD_LOGIC_VECTOR(0 to 2);
signal q, d, h, net, wire: STD_LOGIC_VECTOR(0 to width - 1);
signal carry: STD_LOGIC;
type en_t is array (0 to 6) of natural;
signal en : en_t;
signal sum: natural := 0;
signal Rn : std_logic;

begin

Rn <=  not start;

gro_cell: GRO generic map(delay => delay) port map (start => start, CLK => ck, energy_mon => en(0));
counter1: counter_reset generic map (active_front => FALSE, width => width) port map (CLK => ck(0), R => Rn, Q => q ,energy_mon => en(1));
counter2: counter_reset generic map (active_front => FALSE, width => width) port map (CLK => ck(1), R => Rn, Q => d, energy_mon => en(2));
counter3: counter_reset generic map (active_front => FALSE, width => width) port map (CLK => ck(2), R => Rn, Q => h, energy_mon => en(3));
adder1: adder_Nbits generic map (width => width) port map (Cin => '0', A => q, B => d, Cout => carry, S => net, energy_mon => en(4));
adder2: adder_Nbits generic map (width => width) port map (Cin => carry, A => net, B => h, S => wire, energy_mon => en(5));
reg: reg_nbits generic map (width => width) port map (D => wire, Ck => stop, R => '0', Q => M, energy_mon => en(6));

 process(en)
        begin
        label1: for I in 0 to 6 loop
                    sum <= (sum + en(I));
                end loop;
        end process;
    
    energy_mon <= sum;

end Behavioral;
