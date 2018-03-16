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
--                          activity : number of commutations (used to compute power dissipation)
-- Dependencies: nand_gate.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_nbits is
    Generic ( delay: time := 0 ns;
                
                 width: natural := 8);
    Port ( D : in STD_LOGIC_VECTOR (width-1 downto 0);
           Ck : in STD_LOGIC;
           Rn : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (width-1 downto 0);
           Qn : out STD_LOGIC_VECTOR (width-1 downto 0);
           activity : out natural);
end reg_nbits;

architecture Behavioral of reg_nbits is

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
 
    activity <= 0;

end Behavioral;

architecture Structural of reg_nbits is

    component dff is
        Generic ( active_edge : boolean := true;
                delay : time := 0 ns);
        Port ( D : in STD_LOGIC;
               Ck : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q, Qn : out STD_LOGIC;
               activity : out natural);
    end component;
    -- activity monitoring
    type act_t is array (0 to width-1 ) of natural;
    signal act : act_t;
    type sum_t is array (-1 to width-1 ) of natural;
    signal sum : sum_t;

begin

    registre:  for i in 0 to width-1 generate
        dffi : dff generic map (active_edge => TRUE) port map (D => D(i), Ck => Ck, Rn => Rn, Q => Q(i), Qn => open, activity => act(i));
    end generate registre;

    --+ activity monitoring
    -- for behavioral simulation only - to be ignored for synthesis 
    sum(-1) <= 0;
    sum_up_energy : for I in 0 to width - 1  generate
          sum_i:    sum(I) <= sum(I-1) + act(I);
    end generate sum_up_energy;
    activity <= sum(width - 1);
    -- for behavioral simulation only - to be ignored for synthesis 

end Structural;


