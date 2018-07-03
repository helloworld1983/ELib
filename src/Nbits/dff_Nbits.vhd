----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: D type flip flop with activity monitoring and Reset
--              - parameters :  delay - simulated delay time of an elementary gate
--                              active_edge - configure DFF to be active on positive or negative edge of clock
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs:   D - data bit
--                          Ck - clock, active edge selected by active_edge parameter
--							Rn - reset, active on logic '0'
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outputs : Q, Qn - a nand b
--                          consumption :  port to monitor dynamic and static consumption
-- Dependencies: PElib.vhd, PeGates.vhd, Nbits.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision: 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PElib.all;
use work.PEGates.all;
use work.Nbits.all;

entity dff_Nbits is
    Generic (   active_edge : boolean := TRUE;
                delay : time := 1 ns;
                logic_family : logic_family_t; -- the logic family of the component
                Cload: real := 5.0 -- capacitive load
                );
        Port ( D : in STD_LOGIC;
               Ck : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q, Qn : out STD_LOGIC;
               Vcc : in real ; --supply voltage
               consumption : out consumption_type := (0.0,0.0)
               );
end dff_Nbits;

architecture Behavioral of dff_Nbits is

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

architecture Structural of dff_Nbits is
   
    signal net: STD_LOGIC_VECTOR (2 to 4);
    signal Ckn,Cknn: std_logic;
    signal cons : consumption_type_array(1 to 4);

begin

    falling_active: if (not active_edge) generate
        inversor1: inv_gate generic map (delay => 0 ns, logic_family => logic_family, gate => inv_comp ) port map (a => Ck, Vcc => Vcc, y => Ckn, consumption => cons(1));
    end generate falling_active ;
    
    rising_active: if (active_edge) generate
         Ckn <= Ck;  
    end generate rising_active;
    
    inversor2: inv_gate generic map (delay => 0 ns, logic_family => logic_family, gate => inv_comp ) port map (a => Ckn, Vcc => Vcc, y => Cknn, consumption => cons(4));
    master: latchD generic map (delay => delay, logic_family => logic_family, gate => none_comp) port map (D => D, Ck => Cknn, Rn => Rn, Q => net(2), Vcc => Vcc, consumption => cons(2)); 
    slave : latchD generic map (delay => delay, logic_family => logic_family, gate => none_comp) port map (D => net(2), Ck => Ckn, Rn => Rn, Q => net(3), Qn => net(4),Vcc => Vcc, consumption => cons(3));        
     
    Q <= net(3);
    Qn <= net(4);
    
    --+ consumption monitoring
    -- for behavioral simulation only
    sum_up : sum_up generic map (N => 4) port map (cons => cons, consumption => consumption);
    
    
end Structural;
