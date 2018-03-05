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

architecture Structural of dff is

component latchD is
Generic ( active_front : boolean := true;
            dff_delay : time := 1 ns);
   Port ( D : in STD_LOGIC;
          Ck : in STD_LOGIC;
          R : in STD_LOGIC;
          Q, Qn : out STD_LOGIC;
          energy_mon : out integer);
end component;

component  delay_cell is
    Generic (delay : time :=1 ns);
    Port ( a : in STD_LOGIC;
           y : out STD_LOGIC;
           energy_mon: out integer);
end component;

signal net: STD_LOGIC_VECTOR (1 to 4);
signal en1,en2,en3 : integer;

begin

inversor: delay_cell port map (a => Ck, y => net(1), energy_mon => en1);

rising_active: if (active_front) generate
                D1: latchD generic map (active_front => true) port map (D => D, Ck => net(1), R => R, Q => net(2), energy_mon => en2); 
                D2: latchD generic map (active_front => true) port map (D => net(2), Ck => Ck, R => R, Q => net(3), Qn => net(4),energy_mon => en3);        
end generate rising_active;

falling_active: if (not active_front) generate
                D1: latchD generic map (active_front => false) port map (D => D, Ck => net(1), R => R, Q => net(2), energy_mon => en2); 
                D2: latchD generic map (active_front => false) port map (D => net(2), Ck => Ck, R => R, Q => net(3), Qn => net(4),energy_mon => en3);       
end generate falling_active ;

Q <= net(3);
Qn <= net(4);
energy_mon <= en1 + en2 + en3;

end Structural;
