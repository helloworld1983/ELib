----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description: consumption_monitor is intended to be used as a configurable component to monitor 
--				input and output signal activity and compute the associated energye consumption.
-- Dependencies: Pelib.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.PELib.all;

entity consumption_monitor is
	generic ( N : natural := 1; -- number of inputs
			  M : natural := 1;  -- number of outputs
			  logic_family : logic_family_t; -- the logic family of the component
			  gate : component_t; -- the type of the component
			  Cload : real := 5.0);  -- supply voltage
	port ( sin : in std_logic_vector (N-1 downto 0);
		   sout : in std_logic_vector (M-1 downto 0);
		   -- sim only
		   Vcc : real := 5.0; -- supply voltage
		   consumption : out  consumption_type := (0.0,0.0));
end entity;

architecture monitoring of consumption_monitor is
	type cons_t is array (0 to N + M - 1) of natural;
	signal cons : cons_t;
	type sum_t is array (-1 to N + M - 1) of natural;
	signal sum_in, sum_out : sum_t ;
	constant Icc : real := Icc_values(gate,logic_family);
	constant Cin : real := Cin_values(gate,logic_family);
	constant Cpd : real := Cpd_values(gate,logic_family);
begin
    input_activity_monitors: for i in N-1 downto 0 generate
        ia: activity_monitor port map (signal_in => sin(i), activity => cons(i));
    end generate;
	
    output_activity_monitors: for i in M-1 downto 0 generate
        oa: activity_monitor port map (signal_in => sout(i), activity => cons(i + N));
    end generate;
	
    sum_in(-1) <= 0;
    sum_up_input_activity : for I in 0 to N-1  generate
        sum_i:    sum_in(I) <= sum_in(I-1) + cons(I);
    end generate sum_up_input_activity;
	
    sum_out(-1) <= 0;
    sum_up_output_activity : for I in 0 to M-1  generate
        sum_o:    sum_out(I) <= sum_out(I-1) + cons(I + N);
    end generate sum_up_output_activity;		
	
    consumption.dynamic <= (real(sum_in(N-1)) * (Cpd + Cin) + real(sum_out(M-1)) * Cload) * Vcc * Vcc / 2.0;
    consumption.static <= Vcc * Icc;
	
end architecture;