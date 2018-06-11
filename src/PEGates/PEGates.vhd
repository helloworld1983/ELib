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
	-- component implemented in tristate_buf.vhd
	component tristate_buf is
		Generic (delay : time :=1 ns;
				 Cpd: real := tristate_buf_Cpd; --power dissipation capacity
				 Cin: real := tristate_buf_Cin; --input capacity
				 Cload: real := 0.0; --load capacity; write 0.0 when load is unknown
				 Icc : real := tristate_buf_ICC -- questient current at room temperature  
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
        Port ( I : in STD_LOGIC_VECTOR (0 to 1);
               A : in STD_LOGIC;
               Y : out STD_LOGIC;
               consumption : out consumption_type := (0.0,0.0));
    end component;
    -- component implemented in mux4_1.vhd
       component mux4_1 is
        Generic (delay : time := 1 ns;
                Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
                Icc : real := 2.0e-6 -- questient current at room temperature  
                );
        Port ( I : in STD_LOGIC_VECTOR (0 to 3);
               A : in STD_LOGIC_VECTOR (0 to 1);
               Y : out STD_LOGIC;
               consumption : out consumption_type := (0.0,0.0));
    end component;
    -- component implemented in num74163.vhd
    component num74163 is
        Generic (delay : time := 1 ns;
                Cpd, Cin, Cload : real := 20.0e-12; --power dissipation, input and load capacityies
                Icc : real := 2.0e-6 -- questient current at room temperature  
                );
        Port ( CLK, CLRN, LOADN, P, T, D ,C ,B ,A : in std_logic;
                 Qd, Qc, Qb, Qa, RCO: out std_logic;
                 consumption : out consumption_type := (0.0,0.0));
    end component;
    
    
end PEGates;

package body PEGates is

end PEGates;
