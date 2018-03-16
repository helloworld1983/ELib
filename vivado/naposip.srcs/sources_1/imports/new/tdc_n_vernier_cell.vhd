library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tdc_n_vernier_cell is
    Generic (delay1 : time :=2 ns;
             delay2 : time :=1 ns;
             energy_mon_on : boolean := True; 
             nr_etaje : natural :=4);
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           Rn : in STD_LOGIC; 
           Q : out STD_LOGIC_VECTOR (nr_etaje downto 1);
           energy_mon : out natural);
end tdc_n_vernier_cell;

architecture Behavioral of tdc_n_vernier_cell is

component vernier_cell is
   Generic (delay1 : time :=2 ns;
             delay2 : time :=1 ns;
             active_front : boolean := true);
    Port ( Vin : in STD_LOGIC;
           Ck : in STD_LOGIC;
           Rn : in STD_LOGIC;
           Vout : out STD_LOGIC;
           Q : out STD_LOGIC;
           Qn : out STD_LOGIC;
           ck_out: out STD_LOGIC;
           energy_mon : out natural);
end component;

signal netB: STD_LOGIC_VECTOR (0 to nr_etaje);
signal net: STD_LOGIC_VECTOR (0 to nr_etaje);
type en_t is array (1 to nr_etaje ) of natural;
signal en : en_t;
type sum_t is array (0 to nr_etaje ) of natural;
signal sum : sum_t;


begin

   --cell_0: vernier_cell  generic map (active_front => true) port map (Vin => start, Ck => stop, Rn => Rn, Vout => netB(0), Q => Q(0),ck_out => net(0), energy_mon => en(0));
   netB(0) <= start;
   net(0) <= stop;
   cell_x: 
   for I in 1 to nr_etaje generate
            odd: if( I mod 2 = 1 ) generate
                vernier_cell_odd: vernier_cell generic map (active_front => false, delay1 => delay1, delay2 =>delay2) port map (Vin => netB(I-1), Ck => net(I-1) , Rn => Rn, Vout => netB(I), Q => Q(I),ck_out => net(I), energy_mon => en(I));
                end generate odd;
             
             even: if( I mod 2 = 0 ) generate
                vernier_cell_even: vernier_cell generic map (active_front => true, delay1 => delay1, delay2 =>delay2) port map (Vin => netB(I-1), Ck => net(I-1), Rn => Rn, Vout => netB(I), Qn => Q(I), ck_out => net(I), energy_mon => en(I));
                end generate even;
     end generate cell_x;

     
    sum(0) <= 0;
    sum_up_energy : for I in 1 to nr_etaje  generate
          sum_i:    sum(I) <= sum(I-1) + en(I);
    end generate sum_up_energy;
    energy_mon <= sum(3);


end Behavioral;

architecture Structural of tdc_n_vernier_cell is

    component delay_cell
        Generic (delay : time :=1 ns); 
        Port ( a : in STD_LOGIC;
               y : out STD_LOGIC;
               energy_mon: out natural);
    end component;
    
    component dff
         Generic ( active_front : boolean := true;
                    dff_delay: time := 0 ns);
         Port ( D : in STD_LOGIC;
              Ck : in STD_LOGIC;
              Rn : in STD_LOGIC;
              Q , Qn : out STD_LOGIC;
              energy_mon: out natural);
    end component;
 
    
    signal start_chain, stop_chain: STD_LOGIC_VECTOR (0 to nr_etaje);
    type en_t is array (1 to 3*nr_etaje ) of natural;
    signal en : en_t;
    type sum_t is array (0 to 3*nr_etaje ) of natural;
    signal sum : sum_t;


begin

   start_chain(0) <= start; 
   stop_chain(0) <= stop; 
   delay_x: 
   for I in 1 to nr_etaje generate
            stary_delay_cell: delay_cell generic map (delay => delay1) port map (a => start_chain(I-1), y => start_chain(I), energy_mon => en(3*I-2));
            stop_delay_cell: delay_cell generic map (delay => delay2) port map (a => stop_chain(I-1), y => stop_chain(I), energy_mon => en(3*I-1));
            odd :if( I mod 2 = 1 ) generate
                odd_dff: dff generic map (active_front => FALSE, dff_delay => 1 ns) port map (D => start_chain(I), Ck => stop_chain(i), Rn => Rn, Q => open, Qn => Q(I), energy_mon => en(3*I));
                end generate odd;
             
             even :if( I mod 2 = 0 ) generate
                dff_even: dff generic map (active_front => TRUE,dff_delay => 1 ns) port map (D => start_chain(I), Ck => stop_chain(i), Rn => Rn, Qn => open, Q => Q(I), energy_mon => en(3*I));
                end generate even;
     end generate delay_x;
    --+ energy monitoring 
    -- for simulation purpose only - shall be ignored for synthesis  
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

end Structural;
