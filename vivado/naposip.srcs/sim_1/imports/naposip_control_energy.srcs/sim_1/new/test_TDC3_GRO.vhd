library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_TDC3_GRO is
  Generic (constant V : natural := 5);
end test_TDC3_GRO;

architecture Behavioral of test_TDC3_GRO is

component TDC3_GRO is
    Generic (delay : time :=1 ns);
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           M : out STD_LOGIC_VECTOR (0 to 7);
           energy_mon : out natural);
end component;

signal start,stop : STD_LOGIC;
signal outM : STD_LOGIC_VECTOR (0 to 7);
signal en, energy: natural;

begin
    
    test_TDC3_GRO1: TDC3_GRO port map (start => start, stop => stop, M => outM, energy_mon => en);
     energy <= ( en * V * V )/2; --energia consumata de circuit la tensiunea de alimentare V
--generarea semnalului start de f=11MHz
          gen_start : process 
          begin
              start <= '0';
              wait for 50 ns;
              start <= '1';
              wait for 50 ns;
          end process;
          
    --generarea semnalului stop de f=10MHz   
      gen_stop : process 
          begin
              stop <= '0';
              wait for 45 ns;
              stop <= '1';
              wait for 45 ns;
          end process;

end Behavioral;
