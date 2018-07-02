----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: Ripple counter with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--                          active_edge  - the active clock front of DFFs
--                          width - the number of DFF cells in the counter
--              - inputs :  Clk - clock, active edge selected by active_edge param
--                          Rn - reset, active logic '0'
--              - outpus :  Q - counter value
--                          consumption :  port to monitor dynamic and static consumption
-- Dependencies: nand_gate.vhd
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

entity counter_Nbits is
    generic (
				delay : time := 0 ns;
				active_edge : boolean := TRUE;
				width : natural := 8;
				logic_family : logic_family_t; -- the logic family of the component
                gate : component_t; -- the type of the component
                Cload: real := 5.0 -- capacitive load
                );
		Port ( CLK : in STD_LOGIC;
			   Rn : in STD_LOGIC;
			   Q : out STD_LOGIC_VECTOR (width-1 downto 0);
			   Vcc : in real ; --supply voltage
			   consumption : out consumption_type := (0.0,0.0)
			   );
end counter_Nbits;

architecture Structural of counter_Nbits is

    signal ripple: STD_LOGIC_VECTOR (width downto 0);
    signal feedback : STD_LOGIC_VECTOR (width-1 downto 0);
    signal cons : consumption_type_array(1 to width);

begin

    ripple(0) <= CLK;
    gen_dff:  for i in 0 to width-1 generate
            gen_i : dff_Nbits generic map (delay => 0 ns, active_edge => active_edge, logic_family => logic_family, gate => none_comp) port map (D => feedback(i), Ck => ripple(i), Rn => Rn, Q => ripple(i+1), Qn => feedback(i), Vcc => Vcc, consumption => cons(i+1));
    end generate gen_dff;
    --feedback_d <= feedback after 1 ns;
    Q <= ripple(width downto 1);
    
    --+ consumption monitoring section
    -- for behavioral simulation only
    sum_up_i : sum_up generic map (N => width) port map (cons => cons, consumption => consumption);
end Structural;


