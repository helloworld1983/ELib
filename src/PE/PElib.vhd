----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: Power Estimation 
-- Description: - VHDL package
--              - defines the interface for static and dynamic power estimation
--              - defines operations with the interface
--              - dynamic power dissipation can be estimated using the activity signal 
--              - defines gate primitives with power monitoring function
-- Dependencies: activity_monitor.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

package PElib is
	-- type declaration to hold both static and dynamic power consumption
    type consumption_type is record
        dynamic : real; -- meant to represent dynamic consumption
        static : real; -- meant to represent static consumption
    end record consumption_type;
	-- utility function to add consumption_type typed values
    function "+" (a,b:consumption_type) return consumption_type;
    component activity_monitor is
        port ( signal_in : in STD_LOGIC;
               activity : out natural := 0);
    end component; 
	-- type declaration to get an array of consumption_type
	type consumption_type_array is array (integer range <>) of consumption_type;
	
	component consumption_monitor is
	generic ( N : natural := 1; -- number of inputs
			  M : natural := 1;  -- number of outputs
			  Cpd, Cin, Cload : real := 0.0; --capacities charges and dischareged
			  ICC : real := 0.0; -- leackage/quiescent current
			  VCC: real := 5.0);  -- supply voltage
		port ( sin : in std_logic_vector (N-1 downto 0);
			   sout : in std_logic_vector (M-1 downto 0);
			   consumption : out consumption_type := (0.0,0.0));
	end component;

	component sum_up is
		generic ( N : natural := 1) ; -- number of inputs
		port ( cons : in consumption_type_array ;
			   consumption : out consumption_type := (0.0,0.0));
	end component;
	
	component power_estimator is
		generic ( time_window : time := 1 ns); --capacities charges and dischareged
		port ( consumption : in  consumption_type;
		   power : out real := 0.0);
	end component;
    
end PElib;

package body PElib is

	function "+" (a,b:consumption_type) return consumption_type is
		variable sum : consumption_type;
	begin
		sum.dynamic := a.dynamic + b.dynamic;
		sum.static := a.static + b.static;
	return sum;
	end function;
	
end PElib;
----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description: activity_monitor is detecting the transitions of a node .
--				(the number of times a capacitor is charged/discharged)
-- Dependencies: none
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity activity_monitor is
    Port ( signal_in : in STD_LOGIC;
           activity : out natural := 0);
end activity_monitor;

architecture Behavioral of activity_monitor is
signal NrOFTransitions: natural := 0;
begin
energy_counter : process(signal_in)               
                begin
                    NrOFTransitions <= NrOFTransitions + 1;
                end process; 
    activity <= NrOFTransitions; 
end Behavioral;
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
			  Cpd, Cin, Cload : real := 0.0; --capacities charges and dischareged
			  ICC : real := 0.0; -- leackage/quiescent current
			  VCC: real := 5.0);  -- supply voltage
	port ( sin : in std_logic_vector (N-1 downto 0);
		   sout : in std_logic_vector (M-1 downto 0);
		   consumption : out  consumption_type := (0.0,0.0));
end entity;

architecture monitoring of consumption_monitor is
	type cons_t is array (0 to N + M - 1) of natural;
	signal cons : cons_t;
	type sum_t is array (-1 to N + M - 1) of natural;
	signal sum_in, sum_out : sum_t ;
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
----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description: thi component is used to sum up the consumptions of individual gates/blocks.
-- Dependencies: PElib.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;

library work;
use work.PELib.all;

entity sum_up is
		generic ( N : natural := 1) ;-- number of inputs
		port ( cons : in consumption_type_array (1 to N);
			   consumption : out consumption_type := (0.0,0.0));
end entity;

architecture behavioral of sum_up is
    signal sum: consumption_type_array (0 to N) := (others => (0.0,0.0));
begin

    sum(0) <= (0.0,  0.0);
    sum_up_energy : for I in 1 to N generate
          sum_i:    sum(I) <= sum(I-1) + cons(I);
    end generate sum_up_energy;
    consumption <= sum(N);

end architecture;
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
