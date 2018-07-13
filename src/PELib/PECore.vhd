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
			
	constant default_logic_family : logic_family_t := HC;
	constant default_VCC : real := 5.0; 
	constant Undef : real := 0.0 ;
	type component_t is (tristate_comp, inv_comp, and_comp, nand_comp, or_comp, nor_comp, xor_comp, nand3_comp, nand4_comp, mux2_1_comp, mux4_1_comp, num74163_comp, none_comp);


	type value_matrix is array ( component_t, logic_family_t ) of real;
	--quiescent currents; expressed in Ampere
	constant ICC_values : value_matrix := ( 
						tristate_comp => ( CD => 4.0e-6, HCT => 8.0e-6, HC => 4.0e-6, ACT => 8.0e-6, AC => 2.0e-6, ALS => 0.0, LS => 12.0e-3, LVC => 0.0, F => 31.7e-3, S => 0.0),
						inv_comp 	=> ( CD => 1.0e-6, HCT => 2.0e-6, HC => 2.0e-6, ACT => 4.0e-6, AC => 2.0e-6, ALS => 3.2e-3, LS => 3.6e-3, LVC => 0.1e-6, F => 10.2e-3, S => 0.0),
						and_comp	=> ( CD => 0.004e-6, HCT => 0.0, HC => 0.0, ACT => 4.0e-6, AC => 2.0e-6, ALS => 2.2e-3, LS => 4.4e-3, LVC => 0.1e-6, F => 8.6e-3, S => 20.0e-3),
						nand_comp	=> ( CD => 0.004e-6, HCT => 0.0, HC => 0.0, ACT => 2.0e-6, AC => 2.0e-6, ALS => 1.5e-3, LS => 2.4e-3, LVC => 0.1e-6, F => 6.8e-3, S => 0.0),
						or_comp	    => ( CD => 0.004e-6, HCT => 0.0, HC => 0.0, ACT => 4.0e-6, AC => 2.0e-6, ALS => 2.8e-3, LS => 4.9e-3, LVC => 0.1e-6, F => 10.3e-3, S => 23.0e-3),
						nor_comp	=> ( CD => 0.004e-6, HCT => 0.0, HC => 0.0, ACT => 4.0e-6, AC => 2.0e-6, ALS => 0.0, LS => 2.8e-3, LVC => 0.1e-6, F => 8.7e-3, S => 2.8e-3),
						xor_comp	=> ( CD => 0.05e-6, HCT => 0.0, HC => 0.0, ACT => 2.0e-6, AC => 2.0e-6, ALS => 0.0, LS => 9.0e-3, LVC => 0.0, F => 18.0e-3, S => 0.0),
						nand3_comp	=> ( CD => 0.004e-6, HCT => 0.0, HC => 0.0, ACT => 4.0e-6, AC => 2.0e-6, ALS => 1.6e-3, LS => 1.8e-3, LVC => 0.0, F => 5.1e-3, S => 0.0),
						nand4_comp	=> ( CD => 0.005e-6, HCT => 0.0, HC => 0.0, ACT => 4.0e-6, AC => 2.0e-6, ALS => 0.0, LS => 1.2e-3, LVC => 0.0, F => 3.4e-3, S => 6.0e-3),
						mux2_1_comp	=> ( CD => Undef, HCT => Undef, HC => 8.0e-6, ACT => Undef, AC => Undef, ALS => Undef, LS => Undef, LVC => Undef, F => Undef, S => Undef),
						mux4_1_comp	=> ( CD => Undef, HCT => Undef, HC => 8.0e-6, ACT => Undef, AC => Undef, ALS => Undef, LS => Undef, LVC => Undef, F => Undef, S => Undef),
						num74163_comp	=> ( CD => Undef, HCT => Undef, HC => 8.0e-6, ACT => Undef, AC => Undef, ALS => Undef, LS => Undef, LVC => Undef, F => Undef, S => Undef),
						none_comp => (CD => 0.0, HCT => 0.0, HC => 0.0, ACT => 0.0, AC => 0.0, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0)					
						);	
 
	constant Cin_values : value_matrix := ( 
						tristate_comp => ( CD => 7.5e-12, HCT => 3.5e-12, HC => 10.0e-12, ACT => 4.0e-12, AC => 4.5e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						inv_comp 	=> ( CD => 6.0e-12, HCT => 3.5e-12, HC => 3.5e-12, ACT => 4.5e-12, AC => 4.5e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						and_comp	=> ( CD => 5.0e-12, HCT => 3.5e-12, HC => 3.5e-12, ACT => 4.5e-12, AC => 4.5e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						nand_comp	=> ( CD => 5.0e-12, HCT => 3.5e-12, HC => 3.5e-12, ACT => 4.5e-12, AC => 4.5e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						or_comp	    => ( CD => 5.0e-12, HCT => 3.5e-12, HC => 3.5e-12, ACT => 4.5e-12, AC => 4.5e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						nor_comp	=> ( CD => 5.0e-12, HCT => 3.5e-12, HC => 3.5e-12, ACT => 4.5e-12, AC => 4.5e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						xor_comp	=> ( CD => 5.0e-12, HCT => 3.5e-12, HC => 3.5e-12, ACT => 5.0e-12, AC => 4.5e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						nand3_comp	=> ( CD => 5.0e-12, HCT => 3.5e-12, HC => 3.5e-12, ACT => 4.5e-12, AC => 4.5e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
                        nand4_comp  => ( CD => 5.0e-12, HCT => 3.5e-12, HC => 3.5e-12, ACT => 3.8e-12, AC => 4.5e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						mux2_1_comp	=> ( CD => Undef, HCT => 3.5e-12, HC => 3.5e-12, ACT => Undef, AC => Undef, ALS => Undef, LS => Undef, LVC => Undef, F => Undef, S => Undef),
						mux4_1_comp	=> ( CD => Undef, HCT => 3.5e-12, HC => 3.5e-12, ACT => Undef, AC => Undef, ALS => Undef, LS => Undef, LVC => Undef, F => Undef, S => Undef),
						num74163_comp	=> ( CD => Undef, HCT => 3.5e-12, HC => 3.5e-12, ACT => Undef, AC => Undef, ALS => Undef, LS => Undef, LVC => Undef, F => Undef, S => Undef),
						none_comp	=> ( CD => Undef, HCT => 3.5e-12, HC => 3.5e-12, ACT => Undef, AC => Undef, ALS => Undef, LS => Undef, LVC => Undef, F => Undef, S => Undef)
						);	
						
	constant Cpd_values : value_matrix := ( 
						tristate_comp => ( CD => 40.0e-12, HCT => 35.0e-12, HC => 34.0e-12, ACT => 24.0e-12, AC => 45.0e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						inv_comp 	=> ( CD => 12.0e-12, HCT => 24.0e-12, HC => 21.0e-12, ACT => 30.0e-12, AC => 30.0e-12, ALS => 0.0, LS => 0.0, LVC => 25.0e-12, F => 0.0, S => 0.0),
						and_comp	=> ( CD => 18.0e-12, HCT => 20.0e-12, HC => 10.0e-12, ACT => 20.0e-12, AC => 20.0e-12, ALS => 0.0, LS => 0.0, LVC => 28.0e-12, F => 0.0, S => 0.0),
						nand_comp	=> ( CD => 14.0e-12, HCT => 22.0e-12, HC => 22.0e-12, ACT => 30.0e-12, AC => 30.0e-12, ALS => 0.0, LS => 0.0, LVC => 28.0e-12, F => 0.0, S => 0.0),
						or_comp	    => ( CD => 18.0e-12, HCT => 28.0e-6, HC => 16.0e-12, ACT => 20.0e-12, AC => 20.0e-12, ALS => 0.0, LS => 0.0, LVC => 28.0e-12, F => 0.0, S => 0.0),
						nor_comp	=> ( CD => 14.0e-12, HCT => 24.0e-6, HC => 22.0e-12, ACT => 30.0e-12, AC => 30.0e-12, ALS => 0.0, LS => 0.0, LVC => 8.5e-12, F => 0.0, S => 0.0),
						xor_comp	=> ( CD => 14.0e-12, HCT => 30.0e-6, HC => 30.0e-12, ACT => 30.0e-12, AC => 35.0e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						nand3_comp	=> ( CD => 17.0e-12, HCT => 14.0e-6, HC => 12.0e-12, ACT => 25.0e-12, AC => 25.0e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
                        nand4_comp  => ( CD => 18.0e-12, HCT => 17.0e-6, HC => 22.0e-12, ACT => 33.0e-12, AC => 40.0e-12, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0),
						mux2_1_comp	=> ( CD => Undef, HCT => Undef, HC => Undef, ACT => Undef, AC => Undef, ALS => Undef, LS => Undef, LVC => Undef, F => Undef, S => Undef),
						mux4_1_comp	=> ( CD => Undef, HCT => Undef, HC => 40.0e-12, ACT => Undef, AC => Undef, ALS => Undef, LS => Undef, LVC => Undef, F => Undef, S => Undef),
						num74163_comp	=> ( CD => Undef, HCT => Undef, HC => 60.0e-12, ACT => Undef, AC => Undef, ALS => Undef, LS => Undef, LVC => Undef, F => Undef, S => Undef),
                        none_comp => (CD => 0.0, HCT => 0.0, HC => 0.0, ACT => 0.0, AC => 0.0, ALS => 0.0, LS => 0.0, LVC => 0.0, F => 0.0, S => 0.0)    
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
    
end PECore;

package body PECore is

	function "+" (a,b:consumption_type) return consumption_type is
		variable sum : consumption_type;
	begin
		sum.dynamic := a.dynamic + b.dynamic;
		sum.static := a.static + b.static;
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
			   consumption : out consumption_type := (0.0,0.0)
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
	signal cons_delayed : consumption_type := (0.0,0.0);
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
