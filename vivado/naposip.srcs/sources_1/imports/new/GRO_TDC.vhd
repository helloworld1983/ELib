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
--                          activity : number of commutations (used to compute power dissipation)
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: GRO.vhd, counter_Nbits.vhd, adder_NBits.vhd, reg_Nbit.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity GRO_TDC is
    Generic (delay : time :=1 ns;
            width : natural := 4);
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (width-1 downto 0);
           activity : out natural);
end GRO_TDC;

architecture Behavioral of GRO_TDC is

    component GRO is
        Generic (delay : time :=1 ns);
        Port ( start : in STD_LOGIC;
               CLK : out STD_LOGIC_VECTOR (0 to 2);
               activity : out natural);
    end component;

    component counter_Nbits is
        generic (active_edge : boolean := TRUE;
                width : natural := 8);
        Port ( CLK : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q : out STD_LOGIC_VECTOR (width-1 downto 0);
               activity : out natural);
    end component;

    component adder_Nbits is
        generic (width : natural := 8);
        Port ( A : in STD_LOGIC_VECTOR (0 to width-1);
               B : in STD_LOGIC_VECTOR (0 to width-1);
               Cin : in STD_LOGIC;
               Cout : out STD_LOGIC;
               S : out STD_LOGIC_VECTOR (0 to width-1);
               activity : out natural);
    end component;
    
    component reg_Nbits is
        generic (width : natural := 8);
        Port ( D : in STD_LOGIC_VECTOR (0 to width-1);
               Ck : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q : out STD_LOGIC_VECTOR (0 to width-1);
               Qn : out STD_LOGIC_VECTOR (0 to width-1);
               activity : out natural);
    end component;
    
    signal ck: STD_LOGIC_VECTOR(0 to 2);
    signal C1, C2, C3, C12, C123: STD_LOGIC_VECTOR(width - 1 downto 0);
    signal carry: STD_LOGIC;
    signal Rn : std_logic;
    --activity monitoring
    type act_t is array (0 to 6) of natural;
    signal act : act_t;
    type sum_t is array (-1 to 6) of natural;
    signal sum : sum_t;


begin
    --internal reset signal
    Rn <=  start;
    -- instances used by the GRO TDC
    gro_cell: GRO generic map(delay => delay) port map (start => start, CLK => ck, activity => act(0));
    counter1: counter_Nbits generic map (active_edge => FALSE, width => width) port map (CLK => ck(0), Rn => Rn, Q => C1 ,activity => act(1));
    counter2: counter_Nbits generic map (active_edge => FALSE, width => width) port map (CLK => ck(1), Rn => Rn, Q => C2, activity => act(2));
    counter3: counter_Nbits generic map (active_edge => FALSE, width => width) port map (CLK => ck(2), Rn => Rn, Q => C3, activity => act(3));
    adder1: adder_Nbits generic map (width => width) port map (Cin => '0', A => C1, B => C2, Cout => carry, S => C12, activity => act(4));
    adder2: adder_Nbits generic map (width => width) port map (Cin => carry, A => C12, B => C3, S => C123, activity => act(5));
    reg: reg_nbits generic map (width => width) port map (D => C123, Ck => stop, Rn => '0', Q => Q, activity => act(6));
    
    --+ activity monitoring
    -- for behavioral simulation only
    sum(-1) <= 0;
    sum_up_energy : for I in 0 to 6 generate
          sum_i:    sum(I) <= sum(I-1) + act(I);
    end generate sum_up_energy;
    activity <= sum(width - 1);
    --- for behavioral simulation only
end Behavioral;
