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
type en_t is array (1 to 2*nr_etaje ) of natural;
signal en : en_t;
signal sum: natural := 0;

signal RawQ : STD_LOGIC_VECTOR (0 to nr_etaje); -- signal connecting the delay line and the masks
signal M : STD_LOGIC_VECTOR (0 to nr_etaje); -- Mask Bits

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

component mask is
    Generic (delay_inv, delay_and, delay_or : time:=0 ns);
    Port ( cb : in STD_LOGIC; -- current bit
           pb : in STD_LOGIC; --previous bit
           mi : in STD_LOGIC; --mask in bit
           b : out STD_LOGIC; -- masked bit - output of the current stage
           mo : out STD_LOGIC; --mask out bit
           energy_mon : out natural); -- energy monitoring
end component mask;

begin
 --  delay_0: unit_cell_tdc generic map (delay => delay, active_edge => true) port map (inB => start, Ck => stop, R => R, outB => netB(0), Q => Q(0), energy_mon => en(0));
   netB(0) <= start; 
   delay_x: 
   for I in 1 to nr_etaje generate
            odd :if( I mod 2 = 1 ) generate
                unit_cells_odd: unit_cell_tdc generic map (delay => delay) port map (inB => netB(I-1), Ck => stop, R => R, outB => netB(I), Qn => RawQ(I), energy_mon => en(I));
                end generate odd;
             
             even :if( I mod 2 = 0 ) generate
                unit_cells_even: unit_cell_tdc generic map (delay => delay) port map (inB => netB(I-1), Ck => stop, R => R, outB => netB(I), Q => RawQ(I), energy_mon => en(I));
                end generate even;
     end generate delay_x;
     
     RawQ(0) <= '0';
     M(0) <= '0';
   mask_x :
    for I in 1 to nr_etaje generate
        mask_i : mask port map ( cb => RawQ(I), pb => RawQ(I-1), mi => M(I-1), b=>Q(I), mo => M(I), energy_mon => en (nr_etaje + I));
    end generate mask_x;  
  process(en)
             begin
             label1: for I in 1 to 2*nr_etaje loop
                         sum <= (sum + en(I));
                     end loop;
             end process;
 energy_mon <= sum;
    
end Behavioral;
