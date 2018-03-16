library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_reset is
    generic (active_front : boolean := TRUE;
            width : natural := 8);
    Port ( CLK : in STD_LOGIC;
           Rn : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (width-1 downto 0);
           energy_mon : out natural);
end counter_reset;

architecture Behavioral of counter_reset is

    component dff is
        Generic ( active_front : boolean := true;
                dff_delay : time := 0 ns);
        Port ( D : in STD_LOGIC;
               Ck : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q, Qn : out STD_LOGIC;
               energy_mon : out natural);
    end component;
    signal ripple: STD_LOGIC_VECTOR (width downto 0);
    signal feedback,feedback_d : STD_LOGIC_VECTOR (width-1 downto 0);
    type en_t is array (0 to width -1) of natural;
    signal en : en_t;
    type sum_t is array (-1 to width -1) of natural;
     signal sum : sum_t;

    --signal i : integer;
begin

ripple(0) <= CLK;
gen_dff:  for i in 0 to width-1 generate
        dffi : dff generic map (active_front => active_front) port map (D => feedback_d(i), Ck => ripple(i), Rn => Rn, Q => ripple(i+1), Qn => feedback(i), energy_mon => en(i));
end generate gen_dff;
feedback_d <= feedback after 1 ns;
Q <= ripple(width downto 1);

--+ energy monitoring section
-- for behavioral simulation only
sum(-1) <= 0;
sum_up_energy : for I in 0 to width-1  generate
      sum_i:    sum(I) <= sum(I-1) + en(I);
end generate sum_up_energy;
energy_mon <= sum(width - 1);
--- energy monitoring section
end Behavioral;


