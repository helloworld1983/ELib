----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: N bit register with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--                          active_edge  - rising_edge of clock signal
--                          width - the number of DFF cells in the register
--              - inputs :  Clk - clock, active on rising edge
--                          Rn - reset, active logic '0'
--              - outpus :  Q, Qn - register state
--                          consumption :  port to monitor dynamic and static consumption
-- Dependencies: dff.vhd, Nbits.vhd
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

entity reg_Nbits is
    Generic ( delay: time := 0 ns;
			      width: natural := 8;
				  logic_family : logic_family_t; -- the logic family of the component
                  gate : component_t; -- the type of the component
                  Cload: real := 5.0 -- capacitive load
                  );
		Port ( D : in STD_LOGIC_VECTOR (width-1 downto 0);
			   Ck : in STD_LOGIC;
			   Rn : in STD_LOGIC;
			   Q : out STD_LOGIC_VECTOR (width-1 downto 0);
			   Qn : out STD_LOGIC_VECTOR (width-1 downto 0);
			   Vcc : in real ; --supply voltage
			   consumption : out consumption_type := (0.0,0.0)
			   );
end reg_Nbits;

architecture Behavioral of reg_Nbits is

begin

    registre: process(Rn, Ck)
    begin 
        if Rn = '0' then
            Q <= (others => '0');
        else
           if rising_edge(Ck) then
            Q <= D;
           end if;
        end if;
    end process;
 
    consumption <= (0.0,0.0);

end Behavioral;

architecture Structural of reg_Nbits is
     signal cons : consumption_type_array(1 to width);
begin

    registre:  for i in 0 to width-1 generate
        dffi : dff_Nbits generic map (delay => 0 ns, active_edge => TRUE, logic_family => logic_family, gate => none_comp) port map (D => D(i), Ck => Ck, Rn => Rn, Q => Q(i), Qn => open, Vcc => Vcc, consumption => cons(i+1));
    end generate registre;

	sum_up_i : sum_up generic map (N => width) port map (cons => cons, consumption => consumption);
end Structural;