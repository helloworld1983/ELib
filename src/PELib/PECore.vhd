----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: Power/Area Avare Modeling and Estimation 
-- Description: - VHDL package
--              - defines the interface for static power, dynamic power and occupied area estimation
--              - defines operations with the interface
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: none
-- 
-- Revision: 0.03 - Added area estimation 
-- Revision: 0.02 - Updates, merged the content of sum_up.vhd, activity_monitor.vhd,
--					estimation_monitor.vhd power_estimator.vhd into a single file
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

package PECore is
	-- type declaration to hold both static and dynamic power estimation
    type power_type is record
        dynamic : real; -- dynamic consumption component
        static : real; -- static consumption component
    end record power_type;
    type estimation_type is record
        power : power_type; -- power consumption estimation
        area : real; -- occupied area estimation
    end record estimation_type;
	-- utility function to add estimation_type typed values
    function "+" (a, b : estimation_type) return estimation_type;
    component activity_monitor is
        port ( signal_in : in STD_LOGIC;
               activity : out natural := 0);
    end component; 
	-- type declaration to get an array of estimation_type
	type estimation_type_array is array (integer range <>) of estimation_type;
	-- table type declaration
--	type table_line is record
--		state : std_logic_vector;
--		control : std_logic_vector;
--		output : std_logic_vector;
--	end record table_line;
--	type table is array (integer range <>) of table_line;
	
