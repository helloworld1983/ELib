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
--                          consumption :  port to monitor dynamic and static consumption
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: nand_gate.vhd, and_gate.vhd, or_gate.vhd
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.PElib.all;
use xil_defaultlib.PEGates.all;
use xil_defaultlib.Nbits.all;

entity mask_Nbits is
    Generic (nr_etaje : natural := 4);
    Port ( RawBits : in STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
           MaskedBits : out STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
           consumption : out consumption_type := (0.0,0.0));
end mask_Nbits;

architecture Structural of mask_Nbits is
    component mask is
        Generic (delay : time:=0 ns);
        Port ( cb : in STD_LOGIC; -- current bit
               pb : in STD_LOGIC; --previous bit
               mi : in STD_LOGIC; --mask in bit
               b : out STD_LOGIC; -- masked bit - output of the current stage
               mo : out STD_LOGIC; --mask out bit
               consumption : out consumption_type := (0.0,0.0)); -- consumption monitoring
    end component mask;

    signal RawB : STD_LOGIC_VECTOR (nr_etaje downto 0);
    signal M : STD_LOGIC_VECTOR (nr_etaje downto 0); -- Mask Bits

    --consumption monitoring signals
    type cons_t is array (1 to nr_etaje ) of consumption_type;
    signal cons : cons_t := (others => (0.0,0.0));
    type sum_t is array (0 to nr_etaje ) of consumption_type;
    signal sum : sum_t := (others => (0.0,0.0));  
      
begin

     RawB <= RawBits & '0';
     M(0) <= '0';
   mask_x :
    for I in 1 to nr_etaje generate
        mask_i : mask port map ( cb => RawB(I), pb => RawB(I-1), mi => M(I-1), b=>MaskedBits(I - 1), mo => M(I), consumption => cons (I));
    end generate mask_x;
    -- consumption monitoring section 
    -- not for sinthesis  
    sum(0) <= (0.0,0.0);
     sum_up_energy : for I in 1 to nr_etaje  generate
         sum_i:    sum(I) <= sum(I-1) + cons(I);
     end generate sum_up_energy;
     consumption <= sum(3);
     
end Structural;
