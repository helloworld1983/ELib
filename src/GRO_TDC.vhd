----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: Gated Ring Osccilator Time-to-digital converter 
--              - parameters :  width-number of SR blocks
--                              delay - simulated delay time of an elementary gate
--                              logic_family - the logic family of the tristate buffer
--                              gate-type of gate 
--								Cload - load capacitance
--              - inputs:   start - active on positive front
--                          stop - active front is selected by active_edge parameter
--                          Vcc - supply voltage
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

library xil_defaultlib;
use xil_defaultlib.PElib.all;
use xil_defaultlib.PEGates.all;
use xil_defaultlib.Nbits.all;

entity GRO_TDC is
    Generic (width : natural := 4;
            delay : time :=1 ns;
            logic_family : logic_family_t; -- the logic family of the component
            gate : component_t; -- the type of the component
            Cload: real := 5.0 -- capacitive load
             );
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (width-1 downto 0);
           Vcc : in real ; --supply voltage
           consumption : out consumption_type := (0.0,0.0));
end GRO_TDC;

architecture Behavioral of GRO_TDC is

    component GRO is
         Generic (delay : time :=1 ns;
               logic_family : logic_family_t; -- the logic family of the component
              gate : component_t; -- the type of the component
              Cload: real := 5.0 -- capacitive load
              );
       Port ( start : in STD_LOGIC;
              CLK : out STD_LOGIC_VECTOR (0 to 2);
              Vcc : in real ; --supply voltage
              consumption : out consumption_type := (0.0,0.0));
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
    gro_cell: GRO generic map(delay => delay, logic_family => logic_family, gate => none_comp) port map (start => start, CLK => ck, Vcc => Vcc, consumption => cons(7));
    counter1: counter_Nbits generic map (active_edge => FALSE, width => width, logic_family => logic_family) port map (CLK => ck(0), Rn => Rn, Q => C1 , Vcc => Vcc, consumption => cons(1));
    counter2: counter_Nbits generic map (active_edge => FALSE, width => width, logic_family => logic_family) port map (CLK => ck(1), Rn => Rn, Q => C2, Vcc => Vcc, consumption => cons(2));
    counter3: counter_Nbits generic map (active_edge => FALSE, width => width, logic_family => logic_family) port map (CLK => ck(2), Rn => Rn, Q => C3, Vcc => Vcc, consumption => cons(3));
    adder1: adder_Nbits generic map (delay => 0 ns, width => width, logic_family => logic_family) port map (Cin => '0', A => C1, B => C2, Cout => carry, S => C12, Vcc => Vcc, consumption => cons(4));
    adder2: adder_Nbits generic map (delay => 0 ns, width => width, logic_family => logic_family) port map (Cin => carry, A => C12, B => C3, S => C123, Vcc => Vcc, consumption => cons(5));
    reg: reg_Nbits generic map (width => width, logic_family => logic_family) port map (D => C123, Ck => stop, Rn => '1', Q => Q, Vcc => Vcc, consumption => cons(6));
    
    --+ consumption monitoring
    -- for behavioral simulation only
    sum : sum_up generic map (N => 7) port map (cons => cons, consumption => consumption);
    --- for behavioral simulation only
end Behavioral;