--	--constant tlnull : table_line := ((others => '0'),(others => '0'),(others => '0'));

	-- supported logic families
	type logic_family_t is (
			ssxlib,
			sxlib,
			vxlib,
			vsclib,
			wsclib,
			vgalib,
			rgalib,
			ac,
			act,
			hc,
			hct,
			cmos
			); 
			
	constant default_logic_family : logic_family_t := HC;
	constant default_VCC : real := 5.0; 
	constant Undef : real := 0.0 ;
	constant est_zero : estimation_type := ((0.0,0.0),0.0);
	type component_t is (tristate_buffer, buffer_non_inv, inverter, and2, and3, and4, or2, or3, or4, nand2, nand3, nand4, nor2, nor3, nor4, xor2, xnor2, mux2, mux4, num163, dff_rising_edge, none_comp);


	type value_matrix is array ( component_t, logic_family_t ) of real;
	--quiescent currents; expressed in Ampere
	constant ICC_values : value_matrix := ( 
		tristate_buffer =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 0.00E+00 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 2.00E-06 , act => 8.00E-06 , hc => 4.00E-06 , hct => 8.00E-06 , cmos => 0.00E+00),
		buffer_non_inv =>( ssxlib => 7.33E-10, sxlib =>  7.33E-10 , vxlib => 9.25E-10 , vsclib => 6.67E-10 , wsclib => 6.67E-10 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 0.00E+00),
		inverter =>( ssxlib => 4.83E-10, sxlib =>  4.83E-10 , vxlib => 5.50E-10 , vsclib => 4.00E-10 , wsclib => 4.00E-10 , vgalib => 4.25E-10 , rgalib => 4.58E-10 , ac => 2.00E-06 , act => 4.00E-06 , hc => 2.00E-06 , hct => 0.00E+00 , cmos => 1.00E-05),
		and2 =>( ssxlib => 9.67E-10, sxlib =>  9.67E-10 , vxlib => 1.23E-09 , vsclib => 8.92E-10 , wsclib => 8.92E-10 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 2.00E-06 , act => 4.00E-06 , hc => 2.00E-06 , hct => 0.00E+00 , cmos => 4.00E-06),
		and3 =>( ssxlib => 1.35E-09, sxlib =>  1.35E-09 , vxlib => 1.48E-09 , vsclib => 1.06E-09 , wsclib => 1.06E-09 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 1.00E-05),
		and4 =>( ssxlib => 1.54E-09, sxlib =>  1.54E-09 , vxlib => 1.51E-09 , vsclib => 1.25E-09 , wsclib => 1.25E-09 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 1.00E-05),
		or2 =>( ssxlib => 1.06E-09, sxlib =>  1.06E-09 , vxlib => 6.83E-10 , vsclib => 8.25E-10 , wsclib => 8.25E-10 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 2.00E-06 , act => 4.00E-06 , hc => 2.00E-06 , hct => 0.00E+00 , cmos => 4.00E-06),
		or3 =>( ssxlib => 1.16E-09, sxlib =>  1.16E-09 , vxlib => 8.50E-10 , vsclib => 1.05E-09 , wsclib => 1.05E-09 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 1.00E-05),
		or4 =>( ssxlib => 1.25E-09, sxlib =>  1.25E-09 , vxlib => 8.92E-10 , vsclib => 1.13E-09 , wsclib => 1.13E-09 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 2.50E-04),
		nand2 =>( ssxlib => 5.75E-10, sxlib =>  5.75E-10 , vxlib => 1.07E-09 , vsclib => 6.58E-10 , wsclib => 6.58E-10 , vgalib => 6.75E-10 , rgalib => 7.33E-10 , ac => 2.00E-06 , act => 2.00E-06 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 4.00E-06),
		nand3 =>( ssxlib => 7.67E-10, sxlib =>  7.67E-10 , vxlib => 1.27E-09 , vsclib => 1.08E-09 , wsclib => 1.08E-09 , vgalib => 9.25E-10 , rgalib => 1.00E-09 , ac => 2.00E-06 , act => 4.00E-06 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 4.00E-06),
		nand4 =>( ssxlib => 9.67E-10, sxlib =>  9.67E-10 , vxlib => 1.94E-09 , vsclib => 1.25E-09 , wsclib => 1.25E-09 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 2.00E-06 , act => 4.00E-06 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 5.00E-06),
		nor2 =>( ssxlib => 5.75E-10, sxlib =>  5.75E-10 , vxlib => 1.16E-09 , vsclib => 8.08E-10 , wsclib => 8.08E-10 , vgalib => 6.75E-10 , rgalib => 1.31E-09 , ac => 2.00E-06 , act => 4.00E-06 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 4.00E-06),
		nor3 =>( ssxlib => 6.75E-10, sxlib =>  6.75E-10 , vxlib => 1.18E-09 , vsclib => 1.22E-09 , wsclib => 1.22E-09 , vgalib => 1.69E-09 , rgalib => 1.69E-09 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 5.00E-06),
		nor4 =>( ssxlib => 7.67E-10, sxlib =>  7.67E-10 , vxlib => 1.18E-09 , vsclib => 1.18E-09 , wsclib => 1.18E-09 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 5.00E-06),
		xor2 =>( ssxlib => 1.73E-09, sxlib =>  1.73E-09 , vxlib => 1.06E-09 , vsclib => 1.52E-09 , wsclib => 1.52E-09 , vgalib => 1.02E-09 , rgalib => 1.38E-09 , ac => 2.00E-06 , act => 2.00E-06 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 5.00E-05),
		xnor2 =>( ssxlib => 1.73E-09, sxlib =>  1.73E-09 , vxlib => 1.02E-09 , vsclib => 1.63E-09 , wsclib => 1.63E-09 , vgalib => 1.10E-09 , rgalib => 1.38E-09 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 1.00E-04),
		mux2 =>( ssxlib => 2.29E-14, sxlib =>  2.38E-14 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 1.51E-14 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 7.00E-11 , hct => 7.00E-11 , cmos => 0.00E+00),
		mux4 =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 0.00E+00 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 8.00E-06 , hct => 0.00E+00 , cmos => 0.00E+00),
		num163 =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 0.00E+00 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 8.00E-06 , hct => 0.00E+00 , cmos => 0.00E+00),
		dff_rising_edge =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 1.77E-09 , wsclib => 1.77E-09 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 0.00E+00),
		none_comp =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 0.00E+00 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 0.00E+00)
    );	
 
	constant Cin_values : value_matrix := ( 
		tristate_buffer =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 0.00E+00 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 4.00E-12 , act => 4.00E-12 , hc => 1.00E-11 , hct => 3.50E-12 , cmos => 0.00E+00),
		buffer_non_inv =>( ssxlib => 2.60E-15, sxlib =>  2.50E-15 , vxlib => 4.90E-15 , vsclib => 3.40E-15 , wsclib => 3.40E-15 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 0.00E+00),
		inverter =>( ssxlib => 5.60E-15, sxlib =>  5.50E-15 , vxlib => 5.90E-15 , vsclib => 4.60E-15 , wsclib => 4.60E-15 , vgalib => 5.00E-15 , rgalib => 5.40E-15 , ac => 4.50E-12 , act => 4.50E-12 , hc => 3.50E-12 , hct => 3.50E-12 , cmos => 6.00E-12),
		and2 =>( ssxlib => 4.90E-15, sxlib =>  4.80E-15 , vxlib => 5.50E-15 , vsclib => 3.90E-15 , wsclib => 3.90E-15 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 4.50E-12 , act => 4.50E-12 , hc => 3.50E-12 , hct => 3.50E-12 , cmos => 5.00E-12),
		and3 =>( ssxlib => 4.90E-15, sxlib =>  4.90E-15 , vxlib => 5.70E-15 , vsclib => 4.10E-15 , wsclib => 4.10E-15 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 3.50E-12 , hct => 0.00E+00 , cmos => 5.00E-12),
		and4 =>( ssxlib => 4.70E-15, sxlib =>  4.80E-15 , vxlib => 5.90E-15 , vsclib => 4.60E-15 , wsclib => 4.60E-15 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 3.50E-12 , hct => 0.00E+00 , cmos => 0.00E+00),
		or2 =>( ssxlib => 4.70E-15, sxlib =>  4.70E-15 , vxlib => 4.10E-15 , vsclib => 4.30E-15 , wsclib => 4.30E-15 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 4.50E-12 , act => 4.50E-12 , hc => 3.50E-12 , hct => 3.50E-12 , cmos => 5.00E-12),
		or3 =>( ssxlib => 4.40E-15, sxlib =>  4.40E-15 , vxlib => 5.00E-15 , vsclib => 5.60E-15 , wsclib => 5.60E-15 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 3.50E-12 , hct => 0.00E+00 , cmos => 5.00E-12),
		or4 =>( ssxlib => 4.20E-15, sxlib =>  4.20E-15 , vxlib => 4.90E-15 , vsclib => 6.10E-15 , wsclib => 6.10E-15 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 3.50E-12 , hct => 0.00E+00 , cmos => 7.50E-12),
		nand2 =>( ssxlib => 4.40E-15, sxlib =>  4.40E-15 , vxlib => 7.50E-15 , vsclib => 4.80E-15 , wsclib => 4.80E-15 , vgalib => 4.90E-15 , rgalib => 5.20E-15 , ac => 4.50E-12 , act => 4.50E-12 , hc => 3.50E-12 , hct => 3.50E-12 , cmos => 5.00E-12),
		nand3 =>( ssxlib => 4.50E-15, sxlib =>  4.60E-15 , vxlib => 6.90E-15 , vsclib => 6.00E-15 , wsclib => 6.00E-15 , vgalib => 4.80E-15 , rgalib => 5.20E-15 , ac => 4.50E-12 , act => 4.50E-12 , hc => 3.50E-12 , hct => 3.50E-12 , cmos => 5.00E-12),
		nand4 =>( ssxlib => 4.40E-15, sxlib =>  4.50E-15 , vxlib => 8.70E-15 , vsclib => 6.10E-15 , wsclib => 6.10E-15 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 4.50E-12 , act => 3.80E-12 , hc => 3.50E-12 , hct => 3.50E-12 , cmos => 5.00E-12),
		nor2 =>( ssxlib => 5.20E-15, sxlib =>  5.30E-15 , vxlib => 9.80E-15 , vsclib => 7.30E-15 , wsclib => 7.30E-15 , vgalib => 7.40E-15 , rgalib => 1.04E-14 , ac => 4.50E-12 , act => 4.50E-12 , hc => 3.50E-12 , hct => 3.50E-12 , cmos => 5.00E-12),
		nor3 =>( ssxlib => 5.10E-15, sxlib =>  5.30E-15 , vxlib => 9.20E-15 , vsclib => 1.04E-14 , wsclib => 1.04E-14 , vgalib => 7.40E-15 , rgalib => 1.04E-14 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 5.00E-12),
		nor4 =>( ssxlib => 5.20E-15, sxlib =>  5.30E-15 , vxlib => 1.01E-14 , vsclib => 1.01E-14 , wsclib => 1.01E-14 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 5.00E-12),
		xor2 =>( ssxlib => 9.40E-15, sxlib =>  9.70E-15 , vxlib => 6.50E-15 , vsclib => 1.03E-14 , wsclib => 1.03E-14 , vgalib => 5.30E-15 , rgalib => 5.70E-15 , ac => 4.50E-12 , act => 5.00E-12 , hc => 3.50E-12 , hct => 3.50E-12 , cmos => 5.00E-12),
		xnor2 =>( ssxlib => 9.00E-15, sxlib =>  9.30E-15 , vxlib => 6.20E-15 , vsclib => 6.90E-15 , wsclib => 6.90E-15 , vgalib => 5.40E-15 , rgalib => 5.70E-15 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 5.00E-12),
		mux2 =>( ssxlib => 3.50E-15, sxlib =>  3.70E-15 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 4.30E-15 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 3.50E-12 , hct => 3.50E-12 , cmos => 0.00E+00),
		mux4 =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 0.00E+00 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 3.50E-12 , hct => 3.50E-12 , cmos => 0.00E+00),
		num163 =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 0.00E+00 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 3.50E-12 , hct => 0.00E+00 , cmos => 0.00E+00),
		dff_rising_edge =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 2.30E-15 , wsclib => 2.30E-15 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 3.50E-12 , hct => 3.50E-12 , cmos => 0.00E+00),
		none_comp =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 0.00E+00 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 0.00E+00)
     );	
						
	constant Cpd_values : value_matrix := ( 
		tristate_buffer =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 0.00E+00 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 2.10E-11 , act => 2.40E-11 , hc => 3.40E-11 , hct => 3.50E-11 , cmos => 0.00E+00),
		buffer_non_inv =>( ssxlib => 1.65E-14, sxlib =>  1.67E-14 , vxlib => 1.83E-14 , vsclib => 1.35E-14 , wsclib => 1.35E-14 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 0.00E+00),
		inverter =>( ssxlib => 6.11E-15, sxlib =>  6.04E-15 , vxlib => 6.60E-15 , vsclib => 4.93E-15 , wsclib => 4.93E-15 , vgalib => 6.81E-15 , rgalib => 5.83E-15 , ac => 3.00E-11 , act => 3.00E-11 , hc => 2.10E-11 , hct => 2.40E-11 , cmos => 1.20E-11),
		and2 =>( ssxlib => 1.99E-14, sxlib =>  2.01E-14 , vxlib => 2.01E-14 , vsclib => 1.48E-14 , wsclib => 1.48E-14 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 2.00E-11 , act => 2.00E-11 , hc => 1.00E-11 , hct => 2.00E-11 , cmos => 1.80E-11),
		and3 =>( ssxlib => 2.66E-14, sxlib =>  2.69E-14 , vxlib => 2.24E-14 , vsclib => 1.63E-14 , wsclib => 1.63E-14 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 1.80E-11 , hct => 0.00E+00 , cmos => 0.00E+00),
		and4 =>( ssxlib => 2.26E-14, sxlib =>  2.30E-14 , vxlib => 2.41E-14 , vsclib => 1.71E-14 , wsclib => 1.71E-14 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 1.50E-11 , hct => 0.00E+00 , cmos => 0.00E+00),
		or2 =>( ssxlib => 2.01E-14, sxlib =>  2.02E-14 , vxlib => 1.22E-14 , vsclib => 1.49E-14 , wsclib => 1.49E-14 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 2.00E-11 , act => 2.00E-11 , hc => 1.60E-11 , hct => 2.80E-11 , cmos => 1.80E-11),
		or3 =>( ssxlib => 2.13E-14, sxlib =>  2.13E-14 , vxlib => 1.43E-14 , vsclib => 1.62E-14 , wsclib => 1.62E-14 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 2.80E-11 , hct => 0.00E+00 , cmos => 0.00E+00),
		or4 =>( ssxlib => 2.19E-14, sxlib =>  2.19E-14 , vxlib => 1.44E-14 , vsclib => 1.72E-14 , wsclib => 1.72E-14 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 1.50E-11 , hct => 0.00E+00 , cmos => 0.00E+00),
		nand2 =>( ssxlib => 6.04E-15, sxlib =>  6.04E-15 , vxlib => 9.93E-15 , vsclib => 6.04E-15 , wsclib => 6.04E-15 , vgalib => 6.46E-15 , rgalib => 7.36E-15 , ac => 3.00E-11 , act => 3.00E-11 , hc => 2.20E-11 , hct => 2.20E-11 , cmos => 1.40E-11),
		nand3 =>( ssxlib => 7.78E-15, sxlib =>  7.85E-15 , vxlib => 1.15E-14 , vsclib => 9.17E-15 , wsclib => 9.17E-15 , vgalib => 8.54E-15 , rgalib => 9.58E-15 , ac => 2.50E-11 , act => 2.50E-11 , hc => 1.20E-11 , hct => 1.40E-11 , cmos => 1.70E-11),
		nand4 =>( ssxlib => 8.89E-15, sxlib =>  8.89E-15 , vxlib => 1.58E-14 , vsclib => 9.93E-15 , wsclib => 9.93E-15 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 4.00E-11 , act => 3.30E-11 , hc => 2.20E-11 , hct => 1.70E-11 , cmos => 0.00E+00),
		nor2 =>( ssxlib => 7.01E-15, sxlib =>  7.08E-15 , vxlib => 1.11E-14 , vsclib => 7.36E-15 , wsclib => 7.36E-15 , vgalib => 8.19E-15 , rgalib => 1.33E-14 , ac => 3.00E-11 , act => 3.00E-11 , hc => 2.20E-11 , hct => 2.40E-11 , cmos => 1.40E-11),
		nor3 =>( ssxlib => 8.13E-15, sxlib =>  8.13E-15 , vxlib => 1.15E-14 , vsclib => 1.20E-14 , wsclib => 1.20E-14 , vgalib => 1.04E-14 , rgalib => 1.63E-14 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 0.00E+00),
		nor4 =>( ssxlib => 8.40E-15, sxlib =>  8.40E-15 , vxlib => 3.51E-14 , vsclib => 1.18E-14 , wsclib => 1.18E-14 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 0.00E+00),
		xor2 =>( ssxlib => 2.24E-14, sxlib =>  2.30E-14 , vxlib => 2.09E-14 , vsclib => 2.78E-14 , wsclib => 2.78E-14 , vgalib => 1.99E-14 , rgalib => 2.22E-14 , ac => 3.50E-11 , act => 3.00E-11 , hc => 3.00E-11 , hct => 3.00E-11 , cmos => 0.00E+00),
		xnor2 =>( ssxlib => 2.25E-14, sxlib =>  2.32E-14 , vxlib => 2.19E-14 , vsclib => 2.28E-14 , wsclib => 2.28E-14 , vgalib => 2.03E-14 , rgalib => 2.27E-14 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 2.00E-11),
		mux2 =>( ssxlib => 2.29E-14, sxlib =>  2.38E-14 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 1.51E-14 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 7.00E-11 , hct => 7.00E-11 , cmos => 0.00E+00),
		mux4 =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 0.00E+00 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 4.00E-11 , hct => 3.00E-11 , cmos => 0.00E+00),
		num163 =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 0.00E+00 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 6.00E-11 , hct => 0.00E+00 , cmos => 0.00E+00),
		dff_rising_edge =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 9.31E-15 , wsclib => 9.31E-15 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 2.40E-11 , hct => 2.40E-11 , cmos => 0.00E+00),
		none_comp =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 0.00E+00 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 0.00E+00)
	);	
						
	constant Area_values : value_matrix := ( 
		tristate_buffer =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 0.00E+00 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 1.67E-07 , hct => 1.67E-07 , cmos => 0.00E+00),
		buffer_non_inv =>( ssxlib => 1.21E-11, sxlib =>  1.21E-11 , vxlib => 1.21E-11 , vsclib => 6.97E-12 , wsclib => 7.74E-12 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 0.00E+00),
		inverter =>( ssxlib => 9.08E-12, sxlib =>  9.08E-12 , vxlib => 9.08E-12 , vsclib => 5.23E-12 , wsclib => 5.81E-12 , vgalib => 8.52E-12 , rgalib => 8.52E-12 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 0.00E+00),
		and2 =>( ssxlib => 1.51E-11, sxlib =>  1.51E-11 , vxlib => 1.51E-11 , vsclib => 8.71E-12 , wsclib => 9.68E-12 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 2.50E-07 , hct => 2.50E-07 , cmos => 0.00E+00),
		and3 =>( ssxlib => 1.82E-11, sxlib =>  1.82E-11 , vxlib => 1.82E-11 , vsclib => 1.22E-11 , wsclib => 1.36E-11 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 3.33E-07 , hct => 3.33E-07 , cmos => 0.00E+00),
		and4 =>( ssxlib => 2.12E-11, sxlib =>  2.12E-11 , vxlib => 2.12E-11 , vsclib => 1.39E-11 , wsclib => 1.55E-11 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 5.00E-07 , hct => 5.00E-07 , cmos => 0.00E+00),
		or2 =>( ssxlib => 1.51E-11, sxlib =>  1.51E-11 , vxlib => 1.51E-11 , vsclib => 8.71E-12 , wsclib => 9.68E-12 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 2.50E-07 , hct => 2.50E-07 , cmos => 0.00E+00),
		or3 =>( ssxlib => 1.82E-11, sxlib =>  1.82E-11 , vxlib => 1.82E-11 , vsclib => 1.57E-11 , wsclib => 1.74E-11 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 3.33E-07 , hct => 3.33E-07 , cmos => 0.00E+00),
		or4 =>( ssxlib => 2.12E-11, sxlib =>  2.12E-11 , vxlib => 2.42E-11 , vsclib => 1.92E-11 , wsclib => 2.13E-11 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 5.00E-07 , hct => 5.00E-07 , cmos => 0.00E+00),
		nand2 =>( ssxlib => 1.21E-11, sxlib =>  1.21E-11 , vxlib => 1.21E-11 , vsclib => 6.97E-12 , wsclib => 7.74E-12 , vgalib => 8.52E-12 , rgalib => 8.52E-12 , ac => 0.00E+00 , act => 0.00E+00 , hc => 2.50E-07 , hct => 2.50E-07 , cmos => 0.00E+00),
		nand3 =>( ssxlib => 1.51E-11, sxlib =>  1.51E-11 , vxlib => 1.51E-11 , vsclib => 1.39E-11 , wsclib => 1.55E-11 , vgalib => 1.70E-11 , rgalib => 1.70E-11 , ac => 0.00E+00 , act => 0.00E+00 , hc => 3.33E-07 , hct => 3.33E-07 , cmos => 0.00E+00),
		nand4 =>( ssxlib => 1.82E-11, sxlib =>  1.82E-11 , vxlib => 2.72E-11 , vsclib => 1.74E-11 , wsclib => 1.94E-11 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 5.00E-07 , hct => 5.00E-07 , cmos => 0.00E+00),
		nor2 =>( ssxlib => 1.21E-11, sxlib =>  1.21E-11 , vxlib => 1.82E-11 , vsclib => 1.05E-11 , wsclib => 1.16E-11 , vgalib => 1.70E-11 , rgalib => 1.70E-11 , ac => 0.00E+00 , act => 0.00E+00 , hc => 2.50E-07 , hct => 2.50E-07 , cmos => 0.00E+00),
		nor3 =>( ssxlib => 1.51E-11, sxlib =>  1.51E-11 , vxlib => 2.12E-11 , vsclib => 1.92E-11 , wsclib => 2.13E-11 , vgalib => 2.56E-11 , rgalib => 2.56E-11 , ac => 0.00E+00 , act => 0.00E+00 , hc => 3.33E-07 , hct => 3.33E-07 , cmos => 0.00E+00),
		nor4 =>( ssxlib => 1.82E-11, sxlib =>  1.82E-11 , vxlib => 2.72E-11 , vsclib => 2.44E-11 , wsclib => 2.71E-11 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 5.00E-07 , hct => 5.00E-07 , cmos => 0.00E+00),
		xor2 =>( ssxlib => 2.72E-11, sxlib =>  2.72E-11 , vxlib => 2.12E-11 , vsclib => 2.44E-11 , wsclib => 2.71E-11 , vgalib => 2.56E-11 , rgalib => 2.56E-11 , ac => 0.00E+00 , act => 0.00E+00 , hc => 2.50E-07 , hct => 2.50E-07 , cmos => 0.00E+00),
		xnor2 =>( ssxlib => 2.72E-11, sxlib =>  2.72E-11 , vxlib => 2.12E-11 , vsclib => 2.27E-11 , wsclib => 2.52E-11 , vgalib => 2.56E-11 , rgalib => 2.56E-11 , ac => 0.00E+00 , act => 0.00E+00 , hc => 2.50E-07 , hct => 2.50E-07 , cmos => 0.00E+00),
		mux2 =>( ssxlib => 2.72E-11, sxlib =>  2.72E-11 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 1.55E-11 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 2.50E-07 , hct => 2.50E-07 , cmos => 0.00E+00),
		mux4 =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 0.00E+00 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 5.00E-07 , hct => 5.00E-07 , cmos => 0.00E+00),
		num163 =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 0.00E+00 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 1.00E-06 , hct => 1.00E-06 , cmos => 0.00E+00),
		dff_rising_edge =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 4.36E-11 , wsclib => 3.48E-11 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 5.00E-07 , hct => 5.00E-07 , cmos => 0.00E+00),
		none_comp =>( ssxlib => 0.00E+00, sxlib =>  0.00E+00 , vxlib => 0.00E+00 , vsclib => 0.00E+00 , wsclib => 0.00E+00 , vgalib => 0.00E+00 , rgalib => 0.00E+00 , ac => 0.00E+00 , act => 0.00E+00 , hc => 0.00E+00 , hct => 0.00E+00 , cmos => 0.00E+00)
		);	
						
	component PAEstimator is
	generic ( N : natural := 1; -- number of inputs
			  M : natural := 1;  -- number of outputs
              logic_family : logic_family_t; -- the logic family of the component
              gate : component_t; -- the type of the component
			  Cload : real := 5.0);  
	port ( 	Vcc : in real := 5.0; -- supply voltage
			estimation : out estimation_type := est_zero;
	        sin : in std_logic_vector (N-1 downto 0);
			sout : in std_logic_vector (M-1 downto 0)
		);
	end component;

	component sum_up is
		generic ( N : natural := 1) ; -- number of inputs
			port ( estim : in estimation_type_array ;
			   estimation : out estimation_type := est_zero);
	end component;
	
	component power_estimator 
	generic ( time_window : time  := 1 ns); --capacities charges and dischareged
		port ( estimation : in  estimation_type;
		   power : out real  := 0.0);
	end component;
