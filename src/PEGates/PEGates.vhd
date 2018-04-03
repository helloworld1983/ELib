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

library xil_defaultlib;
use xil_defaultlib.PElib.all;

package PEGates is
	-- component implemented in tristate_buf.vhd
	 component tristate_buf is
		Generic (delay : time :=1 ns;
				 parasitic_capacity : real := 1.0e-12;
				 area : real := 1.0e-9);
		Port ( a, en : in STD_LOGIC;
			   y : out STD_LOGIC;
			   consumption: out consumption_type);
	end component;
 -- component implemented in inv_gate.vhd
	component inv_gate is
     Generic (delay : time :=1 ns;
              parasitic_capacity : real := 1.0e-12;
              area : real := 1.0e-9);
     Port ( a : in STD_LOGIC;
            y : out STD_LOGIC;
            consumption : out consumption_type := (0.0,0.0));
	end component;
  -- component implemented in and_gate.vhd
	component and_gate is
    Generic (delay : time := 1 ns;
             parasitic_capacity : real := 1.0e-12;
             area : real := 1.0e-9);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC;
           consumption : out consumption_type := (0.0,0.0));
	end component;
 -- component implemented in and3_gate .vhd
	component and3_gate is
		Generic (delay : time := 1 ns;
				 parasitic_capacity : real := 1.0e-12;
				 area : real := 1.0e-9);
		Port ( a,b,c : in STD_LOGIC;
			   y : out STD_LOGIC;
			   consumption : out consumption_type := (0.0,0.0));
	end component;
 -- component implemented in and4_gate.vhd
	component and4_gate is
		Generic (delay : time := 1 ns;
				parasitic_capacity : real := 1.0e-12;
				area : real := 1.0e-9);
		Port ( a,b,c,d : in STD_LOGIC;
			   y : out STD_LOGIC;
			   consumption : out consumption_type := (0.0,0.0));
	end component;
 -- component implemented in or_gate.vhd	
	component or_gate is
		Generic (delay : time := 1 ns;
				parasitic_capacity : real := 1.0e-12;
				area : real := 1.0e-9);
		Port ( a : in STD_LOGIC;
			   b : in STD_LOGIC;
			   y : out STD_LOGIC;
			   consumption : out consumption_type := (0.0,0.0));
	end component;	
	 -- component implemented in or3_gate.vhd		
	component or3_gate is
		Generic (delay : time := 1 ns;
				 parasitic_capacity : real := 1.0e-12;
				 area : real := 1.0e-9);
		Port ( a,b,c : in STD_LOGIC;
			   y : out STD_LOGIC;
			   consumption : out consumption_type := (0.0,0.0));
	end component;
	 -- component implemented in nand_gate.vhd		
	component nand_gate is
		Generic (delay : time := 1 ns;
				 parasitic_capacity : real := 1.0e-12;
				 area : real := 1.0e-9);
		Port ( a : in STD_LOGIC;
			   b : in STD_LOGIC;
			   y : out STD_LOGIC;
			   consumption : out consumption_type := (0.0,0.0));
	end component;	
	 -- component implemented in nand9_gate.vhd	
	component nand9_gate is
		Generic (delay : time :=1 ns;
				 parasitic_capacity : real := 1.0e-12;
				 area : real := 1.0e-9);
		Port ( x : in STD_LOGIC_VECTOR(8 downto 0);
			   y : out STD_LOGIC;
			   consumption : out consumption_type := (0.0,0.0));
	end component;
	 -- component implemented in nor_gate.vhd	
	component nor_gate is
		Generic (delay : time := 1 ns;
				 parasitic_capacity : real := 1.0e-12;
				 area : real := 1.0e-9);
		Port ( a : in STD_LOGIC;
			   b : in STD_LOGIC;
			   y : out STD_LOGIC;
			   consumption : out consumption_type := (0.0,0.0));
	end component;
	-- component implemented in nor3_gate.vhd	
	component nor3_gate is
		Generic (delay : time := 1 ns;
				 parasitic_capacity : real := 1.0e-12;
				 area : real := 1.0e-9);
		Port ( a,b,c : in STD_LOGIC;
			   y : out STD_LOGIC;
			   consumption: out consumption_type := (0.0,0.0));
	end component;
	-- component implemented in nor_gate.vhd	
	component nor4_gate is
		Generic (delay : time :=1 ns;
		parasitic_capacity : real := 1.0e-12;
		area : real := 1.0e-9);
		Port ( a,b,c,d : in STD_LOGIC;
				y: out STD_LOGIC;
				consumption : out consumption_type := (0.0,0.0));
	end component;	
	-- component implemented in nor_gate.vhd	
	component nor9_gate is
    Generic (delay : time :=1 ns;
             parasitic_capacity : real := 1.0e-12;
             area : real := 1.0e-9);
    Port ( x : in STD_LOGIC_VECTOR(8 downto 0);
           y : out STD_LOGIC;
           consumption : out consumption_type := (0.0,0.0));
	end component;

end PEGates;

package body PEGates is
  
end PEGates;
