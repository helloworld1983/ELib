library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tdc_n_cell is
    Generic (nr_etaje : natural :=4;
            delay : time :=1 ns;
            active_front : boolean := true);
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           R : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (1 to nr_etaje);
            energy_mon: out natural);
end tdc_n_cell;


architecture Behavioral of tdc_n_cell is
signal netB: STD_LOGIC_VECTOR (0 to nr_etaje);
type en_t is array (1 to nr_etaje ) of natural;
signal en : en_t;
signal sum: natural := 0;


component unit_cell_tdc 
        generic (delay : time :=1 ns;
              active_front : boolean := true);
      Port ( inB : in STD_LOGIC;
          Ck : in STD_LOGIC;
          R : in STD_LOGIC;
          outB : out STD_LOGIC;
          Q, Qn : out STD_LOGIC;
           energy_mon: out natural);
end component;



begin
 --  delay_0: unit_cell_tdc generic map (delay => delay, active_edge => true) port map (inB => start, Ck => stop, R => R, outB => netB(0), Q => Q(0), energy_mon => en(0));
   netB(0) <= start; 
   delay_x: 
   for I in 1 to nr_etaje generate
            odd :if( I mod 2 = 1 ) generate
                unit_cells_odd: unit_cell_tdc generic map (delay => delay) port map (inB => netB(I-1), Ck => stop, R => R, outB => netB(I), Qn => Q(I), energy_mon => en(I));
                end generate odd;
             
             even :if( I mod 2 = 0 ) generate
                unit_cells_even: unit_cell_tdc generic map (delay => delay) port map (inB => netB(I-1), Ck => stop, R => R, outB => netB(I), Q => Q(I), energy_mon => en(I));
                end generate even;
     end generate delay_x;
     
  process(en)
             begin
             label1: for I in 1 to nr_etaje loop
                         sum <= (sum + en(I));
                     end loop;
             end process;
 energy_mon <= sum;
    
end Behavioral;