end PECore;    

package body PECore is

    function "+" (a,b : estimation_type) return estimation_type is
		variable sum : estimation_type;
	begin
		sum.power.dynamic := a.power.dynamic + b.power.dynamic;
		sum.power.static := a.power.static + b.power.static;
		sum.area := a.area + b.area;
	return sum;
	end function;
	
end PECore;

----------------------------------------------------------------------------------
-- Description: activity_monitor is detecting the logic transitions of a node.
--				(the number of times a capacitor is charged/discharged)
-- Dependencies: none
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity activity_monitor is
    Port ( signal_in : in STD_LOGIC;
           activity : out natural := 0);
end activity_monitor;

architecture Behavioral of activity_monitor is

signal NrOfTransitions: natural := 0;
begin
transaction_counter : process(signal_in)               
                begin
					NrOfTransitions <= NrOfTransitions + 1;
                end process; 
    activity <= NrOFTransitions; 
end Behavioral;

----------------------------------------------------------------------------------
-- Description: PAEstimator is is intended to be used as a configurable component to monitor 
--				input and output signal activity and compute the associated energye consumption.
-- Dependencies: PECore
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.PECore.all;

entity PAEstimator is
	generic ( N : natural := 1; -- number of inputs
			  M : natural := 1;  -- number of outputs
              logic_family : logic_family_t; -- the logic family of the component
              gate : component_t; -- the type of the component
			  Cload : real := 5.0);  
	port ( 	Vcc : in real := 5.0; -- supply voltage
			estimation : out estimation_type := est_zero;
	        sin : in std_logic_vector (N-1 downto 0);
			sout : in std_logic_vector (M-1 downto 0)
		);
