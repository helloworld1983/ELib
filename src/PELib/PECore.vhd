----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: Power Estimation 
-- Description: - VHDL package
--              - defines the interface for static and dynamic power estimation
--              - defines operations with the interface
--              - dynamic power dissipation can be estimated using the activity signal 
--              - defines gate primitives with power monitoring function
-- Dependencies: none
-- 
-- Revision: 0.02 - Updates, merged the content of sum_up.vhd, activity_monitor.vhd,
--					consumption_monitor.vhd power_estimator.vhd into a single file
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

package PECore is
	-- type declaration to hold both static and dynamic power consumption
    type consumption_type is record
        dynamic : real; -- meant to represent dynamic consumption
        static : real; -- meant to represent static consumption
		area : real;
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
			
	constant default_logic_family : logic_family_t := cmos;
	constant default_VCC : real := 5.0; 
	constant Undef : real := 0.0 ;
	constant cons_zero : consumption_type := (0.0,0.0,0.0);
	type component_t is (tristate_buffer, buffer_non_inv, inverter, and2, and3, and4, or2, or3, or4, nand2, nand3, nand4, nor2, nor3, nor4, xor2, xnor2, mux2, mux4, num163, dff_rising_edge, none_comp);


	type value_matrix is array ( component_t, logic_family_t ) of real;
	--quiescent currents; expressed in Ampere
	constant ICC_values : value_matrix := ( 
	tristate_buffer =>( ssxlib => 0.000E+00, sxlib =>  0.000E+00 , vxlib => 0.000E+00 , vsclib => 0.000E+00 , wsclib => 0.000E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 002E+00 , act => 008E+00 , hc => 004E+00 , hct => 008E+00 , cmos => 0.000E+00),
    buffer_non_inv =>( ssxlib => 7.333E-04, sxlib =>  7.333E-04 , vxlib => 9.250E-04 , vsclib => 6.667E-04 , wsclib => 6.667E-04 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    inverter =>( ssxlib => 4.833E-04, sxlib =>  4.833E-04 , vxlib => 5.500E-04 , vsclib => 4.000E-04 , wsclib => 4.000E-04 , vgalib => 4.250E-04 , rgalib => 4.583E-04 , ac => 002E+00 , act => 004E+00 , hc => 002E+00 , hct => 0.000E+00 , cmos => 010E+00),
    and2 =>( ssxlib => 9.667E-04, sxlib =>  9.667E-04 , vxlib => 001E+00 , vsclib => 8.917E-04 , wsclib => 8.917E-04 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 002E+00 , act => 004E+00 , hc => 002E+00 , hct => 0.000E+00 , cmos => 004E+00),
    and3 =>( ssxlib => 001E+00, sxlib =>  001E+00 , vxlib => 001E+00 , vsclib => 001E+00 , wsclib => 001E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 010E+00),
    and4 =>( ssxlib => 002E+00, sxlib =>  002E+00 , vxlib => 002E+00 , vsclib => 001E+00 , wsclib => 001E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 010E+00),
    or2 =>( ssxlib => 001E+00, sxlib =>  001E+00 , vxlib => 6.833E-04 , vsclib => 8.250E-04 , wsclib => 8.250E-04 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 002E+00 , act => 004E+00 , hc => 002E+00 , hct => 0.000E+00 , cmos => 004E+00),
    or3 =>( ssxlib => 001E+00, sxlib =>  001E+00 , vxlib => 8.500E-04 , vsclib => 001E+00 , wsclib => 001E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 010E+00),
    or4 =>( ssxlib => 001E+00, sxlib =>  001E+00 , vxlib => 8.917E-04 , vsclib => 001E+00 , wsclib => 001E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 250E+00),
    nand2 =>( ssxlib => 5.750E-04, sxlib =>  5.750E-04 , vxlib => 001E+00 , vsclib => 6.583E-04 , wsclib => 6.583E-04 , vgalib => 6.750E-04 , rgalib => 7.333E-04 , ac => 002E+00 , act => 002E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 004E+00),
    nand3 =>( ssxlib => 7.667E-04, sxlib =>  7.667E-04 , vxlib => 001E+00 , vsclib => 001E+00 , wsclib => 001E+00 , vgalib => 9.250E-04 , rgalib => 001E+00 , ac => 002E+00 , act => 004E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 004E+00),
    nand4 =>( ssxlib => 9.667E-04, sxlib =>  9.667E-04 , vxlib => 002E+00 , vsclib => 001E+00 , wsclib => 001E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 002E+00 , act => 004E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 005E+00),
    nor2 =>( ssxlib => 5.750E-04, sxlib =>  5.750E-04 , vxlib => 001E+00 , vsclib => 8.083E-04 , wsclib => 8.083E-04 , vgalib => 6.750E-04 , rgalib => 001E+00 , ac => 002E+00 , act => 004E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 004E+00),
    nor3 =>( ssxlib => 6.750E-04, sxlib =>  6.750E-04 , vxlib => 001E+00 , vsclib => 001E+00 , wsclib => 001E+00 , vgalib => 002E+00 , rgalib => 002E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 005E+00),
    nor4 =>( ssxlib => 7.667E-04, sxlib =>  7.667E-04 , vxlib => 001E+00 , vsclib => 001E+00 , wsclib => 001E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 005E+00),
    xor2 =>( ssxlib => 002E+00, sxlib =>  002E+00 , vxlib => 001E+00 , vsclib => 002E+00 , wsclib => 002E+00 , vgalib => 001E+00 , rgalib => 001E+00 , ac => 002E+00 , act => 002E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 050E+00),
    xnor2 =>( ssxlib => 002E+00, sxlib =>  002E+00 , vxlib => 001E+00 , vsclib => 002E+00 , wsclib => 002E+00 , vgalib => 001E+00 , rgalib => 001E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 100E+00),
    mux2 =>( ssxlib => 001E+00, sxlib =>  001E+00 , vxlib => 0.000E+00 , vsclib => 0.000E+00 , wsclib => 8.583E-04 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    mux4 =>( ssxlib => 0.000E+00, sxlib =>  0.000E+00 , vxlib => 0.000E+00 , vsclib => 0.000E+00 , wsclib => 0.000E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 008E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    num163 =>( ssxlib => 0.000E+00, sxlib =>  0.000E+00 , vxlib => 0.000E+00 , vsclib => 0.000E+00 , wsclib => 0.000E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 008E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    dff_rising_edge =>( ssxlib => 0.000E+00, sxlib =>  0.000E+00 , vxlib => 0.000E+00 , vsclib => 002E+00 , wsclib => 002E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00)
    );	
 
	constant Cin_values : value_matrix := ( 
    tristate_buffer =>( ssxlib => 0.000E+00, sxlib =>  0.000E+00 , vxlib => 0.000E+00 , vsclib => 0.000E+00 , wsclib => 0.000E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 004E+00 , act => 004E+00 , hc => 010E+00 , hct => 004E+00 , cmos => 0.000E+00),
    buffer_non_inv =>( ssxlib => 003E+00, sxlib =>  003E+00 , vxlib => 005E+00 , vsclib => 003E+00 , wsclib => 003E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    inverter =>( ssxlib => 006E+00, sxlib =>  006E+00 , vxlib => 006E+00 , vsclib => 005E+00 , wsclib => 005E+00 , vgalib => 005E+00 , rgalib => 005E+00 , ac => 005E+00 , act => 005E+00 , hc => 004E+00 , hct => 004E+00 , cmos => 006E+00),
    and2 =>( ssxlib => 005E+00, sxlib =>  005E+00 , vxlib => 006E+00 , vsclib => 004E+00 , wsclib => 004E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 005E+00 , act => 005E+00 , hc => 004E+00 , hct => 004E+00 , cmos => 005E+00),
    and3 =>( ssxlib => 005E+00, sxlib =>  005E+00 , vxlib => 006E+00 , vsclib => 004E+00 , wsclib => 004E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 005E+00),
    and4 =>( ssxlib => 005E+00, sxlib =>  005E+00 , vxlib => 006E+00 , vsclib => 005E+00 , wsclib => 005E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    or2 =>( ssxlib => 005E+00, sxlib =>  005E+00 , vxlib => 004E+00 , vsclib => 004E+00 , wsclib => 004E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 005E+00 , act => 005E+00 , hc => 004E+00 , hct => 004E+00 , cmos => 005E+00),
    or3 =>( ssxlib => 004E+00, sxlib =>  004E+00 , vxlib => 005E+00 , vsclib => 006E+00 , wsclib => 006E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 005E+00),
    or4 =>( ssxlib => 004E+00, sxlib =>  004E+00 , vxlib => 005E+00 , vsclib => 006E+00 , wsclib => 006E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 008E+00),
    nand2 =>( ssxlib => 004E+00, sxlib =>  004E+00 , vxlib => 008E+00 , vsclib => 005E+00 , wsclib => 005E+00 , vgalib => 005E+00 , rgalib => 005E+00 , ac => 005E+00 , act => 005E+00 , hc => 004E+00 , hct => 004E+00 , cmos => 005E+00),
    nand3 =>( ssxlib => 005E+00, sxlib =>  005E+00 , vxlib => 007E+00 , vsclib => 006E+00 , wsclib => 006E+00 , vgalib => 005E+00 , rgalib => 005E+00 , ac => 005E+00 , act => 005E+00 , hc => 004E+00 , hct => 004E+00 , cmos => 005E+00),
    nand4 =>( ssxlib => 004E+00, sxlib =>  005E+00 , vxlib => 009E+00 , vsclib => 006E+00 , wsclib => 006E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 005E+00 , act => 004E+00 , hc => 004E+00 , hct => 004E+00 , cmos => 005E+00),
    nor2 =>( ssxlib => 005E+00, sxlib =>  005E+00 , vxlib => 010E+00 , vsclib => 007E+00 , wsclib => 007E+00 , vgalib => 007E+00 , rgalib => 010E+00 , ac => 005E+00 , act => 005E+00 , hc => 004E+00 , hct => 004E+00 , cmos => 005E+00),
    nor3 =>( ssxlib => 005E+00, sxlib =>  005E+00 , vxlib => 009E+00 , vsclib => 010E+00 , wsclib => 010E+00 , vgalib => 007E+00 , rgalib => 010E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 005E+00),
    nor4 =>( ssxlib => 005E+00, sxlib =>  005E+00 , vxlib => 010E+00 , vsclib => 010E+00 , wsclib => 010E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 005E+00),
    xor2 =>( ssxlib => 009E+00, sxlib =>  010E+00 , vxlib => 007E+00 , vsclib => 010E+00 , wsclib => 010E+00 , vgalib => 005E+00 , rgalib => 006E+00 , ac => 005E+00 , act => 005E+00 , hc => 004E+00 , hct => 004E+00 , cmos => 005E+00),
    xnor2 =>( ssxlib => 009E+00, sxlib =>  009E+00 , vxlib => 006E+00 , vsclib => 007E+00 , wsclib => 007E+00 , vgalib => 005E+00 , rgalib => 006E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 005E+00),
    mux2 =>( ssxlib => 004E+00, sxlib =>  004E+00 , vxlib => 0.000E+00 , vsclib => 0.000E+00 , wsclib => 004E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    mux4 =>( ssxlib => 0.000E+00, sxlib =>  0.000E+00 , vxlib => 0.000E+00 , vsclib => 0.000E+00 , wsclib => 0.000E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 004E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    num163 =>( ssxlib => 0.000E+00, sxlib =>  0.000E+00 , vxlib => 0.000E+00 , vsclib => 0.000E+00 , wsclib => 0.000E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 004E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    dff_rising_edge =>( ssxlib => 0.000E+00, sxlib =>  0.000E+00 , vxlib => 0.000E+00 , vsclib => 002E+00 , wsclib => 002E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00)				
     );	
						
	constant Cpd_values : value_matrix := ( 
	tristate_buffer =>( ssxlib => 0.000E+00, sxlib =>  0.000E+00 , vxlib => 0.000E+00 , vsclib => 0.000E+00 , wsclib => 0.000E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 021E+00 , act => 024E+00 , hc => 034E+00 , hct => 035E+00 , cmos => 0.000E+00),
    buffer_non_inv =>( ssxlib => 017E+00, sxlib =>  017E+00 , vxlib => 018E+00 , vsclib => 013E+00 , wsclib => 013E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    inverter =>( ssxlib => 006E+00, sxlib =>  006E+00 , vxlib => 007E+00 , vsclib => 005E+00 , wsclib => 005E+00 , vgalib => 007E+00 , rgalib => 006E+00 , ac => 030E+00 , act => 030E+00 , hc => 021E+00 , hct => 024E+00 , cmos => 012E+00),
    and2 =>( ssxlib => 020E+00, sxlib =>  020E+00 , vxlib => 020E+00 , vsclib => 015E+00 , wsclib => 015E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 020E+00 , act => 020E+00 , hc => 010E+00 , hct => 020E+00 , cmos => 018E+00),
    and3 =>( ssxlib => 027E+00, sxlib =>  027E+00 , vxlib => 022E+00 , vsclib => 016E+00 , wsclib => 016E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    and4 =>( ssxlib => 023E+00, sxlib =>  023E+00 , vxlib => 024E+00 , vsclib => 017E+00 , wsclib => 017E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    or2 =>( ssxlib => 020E+00, sxlib =>  020E+00 , vxlib => 012E+00 , vsclib => 015E+00 , wsclib => 015E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 020E+00 , act => 020E+00 , hc => 016E+00 , hct => 028E+00 , cmos => 018E+00),
    or3 =>( ssxlib => 021E+00, sxlib =>  021E+00 , vxlib => 014E+00 , vsclib => 016E+00 , wsclib => 016E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    or4 =>( ssxlib => 022E+00, sxlib =>  022E+00 , vxlib => 014E+00 , vsclib => 017E+00 , wsclib => 017E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    nand2 =>( ssxlib => 006E+00, sxlib =>  006E+00 , vxlib => 010E+00 , vsclib => 006E+00 , wsclib => 006E+00 , vgalib => 006E+00 , rgalib => 007E+00 , ac => 030E+00 , act => 030E+00 , hc => 022E+00 , hct => 022E+00 , cmos => 014E+00),
    nand3 =>( ssxlib => 008E+00, sxlib =>  008E+00 , vxlib => 012E+00 , vsclib => 009E+00 , wsclib => 009E+00 , vgalib => 009E+00 , rgalib => 010E+00 , ac => 025E+00 , act => 025E+00 , hc => 012E+00 , hct => 014E+00 , cmos => 017E+00),
    nand4 =>( ssxlib => 009E+00, sxlib =>  009E+00 , vxlib => 016E+00 , vsclib => 010E+00 , wsclib => 010E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 040E+00 , act => 033E+00 , hc => 022E+00 , hct => 017E+00 , cmos => 0.000E+00),
    nor2 =>( ssxlib => 007E+00, sxlib =>  007E+00 , vxlib => 011E+00 , vsclib => 007E+00 , wsclib => 007E+00 , vgalib => 008E+00 , rgalib => 013E+00 , ac => 030E+00 , act => 030E+00 , hc => 022E+00 , hct => 024E+00 , cmos => 014E+00),
    nor3 =>( ssxlib => 008E+00, sxlib =>  008E+00 , vxlib => 012E+00 , vsclib => 012E+00 , wsclib => 012E+00 , vgalib => 010E+00 , rgalib => 016E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    nor4 =>( ssxlib => 008E+00, sxlib =>  008E+00 , vxlib => 035E+00 , vsclib => 012E+00 , wsclib => 012E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    xor2 =>( ssxlib => 022E+00, sxlib =>  023E+00 , vxlib => 021E+00 , vsclib => 028E+00 , wsclib => 028E+00 , vgalib => 020E+00 , rgalib => 022E+00 , ac => 035E+00 , act => 030E+00 , hc => 030E+00 , hct => 030E+00 , cmos => 0.000E+00),
    xnor2 =>( ssxlib => 023E+00, sxlib =>  023E+00 , vxlib => 022E+00 , vsclib => 023E+00 , wsclib => 023E+00 , vgalib => 020E+00 , rgalib => 023E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 020E+00),
    mux2 =>( ssxlib => 023E+00, sxlib =>  024E+00 , vxlib => 0.000E+00 , vsclib => 0.000E+00 , wsclib => 015E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    mux4 =>( ssxlib => 0.000E+00, sxlib =>  0.000E+00 , vxlib => 0.000E+00 , vsclib => 0.000E+00 , wsclib => 0.000E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 040E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    num163 =>( ssxlib => 0.000E+00, sxlib =>  0.000E+00 , vxlib => 0.000E+00 , vsclib => 0.000E+00 , wsclib => 0.000E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 060E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    dff_rising_edge =>( ssxlib => 0.000E+00, sxlib =>  0.000E+00 , vxlib => 0.000E+00 , vsclib => 009E+00 , wsclib => 009E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00)
				 );	
						
	constant Area_values : value_matrix := ( 
	tristate_buffer =>( ssxlib => 0.000E+00, sxlib =>  0.000E+00 , vxlib => 0.000E+00 , vsclib => 0.000E+00 , wsclib => 0.000E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    buffer_non_inv =>( ssxlib => 012E+00, sxlib =>  012E+00 , vxlib => 012E+00 , vsclib => 007E+00 , wsclib => 008E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    inverter =>( ssxlib => 009E+00, sxlib =>  009E+00 , vxlib => 009E+00 , vsclib => 005E+00 , wsclib => 006E+00 , vgalib => 009E+00 , rgalib => 009E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    and2 =>( ssxlib => 015E+00, sxlib =>  015E+00 , vxlib => 015E+00 , vsclib => 009E+00 , wsclib => 010E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    and3 =>( ssxlib => 018E+00, sxlib =>  018E+00 , vxlib => 018E+00 , vsclib => 012E+00 , wsclib => 014E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    and4 =>( ssxlib => 021E+00, sxlib =>  021E+00 , vxlib => 021E+00 , vsclib => 014E+00 , wsclib => 015E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    or2 =>( ssxlib => 015E+00, sxlib =>  015E+00 , vxlib => 015E+00 , vsclib => 009E+00 , wsclib => 010E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    or3 =>( ssxlib => 018E+00, sxlib =>  018E+00 , vxlib => 018E+00 , vsclib => 016E+00 , wsclib => 017E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    or4 =>( ssxlib => 021E+00, sxlib =>  021E+00 , vxlib => 024E+00 , vsclib => 019E+00 , wsclib => 021E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    nand2 =>( ssxlib => 012E+00, sxlib =>  012E+00 , vxlib => 012E+00 , vsclib => 007E+00 , wsclib => 008E+00 , vgalib => 009E+00 , rgalib => 009E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    nand3 =>( ssxlib => 015E+00, sxlib =>  015E+00 , vxlib => 015E+00 , vsclib => 014E+00 , wsclib => 015E+00 , vgalib => 017E+00 , rgalib => 017E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    nand4 =>( ssxlib => 018E+00, sxlib =>  018E+00 , vxlib => 027E+00 , vsclib => 017E+00 , wsclib => 019E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    nor2 =>( ssxlib => 012E+00, sxlib =>  012E+00 , vxlib => 018E+00 , vsclib => 010E+00 , wsclib => 012E+00 , vgalib => 017E+00 , rgalib => 017E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    nor3 =>( ssxlib => 015E+00, sxlib =>  015E+00 , vxlib => 021E+00 , vsclib => 019E+00 , wsclib => 021E+00 , vgalib => 026E+00 , rgalib => 026E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    nor4 =>( ssxlib => 018E+00, sxlib =>  018E+00 , vxlib => 027E+00 , vsclib => 024E+00 , wsclib => 027E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    xor2 =>( ssxlib => 027E+00, sxlib =>  027E+00 , vxlib => 021E+00 , vsclib => 024E+00 , wsclib => 027E+00 , vgalib => 026E+00 , rgalib => 026E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    xnor2 =>( ssxlib => 027E+00, sxlib =>  027E+00 , vxlib => 021E+00 , vsclib => 023E+00 , wsclib => 025E+00 , vgalib => 026E+00 , rgalib => 026E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    mux2 =>( ssxlib => 027E+00, sxlib =>  027E+00 , vxlib => 0.000E+00 , vsclib => 0.000E+00 , wsclib => 015E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    mux4 =>( ssxlib => 0.000E+00, sxlib =>  0.000E+00 , vxlib => 0.000E+00 , vsclib => 0.000E+00 , wsclib => 0.000E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    num163 =>( ssxlib => 0.000E+00, sxlib =>  0.000E+00 , vxlib => 0.000E+00 , vsclib => 0.000E+00 , wsclib => 0.000E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00),
    dff_rising_edge =>( ssxlib => 0.000E+00, sxlib =>  0.000E+00 , vxlib => 0.000E+00 , vsclib => 044E+00 , wsclib => 035E+00 , vgalib => 0.000E+00 , rgalib => 0.000E+00 , ac => 0.000E+00 , act => 0.000E+00 , hc => 0.000E+00 , hct => 0.000E+00 , cmos => 0.000E+00)
		);	
						
	component consumption_monitor is
	generic ( N : natural := 1; -- number of inputs
			  M : natural := 1;  -- number of outputs
              logic_family : logic_family_t; -- the logic family of the component
              gate : component_t; -- the type of the component
			  Cload : real := 5.0);  
		port ( sin : in std_logic_vector (N-1 downto 0);
			   sout : in std_logic_vector (M-1 downto 0);
			   Vcc : in real := 5.0; -- supply voltage
			   consumption : out consumption_type := cons_zero);
	end component;

	component sum_up is
		generic ( N : natural := 1) ; -- number of inputs
		port ( cons : in consumption_type_array ;
			   consumption : out consumption_type := cons_zero);
	end component;
	
	component power_estimator is
		generic ( time_window : time := 1 ns); --capacities charges and dischareged
		port ( consumption : in  consumption_type;
		   power : out real := 0.0);
	end component;
    
end PECore;

package body PECore is

	function "+" (a,b:consumption_type) return consumption_type is
		variable sum : consumption_type;
	begin
		sum.dynamic := a.dynamic + b.dynamic;
		sum.static := a.static + b.static;
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
-- Description: consumption_monitor is intended to be used as a configurable component to monitor 
--				input and output signal activity and compute the associated energye consumption.
-- Dependencies: PECore
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.PECore.all;

entity consumption_monitor is
	generic ( N : natural := 1; -- number of inputs
			  M : natural := 1;  -- number of outputs
			  logic_family : logic_family_t; -- the logic family of the component
			  gate : component_t; -- the type of the component
			  Cload : real := 5.0);  
		port ( sin : in std_logic_vector (N-1 downto 0);
			   sout : in std_logic_vector (M-1 downto 0);
			   Vcc : in real := 5.0; -- supply voltage
			   consumption : out consumption_type := cons_zero
			   );
end entity;

architecture monitoring of consumption_monitor is
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
	
    consumption.dynamic <= (real(sum_in(N-1)) * (Cpd + Cin) + real(sum_out(M-1)) * Cload) * Vcc * Vcc / 2.0;
    consumption.static <= Vcc * Icc;
	consumption.area <= Area;
end architecture;

----------------------------------------------------------------------------------
-- Description: power_estimator is intended to be used as a configurable component to monitor 
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
	port ( consumption : in  consumption_type;
		   power : out real := 0.0);
end entity;

architecture monitoring of power_estimator is
	signal cons_delayed : consumption_type := cons_zero;
	signal time_window_real : real;
begin

	-- convert energy to power 
	cons_delayed <=  transport consumption after time_window;
	time_window_real <= real(time_window/1 ns) * 1.0e-9;
	power <=  0.0 when (consumption.dynamic - cons_delayed.dynamic) = -1.0e+308 else (consumption.dynamic - cons_delayed.dynamic) / time_window_real + consumption.static;
end architecture;
----------------------------------------------------------------------------------
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
		port ( cons : in consumption_type_array (1 to N);
		       consumption : out consumption_type := cons_zero);
end entity;

architecture behavioral of sum_up is
    signal sum: consumption_type_array (0 to N) := (others => cons_zero);
begin

    sum(0) <= cons_zero;
    sum_up_energy : for I in 1 to N generate
          sum_i:    sum(I) <= sum(I-1) + cons(I);
    end generate sum_up_energy;
    consumption <= sum(N);

end architecture;
