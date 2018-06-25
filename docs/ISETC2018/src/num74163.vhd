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
-- Revision: 1.0 - Aded comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

library xil_defaultlib;
use xil_defaultlib.PELib.all;

entity num74163 is
    Generic (delay : time := 1 ns;
            Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
            Icc : real := 2.0e-6 -- questient current at room temperature  
            );
    Port ( CLK, CLRN, LOADN, P, T, D, C, B, A : in std_logic;
             Qd, Qc, Qb, Qa, RCO: out std_logic;
             Vcc : real ; 
		 consumption : out consumption_type := (0.0,0.0));
end num74163;

architecture Behavioral of num74163 is
	signal counter : std_logic_vector (3 downto 0);
	signal rrco: std_logic;
begin

functionare: process(CLK)
             begin
             if rising_edge(CLK) then
		if CLRN = '0' then
                   counter <= "0000";
				elsif (LOADN = '0') then
                   counter <= d & c & b & a;
				elsif ( P = '1' and T = '1') then 
                   counter <= counter + 1;
		end if;
	     end if;
end process;

qd <= counter(3) after delay;
qc <= counter(2) after delay;
qb <= counter(1) after delay;
qa <= counter(0) after delay;
rrco <= '1' after delay when (T = '1' and counter = "1111") else '0' after delay;

RCO <= rrco;


cm_i : consumption_monitor generic map ( N=>9, M=>5, Cpd =>Cpd, Cin => Cin, Cload => Cload, Icc=>2.0e-6)
		port map (	sin(0) => CLK, 
					sin(1) => CLRN, 
					sin(2) => LOADN, 
					sin(3) => P, 
					sin(4) => d, 
					sin(5) => d, 
					sin(6) => c, 
					sin(7) => b, 
					sin(8) => a, 
					sout(0) => counter(0), 
					sout(1) => counter(1), 
					sout(2) => counter(2), 
					sout(3) => counter(3), 
					sout(4) => rrco,
					consumption => consumption);


end Behavioral;
