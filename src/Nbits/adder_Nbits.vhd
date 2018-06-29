----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: N bit adder with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--                          width - the width of the number to be added
--              - inputs :  A, B - N bit operands
--                          Cin - Carry input
--              - outpus :  S - sum of A and B
--                          Cout - Carry out
--                          consumption :  port to monitor dynamic and static consumption
-- Dependencies: FA.vhd, Nbits.vhd
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

entity adder_Nbits is
    generic (   delay: time:= 0 ns;
				width: natural := 8;
				logic_family : logic_family_t; -- the logic family of the component
                gate : component_t; -- the type of the component
                Cload: real := 5.0 -- capacitive load
                );
		Port ( A : in STD_LOGIC_VECTOR (width-1 downto 0);
			   B : in STD_LOGIC_VECTOR (width-1 downto 0);
			   Cin : in STD_LOGIC;
			   Cout : out STD_LOGIC;
			   S : out STD_LOGIC_VECTOR (width-1 downto 0);
			   Vcc : in real ; --supply voltage
			   consumption : out consumption_type := (0.0,0.0)
			   );
end adder_Nbits;

architecture Behavioral of adder_Nbits is

    signal Cint: STD_LOGIC_VECTOR(0 to width);
    --consumption monitoring signals
    signal cons : consumption_type_array(1 to width);

begin

    Cint(0) <= Cin;
    GEN_FA : for i in 0 to width-1 generate
        FAi: FA generic map (delay => 0 ns, logic_family => logic_family, gate => none_comp) port map (A => A(i), B => B(i), Cin => Cint(i), Cout => Cint(i+1), S => S(i), Vcc => Vcc, consumption => cons(i+1));
    end generate GEN_FA;
    Cout <= Cint(width);
    
    --+ summing up consumption
    -- pragma synthesis_off
	sum_up_i : sum_up generic map ( N => width) port map (cons => cons, consumption => consumption);
    -- pragma synthesis_on
  
end Behavioral;
