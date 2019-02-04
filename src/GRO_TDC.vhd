----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: Gated Ring Osccilator Time-to-digital converter 
--              - parameters :  nr_etaje - the length of the delay line
--                              delay - simulated delay time of an elementary gate
--                              active_edge  - the active clock front of DFFs
--              - inputs:   start - active on positive front
--                          stop - active front is selected by active_edge parameter
--                          Rn - flobal reset signal, active logic '0'
--              - outputs : Q - processed output
--                          estimation :  port to monitor dynamic and static estimation
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: GRO.vhd, counter_Nbits.vhd, adder_NBits.vhd, reg_Nbit.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity GRO_TDC is
    Generic (width : natural := 4;
            delay : time :=1 ns;
            logic_family : logic_family_t := default_logic_family; -- the logic family of the component
            Cload: real := 5.0 -- capacitive load
             );
    Port ( -- pragma synthesis_off
           Vcc : in real ; --supply voltage
           estimation : out estimation_type := est_zero;
           -- pragma synthesis_on
           start : in STD_LOGIC;
           stop : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (width-1 downto 0)
);
end GRO_TDC;

architecture Behavioral of GRO_TDC is

    component GRO is
         Generic (delay : time :=1 ns;
               logic_family : logic_family_t := default_logic_family; -- the logic family of the component
              Cload: real := 5.0 -- capacitive load
              );
       Port ( -- pragma synthesis_off
           Vcc : in real ; --supply voltage
           estimation : out estimation_type := est_zero;
           -- pragma synthesis_on   
           start : in STD_LOGIC;
           CLK : out STD_LOGIC_VECTOR (0 to 2)
           );
    end component;
    
    signal ck: STD_LOGIC_VECTOR(0 to 2);
    signal ckn: STD_LOGIC_VECTOR(0 to 2);
    signal C1p, C2p, C3p, C12p, C123p: STD_LOGIC_VECTOR(width - 1 downto 0);
    signal C1n, C2n, C3n, C12n, C123n,C123: STD_LOGIC_VECTOR(width - 1 downto 0);
    signal carryp, carryn: STD_LOGIC;
    signal carrypp, carrynn: STD_LOGIC;
    signal Rn : std_logic;
    --estimation monitoring
    signal estim : estimation_type_array(1 to 13);
begin
    --internal reset signal
    Rn <=  start;
    ckn <= not ck;
    -- instances used by the GRO TDC
    gro_cell: GRO generic map(delay => delay) port map (
                -- pragma synthesis_off
                estimation => estim(1),
                Vcc => Vcc,
                -- pragma synthesis_on
                start => start, CLK => ck);
    counter1p: counter_Nbits generic map (active_edge => FALSE, width => width) 
    port map (-- pragma synthesis_off
                estimation => estim(2),
                Vcc => Vcc,
                -- pragma synthesis_on
                CLK => ck(0), Rn => Rn, Q => C1p );
    counter2p: counter_Nbits generic map (active_edge => FALSE, width => width) 
    port map (-- pragma synthesis_off
                estimation => estim(3),
                Vcc => Vcc,
                -- pragma synthesis_on
                CLK => ck(1), Rn => Rn, Q => C2p);
    counter3p: counter_Nbits generic map (active_edge => FALSE, width => width) 
    port map (-- pragma synthesis_off
                estimation => estim(4),
                Vcc => Vcc,
                -- pragma synthesis_on
                CLK => ck(2), Rn => Rn, Q => C3p);
    counter1n: counter_Nbits generic map (active_edge => FALSE, width => width) 
    port map (-- pragma synthesis_off
                estimation => estim(5),
                Vcc => Vcc,
                -- pragma synthesis_on
                CLK => ckn(0), Rn => Rn, Q => C1n );
    counter2n: counter_Nbits generic map (active_edge => FALSE, width => width) 
    port map (-- pragma synthesis_off
                estimation => estim(6),
                Vcc => Vcc,
                -- pragma synthesis_on
                CLK => ckn(1), Rn => Rn, Q => C2n);
    counter3n: counter_Nbits generic map (active_edge => FALSE, width => width) 
    port map (-- pragma synthesis_off
                estimation => estim(7),
                Vcc => Vcc,
                -- pragma synthesis_on
                CLK => ckn(2), Rn => Rn, Q => C3n);
    adder1p: adder_Nbits generic map (delay => 0 ns, width => width) 
    port map (-- pragma synthesis_off
                estimation => estim(8),
                Vcc => Vcc,
                -- pragma synthesis_on
                Cin => '0', A => C1p, B => C2p, Cout => carryp, S => C12p);
    adder2p: adder_Nbits generic map (delay => 0 ns, width => width) 
    port map (-- pragma synthesis_off
                estimation => estim(9),
                Vcc => Vcc,
                -- pragma synthesis_on
                Cin => carryp, A => C12p, B => C3p, S => C123p, Cout => carrypp);
    adder1n: adder_Nbits generic map (delay => 0 ns, width => width) 
    port map (-- pragma synthesis_off
                estimation => estim(10),
                Vcc => Vcc,
                -- pragma synthesis_on
                Cin => carrypp, A => C1n, B => C2n, Cout => carryn, S => C12n);
    adder2n: adder_Nbits generic map (delay => 0 ns, width => width) 
    port map (-- pragma synthesis_off
                estimation => estim(11),
                Vcc => Vcc,
                -- pragma synthesis_on
                Cin => carryn, A => C12n, B => C3n, S => C123n, Cout => carrynn);
    adder123: adder_Nbits generic map (delay => 0 ns, width => width) 
    port map (-- pragma synthesis_off
                estimation => estim(12),
                Vcc => Vcc,
                -- pragma synthesis_on
                Cin => carrynn, A => C123n, B => C123p, S => C123);
    reg: reg_Nbits generic map (width => width) 
    port map (-- pragma synthesis_off
                estimation => estim(13),
                Vcc => Vcc,
                -- pragma synthesis_on
                D => C123, Ck => stop, Rn => '1', Q => Q);
    
    --+ estimation monitoring
    -- for behavioral simulation only
    -- pragma synthesis_off
    sum : sum_up generic map (N => 13) port map (estim => estim, estimation => estimation);
    -- for behavioral simulation only
    -- pragma synthesis_on
end Behavioral;
