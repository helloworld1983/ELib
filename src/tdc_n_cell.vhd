----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description: Delay Line Time-to-digital converter core (output bits must be processed)
--              - parameters :  nr_etaje - the length of the delay line
--                              delay - simulated delay time of an elementary gate
--                              active_edge  - the active clock front of DFFs
--              - inputs:   start - active on positive front
--                          stop - active front is selected by active_edge parameter
--                          Rn - flobal reset signal, active logic '0'
--              - outputs : Q - raw output
--                          estimation :  port to monitor dynamic and static estimation
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: inv_gate.vhd, dff.vhd
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

entity tdc_n_cell is
    Generic (nr_etaje : natural :=4;
            delay : time :=1 ns;
            --activity_mon_on : boolean := true;
            active_edge : boolean := true;
            logic_family : logic_family_t := default_logic_family; -- the logic family of the component
            Cload: real := 5.0 -- capacitive load
            );
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           Rn : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
           Vcc : in real; --supply voltage
            estimation : out estimation_type := est_zero);
end tdc_n_cell;

architecture Structural of tdc_n_cell is

    signal chain: STD_LOGIC_VECTOR (0 to nr_etaje);
    signal estim : estimation_type_array(1 to 2*nr_etaje);  
begin
    chain(0) <= start; 
    delay_line: 
    --for I in 1 to nr_etaje generate
    for I in 0 to nr_etaje-1 generate
            --inv_i: inv_gate generic map (delay => delay) port map (a => chain(I-1), y => chain(I), estimation => estim(3*I-2));
            inv_i: inv_gate generic map (delay => delay) port map (
                -- pragma synthesis_off
                Vcc => Vcc, estimation => estim(2*I+2),
                -- pragma synthesis_on
                a => chain(I), y => chain(I+1));
            odd :if( I mod 2 = 1 ) generate
                odd_dff: dff_nbits generic map (delay => 0 ns) port map (
                    -- pragma synthesis_off
                    Vcc => Vcc, estimation => estim(2*I+1),
                    -- pragma synthesis_on
                    D => chain(I), Ck => stop, Rn => Rn, Q => open, Qn => Q(I));
                end generate odd;
             
             even :if( I mod 2 = 0 ) generate
                dff_even: dff_nbits generic map (delay => 0 ns) port map (
                    -- pragma synthesis_off
                    VCC => VCC, estimation => estim(2*I+1), 
                    -- pragma synthesis_on
                    D => chain(I), Ck => stop, Rn => Rn, Qn => open, Q => Q(I));
                end generate even;
     end generate delay_line;
    -- estimation monitoring - for simulation purpose only
    -- pragma synthesis_off
    sum : sum_up generic map (N => 2*nr_etaje) port map (estim => estim, estimation => estimation);
    -- pragma synthesis_on
    
end Structural;
