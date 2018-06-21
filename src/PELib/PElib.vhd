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
	-- supported logic families
	type logic_family_t is (
			CD, -- CMOS
			HCT, -- HCT
			HC, -- HC
			ACT, -- ACT
			AC); -- AC
	type component_t is (tristate_buf, inv_comp, nand_comp );

	type value_matrix is array ( component_t, logic_family_t ) of real;
	--quiescent currents; expressed in Ampere
	constant ICC_values : value_matrix := ( 
						tristate_buf=> ( CD => 4.0e-6, HCT => 8.0e-6, HC => 0.0, ACT => 0.0, AC => 2.0e-6),
						inv_comp 	=> ( CD => 1.0e-6, HCT => 2.0e-6, HC => 0.0, ACT => 0.0, AC => 2.0e-6),
						nand_comp	=> ( CD => 0.25e-6, HCT => 2.0e-6, HC => 0.0, ACT => 0.0, AC => 2.0e-6)
						);	

	constant Cin_values : value_matrix := ( 
						tristate_buf=> ( CD => 7.5e-12, HCT => 10.0e-12, HC => 0.0, ACT => 0.0, AC => 4.5e-12),
						inv_comp 	=> ( CD => 6.0e-12, HCT => 3.5e-12, HC => 0.0, ACT => 0.0, AC => 4.5e-12),
						nand_comp	=> ( CD => 5.0e-12, HCT => 10.0e-12, HC => 0.0, ACT => 0.0, AC => 4.5e-12)
						);	
						
	constant Cpd_values : value_matrix := ( 
						tristate_buf=> ( CD => 40.0e-12, HCT => 40.0e-12, HC => 0.0, ACT => 0.0, AC => 45.0e-12),
						inv_comp 	=> ( CD => 12.0e-12, HCT => 24.0e-12, HC => 0.0, ACT => 0.0, AC => 30.0e-12),
						nand_comp	=> ( CD => 14.0e-12, HCT => 26.0e-12, HC => 0.0, ACT => 0.0, AC => 30.0e-12)
						);	
						
	component consumption_monitor is
	generic ( N : natural := 1; -- number of inputs
			  M : natural := 1;  -- number of outputs
			  logic_family : logic_family_t; -- the logic family of the component
			  gate : component_t; -- the type of the component
			  Cload, VCC: real := 5.0);  -- supply voltage
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
