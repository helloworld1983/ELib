library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dff is
    Generic ( active_front : boolean := true;
            dff_delay : time := 1 ns);
    Port ( D : in STD_LOGIC;
           Ck : in STD_LOGIC;
           R : in STD_LOGIC;
           Q, Qn : out STD_LOGIC;
           energy_mon : out natural);
end dff;

architecture Behavioral of dff is
component energy_sum is
    Generic( mult: natural:=1);
    Port ( sum_in : in natural;
           sum_out : out natural;
           energy_mon : in STD_LOGIC);
end component;

signal Qint: STD_LOGIC := '0';
signal en1, en2: natural;
begin

  
    rising_active: if active_front generate
        process(R, Ck)
          begin
               if R = '1' then
                    Qint <= '0';
                else
                    if rising_edge(Ck) then 
                        Qint <= D;
                    end if;
            end if;
          end process;
    end generate rising_active;

    falling_active: if not active_front generate
        process(R, Ck)
          begin
                if R = '1' then
                    Qint <= '0';
                else
                    if falling_edge(Ck) then 
                        Qint <= D;
                    end if;
                end if;
          end process;
     end generate falling_active;
      
Q <= Qint after dff_delay;
Qn <= not Qint after dff_delay;

energy_1: energy_sum port map (sum_in => 0, sum_out => en1, energy_mon => D);
energy_2: energy_sum port map (sum_in => en1, sum_out => en2, energy_mon => Ck);
energy_3: energy_sum port map (sum_in => en2, sum_out => energy_mon, energy_mon => R);
end Behavioral;
