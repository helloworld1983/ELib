library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_nbits is
    Generic ( width: natural := 8);
    Port ( D : in STD_LOGIC_VECTOR (0 to width-1);
           Ck : in STD_LOGIC;
           R : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (0 to width-1);
           Qn : out STD_LOGIC_VECTOR (0 to width-1);
           energy_mon : out natural);
end reg_nbits;

architecture Behavioral of reg_nbits is

component energy_sum is
    Port ( sum_in : in natural;
           sum_out : out natural;
           energy_mon : in STD_LOGIC);
end component;

type en_t is array (0 to width+2 ) of natural;
signal en : en_t;
signal sum: natural := 0;

begin

registre: process(R, Ck)
    begin 
        if R = '1' then
            Q <= (others => '0');
        else
           if rising_edge(Ck) then
                     Q <= D;
           end if;
        end if;
    end process;
 
    en(0) <= 0;
     energy_gen:
         for i in 0 to width-1 generate
              energy_x : energy_sum port map (sum_in => en(i), sum_out => en(i+1), energy_mon => D(i));
         end generate energy_gen;

    
energy_2: energy_sum port map (sum_in => en(width), sum_out => en(width+1), energy_mon => Ck);
energy_3: energy_sum port map (sum_in => en(width+1), sum_out =>en(width+2), energy_mon => R);
    
    process(en)
        begin
        energy: for I in 0 to width+2 loop
                    sum <= (sum + en(I));
                end loop;
        end process;
    
    energy_mon <= sum;

end Behavioral;


