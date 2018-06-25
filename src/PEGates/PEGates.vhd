----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description: - PEGatesity functions
--              - implements the log2 function used to compute the number of bits to represent a value
--              - defines components with power monitoring function
-- Dependencies: none
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.PElib.all;

package PEGates is
	-- the length of the array should be equal to the number of elements in logic_family_t type
    type real_array is array (0 to 4) of real;
	-- the supported logic families
    type logic_family_t is (None, -- none
			CD4000, -- CMOS
			HCT, -- HCT
			HC, -- HC
			AC); -- AC
	-- selected logic family - change the value for other 
    constant logic_family : logic_family_t := HC;
	
	type component_parameter_type is record
		Cin : real; 	--input capacity
		Cpd : real;		--power dissipation capacity 
		Cload : real;	--load capacity; write 0.0 when load is unknown
		Icc : real ; 	--quiescent current expressed in Ampere
	end record;
	
    constant Vcc_values 		: real_array; -- typical values of VCC of logic families
    constant tristate_buf_Cpd_values 	: real_array; -- typical values of Cpd of logic families
    constant tristate_buf_Cin_values 	: real_array; -- typical values of VCC of logic families
    constant tristate_buf_ICC_values 	: real_array; -- typical values of VCC of logic families
    constant num74163_Cpd_values 	: real_array; -- typical values of Cpd of logic families
    constant num74163_Cin_values 	: real_array; -- typical values of VCC of logic families
    constant num74163_ICC_values 	: real_array; -- typical values of VCC of logic families
    constant mux4_1_Cpd_values 	: real_array; -- typical values of Cpd of logic families
    constant mux4_1_Cin_values 	: real_array; -- typical values of VCC of logic families
    constant mux4_1_ICC_values 	: real_array; -- typical values of VCC of logic families
    constant inv_gate_Cpd_values 	: real_array; -- typical values of Cpd of logic families
    constant inv_gate_Cin_values 	: real_array; -- typical values of Cpd of logic families
    constant inv_gate_ICC_values 	: real_array; -- typical values of VCC of logic families
    constant nand_gate_Cpd_values 	: real_array; -- typical values of Cpd of logic families
    constant nand_gate_Cin_values 	: real_array; -- typical values of Cpd of logic families
    constant nand_gate_ICC_values 	: real_array; -- typical values of VCC of logic families
    constant VCC : real;
    constant tristate_buf_Cpd : real;
    constant tristate_buf_Cin : real; 
    constant tristate_buf_ICC : real; 
    constant num74163_Cpd : real;
    constant num74163_Cin : real; 
    constant num74163_ICC : real;
    constant mux4_1_Cpd : real;
    constant mux4_1_Cin : real; 
    constant mux4_1_ICC : real;
    constant inv_gate_Cpd : real;
    constant inv_gate_Cin : real; 
    constant inv_gate_ICC : real; 
    constant nand_gate_Cpd : real; 
    constant nand_gate_Cin : real; 
    constant nand_gate_ICC : real;
	
	-- component implemented in tristate_buf.vhd
	component tristate_buf is
		Generic (delay : time :=1 ns;
				 Cpd: real := tristate_buf_Cpd; --power dissipation capacity
				 Cin: real := tristate_buf_Cin; --input capacity
				 Cload: real := 0.0; --load capacity; write 0.0 when load is unknown
				 Icc : real := tristate_buf_ICC; -- questient current at room temperature  
				 Vcc : real := 5.0 -- supply voltage
				 );
		Port ( a, en : in STD_LOGIC;
			   y : out STD_LOGIC;
			   consumption: out consumption_type := (0.0,0.0));
	end component;
	-- component implemented in inv_gate.vhd
	component inv_gate is
		Generic (delay : time :=1 ns;
				 Cpd: real := inv_gate_Cpd; --power dissipation capacity
				 Cin: real := inv_gate_Cin; --input capacity
				 Cload: real := 0.0; --load capacity; write 0.0 when load is unknown
				 Icc : real := inv_gate_ICC -- questient current at room temperature  
				 );
     Port ( a : in STD_LOGIC;
            y : out STD_LOGIC;
            consumption : out consumption_type := (0.0,0.0));
	end component;
	-- component implemented in and_gate.vhd
	component xor_gate is
    Generic (delay : time := 1 ns;
             Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
             Icc : real := 1.0e-6 -- questient current at room temperature  
             );
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC;
           consumption : out consumption_type := (0.0,0.0));
	end component;
	-- component implemented in and_gate.vhd
	component and_gate is
    Generic (delay : time := 1 ns;
             Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacities
             Icc : real := 1.0e-6 -- questient current at room temperature  
             );
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC;
           consumption : out consumption_type := (0.0,0.0));
	end component;
	-- component implemented in and3_gate .vhd
	component and3_gate is
		Generic (delay : time := 1 ns;
				 Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacities
				 Icc : real := 1.0e-6 -- questient current at room temperature  
             );
		Port ( a,b,c : in STD_LOGIC;
			   y : out STD_LOGIC;
			   consumption : out consumption_type := (0.0,0.0));
	end component;
	-- component implemented in and4_gate.vhd
	component and4_gate is
		Generic (delay : time := 1 ns;
				Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacities
				Icc : real := 1.0e-6 -- questient current at room temperature  
             );
		Port ( a,b,c,d : in STD_LOGIC;
			   y : out STD_LOGIC;
			   consumption : out consumption_type := (0.0,0.0));
	end component;
	-- component implemented in and5_gate.vhd
	component and5_gate is
        Generic (delay : time := 1 ns;
        Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacities
        Icc : real := 1.0e-6 -- questient current at room temperature  
             );
        Port ( a,b,c,d,e : in STD_LOGIC;
               y : out STD_LOGIC;
               consumption: out consumption_type := (0.0,0.0));
    end component;
 -- component implemented in or_gate.vhd	
	component or_gate is
		Generic (delay : time := 1 ns;
				Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
				Icc : real := 2.0e-6 -- questient current at room temperature  
             );
		Port ( a : in STD_LOGIC;
			   b : in STD_LOGIC;
			   y : out STD_LOGIC;
			   consumption : out consumption_type := (0.0,0.0));
	end component;	
	 -- component implemented in or3_gate.vhd		
	component or3_gate is
		Generic (delay : time := 1 ns;
				 Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
				 Icc : real := 1.0e-6 -- questient current at room temperature  
             );
		Port ( a,b,c : in STD_LOGIC;
			   y : out STD_LOGIC;
			   consumption : out consumption_type := (0.0,0.0));
	end component;
	-- component implemented in or4_gate.vhd	
    component or4_gate is
        Generic (delay : time :=1 ns;
        Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
        Icc : real := 1.0e-6 -- questient current at room temperature  
             );
        Port ( a,b,c,d : in STD_LOGIC;
                y: out STD_LOGIC;
                consumption : out consumption_type := (0.0,0.0));
    end component;	
	-- component implemented in or9_gate.vhd	
    component or9_gate is
    Generic (delay : time :=1 ns;
             Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
             Icc : real := 1.0e-6 -- questient current at room temperature  
             );
    Port ( x : in STD_LOGIC_VECTOR(8 downto 0);
           y : out STD_LOGIC;
           consumption : out consumption_type := (0.0,0.0));
    end component;
    -- component implemented in nand_gate.vhd		
    component nand_gate is
    Generic (delay : time := 1 ns;
             Cpd: real := nand_gate_CPD; --power dissipation capacity
             Cin: real := nand_gate_Cin; --input capacity
             Cload: real := 0.0; --load capacity
             Icc : real := nand_gate_ICC -- questient current at room temperature  
             );
    Port ( a : in STD_LOGIC;
             b : in STD_LOGIC;
             y : out STD_LOGIC;
             consumption : out consumption_type := (0.0,0.0));
    end component;	
	-- component implemented in nand4_gate.vhd
	component nand4_gate is
        Generic (delay : time := 1 ns;
                Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
                Icc : real := 1.0e-6 -- questient current at room temperature  
             );
        Port ( a,b,c,d : in STD_LOGIC;
               y : out STD_LOGIC;
               consumption: out consumption_type := (0.0,0.0));
    end component;
	-- component implemented in nand9_gate.vhd	
	component nand9_gate is
		Generic (delay : time :=1 ns;
				 Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
				 Icc : real := 1.0e-6 -- questient current at room temperature  
             );
		Port ( x : in STD_LOGIC_VECTOR(8 downto 0);
			   y : out STD_LOGIC;
			   consumption : out consumption_type := (0.0,0.0));
	end component;
	 -- component implemented in nor_gate.vhd	
	component nor_gate is
		Generic (delay : time := 1 ns;
				 Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies 
				 Icc : real := 1.0e-6 -- questient current at room temperature  
				 );
		Port ( a : in STD_LOGIC;
			   b : in STD_LOGIC;
			   y : out STD_LOGIC;
			   consumption : out consumption_type := (0.0,0.0));
	end component;
	-- component implemented in nor3_gate.vhd	
	component nor3_gate is
		Generic (delay : time := 1 ns;
				 Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
				 Icc : real := 1.0e-6 -- questient current at room temperature  
             );
		Port ( a,b,c : in STD_LOGIC;
			   y : out STD_LOGIC;
			   consumption: out consumption_type := (0.0,0.0));
	end component;
	-- component implemented in nor4_gate.vhd	
	component nor4_gate is
		Generic (delay : time :=1 ns;
		Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
		Icc : real := 1.0e-6 -- questient current at room temperature  
             );
		Port ( a,b,c,d : in STD_LOGIC;
				y: out STD_LOGIC;
				consumption : out consumption_type := (0.0,0.0));
	end component;
	-- component implemented in nor9_gate.vhd	
	component nor9_gate is
    Generic (delay : time :=1 ns;
             Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
             Icc : real := 1.0e-6 -- questient current at room temperature  
             );
    Port ( x : in STD_LOGIC_VECTOR(8 downto 0);
           y : out STD_LOGIC;
           consumption : out consumption_type := (0.0,0.0));
	end component;
	-- component implemented in nor8_gate.vhd	
	component nor8_gate is
    Generic (delay : time :=1 ns;
             Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
             Icc : real := 1.0e-6 -- questient current at room temperature  
             );
    Port ( x : in STD_LOGIC_VECTOR(7 downto 0);
           y : out STD_LOGIC;
           consumption : out consumption_type := (0.0,0.0));
	end component;
	
	-- component implemented in mux2_1.vhd
	component mux2_1 is
        Generic (delay : time := 1 ns;
                Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
                Icc : real := 2.0e-6 -- questient current at room temperature  
                );
        Port ( I : in STD_LOGIC_VECTOR (1 downto 0);
               A : in STD_LOGIC;
               Y : out STD_LOGIC;
               consumption : out consumption_type := (0.0,0.0));
    end component;
    -- component implemented in mux4_1.vhd
       component mux4_1 is
        Generic (delay : time := 1 ns;
				 Cpd: real := mux4_1_Cpd; --power dissipation capacity
				 Cin: real := mux4_1_Cin; --input capacity
				 Icc: real := mux4_1_ICC; -- questient current at room temperature 
 				 Cload: real := 0.0 --load capacity; write 0.0 when load is unknown
                );
        Port ( I : in STD_LOGIC_VECTOR (3 downto 0);
               A : in STD_LOGIC_VECTOR (1 downto 0);
               Y : out STD_LOGIC;
               consumption : out consumption_type := (0.0,0.0));
    end component;
    -- component implemented in num74163.vhd
    component num74163 is
        Generic (delay : time := 1 ns;
				 Cpd: real := num74163_Cpd; --power dissipation capacity
				 Cin: real := num74163_Cin; --input capacity
				 Icc: real := num74163_ICC; -- questient current at room temperature 
 				 Cload: real := 0.0 --load capacity; write 0.0 when load is unknown

                );
        Port ( CLK, CLRN, LOADN, P, T, D ,C ,B ,A : in std_logic;
                 Qd, Qc, Qb, Qa, RCO: out std_logic;
                 consumption : out consumption_type := (0.0,0.0));
    end component;
    -- component implemented in dff.vhd
    component dff is
		Generic (delay : time := 1 ns;
				Cpd: real := 29.0e-12; --power dissipation capacity
				Cin: real := 3.5e-12; -- input capacity
				Cload : real := 0.0; -- load capacity
				Icc : real := 40.0e-6; -- questient current at room temperature  
				active_edge : std_logic := '0'
				);
		Port ( CP, D, Rdn, SDn : in STD_LOGIC;
			   Q, Qn : out STD_LOGIC;
			   consumption : out consumption_type := (0.0,0.0));
    end component;    
    
