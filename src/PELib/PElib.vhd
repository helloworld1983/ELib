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
    type consumption_type is record
        dynamic : real; -- ment to represent dynamic comsumption
        static : real; -- ment to represent static consumption
    end record consumption_type;
    function "+" (a,b:consumption_type) return consumption_type;
    component activity_monitor is
        port ( signal_in : in STD_LOGIC;
               activity : out natural := 0);
    end component; 


	-- the length of the array should be equal to the number of elements in logic_family_t type
    type real_array is array (0 to 3) of real;
	-- the supported logic families
    type logic_family_t is (None, -- none
			CD4000, -- CMOS
			HCT, -- HCT
			AC); -- AC
	-- selected logic family - change the value for other 
    constant logic_family : logic_family_t := CD4000;
	
    constant Vcc_values 		: real_array; -- typical values of VCC of logic families
    constant tristate_buf_Cpd_values 	: real_array; -- typical values of Cpd of logic families
    constant tristate_buf_Cin_values 	: real_array; -- typical values of VCC of logic families
    constant tristate_buf_ICC_values 	: real_array; -- typical values of VCC of logic families
    constant inv_gate_Cpd_values 	: real_array; -- typical values of Cpd of logic families
    constant inv_gate_Cin_values 	: real_array; -- typical values of Cpd of logic families
    constant inv_gate_ICC_values 	: real_array; -- typical values of VCC of logic families
    constant nand_gate_Cpd_values 	: real_array; -- typical values of Cpd of logic families
    constant nand_gate_Cin_values 	: real_array; -- typical values of Cpd of logic families
    constant nand_gate_ICC_values 	: real_array; -- typical values of VCC of logic families
    constant VCC : real;
    constant tristate_buf_Cpd : real;
    constant tristate_buf_Cin : real; 
    constant tristate_buf_ICC : real; --quiescent current expressed in Ampere
    constant inv_gate_Cpd : real;
    constant inv_gate_Cin : real; 
    constant inv_gate_ICC : real; --quiescent current expressed in Ampere
    constant nand_gate_Cpd : real; 
    constant nand_gate_Cin : real; 
    constant nand_gate_ICC : real; --quiescent current expressed in Ampere
	
	component consumption_monitor is
		generic ( N : natural := 1; -- number of inputs
				  M : natural := 1; -- number of outputs
				Cpd, Cin, Cload, ICC: real := 0.0 ); -- cpacities and quiescent current
		port ( sin : in std_logic_vector (N-1 downto 0);
			   sout : in std_logic_vector (M-1 downto 0);
			   consumption : out consumption_type := (0.0,0.0));
	end component;
	component power_estimator is
		generic ( time_window : time := 1 ns); --capacities charges and dischareged
		port ( consumption : in  consumption_type;
		   power : out real := 0.0);
	end component;
    
end PElib;

package body PElib is
	-- typical values of VCC for the logic families
  	constant Vcc_values : real_array := (0.0, -- none
					5.0,  -- CMOS 5V
					5.0,  -- HCT  5V
					5.0); -- AC   5V
	constant tristate_buf_Cpd_values : real_array := (0.0, -- none
							40.0e-12, -- CMOS 40 pF
							40.0e-12, -- HCT 40 pF
							45.0e-12 -- AC
							 );
	constant tristate_buf_Cin_values : real_array := (0.0, -- none
							7.5e-12, -- CMOS 7.5 pF
							10.0e-12, -- HCT 10 pF
							4.5e-12
							);
	constant tristate_buf_ICC_values : real_array := (1.0, -- none 
							4.0e-6, -- CMOS 4 uA
							8.0e-6, -- HCT 8 uA
							2.0e-6 -- AC 8 uA
							);
	constant inv_gate_Cpd_values : real_array := (0.0, -- none
							12.0e-12, -- CMOS 12 pF
							24.0e-12, -- HCT 24 pF
							30.0e-12-- AC 30pF
							);
	constant inv_gate_Cin_values : real_array := (0.0, -- none
							6.0e-12, -- CMOS 6 pF
							3.5e-12, -- HCT 10 pF
							4.5e-12 --AC 4.5 pf
							);
	constant inv_gate_ICC_values : real_array := (1.0, -- none 
							1.0e-6, -- CMOS 1 uA
							2.0e-6, -- HCT 2 uA
							2.0e-6 -- AC 2 uA
							);
	constant nand_gate_Cpd_values : real_array := (0.0, -- none
							14.0e-12, -- CMOS 14 pF
							26.0e-12, -- HCT 26 pF
							30.0e-12-- AC 30pF
							);
	constant nand_gate_Cin_values : real_array := (0.0, -- none
							5.0e-12, -- CMOS 5 pF
							10.0e-12, -- HCT 10 pF
							4.5e-12 --AC 4.5 pf
							);
	constant nand_gate_ICC_values : real_array := (1.0, -- none 
							0.25e-6, -- CMOS 0.25 uA
							2.0e-6, -- HCT 8 uA
							2.0e-6 -- HCT 8 uA
							);
	-- selection of the parameter values, for a selected logic_family
	constant Vcc 			: real := Vcc_values			(logic_family_t'POS(logic_family));	
	constant tristate_buf_Cpd	: real := tristate_buf_Cpd_values	(logic_family_t'POS(logic_family));
	constant tristate_buf_Cin	: real := tristate_buf_Cin_values	(logic_family_t'POS(logic_family));
	constant tristate_buf_ICC 	: real := tristate_buf_ICC_values	(logic_family_t'POS(logic_family));
	constant inv_gate_Cpd	: real := inv_gate_Cpd_values	(logic_family_t'POS(logic_family));
	constant inv_gate_Cin	: real := inv_gate_Cin_values	(logic_family_t'POS(logic_family));
	constant inv_gate_ICC 	: real := inv_gate_ICC_values	(logic_family_t'POS(logic_family));
	constant nand_gate_Cpd	: real := nand_gate_Cpd_values	(logic_family_t'POS(logic_family));
	constant nand_gate_Cin	: real := nand_gate_Cin_values	(logic_family_t'POS(logic_family));
	constant nand_gate_ICC 	: real := nand_gate_ICC_values	(logic_family_t'POS(logic_family));	
	function "+" (a,b:consumption_type) return consumption_type is
		variable sum : consumption_type;
	begin
		sum.dynamic := a.dynamic + b.dynamic;
		sum.static := a.static + b.static;
	return sum;
	end function;
	
end PElib;
