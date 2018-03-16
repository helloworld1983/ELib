library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tdc_n_cell is
    Generic (nr_etaje : natural :=4;
            delay : time :=1 ns;
            active_front : boolean := true;
            energy_mon_on : boolean := true);
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           Rn : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (nr_etaje downto 1);
            energy_mon: out natural);
end tdc_n_cell;


architecture Behavioral of tdc_n_cell is

    signal netB: STD_LOGIC_VECTOR (0 to nr_etaje);
    type en_t is array (1 to nr_etaje ) of natural;
    signal en : en_t;
    type sum_t is array (0 to nr_etaje ) of natural;
    signal sum : sum_t;

    component unit_cell_tdc 
            generic (delay : time :=1 ns;
                  active_front : boolean := true);
          Port ( inB : in STD_LOGIC;
              Ck : in STD_LOGIC;
              Rn : in STD_LOGIC;
              outB : out STD_LOGIC;
              Q, Qn : out STD_LOGIC;
               energy_mon: out natural);
    end component;

begin
 --  delay_0: unit_cell_tdc generic map (delay => delay, active_edge => true) port map (inB => start, Ck => stop, Rn => Rn, outB => netB(0), Q => Q(0), energy_mon => en(0));
   netB(0) <= start; 
   delay_x: 
   for I in 1 to nr_etaje generate
            odd :if( I mod 2 = 1 ) generate
                unit_cells_odd: unit_cell_tdc generic map (delay => delay) port map (inB => netB(I-1), Ck => stop, Rn => Rn, outB => netB(I), Qn => Q(I), energy_mon => en(I));
                end generate odd;
             
             even :if( I mod 2 = 0 ) generate
                unit_cells_even: unit_cell_tdc generic map (delay => delay) port map (inB => netB(I-1), Ck => stop, Rn => Rn, outB => netB(I), Q => Q(I), energy_mon => en(I));
                end generate even;
     end generate delay_x;
    -- energy monitoring - for simulation purpose only
    --shell be ignored for synthesis  
    sim: if (energy_mon_on) generate
        sum(0) <= 0;
        sum_up_energy : for I in 1 to nr_etaje  generate
            sum_i:    sum(I) <= sum(I-1) + en(I);
        end generate sum_up_energy;
        energy_mon <= sum(3);
     end generate sim;
     
     synth: if (not energy_mon_on) generate
        energy_mon <= 0;
     end generate synth;
    
end Behavioral;



architecture Behavioral2 of tdc_n_cell is

    signal chain: STD_LOGIC_VECTOR (0 to nr_etaje);
    type en_t is array (1 to 3*nr_etaje ) of natural;
    signal en : en_t;
    type sum_t is array (0 to 3*nr_etaje ) of natural;
    signal sum : sum_t;

    component delay_cell is
        Generic (delay : time :=1 ns);
        Port ( a : in STD_LOGIC;
               y : out STD_LOGIC;
               energy_mon: out natural);
    end component delay_cell;
    component dff is
        Generic ( active_front : boolean := true;
                dff_delay : time := 1 ns);
        Port ( D : in STD_LOGIC;
               Ck : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q, Qn : out STD_LOGIC;
               energy_mon : out natural);
    end component dff;
    
begin
 --  delay_0: unit_cell_tdc generic map (delay => delay, active_edge => true) port map (inB => start, Ck => stop, Rn => Rn, outB => netB(0), Q => Q(0), energy_mon => en(0));
   chain(0) <= start; 
   delay_x: 
   for I in 1 to nr_etaje generate
            delay_cell_i: delay_cell generic map (delay => delay) port map (a => chain(I-1), y => chain(I), energy_mon => en(3*I-2));
            odd :if( I mod 2 = 1 ) generate
                odd_dff: dff generic map (dff_delay => 1 ns) port map (D => chain(I), Ck => stop, Rn => Rn, Q => open, Qn => Q(I), energy_mon => en(3*I-1));
                end generate odd;
             
             even :if( I mod 2 = 0 ) generate
                dff_even: dff generic map (dff_delay => 1 ns) port map (D => chain(I), Ck => stop, Rn => Rn, Qn => open, Q => Q(I), energy_mon => en(3*I));
                end generate even;
     end generate delay_x;
    -- energy monitoring - for simulation purpose only
    --shell be ignored for synthesis  
    sim: if (energy_mon_on) generate
        sum(0) <= 0;
        sum_up_energy : for I in 1 to 3*nr_etaje  generate
            sum_i:    sum(I) <= sum(I-1) + en(I);
        end generate sum_up_energy;
        energy_mon <= sum(3*nr_etaje);
     end generate sim;
     
     synth: if (not energy_mon_on) generate
        energy_mon <= 0;
     end generate synth;
    
end Behavioral2;
