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
