----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: D type flip flop with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--                              active_edge - configure DFF to be active on positive or negative edge of clock
--              - inputs:   D - data bit
--                          Ck - clock, active edge selected by active_edge parameter
--              - outputs : Q, Qn - a nand b
--                          consumption :  port to monitor dynamic and static consumption
-- Dependencies: nand_gate.vhd, and_gate.vhd, delay_cell.vhd, latchSR.vhd, util.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.util.all;

entity dff is
    Generic ( active_edge : boolean := true;
            delay : time := 1 ns);
    Port ( D : in STD_LOGIC;
           Ck : in STD_LOGIC;
           Rn : in STD_LOGIC;
           Q, Qn : out STD_LOGIC;
           consumption : out consumption_monitor_type);
end dff;

architecture Behavioral of dff is

    signal Qint: STD_LOGIC := '0';
    signal en1, en2: natural;
begin

    rising_active: if active_edge generate
        process(Rn, Ck)
          begin
               if Rn = '0' then
                    Qint <= '0';
                else
                    if rising_edge(Ck) then 
                        Qint <= D;
                    end if;
            end if;
          end process;
    end generate rising_active;

    falling_active: if not active_edge generate
        process(Rn, Ck)
          begin
                if Rn = '0' then
                    Qint <= '0';
                else
                    if falling_edge(Ck) then 
                        Qint <= D;
                    end if;
                end if;
          end process;
     end generate falling_active;
      
    Q <= Qint after delay;
    Qn <= not Qint after delay;
    consumption <= (0.0,0.0);
    
end Behavioral;

architecture Structural of dff is

component latchD is
    Generic ( delay : time := 1 ns);
       Port ( D : in STD_LOGIC;
              Ck : in STD_LOGIC;
              Rn : in STD_LOGIC;
              Q, Qn : inout STD_LOGIC;
              consumption : out consumption_monitor_type);
end component;

component  delay_cell is
        Generic (delay : time :=1 ns);
        Port ( a : in STD_LOGIC;
               y : out STD_LOGIC;
               consumption : out consumption_monitor_type);
end component;
    
    signal net: STD_LOGIC_VECTOR (2 to 4);
    signal Ckn,Cknn: std_logic;
    --consumption monitoring
    type cons_t is array (0 to 3) of consumption_monitor_type;
    signal cons : cons_t;
    type sum_t is array (-1 to 3) of consumption_monitor_type;
    signal sum : sum_t;

begin

    falling_active: if (not active_edge) generate
        inversor1: delay_cell generic map (delay => 0 ns) port map (a => Ck, y => Ckn, consumption => cons(0));
    end generate falling_active ;
    
    rising_active: if (active_edge) generate
         Ckn <= Ck;  
         cons(0)<=(0.0,0.0);         
    end generate rising_active;
    
    inversor2: delay_cell generic map (delay => 1 ns) port map (a => Ckn, y => Cknn, consumption => cons(1));
    master: latchD generic map (delay => delay) port map (D => D, Ck => Cknn, Rn => Rn, Q => net(2), consumption => cons(2)); 
    slave : latchD generic map (delay => delay) port map (D => net(2), Ck => Ckn, Rn => Rn, Q => net(3), Qn => net(4),consumption => cons(3));        
    
    Q <= net(3);
    Qn <= net(4);
    
    --+ consumption monitoring
    -- for behavioral simulation only
    sum(-1) <= (0.0,  0.0);
    sum_up_energy : for I in 0 to 3 generate
          sum_i:    sum(I) <= sum(I-1) + cons(I);
    end generate sum_up_energy;
    consumption <= sum(3);
    --- for behavioral simulation only
end Structural;
