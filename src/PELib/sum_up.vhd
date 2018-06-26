----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description: thi component is used to sum up the consumptions of individual gates/blocks.
-- Dependencies: PElib.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.PELib.all;

entity sum_up is
		generic ( N : natural := 1) ;-- number of inputs
		port ( cons : in consumption_type_array (1 to N);
		       consumption : out consumption_type := (0.0,0.0));
end entity;

architecture behavioral of sum_up is
    signal sum: consumption_type_array (0 to N) := (others => (0.0,0.0));
begin

    sum(0) <= (0.0,  0.0);
    sum_up_energy : for I in 1 to N generate
          sum_i:    sum(I) <= sum(I-1) + cons(I);
    end generate sum_up_energy;
    consumption <= sum(N);

end architecture;