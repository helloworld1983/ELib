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
--                          estimation :  port to monitor dynamic and static estimation
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: inv_gate.vhd, nand_gate.vhd, dff.vhd, util.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity tdc_n_vernier_cell is
    Generic ( delay_start : time := 2 ns;
             delay_stop : time := 1 ns;
             --activity_mon_on : boolean := True; 
             nr_etaje : natural :=4;
             logic_family : logic_family_t := default_logic_family; -- the logic family of the component
             Cload: real := 5.0 -- capacitive load
             );
    Port ( -- pragma synthesis_off
           Vcc : in real ; -- supply voltage
           estimation : out estimation_type := est_zero;
           -- pragma synthesis_on
           start : in STD_LOGIC;
           stop : in STD_LOGIC;
           Rn : in STD_LOGIC; 
           Q : out STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
           done : out STD_LOGIC
           );
end tdc_n_vernier_cell;

architecture Structural of tdc_n_vernier_cell is

    -- estimation monitoring signals 
    signal start_chain, stop_chain: STD_LOGIC_VECTOR (0 to nr_etaje);
    signal estim : estimation_type_array(0 to 3*nr_etaje);

begin

   start_chain(0) <= start; 
   stop_chain(0) <= stop; 
   done_logic_odd : if (nr_etaje mod 2 = 1) generate
        --done <=  not stop_chain(nr_etaje);
        done_inv: inv_gate generic map (delay => 0 ns) port map (
            -- pragma synthesis_off
            estimation => estim(0),
            Vcc => Vcc,
            -- pragma synthesis_on
            a => stop_chain(nr_etaje), y => done);
  end generate;
   done_logic_even : if (nr_etaje mod 2 = 0) generate
        -- pragma synthesis_off
        estim(0) <= est_zero;
        -- pragma synthesis_on
        done <=  stop_chain(nr_etaje);
   end generate;
   delay_x: 
   for I in 0 to nr_etaje-1 generate
            start_chain_gates: nand_gate generic map (delay => delay_start) port map (
                -- pragma synthesis_off
                estimation => estim(3*I+3),
                Vcc => Vcc,
                -- pragma synthesis_on
                a => start_chain(I), b => start_chain(I), y => start_chain(I+1));
            stop_chain_gates: inv_gate generic map (delay => delay_stop) port map (
                -- pragma synthesis_off
                estimation => estim(3*I+2),
                Vcc => Vcc,
                -- pragma synthesis_on
                a => stop_chain(I), y => stop_chain(I+1));
            odd :if( I mod 2 = 1 ) generate
                odd_dff: dff_nbits generic map (active_edge => FALSE, delay => 1 ns) port map (
                    -- pragma synthesis_off
                    VCC => VCC, estimation => estim(3*I+1), 
                    -- pragma synthesis_on
                    D => start_chain(I), Ck => stop_chain(i), Rn => Rn, Q => open, Qn => Q(I));
                end generate odd;
             
             even :if( I mod 2 = 0 ) generate
                dff_even: dff_nbits generic map (active_edge => TRUE,delay => 1 ns) port map (
                    -- pragma synthesis_off
                    VCC => VCC, estimation => estim(3*I+1), 
                    -- pragma synthesis_on
                    D => start_chain(I), Ck => stop_chain(i), Rn => Rn, Qn => open, Q => Q(I));
                end generate even;
     end generate delay_x;
    --+ estimation monitoring 
    -- for simulation purpose only - shall be ignored for synthesis  
    -- pragma synthesis_off
        sum : sum_up generic map (N => 3*nr_etaje+1) port map (estim => estim, estimation => estimation);
     -- pragma synthesis_on

end Structural;