end entity;

architecture monitoring of PAEstimator is
	type cons_t is array (0 to N + M - 1) of natural;
	signal cons : cons_t;
	type sum_t is array (-1 to N + M - 1) of natural;
	signal sum_in, sum_out : sum_t ;
	constant Icc : real := Icc_values(gate,logic_family);
	constant Cin : real := Cin_values(gate,logic_family);
	constant Cpd : real := Cpd_values(gate,logic_family);
	constant Area : real := Area_values(gate,logic_family);
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
	
    estimation.power.dynamic <=  (real(sum_in(N-1)) * (Cpd + Cin) + real(sum_out(M-1)) * Cload) * Vcc * Vcc ;
    estimation.power.static <= Vcc * Icc;
	estimation.area <= Area;
end architecture;

----------------------------------------------------------------------------------
-- Description: power_estimator is intended to be estimationonfigurable component to monitor 
--				input and output signal activity and compute the associated energye consumption.
-- Dependencies: PECore
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.PECore.all;

entity power_estimator is
	generic ( time_window : time := 1 ns); --capacities charges and dischareged
	port ( estimation : in  estimation_type;
	       power : out real := 0.0);
end entity;

architecture monitoring of power_estimator is
	signal est_delayed : estimation_type := est_zero;
	signal time_window_real : real;
