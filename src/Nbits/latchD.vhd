----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: D type latch with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   D - data bit
--                          Ck - clock, active '1' high
--              - outputs : Q, Qn - a nand b
--                          consumption :  port to monitor dynamic and static consumption
-- Dependencies: nand_gate.vhd, and_gate.vhd, inv_gate.vhd, latchSR.vhd, Nbits.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PElib.all;
use work.PEGates.all; 
use work.Nbits.all;


entity latchD is
        Generic ( delay : time := 1 ns;
	           logic_family : logic_family_t; -- the logic family of the component
               gate : component_t; -- the type of the component
               Cload: real := 5.0 -- capacitive load
               );
	    Port ( D : in STD_LOGIC;
			  Ck : in STD_LOGIC;
			  Rn : in STD_LOGIC;
			  Q, Qn : inout STD_LOGIC;
			  Vcc : in real ; --supply voltage
			  consumption : out consumption_type := (0.0,0.0)
			  );
end latchD;

architecture Behavioral of latchD is

     signal net: STD_LOGIC_VECTOR (1 to 4);
     signal cons : consumption_type_array(1 to 4);
begin


    gate1: nand_gate generic map (delay => delay, logic_family => logic_family, gate => nand_comp) port map (a => D, b =>Ck, y => net(1), Vcc => Vcc, consumption => cons(1));
    gate2: nand_gate generic map (delay => delay, logic_family => logic_family, gate => nand_comp) port map (a => net(1), b => Ck, y => net(2), Vcc => Vcc,  consumption => cons(2));
    gate3: and_gate generic map (delay => delay, logic_family => logic_family, gate => and_comp) port map (a => Rn, b => net(2), y => net(3), Vcc => Vcc, consumption => cons(3));
    latch4: latchSR generic map (delay => delay, logic_family => logic_family, gate => none_comp) port map (S=>net(1), R=>net(3), Q=>Q, Qn=>Qn, Vcc => Vcc, consumption => cons(4));
    
    --+ consumption monitoring
    -- for behavioral simulation only
   sum_up1 : sum_up generic map (N => 4) port map (cons => cons, consumption => consumption);
    --- for behavioral simulation only

end Behavioral;
