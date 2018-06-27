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

library work;
use work.PElib.all;

package PEGates is
	
	-- component implemented in tristate_buf.vhd
	component tristate_buf is
		Generic (delay : time :=1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload: real := 5.0 -- capacitive load
				 );
		Port ( a, en : in STD_LOGIC;
			   y : out STD_LOGIC;
			   -- sim only
			   Vcc : in real; -- supply voltage
		       consumption : out consumption_type := (0.0,0.0)
		       );
	end component;
	-- component implemented in inv_gate.vhd
	component inv_gate is
		Generic (delay : time :=1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
                 gate : component_t; -- the type of the component
				 Cload: real := 5.0 -- capacitive load
				 );
     Port ( a : in STD_LOGIC;
            y : out STD_LOGIC;
            Vcc : in real ; -- supply voltage
		    consumption : out consumption_type := (0.0,0.0)
		    );
	end component;
	-- component implemented in and_gate.vhd
	component xor_gate is
		Generic (delay : time := 1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload : real := 5.0 -- capacitive load
				 );
		Port ( a : in STD_LOGIC;
			   b : in STD_LOGIC;
			   y : out STD_LOGIC;
			   Vcc : in real ; -- supply voltage
		       consumption : out consumption_type := (0.0,0.0)
		       );
	end component;
	-- component implemented in and_gate.vhd
	component and_gate is
		Generic (delay : time := 1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
                 gate : component_t; -- the type of the component
				 Cload : real := 5.0 -- capacitive load 
				 );
		Port ( a : in STD_LOGIC;
			   b : in STD_LOGIC;
			   y : out STD_LOGIC;
			   Vcc : in real ; -- supply voltage
		       consumption : out consumption_type := (0.0,0.0)
		       );
	end component;
	-- component implemented in and3_gate .vhd
	component and3_gate is
		Generic (delay : time := 1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload : real := 5.0 -- capacitive load
             );
		Port ( a,b,c : in STD_LOGIC;
			   y : out STD_LOGIC;
			   Vcc : in real ; -- supply voltage
		       consumption : out consumption_type := (0.0,0.0)
		       );
	end component;
	-- component implemented in and4_gate.vhd
	component and4_gate is
		Generic (delay : time := 1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload : real := 5.0 -- capacitive load 
             );
		Port ( a,b,c,d : in STD_LOGIC;
			   y : out STD_LOGIC;
			   Vcc : in real ; -- supply voltage
		       consumption : out consumption_type := (0.0,0.0)
		       );
	end component;
	-- component implemented in and5_gate.vhd
	component and5_gate is
        Generic (delay : time := 1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload : real := 5.0 -- capacitive load
				 );
        Port ( a,b,c,d,e : in STD_LOGIC;
               y : out STD_LOGIC;
               Vcc : in real ; -- supply voltage
		       consumption : out consumption_type := (0.0,0.0)
		       );
    end component;
 -- component implemented in or_gate.vhd	
	component or_gate is
		Generic (delay : time := 1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload : real := 5.0 -- capacitive load 
             );
		Port ( a : in STD_LOGIC;
			   b : in STD_LOGIC;
			   y : out STD_LOGIC;
			   Vcc : in real ; -- supply voltage
		       consumption : out consumption_type := (0.0,0.0)
		       );
	end component;	
	 -- component implemented in or3_gate.vhd		
	component or3_gate is
		Generic (delay : time := 1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload: real := 5.0 -- capacitive load 
             );
		Port ( a,b,c : in STD_LOGIC;
			   y : out STD_LOGIC;
			   Vcc : in real ; -- supply voltage
		       consumption : out consumption_type := (0.0,0.0)
		       );
	end component;
	-- component implemented in or4_gate.vhd	
    component or4_gate is
        Generic (delay : time :=1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload : real := 5.0 -- capacitive load 
             );
        Port ( a,b,c,d : in STD_LOGIC;
                y: out STD_LOGIC;
                Vcc : in real ; -- supply voltage
		        consumption : out consumption_type := (0.0,0.0)
		        );
    end component;	
	-- component implemented in or9_gate.vhd	
    component or9_gate is
		Generic (delay : time :=1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload : real := 5.0 -- capacitive load 
             );
		Port ( x : in STD_LOGIC_VECTOR(8 downto 0);
			   y : out STD_LOGIC;
			   Vcc : in real ; -- supply voltage
		       consumption : out consumption_type := (0.0,0.0)
		       );
    end component;
    -- component implemented in nand_gate.vhd		
    component nand_gate is
		Generic (delay : time := 1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload : real := 5.0 -- capacitive load  
             );
		Port ( a : in STD_LOGIC;
				 b : in STD_LOGIC;
				 y : out STD_LOGIC;
				 Vcc : in real ; -- supply voltage
		         consumption : out consumption_type := (0.0,0.0)
		         );
    end component;	
	-- component implemented in nand4_gate.vhd
	component nand4_gate is
        Generic (delay : time := 1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload: real := 5.0 -- capacitive load 
             );
        Port ( a,b,c,d : in STD_LOGIC;
               y : out STD_LOGIC;
               Vcc : in real ; 
		       consumption : out consumption_type := (0.0,0.0)
		       );
    end component;
	-- component implemented in nand9_gate.vhd	
	component nand9_gate is
		Generic (delay : time :=1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload: real := 5.0 -- capacitive load 
             );
		Port ( x : in STD_LOGIC_VECTOR(8 downto 0);
			   y : out STD_LOGIC;
			   Vcc : in real ; -- supply voltage
		       consumption : out consumption_type := (0.0,0.0)
		       );
	end component;
	 -- component implemented in nor_gate.vhd	
	component nor_gate is
		Generic (delay : time := 1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload : real := 5.0 -- capacitive load 
				 );
		Port ( a : in STD_LOGIC;
			   b : in STD_LOGIC;
			   y : out STD_LOGIC;
			   Vcc : in real ;-- supply voltage 
		       consumption : out consumption_type := (0.0,0.0)
		       );
	end component;
	-- component implemented in nor3_gate.vhd	
	component nor3_gate is
		Generic (delay : time := 1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload : real := 5.0 -- capacitive load
             );
		Port ( a,b,c : in STD_LOGIC;
			   y : out STD_LOGIC;
			   Vcc : in real ; -- supply voltage
		       consumption : out consumption_type := (0.0,0.0)
		       );
	end component;
	-- component implemented in nor4_gate.vhd	
	component nor4_gate is
		Generic (delay : time :=1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload : real := 5.0 -- capacitive load
             );
		Port ( a,b,c,d : in STD_LOGIC;
				y: out STD_LOGIC;
				Vcc : in real ; -- supply voltage
		        consumption : out consumption_type := (0.0,0.0)
		        );
	end component;
	-- component implemented in nor9_gate.vhd	
	component nor9_gate is
		Generic (delay : time :=1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload : real := 5.0 -- capacitive load 
             );
    Port ( x : in STD_LOGIC_VECTOR(8 downto 0);
           y : out STD_LOGIC;
           Vcc : in real ; -- supply voltage
		   consumption : out consumption_type := (0.0,0.0)
		   );
	end component;
	-- component implemented in nor8_gate.vhd	
	component nor8_gate is
		Generic (delay : time :=1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload : real := 5.0 -- capacitive load 
             );
		Port ( x : in STD_LOGIC_VECTOR(7 downto 0);
			   y : out STD_LOGIC;
			   Vcc : in real ; -- supply voltage
		       consumption : out consumption_type := (0.0,0.0)
		       );
	end component;
	
	-- component implemented in mux2_1.vhd
	component mux2_1 is
        Generic (delay : time := 1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 --gate : component_t; -- the type of the component
				 Cload : real := 5.0 -- capacitive load 
                );
        Port ( I : in STD_LOGIC_VECTOR (1 downto 0);
               A : in STD_LOGIC;
               Y : out STD_LOGIC;
               Vcc : in real ; -- supply voltage
		       consumption : out consumption_type := (0.0,0.0)
		       );
    end component;
    -- component implemented in mux4_1.vhd
    component mux4_1 is
        Generic (delay : time := 1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 --gate : component_t; -- the type of the component
				 Cload: real := 5.0 -- capacitive load 
                );
        Port ( I : in STD_LOGIC_VECTOR (3 downto 0);
               A : in STD_LOGIC_VECTOR (1 downto 0);
               Y : out STD_LOGIC;
               Vcc : in real ; -- supply voltage
		       consumption : out consumption_type := (0.0,0.0)
		       );
    end component;
    -- component implemented in num74163.vhd
    component num74163 is
        Generic (delay : time := 1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload : real := 5.0 -- capacitive load 
                );
        Port ( CLK, CLRN, LOADN, P, T, D ,C ,B ,A : in std_logic;
                 Qd, Qc, Qb, Qa, RCO: out std_logic;
                 Vcc : in real ; -- supply voltage
		         consumption : out consumption_type := (0.0,0.0)
		         );
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


end PEGates;