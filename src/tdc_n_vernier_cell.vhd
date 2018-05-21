----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description: Vernier Delay Line Time-to-digital converter core (output bits must be processed)
--              - parameters :  nr_etaje - the length of the delay line
--                              delay1 - simulated delay time of an nand gate
--                              delay2 - simulated delay time of an inverter gate
--                              active_edge  - the active clock front of DFFs
--              - inputs:   start - active on positive front
--                          stop - active front is selected by active_edge parameter
--                          Rn - flobal reset signal, active logic '0'
--              - outputs : Q - raw output
--                          consumption :  port to monitor dynamic and static consumption
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: inv_gate.vhd, nand_gate.vhd, dff.vhd, util.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.PElib.all;
use xil_defaultlib.PEGates.all;
use xil_defaultlib.Nbits.all;

entity tdc_n_vernier_cell is
    Generic (delay1 : time :=2 ns;
             delay2 : time :=1 ns;
             --activity_mon_on : boolean := True; 
             nr_etaje : natural :=4);
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           Rn : in STD_LOGIC; 
           Q : out STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
           done : out STD_LOGIC;
           consumption : out consumption_type := (0.0,0.0));
end tdc_n_vernier_cell;

architecture Structural of tdc_n_vernier_cell is

    -- consumption monitoring signals 
    signal start_chain, stop_chain: STD_LOGIC_VECTOR (0 to nr_etaje);
    type cons_t is array (0 to 3*nr_etaje ) of consumption_type;
    signal cons : cons_t := (others => (0.0,0.0));
    type sum_t is array (-1 to 3*nr_etaje ) of consumption_type;
    signal sum : sum_t;

begin

   start_chain(0) <= start; 
   stop_chain(0) <= stop; 
   done_logic_odd : if (nr_etaje mod 2 = 1) generate
        --done <=  not stop_chain(nr_etaje);
        done_inv: inv_gate generic map (delay => 0 ns) port map (a => stop_chain(nr_etaje), y => done, consumption => cons(0));
  end generate;
   done_logic_even : if (nr_etaje mod 2 = 0) generate
        --cons(0) <= (0.0,0.0);
        done <=  stop_chain(nr_etaje);
   end generate;
   delay_x: 
   for I in 0 to nr_etaje-1 generate
            start_inv: nand_gate generic map (delay => delay1) port map (a => start_chain(I), b => start_chain(I), y => start_chain(I+1), consumption => cons(3*I+3));
            stop_inv: inv_gate generic map (delay => delay2) port map (a => stop_chain(I), y => stop_chain(I+1), consumption => cons(3*I+2));
            odd :if( I mod 2 = 1 ) generate
                odd_dff: dff generic map (active_edge => FALSE, delay => 1 ns) port map (D => start_chain(I), Ck => stop_chain(i), Rn => Rn, Q => open, Qn => Q(I), consumption => cons(3*I+1));
                end generate odd;
             
             even :if( I mod 2 = 0 ) generate
                dff_even: dff generic map (active_edge => TRUE,delay => 1 ns) port map (D => start_chain(I), Ck => stop_chain(i), Rn => Rn, Qn => open, Q => Q(I), consumption => cons(3*I+1));
                end generate even;
     end generate delay_x;
    --+ consumption monitoring 
    -- for simulation purpose only - shall be ignored for synthesis  
    -- pragma synthesis_off
        sum(-1) <= (0.0,0.0);
        sum_up_energy : for I in 0 to 3*nr_etaje  generate
            sum_i:    sum(I) <= sum(I-1) + cons(I);
        end generate sum_up_energy;
        consumption <= sum(3*nr_etaje);
     -- pragma synthesis_on

end Structural;
