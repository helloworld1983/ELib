----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description:  Mask on N bits (the raw bits of a delay line converter must undergo for "thermal" encoding - masking is a fisrt stage of the encoding)
--              - parameters :  delay1 - simulated delay time of an nand gate
--              - inputs:   cb - current bit
--                          pb - previous bit
--                          mi - mask in - from previous mask cell
--              - outputs : bo - masked bit out
--                          mo - mask out - to next mask cell
--                          consumption :  port to monitor dynamic and static consumption
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: nand_gate.vhd, and_gate.vhd, or_gate.vhd, util.vhd
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.PElib.all;
use xil_defaultlib.PEGates.all;

entity mask is
    Generic (delay: time:=0 ns);
    Port ( cb : in STD_LOGIC; -- current bit
           pb : in STD_LOGIC; --previous bit
           mi : in STD_LOGIC; -- mask in bit
           b : out STD_LOGIC; -- masked bit - output of the current stage
           mo : out STD_LOGIC; --mask out bit
           consumption : out consumption_type := (0.0,0.0)); -- consumption monitoring
end mask;

architecture Behavioral of mask is
begin
    b <= cb and (not mi);
    mo <= mi  or ( (not cb) and pb);
    consumption <= (0.0,0.0);
end Behavioral;

architecture Structural of mask is

    -- consumption monitoring signals
    signal mi_n, cb_n, net : std_logic;
    type cons_t is array (0 to 4) of consumption_type;
    signal cons : cons_t := (others => (0.0,0.0));
    type sum_t is array (-1 to 4) of consumption_type;
    signal sum : sum_t := (others => (0.0,0.0));
    
 begin
 
     inv_g1: inv_gate generic map (delay => delay) port map (a => mi, y => mi_n, consumption => cons(0));
     and_g1: and_gate generic map (delay => delay) port map (a => cb, b=>mi_n, y =>b, consumption => cons(1));
     
     inv_g2: inv_gate generic map (delay => delay) port map (a => cb, y => cb_n, consumption => cons(2));
     and_g2: and_gate generic map (delay => delay) port map (a=>pb, b=> cb_n, y=>net, consumption => cons(3));
     or_g1: or_gate generic map (delay => delay) port map (a=> mi, b=> net, y=>mo, consumption => cons(4));

    --+ consumption monitoring
    -- for simulation only - to be ignored for synthesis 
    sum(-1) <= (0.0,  0.0);
    sum_up_energy : for I in 0 to 4  generate
          sum_i:    sum(I) <= sum(I-1) + cons(I);
    end generate sum_up_energy;
    consumption <= sum(4);
    -- for simulation only - to be ignored for synthesis     
      
 end architecture;