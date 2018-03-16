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
--                          activity : number of commutations (used to compute power dissipation)
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: nand_gate.vhd, and_gate.vhd, or_gate.vhd
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mask_Nbits is
    Generic (nr_etaje : natural := 4);
    Port ( RawBits : in STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
           MaskedBits : out STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
           activity : out natural);
end mask_Nbits;

architecture Structural of mask_Nbits is
    component mask is
        Generic (delay : time:=0 ns);
        Port ( cb : in STD_LOGIC; -- current bit
               pb : in STD_LOGIC; --previous bit
               mi : in STD_LOGIC; --mask in bit
               b : out STD_LOGIC; -- masked bit - output of the current stage
               mo : out STD_LOGIC; --mask out bit
               activity : out natural); -- activity monitoring
    end component mask;

    signal RawB : STD_LOGIC_VECTOR (nr_etaje downto 0);
    signal M : STD_LOGIC_VECTOR (nr_etaje downto 0); -- Mask Bits

    --activity monitoring signals
    type act_t is array (1 to nr_etaje ) of natural;
    signal act : act_t;
    type sum_t is array (0 to nr_etaje ) of natural;
    signal sum : sum_t;  
      
begin

     RawB <= RawBits & '0';
     M(0) <= '0';
   mask_x :
    for I in 1 to nr_etaje generate
        mask_i : mask port map ( cb => RawB(I), pb => RawB(I-1), mi => M(I-1), b=>MaskedBits(I - 1), mo => M(I), activity => act (I));
    end generate mask_x;
    -- activity monitoring section 
    -- not for sinthesis  
    sum(0) <= 0;
     sum_up_energy : for I in 1 to nr_etaje  generate
         sum_i:    sum(I) <= sum(I-1) + act(I);
     end generate sum_up_energy;
     activity <= sum(3);
     
end Structural;
