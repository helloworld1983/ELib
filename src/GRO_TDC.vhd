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
--                          consumption :  port to monitor dynamic and static consumption
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
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (width-1 downto 0);
           Vcc : in real ; --supply voltage
           consumption : out consumption_type := cons_zero);
end GRO_TDC;

architecture Behavioral of GRO_TDC is

    component GRO is
         Generic (delay : time :=1 ns;
               logic_family : logic_family_t := default_logic_family; -- the logic family of the component
              Cload: real := 5.0 -- capacitive load
              );
       Port ( start : in STD_LOGIC;
              CLK : out STD_LOGIC_VECTOR (0 to 2);
              Vcc : in real ; --supply voltage
              consumption : out consumption_type := cons_zero);
    end component;
    
    signal ck: STD_LOGIC_VECTOR(0 to 2);
    signal C1, C2, C3, C12, C123: STD_LOGIC_VECTOR(width - 1 downto 0);
    signal carry: STD_LOGIC;
    signal Rn : std_logic;
    --consumption monitoring
    signal cons : consumption_type_array(1 to 7);
begin
    --internal reset signal
    Rn <=  start;
    -- instances used by the GRO TDC
    gro_cell: GRO generic map(delay => delay) port map (start => start, CLK => ck, Vcc => Vcc, consumption => cons(1));
    counter1: counter_Nbits generic map (active_edge => FALSE, width => width) port map (CLK => ck(0), Rn => Rn, Q => C1 , Vcc => Vcc, consumption => cons(2));
    counter2: counter_Nbits generic map (active_edge => FALSE, width => width) port map (CLK => ck(1), Rn => Rn, Q => C2, Vcc => Vcc, consumption => cons(3));
    counter3: counter_Nbits generic map (active_edge => FALSE, width => width) port map (CLK => ck(2), Rn => Rn, Q => C3, Vcc => Vcc, consumption => cons(4));
    adder1: adder_Nbits generic map (delay => 0 ns, width => width) port map (Cin => '0', A => C1, B => C2, Cout => carry, S => C12, Vcc => Vcc, consumption => cons(5));
    adder2: adder_Nbits generic map (delay => 0 ns, width => width) port map (Cin => carry, A => C12, B => C3, S => C123, Vcc => Vcc, consumption => cons(6));
    reg: reg_Nbits generic map (width => width) port map (D => C123, Ck => stop, Rn => '1', Q => Q, Vcc => Vcc, consumption => cons(7));
    
    --+ consumption monitoring
    -- for behavioral simulation only
    sum : sum_up generic map (N => 7) port map (cons => cons, consumption => consumption);
    --- for behavioral simulation only
end Behavioral;
