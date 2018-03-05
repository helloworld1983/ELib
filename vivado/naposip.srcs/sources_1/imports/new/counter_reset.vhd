library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_reset is
    generic (active_front : boolean := TRUE;
            width : natural := 8);
    Port ( CLK : in STD_LOGIC;
           R : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (0 to width-1);
           energy_mon : out natural);
end counter_reset;

architecture Behavioral of counter_reset is

    component dff is
        Generic ( active_front : boolean := true);
        Port ( D : in STD_LOGIC;
               Ck : in STD_LOGIC;
               R : in STD_LOGIC;
               Q, Qn : out STD_LOGIC;
               energy_mon : out natural);
    end component;
    signal ripple: STD_LOGIC_VECTOR (0 to width);
    signal feedback : STD_LOGIC_VECTOR (0 to width-1);
    type en_t is array (0 to width -1) of natural;
    signal en : en_t;
    signal sum: natural := 0;
begin

--dff1: dff port map (D => ripple(0), Ck => CLK, R => R, Q => Q(0), Qn => ripple(0), energy_mon => en(0));
ripple(0) <= CLK;
gen_dff:  for i in 0 to width-1 generate
        dffi : dff generic map (active_front => active_front) port map (D => feedback(i), Ck => ripple(i), R => R, Q => ripple(i+1), Qn => feedback(i), energy_mon => en(i));
 end generate gen_dff;
--dff8: dff port map (D => ripple(7), Ck => ripple(6), R => R, Q => Q(7), Qn => ripple(7), energy_mon => en(7));
Q <= ripple(1 to width);
process(en)
begin
 label_for: for I in 0 to width-1 loop
        sum <= (sum + en(I));
        end loop  label_for;
end process;

  energy_mon <= sum;

end Behavioral;


