----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description: Vernier Delay Line Time-to-digital converter 
--              - this module wraps a Vernier delay line made of N delay cells (inverters + D flip-flops)
--              - the raw converted value is postprocessed in mask_Nbits and pe_Nbits modules
--              - usage : 
--              - parameters :  nr_etaje - the length of the delay line
--                              delay2 - simulated delay time of an elementary nand gate
--                              delay1 - simulated delay time of an elementary inverter gate
--              - inputs:   start - active on rising edge
--                          stop - active on risign edge
--                          Rn - flobal reset signal, active logic '0'
--              - outputs : Q - processed output
--                          consumption :  port to monitor dynamic and static consumption
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: util.vhd, tdc_n_vernier_cell.vhd, mask_NBits.vhd, pe_Nbit.vhd
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

entity VDL_TDC is
        Generic (delay1 : time :=2 ns;
                delay2 : time :=1 ns;
                nr_etaje : natural :=4);
        Port ( start : in STD_LOGIC;
            stop : in STD_LOGIC;
            Rn : in STD_LOGIC; 
            Q : out STD_LOGIC_VECTOR (log2(nr_etaje)-1 downto 0);
            consumption : out consumption_type := (0.0,0.0));
end entity;

architecture Sructural of VDL_TDC is 

    component tdc_n_vernier_cell is
        Generic (delay1 : time :=2 ns;
                 delay2 : time :=1 ns;
                 nr_etaje : natural :=4);
        Port ( start : in STD_LOGIC;
               stop : in STD_LOGIC;
               Rn : in STD_LOGIC; 
               Q : out STD_LOGIC_VECTOR (1 to nr_etaje);
               consumption : out consumption_type := (0.0,0.0));
    end component;
    component mask_Nbits is
        Generic (nr_etaje : natural := 4);
        Port ( RawBits : in STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
               MaskedBits : out STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
               consumption : out consumption_type := (0.0,0.0));
    end component;
    component pe_NBits is 
        Generic ( N: natural := 4;
               delay : time := 0 ns);
        Port ( ei : in std_logic;
               bi : in STD_LOGIC_VECTOR (N-1 downto 0);
               bo : out STD_LOGIC_VECTOR (log2(N)-1 downto 0);
               eo : out std_logic;
               gs : out std_logic;
           consumption : out consumption_type := (0.0,0.0));
    end component;
    -- consumption monitoring signals
    signal RawBits, MaskedBits : STD_LOGIC_VECTOR  (nr_etaje - 1 downto 0);    
    type cons_t is array (1 to 3) of consumption_type;
    signal cons : cons_t;
    type sum_t is array (0 to 3) of consumption_type;
    signal sum : sum_t;

begin

    TDC_core : tdc_n_vernier_cell generic map (nr_etaje => nr_etaje) 
                            port map ( start => start,
                                       stop =>stop,
                                       Rn => Rn,
                                       Q => RawBits,
                                       consumption => cons(1));
    Mask : mask_Nbits generic map (nr_etaje => nr_etaje)
                        port map ( RawBits => RawBits,
                                    MaskedBits => MaskedBits,
                                    consumption => cons(2));
    Encoder : pe_Nbits generic map (N => nr_etaje)
                        port map (ei => '0',
                                    bi => MaskedBits,
                                  bo => Q,
                                  eo => open,
                                  gs => open,
                                  consumption => cons(3));
    -- consumption monitoring
    -- for simulation only                              
    sum(0) <= (0.0,0.0);
    sum_up_energy : for I in 1 to 3  generate
        sum_i:    sum(I) <= sum(I-1) + cons(I);
    end generate sum_up_energy;
    consumption <= sum(3);
    --for simulation only
end architecture;