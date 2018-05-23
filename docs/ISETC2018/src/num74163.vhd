----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: Counter 74163 with activity monitoring 
--              - inputs:  CK, CLRN, LOADN, PT, D ,C ,B ,A -std_logic  
--              - outputs : Qd, Qc, Qb, Qa, RCO-std_logic
--              - consumption :  port to monitor dynamic and static consumption
-- Dependencies: none
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use work.PELib.all;

entity num74163 is
    Generic (delay : time := 1 ns;
            Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
            Icc : real := 2.0e-6 -- questient current at room temperature  
            );
    Port ( CLK, CLRN, LOADN, PT, D ,C ,B ,A : in std_logic;
             Qd, Qc, Qb, Qa, RCO: out std_logic;
             consumption : out consumption_type := (0.0,0.0));
end num74163;

architecture Behavioral of num74163 is
signal counter : std_logic_vector (3 downto 0);
signal ck,cl,ld,en,dd,cc,bb,aa,qdd,qcc,qbb,qaa,rrco: std_logic;
begin
ck <= CLK;
cl <= CLRN;
ld <= LOADN;
en <= PT;
dd <= D;
cc <= C;
bb <= B;
aa <= A;
functionare: process(ck,cl)
             begin
             if cl = '0' then
                   counter <= "0000";
             elsif rising_edge(ck) then
             if (ld = '0') then
                   counter <= dd & cc & bb & aa;
             elsif ( en = '1') then 
                   counter <= counter + 1;
       end if;
   end if;
end process;

qdd <= counter(3) after 5 ns;
qcc <= counter(2) after 5 ns;
qbb <= counter(1) after 5 ns;
qaa <= counter(0) after 5 ns;
rrco <= '1' after 5 ns when (en = '1' and counter = "1111") else '0' after 5 ns;

RCO <= rrco;
Qd <= qdd;
Qc <= qcc;
Qb <= qbb;
Qa <= qaa;

cm_i : consumption_monitor generic map ( N=>8, M=>15, Cpd =>Cpd, Cin => Cin, Cload => Cload, Icc=>Icc)
		port map (sin(0) => ck, sin(1) => cl, sin(2) => ld, sin(3) => en, sin(4) => dd, sin(5) => cc, sin(6) => bb, sin(7) => aa, sout(0) => qdd, sout(1) => qcc, sout(2) => qbb, sout(3) => qaa, sout(4) => rrco, consumption => consumption);


end Behavioral;
