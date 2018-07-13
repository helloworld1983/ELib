----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
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
--                          consumption :  port to monitor dynamic and static consumption
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: util.vhd, tdc_n_cell.vhd, mask_NBits.vhd, pe_Nbit.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PElib.all;
use work.PEGates.all;
use work.Nbits.all;

entity DL_TDC is
    Generic (nr_etaje : natural :=4;
            delay : time := 1 ns;
            active_edge : boolean := true;
            logic_family : logic_family_t; -- the logic family of the component
            gate : component_t; -- the type of the component
            Cload: real := 5.0 -- capacitive load
            );
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           Rn : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (log2(nr_etaje)-1 downto 0);
           Vcc : in real; --supply voltage
           consumption : out consumption_type := (0.0,0.0));
end DL_TDC;

architecture Behavioral of DL_TDC is
    component tdc_n_cell is
        Generic (nr_etaje : natural :=4;
                delay : time :=1 ns;
                --activity_mon_on : boolean := true;
                active_edge : boolean := true;
                logic_family : logic_family_t; -- the logic family of the component
                gate : component_t; -- the type of the component
                Cload: real := 5.0 -- capacitive load
                );
        Port ( start : in STD_LOGIC;
               stop : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q : out STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
               Vcc : in real; --supply voltage
                consumption : out consumption_type := (0.0,0.0));
    end component;
    component mask_Nbits is
        Generic (nr_etaje : natural := 4;
                    logic_family : logic_family_t; -- the logic family of the component
                    gate : component_t; -- the type of the component
                    Cload: real := 5.0 -- capacitive load
                    );
        Port ( RawBits : in STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
               MaskedBits : out STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
               Vcc : in real ; --supply voltage
               consumption : out consumption_type := (0.0,0.0));
    end component;
    component pe_NBits is 
          Generic ( N: natural := 4;
                      delay : time := 0 ns;
                      logic_family : logic_family_t; -- the logic family of the component
                      gate : component_t; -- the type of the component
                      Cload: real := 5.0 -- capacitive load
                      );
               Port (  ei : in std_logic;
                         bi : in STD_LOGIC_VECTOR (N-1 downto 0);
                        bo : out STD_LOGIC_VECTOR (log2(N)-1 downto 0);
                         eo : out std_logic;
                         gs : out std_logic;
                         Vcc : in real ; --supply voltage
                         consumption : out consumption_type := (0.0,0.0)
                         );
    end component;
    
    signal RawBits, MaskedBits : STD_LOGIC_VECTOR  (nr_etaje - 1 downto 0);
    signal cons : consumption_type_array(1 to 3);
begin

    TDC_core : tdc_n_cell generic map (nr_etaje => nr_etaje, delay => delay, logic_family => logic_family, gate => none_comp) 
                            port map ( start => start,
                                       stop =>stop,
                                       Rn => Rn,
                                       Q => RawBits,
                                       Vcc => Vcc, 
                                       consumption => cons(1));
    Mask : mask_Nbits generic map (nr_etaje => nr_etaje, logic_family => logic_family, gate => none_comp)
                        port map ( RawBits => RawBits,
                                    MaskedBits => MaskedBits,
                                     Vcc => Vcc, 
                                    consumption => cons(2));
    Encoder : pe_Nbits generic map (N => nr_etaje,logic_family => logic_family, gate => none_comp)
                        port map (ei => '1', bi => MaskedBits,
                                  bo => Q,
                                  eo => open,
                                  gs => open,
                                  Vcc => Vcc, 
                                  consumption => cons(3));
    --energy monitoring - for simulation only
    -- pragama synthesis_off
    sum : sum_up generic map (N => 3) port map (cons => cons, consumption => consumption);                           
    -- pragama synthesis_on                                
end Behavioral;
