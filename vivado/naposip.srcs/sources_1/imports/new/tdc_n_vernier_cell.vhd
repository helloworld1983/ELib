library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tdc_n_vernier_cell is
    Generic (delay1 : time :=2 ns;
             delay2 : time :=1 ns;
             nr_etaje : natural :=4);
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           R : in STD_LOGIC; 
           Q : out STD_LOGIC_VECTOR (1 to nr_etaje);
           energy_mon : out natural);
end tdc_n_vernier_cell;

architecture Behavioral of tdc_n_vernier_cell is

component vernier_cell is
   Generic (delay1 : time :=2 ns;
             delay2 : time :=1 ns;
             active_front : boolean := true);
    Port ( Vin : in STD_LOGIC;
           Ck : in STD_LOGIC;
           R : in STD_LOGIC;
           Vout : out STD_LOGIC;
           Q : out STD_LOGIC;
           Qn : out STD_LOGIC;
           ck_out: out STD_LOGIC;
           energy_mon : out natural);
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

signal netB: STD_LOGIC_VECTOR (0 to nr_etaje);
signal net: STD_LOGIC_VECTOR (0 to nr_etaje);
type en_t is array (1 to 2 * nr_etaje ) of natural;
signal en : en_t;
signal sum: natural := 0;

signal RawQ : STD_LOGIC_VECTOR (0 to nr_etaje); -- signal connecting the delay line and the masks
signal M : STD_LOGIC_VECTOR (0 to nr_etaje); -- Mask Bits


begin

   --cell_0: vernier_cell  generic map (active_front => true) port map (Vin => start, Ck => stop, R => R, Vout => netB(0), Q => Q(0),ck_out => net(0), energy_mon => en(0));
   netB(0) <= start;
   net(0) <= stop;
   cell_x: 
   for I in 1 to nr_etaje generate
            odd: if( I mod 2 = 1 ) generate
                vernier_cell_odd: vernier_cell generic map (active_front => false, delay1 => delay1, delay2 =>delay2) port map (Vin => netB(I-1), Ck => net(I-1) , R => R, Vout => netB(I), Q => RawQ(I),ck_out => net(I), energy_mon => en(I));
                end generate odd;
             
             even: if( I mod 2 = 0 ) generate
                vernier_cell_even: vernier_cell generic map (active_front => true, delay1 => delay1, delay2 =>delay2) port map (Vin => netB(I-1), Ck => net(I-1), R => R, Vout => netB(I), Qn => RawQ(I), ck_out => net(I), energy_mon => en(I));
                end generate even;
     end generate cell_x;

     RawQ(0) <= '0';
     M(0) <= '0';
     mask_x :
      for I in 1 to nr_etaje generate
          mask_i : mask port map ( cb => RawQ(I), pb => RawQ(I-1), mi => M(I-1), b=>Q(I), mo => M(I), energy_mon => en (nr_etaje + I));
      end generate mask_x;  
     
     process(en)
                  begin
                  label1: for I in 1 to nr_etaje loop
                              sum <= (sum + en(I));
                          end loop;
                  end process;
      energy_mon <= sum;
end Behavioral;


