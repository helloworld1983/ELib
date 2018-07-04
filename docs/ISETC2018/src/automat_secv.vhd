----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: automatically sequentially with activity monitoring 
--              - inputs:  Clock, Clearn, a, b -std_logic  
--              - outputs :  Q(2:0)-std_logic_vector
--              - consumption :  port to monitor dynamic and static consumption
-- Dependencies: none
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PELib.all;
use work.PEGates.all;


entity automat_secv is
    Generic (delay : time := 1 ns);
    Port ( Clock, Clearn, a, b : in std_logic;  
           Q : out std_logic_vector(2 downto 0);
           consumption : out consumption_type := (0.0,0.0)); 
end automat_secv;

architecture Behavioral of automat_secv is

	signal input: std_logic_vector (0 to 3);
	signal output: std_logic_vector (2 downto 0);
	signal a_n, b_n, qa_n: std_logic;
	signal cons : consumption_type_array(1 to 8);

begin

counter: num74163 generic map(Cpd => 63.0e-12, Cload => 0.0e-12) port map (CLK => Clock, CLRN => Clearn, LOADN => input(3), P => input(2), T => input(2) , D => '0', C => input(0), B => '0', A => input(1), Qd => OPEN, Qc => output(2), Qb => output(1), Qa => output(0), consumption => cons(1));
--counter: num74163 generic map(logic_family => HC, gate => num_comp, Cload => 10.0e-12) port map (CLK => Clock, CLRN => Clearn, LOADN => input(3), P => input(2), T => input(2) , D => '0', C => input(0), B => '0', A => input(1), Qd => OPEN, Qc => output(2), Qb => output(1), Qa => output(0), Vcc => 5.0, consumption => cons(1));
-- some glitching power can be simulated, if different delay times are considered
inv1: inv_gate generic map(delay => 1 ns, Cload => 0.0e-12) port map (a => a, y =>a_n,  consumption => cons(2));
inv2: inv_gate generic map(delay => 1 ns, Cload => 0.0e-12) port map (a => b, y =>b_n,  consumption => cons(3));
inv3: inv_gate generic map(delay => 1 ns, Cload => 0.0e-12) port map (a => output(0), y => qa_n, consumption => cons(4));
mux1: mux4_1 generic map(delay => 1 ns, Cload => 0.0e-12) port map (I(0) => '1', I(1) => '1', I(2) => '0', I(3) => '0', A(0) => output(1), A(1) => output(2), Y => input(0), consumption => cons(5));
mux2: mux4_1 generic map(delay => 1 ns, Cload => 0.0e-12) port map (I(0) => '1', I(1) => '1', I(2) => '0', I(3) => '0', A(0) => output(1), A(1) => output(2), Y => input(1),  consumption => cons(6));
mux3: mux4_1 generic map(delay => 1 ns, Cload => 0.0e-12) port map (I(0) => '1', I(1) => '0', I(2) => a_n, I(3) => '1', A(0) => output(1), A(1) => output(2), Y => input(2), consumption => cons(7));
mux4: mux4_1 generic map(delay => 1 ns, Cload => 0.0e-12) port map (I(0) => '1', I(1) => b_n, I(2) => '1', I(3) => qa_n, A(0) => output(1), A(1) => output(2), Y => input(3), consumption => cons(8));

Q <= output;

sum : sum_up generic map (N=>8) port map (cons=>cons, consumption=>consumption);

end Behavioral;

configuration automat_secv_Behavioral of automat_secv is
	for Behavioral 
		for counter: num74163 
			use entity work.num74163(Behavioral);
		end for;
		for mux1: mux4_1 
			use entity work.mux4_1(Behavioral);
		end for;
		for mux2: mux4_1 
			use entity work.mux4_1(Behavioral);
		end for;
		for mux3: mux4_1 
			use entity work.mux4_1(Behavioral);
		end for;
		for mux4: mux4_1 
			use entity work.mux4_1(Behavioral);
		end for;
	end for;
end configuration; 




