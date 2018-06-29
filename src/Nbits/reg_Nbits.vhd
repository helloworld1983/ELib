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
                 width: natural := 8);
    Port ( D : in STD_LOGIC_VECTOR (width-1 downto 0);
           Ck : in STD_LOGIC;
           Rn : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (width-1 downto 0);
           Qn : out STD_LOGIC_VECTOR (width-1 downto 0);
           consumption : out consumption_type := (0.0,0.0));
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


    signal cons : consumption_type_array(1 to width) := (others => (0.0,0.0));


begin

    registre:  for i in 0 to width-1 generate
        dffi : dff generic map (delay => 0 ns, active_edge => TRUE) port map (D => D(i), Ck => Ck, Rn => Rn, Q => Q(i), Qn => open, consumption => cons(i+1));
    end generate registre;

    --+ consumption monitoring
    -- for behavioral simulation only - to be ignored for synthesis 
	-- pragma synthesis_off
    sum : sum_up generic map (N => width) port map (cons => cons, consumption => consumption)
	-- pragma synthesis_on
    -- for behavioral simulation only - to be ignored for synthesis 

end Structural;


