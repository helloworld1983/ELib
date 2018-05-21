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
--                          consumption :  port to monitor dynamic and static consumption
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: inv_gate.vhd, dff.vhd
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

entity tdc_n_cell is
    Generic (nr_etaje : natural :=4;
            delay : time :=1 ns;
            --activity_mon_on : boolean := true;
            active_edge : boolean := true
            );
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           Rn : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
            consumption : out consumption_type := (0.0,0.0));
end tdc_n_cell;

architecture Structural of tdc_n_cell is

    signal chain: STD_LOGIC_VECTOR (0 to nr_etaje);
    type cons_t is array (1 to 2*nr_etaje ) of consumption_type ;
    signal cons : cons_t := (others => (dynamic => 0.0, static => 0.0));
    type sum_t is array (0 to 2*nr_etaje ) of consumption_type;
    signal sum : sum_t ;
    
begin
    chain(0) <= start; 
    delay_line: 
    --for I in 1 to nr_etaje generate
    for I in 0 to nr_etaje-1 generate
            --inv_i: inv_gate generic map (delay => delay) port map (a => chain(I-1), y => chain(I), consumption => cons(3*I-2));
            inv_i: inv_gate generic map (delay => delay) port map (a => chain(I), y => chain(I+1), consumption => cons(2*I+2));
            odd :if( I mod 2 = 1 ) generate
                odd_dff: dff generic map (delay => 0 ns) port map (D => chain(I), Ck => stop, Rn => Rn, Q => open, Qn => Q(I), consumption => cons(2*I+1));
                end generate odd;
             
             even :if( I mod 2 = 0 ) generate
                dff_even: dff generic map (delay => 0 ns) port map (D => chain(I), Ck => stop, Rn => Rn, Qn => open, Q => Q(I), consumption => cons(2*I+1));
                end generate even;
     end generate delay_line;
    -- consumption monitoring - for simulation purpose only
    -- pragma synthesis_off
        sum(0) <= (0.0,0.0);
        sum_up_energy : for I in 1 to 2*nr_etaje  generate
            sum_i:    sum(I) <= sum(I-1) + cons(I);
        end generate sum_up_energy;
        consumption <= sum(2*nr_etaje);
    -- pragma synthesis_on
    
end Structural;
