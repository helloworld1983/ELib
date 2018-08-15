----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: automatically sequentially with activity monitoring 
--              - inputs:  CLK, RESET -std_logic  
--              - outputs :  Q(3:0)-std_logic_vector
--              - consumption :  port to monitor dynamic and static consumption
-- Dependencies: none
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity automat is
    Generic (delay : time := 1 ns;
             logic_family : logic_family_t; -- the logic family of the component
             Cload: real := 5.0 ; -- capacitive load
             Area: real := 0.0 --parameter area 
              );
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           Vcc : in real; --supply voltage
           Q : out STD_LOGIC_VECTOR (0 to 3);
           consumption: out consumption_type := cons_zero );
end automat;

architecture Behavioral of automat is
signal Q0, Q1, Q2, Q3, nQ0, nQ1, nQ2, nQ3: STD_LOGIC;
signal D0, D1, D2, D3 : STD_LOGIC;
signal CLK0, CLK1, CLK2, CLK3 : STD_LOGIC;
signal net: STD_LOGIC_VECTOR (1 to 30); 
signal cons : consumption_type_array(1 to 30);


begin
--Q0 negat
inv1: inv_gate generic map (delay => delay, logic_family => ssxlib) port map (a => Q0, y => nQ0, Vcc => Vcc, consumption => cons(1));
--Q1 negat
inv2: inv_gate generic map (delay => delay, logic_family => ssxlib) port map (a => Q1, y => nQ1, Vcc => Vcc, consumption => cons(2));
--Q2 negat
inv3: inv_gate generic map (delay => delay, logic_family => ssxlib) port map (a => Q2, y => nQ2, Vcc => Vcc, consumption => cons(3));
--Q3 negat
inv4: inv_gate generic map (delay => delay, logic_family => ssxlib) port map (a => Q3, y => nQ3, Vcc => Vcc, consumption => cons(4));

--D0
and_gate1: and_gate generic map (delay => delay, logic_family => ssxlib) port map (a => Q1, b => nQ0, y => net(1), Vcc => Vcc, consumption => cons(5)); 
and_gate2: and_gate generic map (delay => delay, logic_family => ssxlib) port map (a => Q3, b => Q2, y => net(2), Vcc => Vcc, consumption => cons(6));
and_gate3: and_gate generic map (delay => delay, logic_family => ssxlib) port map (a => Q3, b => nQ1, y => net(3), Vcc => Vcc, consumption => cons(7));
and_gate4: and3_gate generic map (delay => delay, logic_family => ssxlib) port map (a => Q2, b => nQ1, c => Q0, y => net(4), Vcc => Vcc, consumption => cons(8));
and_gate5: and3_gate generic map (delay => delay, logic_family => ssxlib) port map (a => nQ2, b => nQ1, c => nQ0, y => net(5), Vcc => Vcc, consumption => cons(9));
or_gate1: or5_gate generic map (delay => delay, logic_family => ssxlib) port map (a => net(1), b => net(2), c => net(3), d => net(4), e => net(5), y => D0, Vcc => Vcc, consumption => cons(10));

--D1
and_gate6: and3_gate generic map (delay => delay, logic_family => ssxlib) port map (a => nQ3, b => Q1, c => nQ0, y => net(6), Vcc => Vcc, consumption => cons(11));
and_gate7: and3_gate generic map (delay => delay, logic_family => ssxlib) port map (a => Q3, b => nQ1, c => nQ0, y => net(7), Vcc => Vcc, consumption => cons(12));
and_gate8: and3_gate generic map (delay => delay, logic_family => ssxlib) port map (a => Q2, b => nQ1, c => nQ0, y => net(8), Vcc => Vcc, consumption => cons(13));
and_gate9: and4_gate generic map (delay => delay, logic_family => ssxlib) port map (a => nQ3, b => nQ2, c => nQ1, d => Q0, y => net(9), Vcc => Vcc, consumption => cons(14));
or_gate2: or4_gate generic map (delay => delay, logic_family => ssxlib) port map (a => net(6), b => net(7), c => net(8), d => net(9), y => D1, Vcc => Vcc, consumption => cons(15));

--D2
and_gate10: and3_gate generic map (delay => delay, logic_family => ssxlib) port map (a => Q2, b => nQ1, c => nQ0, y => net(10), Vcc => Vcc, consumption => cons(16));
and_gate11: and3_gate generic map (delay => delay, logic_family => ssxlib) port map (a => nQ2, b => Q1, c => nQ0, y => net(11), Vcc => Vcc, consumption => cons(17));
and_gate12: and4_gate generic map (delay => delay, logic_family => ssxlib) port map (a => nQ3, b => Q2, c => Q1, d => Q0, y => net(12), Vcc => Vcc, consumption => cons(18));
or_gate3: or3_gate generic map (delay => delay, logic_family => ssxlib) port map (a => net(10), b => net(11), c => net(12), y => D2, Vcc => Vcc, consumption => cons(19));

--D3
and_gate13: and3_gate generic map (delay => delay, logic_family => ssxlib) port map (a => Q3, b => nQ1, c => nQ0, y => net(13), Vcc => Vcc, consumption => cons(20));
and_gate14: and4_gate generic map (delay => delay, logic_family => ssxlib) port map (a => nQ3, b => Q2, c => Q1, d => Q0, y => net(14), Vcc => Vcc, consumption => cons(21));
and_gate15: and4_gate generic map (delay => delay, logic_family => ssxlib) port map (a => Q3, b => nQ2, c => Q1, d => Q0, y => net(15), Vcc => Vcc, consumption => cons(22));
or_gate4: or3_gate generic map (delay => delay, logic_family => ssxlib) port map (a => net(13), b => net(14), c => net(15), y => D3, Vcc => Vcc, consumption => cons(23));

--dff0
dff0: dff_Nbits generic map( active_edge => true, delay => delay, logic_family => ssxlib ) port map ( D => D0, Ck => CLK0, Rn => RESET, Q => Q(0), Vcc => Vcc, consumption => cons(24));
--dff1
dff1: dff_Nbits generic map( active_edge => true, delay => delay, logic_family => ssxlib ) port map ( D => D1, Ck => CLK1, Rn => RESET, Q => Q(1), Vcc => Vcc, consumption => cons(25));
--dff2
dff2: dff_Nbits generic map( active_edge => true, delay => delay, logic_family => ssxlib ) port map ( D => D2, Ck => CLK2, Rn => RESET, Q => Q(2), Vcc => Vcc, consumption => cons(26));
--dff3
dff3: dff_Nbits generic map( active_edge => true, delay => delay, logic_family => ssxlib ) port map ( D => D3, Ck => CLK3, Rn => RESET, Q => Q(3), Vcc => Vcc, consumption => cons(27));

CLK0 <= CLK;
CLK1 <= CLK;
CLK2 <= CLK;
CLK3 <= CLK;

Q(0) <= Q0;
Q(1) <= Q1;
Q(2) <= Q2;
Q(3) <= Q3;

sum : sum_up generic map (N=>27) port map (cons=>cons, consumption=>consumption);

end Behavioral;
