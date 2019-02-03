----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description:  Mask on N bits
--              - wrapper modeule for mask.vhd, instantiates N mask cells
--              - the raw bits of a delay line converter must undergo for 
--              - "thermal" encoding - masking is the fisrt stage of encoding
--              - parameters :  delay1 - simulated delay time of an nand gate
--              - inputs:   cb - current bit
--                          pb - previous bit
--                          mi - mask in - from previous mask cell
--              - outputs : bo - masked bit out
--                          mo - mask out - to next mask cell
--                          estimation :  port to monitor dynamic and static estimation
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: nand_gate.vhd, and_gate.vhd, or_gate.vhd
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity mask_Nbits is
      Generic (nr_etaje : natural := 4;
                logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                Cload: real := 5.0 -- capacitive load
                );
    Port (  -- pragma synthesis_off
           Vcc : in real ; -- supply voltage
           estimation : out estimation_type := est_zero; -- estimation monitoring
           -- pragma synthesis_on
           RawBits : in STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
           MaskedBits : out STD_LOGIC_VECTOR (nr_etaje-1 downto 0)
           );
end mask_Nbits;

architecture Structural of mask_Nbits is
    component mask is
        Generic (delay: time:=0 ns;
                logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                Cload: real := 5.0 -- capacitive load
                );
        Port ( -- pragma synthesis_off
               Vcc : in real ; -- supply voltage
               estimation : out estimation_type := est_zero; -- estimation monitoring
               -- pragma synthesis_on
               cb : in STD_LOGIC; -- current bit
               pb : in STD_LOGIC; --previous bit
               mi : in STD_LOGIC; -- mask in bit
               b : out STD_LOGIC; -- masked bit - output of the current stage
               mo : out STD_LOGIC --mask out bit
        );
    end component mask;

    signal RawB : STD_LOGIC_VECTOR (nr_etaje downto 0);
    signal M : STD_LOGIC_VECTOR (nr_etaje downto 0); -- Mask Bits
    --estimation monitoring signals
    -- pragma synthesis_off
    signal estim : estimation_type_array(1 to nr_etaje);  
     -- pragma synthesis_on 
begin

     RawB <= RawBits & '0';
     M(0) <= '0';
   mask_x :
    for I in 1 to nr_etaje generate
        mask_i : mask generic map (delay => 0 ns) port map (
            -- pragma synthesis_off
            Vcc => Vcc, estimation => estim(I), 
            -- pragma synthesis_on
             cb => RawB(I), pb => RawB(I-1), mi => M(I-1), b=>MaskedBits(I - 1), mo => M(I));
    end generate mask_x;
    -- estimation monitoring section 
    -- pragma synthesis_off
    sum : sum_up generic map ( N => nr_etaje) port map (estim => estim, estimation => estimation);
    -- pragma synthesis_on 
end Structural;
