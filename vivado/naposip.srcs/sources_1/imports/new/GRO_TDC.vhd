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

library xil_defaultlib;
use xil_defaultlib.util.all;

entity GRO_TDC is
    Generic (delay : time :=1 ns;
            width : natural := 4);
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (width-1 downto 0);
           consumption : out consumption_monitor_type);
end GRO_TDC;

architecture Behavioral of GRO_TDC is

    component GRO is
        Generic (delay : time :=1 ns);
        Port ( start : in STD_LOGIC;
               CLK : out STD_LOGIC_VECTOR (0 to 2);
               consumption : out consumption_monitor_type);
    end component;

    component counter_Nbits is
        generic (active_edge : boolean := TRUE;
                width : natural := 8);
        Port ( CLK : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q : out STD_LOGIC_VECTOR (width-1 downto 0);
               consumption : out consumption_monitor_type);
    end component;

    component adder_Nbits is
        generic (width : natural := 8);
        Port ( A : in STD_LOGIC_VECTOR (0 to width-1);
               B : in STD_LOGIC_VECTOR (0 to width-1);
               Cin : in STD_LOGIC;
               Cout : out STD_LOGIC;
               S : out STD_LOGIC_VECTOR (0 to width-1);
               consumption : out consumption_monitor_type);
    end component;
    
    component reg_Nbits is
        generic (width : natural := 8);
        Port ( D : in STD_LOGIC_VECTOR (0 to width-1);
               Ck : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q : out STD_LOGIC_VECTOR (0 to width-1);
               Qn : out STD_LOGIC_VECTOR (0 to width-1);
               consumption : out consumption_monitor_type);
    end component;
    
    signal ck: STD_LOGIC_VECTOR(0 to 2);
    signal C1, C2, C3, C12, C123: STD_LOGIC_VECTOR(width - 1 downto 0);
    signal carry: STD_LOGIC;
    signal Rn : std_logic;
    --consumption monitoring
    type cons_t is array (0 to 6) of consumption_monitor_type;
    signal cons : cons_t;
    type sum_t is array (-1 to 6) of consumption_monitor_type;
    signal sum : sum_t;


begin
    --internal reset signal
    Rn <=  start;
    -- instances used by the GRO TDC
    gro_cell: GRO generic map(delay => delay) port map (start => start, CLK => ck, consumption => cons(0));
    counter1: counter_Nbits generic map (active_edge => FALSE, width => width) port map (CLK => ck(0), Rn => Rn, Q => C1 ,consumption => cons(1));
    counter2: counter_Nbits generic map (active_edge => FALSE, width => width) port map (CLK => ck(1), Rn => Rn, Q => C2, consumption => cons(2));
    counter3: counter_Nbits generic map (active_edge => FALSE, width => width) port map (CLK => ck(2), Rn => Rn, Q => C3, consumption => cons(3));
    adder1: adder_Nbits generic map (width => width) port map (Cin => '0', A => C1, B => C2, Cout => carry, S => C12, consumption => cons(4));
    adder2: adder_Nbits generic map (width => width) port map (Cin => carry, A => C12, B => C3, S => C123, consumption => cons(5));
    reg: reg_nbits generic map (width => width) port map (D => C123, Ck => stop, Rn => '0', Q => Q, consumption => cons(6));
    
    --+ consumption monitoring
    -- for behavioral simulation only
    sum(-1) <= (0.0,0.0);
    sum_up_energy : for I in 0 to 6 generate
          sum_i:    sum(I) <= sum(I-1) + cons(I);
    end generate sum_up_energy;
    consumption <= sum(width - 1);
    --- for behavioral simulation only
end Behavioral;
