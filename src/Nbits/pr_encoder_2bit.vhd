----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia, Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description:  Priority encoder on 2 bits with activity monitroing
--              - parameters :  logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs:   bi - bits in
--              - outputs : bo - the priotity number
--                          mo - mask out - to next mask cell
--                          consumption :  port to monitor dynamic and static consumption
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: PElib.vhd, PEGates.vhd, Nbits.vhd
-- Revision: 0.02 - Added comments
-- Revision: 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

library work;
use work.PElib.all;
use work.PEGates.all; 
use work.Nbits.all;

entity pr_encoder_2bit is
    Generic (logic_family : logic_family_t; -- the logic family of the component
             Cload: real := 5.0 -- capacitive load
              );
    Port ( ei : in STD_LOGIC;
           bi : in STD_LOGIC_VECTOR(1 downto 0);
           bo : out STD_LOGIC;
           eo, gs : out STD_LOGIC;
           Vcc: in real; -- supply voltage
           consumption : out consumption_type := (0.0,0.0));
end pr_encoder_2bit;

architecture Behavioral of pr_encoder_2bit is
    signal eo_intern : std_logic;
begin

     eo_intern <= not (ei or (bi(1)) or (bi(0)));
     eo <= eo_intern;
     gs <=  ei nor (eo_intern);
     -- ls348 are iesiri cu inalta impedanta
     --bo <= bi(1) when (ei = '1' and eo = '1') else 'Z';
     bo <= bi(1); 
    consumption <= (0.0,0.0);

end Behavioral;

architecture structural of pr_encoder_2bit is
    signal tristate_enable, eo_intern : std_logic;
    signal cons : consumption_type_array(1 to 2);
begin
     -- gs <=  ei nor eo;
    nor1: nor_gate generic map (delay => 0 ns, logic_family => logic_family, gate => nor_comp ) port map (a => ei, b => eo_intern,  y => gs, Vcc => Vcc, consumption => cons(1));
    -- eo <= ei nor bi(1) nor bi(0);
    nor2: nor3_gate generic map (delay => 0 ns, logic_family => logic_family, gate => none_comp ) port map (a => ei, b => bi(1), c => bi(0), y => gs,Vcc => Vcc, consumption => cons(2));
    --bo(0) <= bi(1) when (ei = '1' and eo = '1') else 'Z';
    --and1: and_gate port map (a => ei, b => eo, y => tristate_enable, consumption => en3);
    --buffer1 : tristate_buf port map (a => bi(1), en => tristate_enable, y => bo, consumption => en4); 
    bo <= bi(1);
    eo <= eo_intern;
    
    sum_up1 : sum_up generic map (N => 2) port map (cons => cons, consumption => consumption);

end architecture;
