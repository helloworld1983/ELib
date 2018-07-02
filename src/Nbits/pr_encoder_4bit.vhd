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

library work;
use work.PELib.all;
use work.PEGates.all;
use work.Nbits.all;


entity pr_encoder_4bit is
    Generic (logic_family : logic_family_t; -- the logic family of the component
             gate : component_t; -- the type of the component
             Cload: real := 5.0 -- capacitive load
              );
    Port ( ei : in STD_LOGIC;
           bi : in STD_LOGIC_VECTOR(3 downto 0);
           bo : out STD_LOGIC_VECTOR(1 downto 0);
           eo,gs : out STD_LOGIC;
           Vcc : in real ; -- supply voltage
           consumption : out consumption_type := (0.0,0.0));
end pr_encoder_4bit;

architecture Behavioral of pr_encoder_4bit is

    signal net1,net2,net3 : std_logic;
    signal cons : consumption_type_array(1 to 5);
begin

inv1: inv_gate generic map (delay => 0 ns, logic_family => logic_family, gate => inv_comp ) port map (a => bi(2), y => net1, Vcc => Vcc, consumption => cons(1));
and_gate1: and_gate generic map (delay => 0 ns, logic_family => logic_family, gate => and_comp ) port map (a => net1, b => bi(1), y => net3, Vcc => Vcc, consumption => cons(2));
or_gate1: or_gate generic map (delay => 0 ns, logic_family => logic_family, gate => or_comp ) port map (a => bi(3), b => bi(2), y => net2, Vcc => Vcc, consumption => cons(3));
or_gate2: or_gate generic map (delay => 0 ns, logic_family => logic_family, gate => or_comp ) port map (a => bi(3), b => net3, y => bo(0), Vcc => Vcc, consumption => cons(4)); 
or3_gate1: or3_gate generic map (delay => 0 ns, logic_family => logic_family, gate => none_comp ) port map (a => net2, b => bi(1), c => bi(0), y => gs, Vcc => Vcc, consumption => cons(5)); 
 
 bo(1) <= net2;
 
 -- consumption monitoring
 -- for simulation only                              
    sum_up1 : sum_up generic map (N => 5) port map (cons => cons, consumption => consumption);

end Behavioral;

-- this solution should be further tested
architecture Structural of pr_encoder_4bit is

    component pr_encoder_2bit is
        Generic (logic_family : logic_family_t; -- the logic family of the component
                 gate : component_t; -- the type of the component
                 Cload: real := 5.0 -- capacitive load
                  );
        Port ( ei : in STD_LOGIC;
               bi : in STD_LOGIC_VECTOR(1 downto 0);
               bo : out STD_LOGIC;
               eo, gs : out STD_LOGIC;
               Vcc: in real; -- supply voltage
               consumption : out consumption_type := (0.0,0.0));
    end component;
    
    signal net0, net1,net2,net3, net4 : std_logic;
    signal cons : consumption_type_array(1 to 4);    
begin

    U1: pr_encoder_2bit generic map (logic_family => logic_family, gate => none_comp ) port map ( ei => ei,  bi => bi(3 downto 2), bo => net0,
                                         eo => net1, gs => net2, Vcc => Vcc, consumption => cons(1));
    --bo(0) <= net0;
    bo(1) <= net2;
    U2: pr_encoder_2bit generic map (logic_family => logic_family, gate => none_comp ) port map ( ei => net1,  bi => bi(1 downto 0), bo => net3,
                                         eo => eo, gs => net4,Vcc => Vcc, consumption => cons(2));
                                         
    U3: or_gate generic map (delay => 0 ns, logic_family => logic_family, gate => or_comp ) port map (a => net0, b => net3, y => bo(0),Vcc => Vcc, consumption => cons(3));
    U4: or_gate generic map (delay => 0 ns, logic_family => logic_family, gate => or_comp ) port map (a => net2, b => net4, y => gs,Vcc => Vcc, consumption => cons(4));
    
 -- consumption monitoring
 -- for simulation only                              
sum_up1 : sum_up generic map (N => 4) port map (cons => cons, consumption => consumption);
 --for simulation only

end Structural;

architecture Structural2 of pr_encoder_4bit is

    component pr_encoder_8bit is
       Port (  I : in STD_LOGIC_VECTOR(7 DOWNTO 0);
            EI: in STD_LOGIC;
            Y : out STD_LOGIC_VECTOR(2 DOWNTO 0);
            GS,EO : out STD_LOGIC;
            consumption: out consumption_type := (0.0,0.0));
   end component;
  
    signal to_bo : STD_LOGIC_VECTOR(2 DOWNTO 0);
begin

    U1: pr_encoder_8bit port map ( ei => ei,  I(3 downto 0) => bi, I(7 downto 4) => (others => '0'), Y => to_bo,
                                         eo => eo, gs => gs, consumption => consumption);
    bo <= to_bo(1 downto 0);
end Structural2;