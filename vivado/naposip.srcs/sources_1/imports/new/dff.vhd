library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dff is
    Generic ( active_front : boolean := true;
            dff_delay : time := 1 ns);
    Port ( D : in STD_LOGIC;
           Ck : in STD_LOGIC;
           Rn : in STD_LOGIC;
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
        process(Rn, Ck)
          begin
               if Rn = '0' then
                    Qint <= '0';
                else
                    if rising_edge(Ck) then 
                        Qint <= D;
                    end if;
            end if;
          end process;
    end generate rising_active;

    falling_active: if not active_front generate
        process(Rn, Ck)
          begin
                if Rn = '0' then
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

--energy_1: energy_sum port map (sum_in => 0, sum_out => en1, energy_mon => D);
--energy_2: energy_sum port map (sum_in => en1, sum_out => en2, energy_mon => Ck);
--energy_3: energy_sum port map (sum_in => en2, sum_out => energy_mon, energy_mon => Rn);
energy_mon <= 0;
end Behavioral;

architecture Structural of dff is

component latchD is
Generic ( active_front : boolean := true;
          dff_delay : time := 1 ns);
   Port ( D : in STD_LOGIC;
          Ck : in STD_LOGIC;
          Rn : in STD_LOGIC;
          Q, Qn : out STD_LOGIC;
          energy_mon : out integer);
end component;

component  delay_cell is
    Generic (delay : time :=1 ns);
    Port ( a : in STD_LOGIC;
           y : out STD_LOGIC;
           energy_mon: out natural);
end component;

signal net: STD_LOGIC_VECTOR (2 to 4);
signal Ckn: std_logic;
signal en0,en1,en2,en3 : natural;

begin

inversor1: delay_cell generic map (delay => 1 ns) port map (a => Ck, y => Ckn, energy_mon => en0);


rising_active: if (active_front) generate
                D1: latchD generic map (active_front => true, dff_delay => 0 ns) port map (D => D, Ck => Ckn, Rn => Rn, Q => net(2), energy_mon => en2); 
                D2: latchD generic map (active_front => true, dff_delay => 0 ns) port map (D => net(2), Ck => Ck, Rn => Rn, Q => net(3), Qn => net(4),energy_mon => en3);        
end generate rising_active;

falling_active: if (not active_front) generate
                D1: latchD generic map (active_front => false, dff_delay => 0 ns) port map (D => D, Ck => Ckn, Rn => Rn, Q => net(2), energy_mon => en2); 
                D2: latchD generic map (active_front => false, dff_delay => 0 ns) port map (D => net(2), Ck => Ck, Rn => Rn, Q => net(3), Qn => net(4),energy_mon => en3);       
end generate falling_active ;

Q <= net(3);
Qn <= net(4);
energy_mon <= en1 + en2 + en3;

end Structural;

architecture Structural2 of dff is

component latchD is
Generic ( active_front : boolean := true;
          dff_delay : time := 1 ns);
   Port ( D : in STD_LOGIC;
          Ck : in STD_LOGIC;
          Rn : in STD_LOGIC;
          --Q, Qn : out STD_LOGIC;
          Q, Qn : inout STD_LOGIC;
          energy_mon : out integer);
end component;

component  delay_cell is
    Generic (delay : time :=1 ns);
    Port ( a : in STD_LOGIC;
           y : out STD_LOGIC;
           energy_mon: out natural);
end component;

signal net: STD_LOGIC_VECTOR (2 to 4);
signal Ckn,Cknn: std_logic;
signal en0,en1,en2,en3,en4 : natural := 0;

begin

falling_active: if (not active_front) generate
    inversor1: delay_cell generic map (delay => 0 ns) port map (a => Ck, y => Ckn, energy_mon => en4);
end generate falling_active ;

rising_active: if (active_front) generate
     Ckn <= Ck;  
     en4<=0;         
end generate rising_active;

inversor2: delay_cell generic map (delay => 1 ns) port map (a => Ckn, y => Cknn, energy_mon => en0);
master: latchD generic map (active_front => true, dff_delay => 0 ns) port map (D => D, Ck => Cknn, Rn => Rn, Q => net(2), energy_mon => en2); 
slave : latchD generic map (active_front => true, dff_delay => 0 ns) port map (D => net(2), Ck => Ckn, Rn => Rn, Q => net(3), Qn => net(4),energy_mon => en3);        

Q <= net(3);
Qn <= net(4);
energy_mon <= en1 + en2 + en3 + en4;

end Structural2;