begin

	-- convert energy to power 
	est_delayed <=  transport estimation after time_window;
	time_window_real <= real(time_window/1 ns) * 1.0e-9;
	power <=  0.0 when (estimation.power.dynamic - est_delayed.power.dynamic) = -1.0e+308 else (estimation.power.dynamic - est_delayed.power.dynamic) / time_window_real + estimation.power.static;
end architecture;

architecture periodc of power_estimator is
	signal est_delayed : estimation_type := est_zero;
	constant time_window_real : real := real(time_window/1 ns) * 1.0e-9;
	signal trigger : std_logic := '0';
begin
	process begin
		trigger <= '0';
		wait for time_window /2;	
		trigger <= '1';
		wait for time_window /2;
	end process;
	-- convert energy to power 
	process (trigger) begin
		 if (estimation.power.dynamic - estimation.power.dynamic) = -1.0e+308 then
		 	power <=  0.0;
		else 
			power <= (estimation.power.dynamic - est_delayed.power.dynamic) / time_window_real + estimation.power.static;
		end if;
		est_delayed <= estimation;
	end process;
end architecture;
----------------------------------------------------------------------------
-- Project Name: NAPOSIP
-- Description: this component is used to sum up the consumptions of individual gates/blocks.
-- Dependencies: PECore
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.PECore.all;

entity sum_up is
		generic ( N : natural := 1) ;-- number of inputs
		port ( estim : in estimation_type_array (1 to N);
		       estimation : out estimation_type := est_zero);
end entity;

architecture behavioral of sum_up is
    signal sum: estimation_type_array (0 to N) := (others => est_zero);
begin

    sum(0) <= est_zero;
    sum_up_energy : for I in 1 to N generate
          sum_i:    sum(I) <= sum(I-1) + estim(I);
    end generate sum_up_energy;
    estimation <= sum(N);

end architecture;
