----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description: power_estimator is intended to be used as a configurable component to monitor 
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

entity power_estimator is
	generic ( time_window : time := 1 ns); --capacities charges and dischareged
	port ( consumption : in  consumption_type;
		   power : out real := 0.0);
end entity;

architecture monitoring of power_estimator is
	signal cons_delayed : consumption_type := (0.0,0.0);
	signal time_window_real : real;
begin

	-- convert energy to power 
	cons_delayed <=  transport consumption after time_window;
	time_window_real <= real(time_window/1 ns) * 1.0e-9;
	power <=  0.0 when (consumption.dynamic - cons_delayed.dynamic) = -1.0e+308 else (consumption.dynamic - cons_delayed.dynamic) / time_window_real + consumption.static;
end architecture;