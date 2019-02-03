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
--                          estimation :  port to monitor dynamic and static estimation
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: nand_gate.vhd, and_gate.vhd, or_gate.vhd, util.vhd
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--library work;
use work.PECore.all;
use work.PEGates.all;

entity mask is
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
end mask;

architecture Behavioral of mask is
begin
    b <= cb and (not mi);
    mo <= mi  or ( (not cb) and pb);
    -- pragma synthesis_off
    estimation <= est_zero;
    -- pragma synthesis_on
end Behavioral;

architecture Structural of mask is

    -- estimation monitoring signals
    signal mi_n, cb_n, net : std_logic;
    -- pragma synthesis_off
    signal estim : estimation_type_array(1 to 5);
    -- pragma synthesis_on
 begin
 
     inv_g1: inv_gate generic map (delay => delay) port map (
                -- pragma synthesis_off
                estimation => estim(1),
                Vcc => Vcc,
                -- pragma synthesis_on
                a => mi, y => mi_n);
     and_g1: and_gate generic map (delay => delay) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(2), 
        -- pragma synthesis_on
        a => cb, b=>mi_n, y =>b);
     
     inv_g2: inv_gate generic map (delay => delay) port map (
                -- pragma synthesis_off
                estimation => estim(3),
                Vcc => Vcc,
                -- pragma synthesis_on
                a => cb, y => cb_n);
     and_g2: and_gate generic map (delay => delay) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(4), 
        -- pragma synthesis_on
        a=>pb, b=> cb_n, y=>net);
     or_g1: or_gate generic map (delay => delay) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(5),
        -- pragma synthesis_on
        a=> mi, b=> net, y=>mo);

    --+ estimation monitoring
    -- for simulation only - to be ignored for synthesis 
    -- pragma synthesis_off
sum : sum_up generic map ( N => 5) port map (estim => estim, estimation => estimation);
    -- for simulation only - to be ignored for synthesis 
    -- pragma synthesis_on    
      
 end architecture;