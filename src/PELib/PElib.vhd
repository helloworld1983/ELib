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
			AC, -- AC
			ACT,-- ACT
			ALS,--ALS
			LS,--LS
			LVC,--LVC
			F,--F
			S --S
			); 
	type component_t is (tristate_buf, inv_comp,and_comp, nand_comp, or_comp, nor_comp, xor_comp, nand3_comp, nand4_comp, num_comp);
	constant NaN : real := -1.0e+308;
	type value_matrix is array ( component_t, logic_family_t ) of real;
	--quiescent currents; expressed in Ampere
	constant ICC_values : value_matrix := ( 
						tristate_buf=> ( CD => 4.0e-6, HCT => 8.0e-6, HC => 4.0e-6, ACT => 8.0e-6, AC => 2.0e-6, ALS => 0.0, LS => 12.0e-3, LVC => 0.0, F => 31.7e-3, S => 0.0),
						inv_comp 	=> ( CD => 1.0e-6, HCT => 2.0e-6, HC => 2.0e-6, ACT => 4.0e-6, AC => 2.0e-6, ALS => 3.2e-3, LS => 3.6e-3, LVC => 0.1e-6, F => 10.2e-3, S => 0.0),
						and_comp	=> ( CD => 0.25e-6, HCT => 0.0, HC => 2.0e-6, ACT => 4.0e-6, AC => 2.0e-6, ALS => 2.2e-3, LS => 4.4e-3, LVC => 0.1e-6, F => 8.6e-3, S => 20.0e-3),
						nand_comp	=> ( CD => 0.25e-6, HCT => 0.0, HC => 2.0e-6, ACT => 2.0e-6, AC => 2.0e-6, ALS => 1.5e-3, LS => 2.4e-3, LVC => 0.1e-6, F => 6.8e-3, S => 0.0),
						or_comp		=> ( CD => 0.25e-6, HCT => 2.0e-6, HC => 2.0e-6, ACT => 4.0e-6, AC => 2.0e-6, ALS => 2.8e-3, LS => 4.9e-3, LVC => 0.1e-6, F => 10.3e-3, S => 23.0e-3),
						nor_comp	=> ( CD => 0.25e-6, HCT => 0.0, HC => 0.0, ACT => 4.0e-6, AC => 2.0e-6, ALS => 0.0, LS => 2.8e-3, LVC => 0.1e-6, F => 8.7e-3, S => 2.8e-3),
						xor_comp	=> ( CD => 0.25e-6, HCT => 0.0, HC => 0.0, ACT => 2.0e-6, AC => 2.0e-6, ALS => 0.0, LS => 9.0e-3, LVC => 0.0, F => 18.0e-3, S => 0.0),
						nand3_comp	=> ( CD => 0.25e-6, HCT => 0.0, HC => 0.0, ACT => 4.0e-6, AC => 2.0e-6, ALS => 1.6e-3, LS => 1.8e-3, LVC => 0.0, F => 5.1e-3, S => 0.0),
						nand4_comp	=> ( CD => 0.25e-6, HCT => 0.0, HC => 0.0, ACT => 4.0e-6, AC => 2.0e-6, ALS => 0.0, LS => 1.2e-3, LVC => 0.0, F => 3.4e-3, S => 6.0e-3),						
						num_comp	=> ( CD => NaN, HCT => NaN, HC => 2.0e-6, ACT => NaN, AC => NaN, ALS => NaN, LS => NaN, LVC => NaN, F => NaN, S => NaN)						
						);	
 
	constant Cin_values : value_matrix := ( 
						tristate_buf=> ( CD => 7.5e-12, HCT => 3.5e-12, HC => 10.0e-12, ACT => 4.0e-12, AC => 4.5e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						inv_comp 	=> ( CD => 6.0e-12, HCT => 3.5e-12, HC => 3.5e-12, ACT => 4.5e-12, AC => 4.5e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						and_comp	=> ( CD => 5.0e-12, HCT => 3.5e-12, HC => 3.5e-12, ACT => 4.5e-12, AC => 4.5e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						nand_comp	=> ( CD => 5.0e-12, HCT => 3.5e-12, HC => 3.5e-12, ACT => 4.5e-12, AC => 4.5e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						or_comp	    => ( CD => 5.0e-12, HCT => 3.5e-12, HC => 3.5e-12, ACT => 4.5e-12, AC => 4.5e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						nor_comp	=> ( CD => 5.0e-12, HCT => 3.5e-12, HC => 3.5e-12, ACT => 4.5e-12, AC => 4.5e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						xor_comp	=> ( CD => 5.0e-12, HCT => 3.5e-12, HC => 3.5e-12, ACT => 5.0e-12, AC => 4.5e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						nand3_comp	=> ( CD => 5.0e-12, HCT => 3.5e-12, HC => 3.5e-12, ACT => 4.5e-12, AC => 4.5e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
  						nand4_comp  => ( CD => 5.0e-12, HCT => 3.5e-12, HC => 3.5e-12, ACT => 3.8e-12, AC => 4.5e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),    
  						num_comp  => ( CD => NaN, HCT => NaN, HC => 3.5e-12, ACT => NaN, AC => NaN, ALS => NaN, LS => NaN, LVC => NaN, F => NaN, S => NaN)    
						);	
						
	constant Cpd_values : value_matrix := ( 
						tristate_buf	=> ( CD => 40.0e-12, HCT => 35.0e-12, HC => 34.0e-12, ACT => 24.0e-12, AC => 45.0e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						inv_comp 	=> ( CD => 12.0e-12, HCT => 24.0e-12, HC => 21.0e-12, ACT => 30.0e-12, AC => 30.0e-12, ALS => 0.0, LS => 0.0, LVC => 25.0e-12, F => 0.0, S => 0.0),
						and_comp	=> ( CD => 14.0e-12, HCT => 20.0e-12, HC => 10.0e-12, ACT => 20.0e-12, AC => 20.0e-12, ALS => 0.0, LS => 0.0, LVC => 28.0e-12, F => 0.0, S => 0.0),
						nand_comp	=> ( CD => 14.0e-12, HCT => 22.0e-12, HC => 22.0e-12, ACT => 30.0e-12, AC => 30.0e-12, ALS => 0.0, LS => 0.0, LVC => 28.0e-12, F => 0.0, S => 0.0),
						or_comp		=> ( CD => 14.0e-12, HCT => 28.0e-6, HC => 16.0e-12, ACT => 20.0e-12, AC => 20.0e-12, ALS => 0.0, LS => 0.0, LVC => 28.0e-12, F => 0.0, S => 0.0),
						nor_comp	=> ( CD => 14.0e-12, HCT => 24.0e-6, HC => 22.0e-12, ACT => 30.0e-12, AC => 30.0e-12, ALS => 0.0, LS => 0.0, LVC => 8.5e-12, F => 0.0, S => 0.0),
						xor_comp	=> ( CD => 14.0e-12, HCT => 30.0e-6, HC => 30.0e-12, ACT => 30.0e-12, AC => 35.0e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						nand3_comp	=> ( CD => 14.0e-12, HCT => 14.0e-6, HC => 12.0e-12, ACT => 25.0e-12, AC => 25.0e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						nand4_comp  	=> ( CD => 14.0e-12, HCT => 17.0e-6, HC => 22.0e-12, ACT => 33.0e-12, AC => 40.0e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),    
						num_comp  	=> ( CD => NaN, HCT => NaN, HC => 63.0e-12, ACT => NaN, AC => NaN, ALS => NaN, LS => NaN, LVC => NaN, F => NaN, S => NaN)    
						);	
						
	component consumption_monitor is
	generic ( N : natural := 1; -- number of inputs
			  M : natural := 1;  -- number of outputs
              logic_family : logic_family_t; -- the logic family of the component
              gate : component_t; -- the type of the component
			  Cload : real := 0.0);  
		port ( sin : in std_logic_vector (N-1 downto 0);
			   sout : in std_logic_vector (M-1 downto 0);
			   Vcc : in real := 5.0; -- supply voltage
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
