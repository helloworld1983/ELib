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
--                          activity : number of commutations (used to compute power dissipation)
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: nand_gate.vhd, and_gate.vhd, or_gate.vhd
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mask is
    Generic (delay: time:=0 ns);
    Port ( cb : in STD_LOGIC; -- current bit
           pb : in STD_LOGIC; --previous bit
           mi : in STD_LOGIC; -- mask in bit
           b : out STD_LOGIC; -- masked bit - output of the current stage
           mo : out STD_LOGIC; --mask out bit
           activity : out natural); -- activity monitoring
end mask;

architecture Behavioral of mask is
begin
    b <= cb and (not mi);
    mo <= mi  or ( (not cb) and pb);
    activity <= 0;
end Behavioral;

architecture Structural of mask is

    component delay_cell 
      Generic (delay : time :=1 ns);
      Port ( a : in STD_LOGIC;
             y : out STD_LOGIC;
             activity: out natural);
     end component;
     
     component and_gate
     Generic (delay : time :=1 ns);
     Port ( a : in STD_LOGIC;
            b : in STD_LOGIC;
            y : out STD_LOGIC;
            activity: out natural);
    end component;      
      
    component or_gate
    Generic (delay : time :=1 ns);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC;
           activity: out natural);
    end component; 
    -- activity monitoring signals
    signal mi_n, cb_n, net : std_logic;
    type act_t is array (0 to 4) of natural;
    signal act : act_t;
    type sum_t is array (-1 to 4) of natural;
    signal sum : sum_t;
    
 begin
 
     inv_g1: delay_cell generic map (delay => delay) port map (a => mi, y => mi_n, activity=>act(0));
     and_g1: and_gate generic map (delay => delay) port map (a => cb, b=>mi_n, y =>b, activity=>act(1));
     
     inv_g2: delay_cell generic map (delay => delay) port map (a => cb, y => cb_n, activity=>act(2));
     and_g2: and_gate generic map (delay => delay) port map (a=>pb, b=> cb_n, y=>net, activity=>act(3));
     or_g1: or_gate generic map (delay => delay) port map (a=> mi, b=> net, y=>mo, activity=>act(4));

    --+ activity monitoring
    -- for simulation only - to be ignored for synthesis 
    sum(-1) <= 0;
    sum_up_energy : for I in 0 to 4  generate
          sum_i:    sum(I) <= sum(I-1) + act(I);
    end generate sum_up_energy;
    activity <= sum(4);
    -- for simulation only - to be ignored for synthesis     
      
 end architecture;