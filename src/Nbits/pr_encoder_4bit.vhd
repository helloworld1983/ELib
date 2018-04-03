----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description:  Priority encoder on 4 bits with activity monitroing
--              - the raw bits of a delay line converter must undergo for 
--                "thermal" encoding - priority encoding is  the second stage of the encoding)
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   bi - bits in
--              - outputs : bo - the priotity number
--                          mo - mask out - to next mask cell
--                          consumption :  port to monitor dynamic and static consumption
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: PELib.vhd, PEGates.vhd, Nbits.vhd
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.PELib.all;
use xil_defaultlib.PEGates.all;
use xil_defaultlib.Nbits.all;


entity pr_encoder_4bit is
    Port ( ei : in STD_LOGIC;
           bi : in STD_LOGIC_VECTOR(3 downto 0);
           bo : out STD_LOGIC_VECTOR(1 downto 0);
           eo,gs : inout STD_LOGIC;
           consumption : out consumption_type := (0.0,0.0));
end pr_encoder_4bit;

architecture Behavioral of pr_encoder_4bit is

    signal net1,net2,net3 : std_logic;
    
    type cons_t is array (1 to 5 ) of consumption_type;
    signal cons : cons_t;
    type sum_t is array (0 to 5 ) of consumption_type;
    signal sum : sum_t;

begin

inv1: inv_gate port map (a => bi(2), y => net1, consumption => cons(1));
and_gate1: and_gate port map (a => net1, b => bi(1), y => net3, consumption => cons(2));
or_gate1: or_gate port map (a => bi(3), b => bi(2), y => net2, consumption => cons(3));
or_gate2: or_gate port map (a => bi(3), b => net3, y => bo(0), consumption => cons(4)); 
or3_gate1: or3_gate port map (a => net2, b => bi(1), c => bi(0), y => gs, consumption => cons(5)); 
 
 bo(1) <= net2;
 
    -- consumption monitoring
 -- for simulation only                              
 sum(0) <= (0.0,0.0);
 sum_up_energy : for I in 1 to 5  generate
     sum_i:    sum(I) <= sum(I-1) + cons(I);
 end generate sum_up_energy;
 consumption <= sum(5);
 --for simulation only

end Behavioral;

architecture Structural of pr_encoder_4bit is

    component pr_encoder_2bit is
        Port ( ei : in STD_LOGIC;
               bi : in STD_LOGIC_VECTOR(1 downto 0);
               bo : out STD_LOGIC;
               eo, gs : out STD_LOGIC;
               consumption : out consumption_type := (0.0,0.0));
    end component;
    
    signal net0, net1,net2,net3, net4 : std_logic;
    
    type cons_t is array (1 to 4) of consumption_type;
    signal cons : cons_t;
    type sum_t is array (0 to 4) of consumption_type;
    signal sum : sum_t;
    
    

begin

    U1: pr_encoder_2bit port map ( ei => ei,  bi => bi(3 downto 2), bo => net0,
                                         eo => net1, gs => net2, consumption => cons(1));
    --bo(0) <= net0;
    bo(1) <= net2;
    U2: pr_encoder_2bit port map ( ei => net1,  bi => bi(1 downto 0), bo => net3,
                                         eo => eo, gs => net4, consumption => cons(2));
                                         
    U3: or_gate port map (a => net0, b => net3, y => bo(0), consumption => cons(3));
    U4: or_gate port map (a => net2, b => net4, y => gs, consumption => cons(4));
 -- consumption monitoring
 -- for simulation only                              
 sum(0) <= (0.0,0.0);
 sum_up_energy : for I in 1 to 4  generate
     sum_i:    sum(I) <= sum(I-1) + cons(I);
 end generate sum_up_energy;
 consumption <= sum(4);
 --for simulation only

end Structural;