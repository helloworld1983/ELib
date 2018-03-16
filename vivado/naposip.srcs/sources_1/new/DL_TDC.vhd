----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description: Delay Line Time-to-digital converter 
--              - this module wraps a delay line made of N delay cells (inverters + D flip-flops)
--              - the raw converted value is postprocessed in mask_Nbits and pe_Nbits modules
--              - usage : 
--              - parameters :  nr_etaje - the length of the delay line
--                              delay - simulated delay time of an elementary gate
--                              active_edge  - the active clock front of DFFs
--              - inputs:   start - active on rising edge
--                          stop - active on rising edge
--                          Rn - flobal reset signal, active logic '0'
--              - outputs : Q - processed output
--                          activity : number of commutations (used to compute power dissipation)
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: util.vhd, tdc_n_cell.vhd, mask_NBits.vhd, pe_Nbit.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.util.all;

entity DL_TDC is
    Generic (nr_etaje : natural :=4;
            delay : time :=1 ns;
            active_edge : boolean := true);
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           Rn : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (log2(nr_etaje)-1 downto 0);
           activity: out natural);
end DL_TDC;

architecture Behavioral of DL_TDC is
    component tdc_n_cell is
        Generic (nr_etaje : natural :=4;
                delay : time :=1 ns;
                active_edge : boolean := true);
        Port ( start : in STD_LOGIC;
               stop : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q : out STD_LOGIC_VECTOR (nr_etaje downto 1);
                activity: out natural);
    end component;
    component mask_Nbits is
        Generic (nr_etaje : natural := 4);
        Port ( RawBits : in STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
               MaskedBits : out STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
               activity : out natural);
    end component;
    component pe_NBits is 
        Generic ( N: natural := 4;
               delay : time := 0 ns);
        Port ( bi : in STD_LOGIC_VECTOR (N-1 downto 0);
           bo : out STD_LOGIC_VECTOR (log2(N)-1 downto 0);
           activity: out integer);
    end component;
    
    signal RawBits, MaskedBits : STD_LOGIC_VECTOR  (nr_etaje - 1 downto 0);
    type act_t is array (1 to 3 ) of natural;
    signal act : act_t;
    type sum_t is array (0 to 3) of natural;
    signal sum : sum_t;
begin

    TDC_core : tdc_n_cell generic map (nr_etaje => nr_etaje) 
                            port map ( start => start,
                                       stop =>stop,
                                       Rn => Rn,
                                       Q => RawBits,
                                       activity => act(1));
    Mask : mask_Nbits generic map (nr_etaje => nr_etaje)
                        port map ( RawBits => RawBits,
                                    MaskedBits => MaskedBits,
                                    activity => act(2));
    Encoder : pe_Nbits generic map (N => nr_etaje)
                        port map (bi => MaskedBits,
                                  bo => Q,
                                  activity => act(3));

    sum(0) <= 0;
    sum_up_energy : for I in 1 to 3  generate
        sum_i:    sum(I) <= sum(I-1) + act(I);
    end generate sum_up_energy;
    activity <= sum(3);                             
                                    
end Behavioral;
