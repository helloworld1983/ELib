library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_nbits is
    Generic ( width: natural := 8);
    Port ( D : in STD_LOGIC_VECTOR (width-1 downto 0);
           Ck : in STD_LOGIC;
           Rn : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (width-1 downto 0);
           Qn : out STD_LOGIC_VECTOR (width-1 downto 0);
           energy_mon : out natural);
end reg_nbits;

architecture Behavioral of reg_nbits is

component energy_sum is
    Port ( sum_in : in natural;
           sum_out : out natural;
           energy_mon : in STD_LOGIC);
end component;

begin

registre: process(Rn, Ck)
    begin 
        if Rn = '0' then
            Q <= (others => '0');
        else
           if rising_edge(Ck) then
                     Q <= D;
           end if;
        end if;
    end process;
 
energy_mon <= 0;

end Behavioral;


architecture Structural of reg_nbits is

    component dff is
        Generic ( active_front : boolean := true;
                dff_delay : time := 0 ns);
        Port ( D : in STD_LOGIC;
               Ck : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q, Qn : out STD_LOGIC;
               energy_mon : out natural);
    end component;

-- energy monitoring in the components to be active only for leaf components ??? -> de verificat
--    component energy_sum is
--        Port ( sum_in : in natural;
--           sum_out : out natural;
--           energy_mon : in STD_LOGIC);
--    end component;

type en_t is array (0 to width-1 ) of natural;
signal en : en_t;
type sum_t is array (-1 to width-1 ) of natural;
signal sum : sum_t;

begin

    registre:  for i in 0 to width-1 generate
        dffi : dff generic map (active_front => TRUE) port map (D => D(i), Ck => Ck, Rn => Rn, Q => Q(i), Qn => open, energy_mon => en(i));
    end generate registre;

-- energy monitoring in the components to be active only for leaf components ??? -> de verificat
--    energy_gen : for i in 0 to width-1 generate
--        energy_x : energy_sum port map (sum_in => en(i), sum_out => en(i+1), energy_mon => D(i));
--    end generate energy_gen;


--+ Energy monitoring
-- for behavioral simulation only - to be ignored for synthesis 
sum(-1) <= 0;
sum_up_energy : for I in 0 to width - 1  generate
      sum_i:    sum(I) <= sum(I-1) + en(I);
end generate sum_up_energy;
energy_mon <= sum(width - 1);
-- for behavioral simulation only - to be ignored for synthesis 

end Structural;