end PEGates;

package body PEGates is
	-- typical values of VCC for the logic families
  	constant Vcc_values : real_array := (0.0, -- none
					5.0,  -- CMOS 5V
					5.0,  -- HCT  5V
					5.0,  -- HCT  5V
					5.0); -- AC   5V
	constant tristate_buf_Cpd_values : real_array := (0.0, -- none
							40.0e-12, -- CMOS 40 pF
							40.0e-12, -- HCT 40 pF
							40.0e-12, -- HC 40 pF
							45.0e-12 -- AC
							 );
	constant tristate_buf_Cin_values : real_array := (0.0, -- none
							7.5e-12, -- CMOS 7.5 pF
							10.0e-12, -- HCT 10 pF
							10.0e-12, -- HC 10 pF
							4.5e-12 -- AC
							);
	constant tristate_buf_ICC_values : real_array := (1.0, -- none 
							4.0e-6, -- CMOS 4 uA
							8.0e-6, -- HCT 8 uA
							8.0e-6, -- HC 8 uA
							2.0e-6 -- AC 8 uA
							);
	constant num74163_Cpd_values : real_array := (0.0, -- none
						40.0e-12, -- CMOS 40 pF
						40.0e-12, -- HCT 40 pF
						60.0e-12, -- HC 60 pF
						--2.0e-9, -- HC 60 pF
						45.0e-12 -- AC
						 );
	constant num74163_Cin_values : real_array := (0.0, -- none
						7.5e-12, -- CMOS 7.5 pF
						10.0e-12, -- HCT 10 pF
						10.0e-12, -- HC 10 pF
						4.5e-12 -- AC 8 uA
						);
	constant num74163_ICC_values : real_array := (1.0, -- none 
							4.0e-6, -- CMOS 4 uA
							8.0e-6, -- HCT 8 uA
							8.0e-6, -- HC 8 uA
							2.0e-6 -- AC 8 uA
							);
	constant mux4_1_Cpd_values : real_array := (0.0, -- none
						40.0e-12, -- CMOS 40 pF
						40.0e-12, -- HCT 40 pF
						40.0e-12, -- HC 40 pF
						45.0e-12 -- AC
						 );
	constant mux4_1_Cin_values : real_array := (0.0, -- none
						7.5e-12, -- CMOS 7.5 pF
						10.0e-12, -- HCT 10 pF
						10.0e-12, -- HC 10 pF
						4.5e-12
						);
	constant mux4_1_ICC_values : real_array := (1.0, -- none 
							4.0e-6, -- CMOS 4 uA
							8.0e-6, -- HCT 8 uA
							8.0e-6, -- HC 8 uA
							2.0e-6 -- AC 8 uA
							);
	constant inv_gate_Cpd_values : real_array := (0.0, -- none
							12.0e-12, -- CMOS 12 pF
							24.0e-12, -- HCT 24 pF
							20.0e-12, -- HC 20 pF
							30.0e-12-- AC 30pF
							);
	constant inv_gate_Cin_values : real_array := (0.0, -- none
							6.0e-12, -- CMOS 6 pF
							3.5e-12, -- HCT 10 pF
							2.5e-12, -- HC 10 pF
							4.5e-12 --AC 4.5 pf
							);
	constant inv_gate_ICC_values : real_array := (1.0, -- none 
							1.0e-6, -- CMOS 1 uA
							2.0e-6, -- HCT 2 uA
							2.0e-6, -- HC 2 uA
							2.0e-6 -- AC 2 uA
							);
	constant nand_gate_Cpd_values : real_array := (0.0, -- none
							14.0e-12, -- CMOS 14 pF
							26.0e-12, -- HCT 26 pF
							26.0e-12, -- HC 26 pF
							30.0e-12-- AC 30pF
							);
	constant nand_gate_Cin_values : real_array := (0.0, -- none
							5.0e-12, -- CMOS 5 pF
							10.0e-12, -- HCT 10 pF
							10.0e-12, -- HC 10 pF
							4.5e-12  --AC 4.5 pf
							);
	constant nand_gate_ICC_values : real_array := (1.0, -- none 
							0.25e-6, -- CMOS 0.25 uA
							2.0e-6, -- HCT 8 uA
							2.0e-6, -- HC 8 uA
							2.0e-6 -- AC 8 uA
							);
	-- selection of the parameter values, for a selected logic_family
	constant Vcc 			: real := Vcc_values			(logic_family_t'POS(logic_family));	
	constant tristate_buf_Cpd	: real := tristate_buf_Cpd_values	(logic_family_t'POS(logic_family));
	constant tristate_buf_Cin	: real := tristate_buf_Cin_values	(logic_family_t'POS(logic_family));
	constant tristate_buf_ICC 	: real := tristate_buf_ICC_values	(logic_family_t'POS(logic_family));
	constant num74163_Cpd	: real := num74163_Cpd_values	(logic_family_t'POS(logic_family));
	constant num74163_Cin	: real := num74163_Cin_values	(logic_family_t'POS(logic_family));
	constant num74163_ICC 	: real := num74163_ICC_values	(logic_family_t'POS(logic_family));
	constant mux4_1_Cpd		: real := mux4_1_Cpd_values	(logic_family_t'POS(logic_family));
	constant mux4_1_Cin		: real := mux4_1_Cin_values	(logic_family_t'POS(logic_family));
	constant mux4_1_ICC 	: real := mux4_1_ICC_values	(logic_family_t'POS(logic_family));
	constant inv_gate_Cpd	: real := inv_gate_Cpd_values	(logic_family_t'POS(logic_family));
	constant inv_gate_Cin	: real := inv_gate_Cin_values	(logic_family_t'POS(logic_family));
	constant inv_gate_ICC 	: real := inv_gate_ICC_values	(logic_family_t'POS(logic_family));
	constant nand_gate_Cpd	: real := nand_gate_Cpd_values	(logic_family_t'POS(logic_family));
	constant nand_gate_Cin	: real := nand_gate_Cin_values	(logic_family_t'POS(logic_family));
	constant nand_gate_ICC 	: real := nand_gate_ICC_values	(logic_family_t'POS(logic_family));	

end PEGates;