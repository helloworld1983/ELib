library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity test_tdc_n_vernier_cell is
    Generic (constant V : natural := 5);
end test_tdc_n_vernier_cell;


architecture Behavioral of test_tdc_n_vernier_cell is
 
 component tdc_n_vernier_cell is
     Generic (nr_etaje : natural :=4);
     Port ( start : in STD_LOGIC;
            stop : in STD_LOGIC;
            R : in STD_LOGIC;
            Q : out STD_LOGIC_VECTOR (0 to nr_etaje);
            energy_mon : out natural);
 end component;
 
 constant nr_etaje : natural :=4;
 signal start,stop,rst : STD_LOGIC;
 signal outQ : STD_LOGIC_VECTOR (0 to nr_etaje);
 signal en, energy: natural;
begin

test_tdc_n_vernier_cell: tdc_n_vernier_cell generic map (nr_etaje => nr_etaje) port map (start => start, stop => stop, R => rst, Q => outQ, energy_mon => en);

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
       
--generarea semnalului rst astfel incat sa nu influenteze deloc functionarea    
     gen_rst : process 
          begin
              rst <= '1' after 10 ps, '0' after 20 ps;
              wait ; 
     end process;
     
end Behavioral;
