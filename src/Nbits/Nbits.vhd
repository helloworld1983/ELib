----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description: - utility functions, utility components configurable size components with power estimation
--              - implements the log2 function used to compute the number of bits to represent a value
--              - defines components with power monitoring function
-- Dependencies: adder_Nbits.vhd, 
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.PELib.all;
use work.PEGates.all; 


package Nbits is

    function log2( n:natural ) return integer; 
    
	-- implementation is in adder_Nbits.vhd
	component adder_Nbits is
		generic (delay: time:= 0 ns;
				width: natural := 8;
				logic_family : logic_family_t; -- the logic family of the component
                gate : component_t; -- the type of the component
                Cload: real := 5.0 -- capacitive load
                );
		Port ( A : in STD_LOGIC_VECTOR (width-1 downto 0);
			   B : in STD_LOGIC_VECTOR (width-1 downto 0);
			   Cin : in STD_LOGIC;
			   Cout : out STD_LOGIC;
			   S : out STD_LOGIC_VECTOR (width-1 downto 0);
			   Vcc : in real ; --supply voltage
			   consumption : out consumption_type := (0.0,0.0)
			   );
	end component;
	
	-- implementation is in counter_Nbits.vhd
	component counter_Nbits is
		generic (
				delay : time := 0 ns;
				active_edge : boolean := TRUE;
				width : natural := 8;
				logic_family : logic_family_t; -- the logic family of the component
                gate : component_t; -- the type of the component
                Cload: real := 5.0 -- capacitive load
                );
		Port ( CLK : in STD_LOGIC;
			   Rn : in STD_LOGIC;
			   Q : out STD_LOGIC_VECTOR (width-1 downto 0);
			   Vcc : in real ; --supply voltage
			   consumption : out consumption_type := (0.0,0.0)
			   );
	end component;
	
	-- implementation is in FA.vhd
	component FA is
		Generic (delay : time := 1 ns;
		         logic_family : logic_family_t; -- the logic family of the component
                 gate : component_t; -- the type of the component
                 Cload: real := 5.0 -- capacitive load
                 );
		Port ( A : in STD_LOGIC;
			   B : in STD_LOGIC;
			   Cin : in STD_LOGIC;
			   Cout : out STD_LOGIC;
			   S : out STD_LOGIC;
			   Vcc : in real ; --supply voltage
			   consumption : out consumption_type := (0.0,0.0)
			   );
	end component;
	
	-- implementation is in dff_Nbits.vhd
	component dff_Nbits is
        Generic (   active_edge : boolean := TRUE;
                    delay : time := 1 ns;
                    logic_family : logic_family_t; -- the logic family of the component
                    gate : component_t; -- the type of the component
                    Cload: real := 5.0 -- capacitive load
                    );
            Port ( D : in STD_LOGIC;
                   Ck : in STD_LOGIC;
                   Rn : in STD_LOGIC;
                   Q, Qn : out STD_LOGIC;
                   Vcc : in real ; --supply voltage
                   consumption : out consumption_type := (0.0,0.0)
                   );
    end component;
    
	-- implementation is in latchD.vhd
	component latchD is
	 Generic ( delay : time := 1 ns;
	           logic_family : logic_family_t; -- the logic family of the component
               gate : component_t; -- the type of the component
               Cload: real := 5.0 -- capacitive load
               );
	   Port ( D : in STD_LOGIC;
			  Ck : in STD_LOGIC;
			  Rn : in STD_LOGIC;
			  Q, Qn : inout STD_LOGIC;
			  Vcc : in real ; --supply voltage
			  consumption : out consumption_type := (0.0,0.0)
			  );
	end component;
	
	-- implementation is in latchSR.vhd	
	component latchSR is
		Generic(delay : time := 1 ns;
		        logic_family : logic_family_t; -- the logic family of the component
                gate : component_t; -- the type of the component
                Cload: real := 5.0 -- capacitive load
		        );
		Port ( S : in STD_LOGIC;
			   R : in STD_LOGIC;
			   Q, Qn : inout STD_LOGIC;
			   Vcc : in real ; --supply voltage
			   consumption : out consumption_type := (0.0,0.0)
			   );
	end component;
	
	-- implementation is in pe_Nbits.vhd	
	component pe_Nbits is
		Generic ( N: natural := 4;
				   delay : time := 0 ns;
				   logic_family : logic_family_t; -- the logic family of the component
                   gate : component_t; -- the type of the component
                   Cload: real := 5.0 -- capacitive load
                   );
		Port (  ei : in std_logic;
              		bi : in STD_LOGIC_VECTOR (N-1 downto 0);
             		 bo : out STD_LOGIC_VECTOR (log2(N)-1 downto 0);
              		eo : out std_logic;
              		gs : out std_logic;
              		Vcc : in real ; --supply voltage
              		consumption : out consumption_type := (0.0,0.0)
              		);
	end component;
	
	-- implementation is in reg_Nbits.vhd
	component reg_Nbits is
		Generic ( delay: time := 0 ns;
			      width: natural := 8;
				  logic_family : logic_family_t; -- the logic family of the component
                  gate : component_t; -- the type of the component
                  Cload: real := 5.0 -- capacitive load
                  );
		Port ( D : in STD_LOGIC_VECTOR (width-1 downto 0);
			   Ck : in STD_LOGIC;
			   Rn : in STD_LOGIC;
			   Q : out STD_LOGIC_VECTOR (width-1 downto 0);
			   Qn : out STD_LOGIC_VECTOR (width-1 downto 0);
			   Vcc : in real ; --supply voltage
			   consumption : out consumption_type := (0.0,0.0)
			   );
	end component;		 
	
		
	-- component implemented in mux2_1.vhd
	component mux2_1 is
        Generic (delay : time := 1 ns;
				 logic_family : logic_family_t; -- the logic family of the component
				 gate : component_t; -- the type of the component
				 Cload : real := 0.0 -- capacitive load 
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
				 gate : component_t; -- the type of the component
				 Cload : real := 0.0 -- capacitive load 
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
				 Cload : real := 0.0 -- capacitive load 
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
                 logic_family : logic_family_t; -- the logic family of the component
                 gate : component_t; -- the type of the component
                 Cload : real := 0.0; -- capacitive load   
                 active_edge : std_logic := '0'
                );
        Port ( CP, D, Rdn, SDn : in STD_LOGIC;
               Q, Qn : out STD_LOGIC;
               Vcc : in real ; --supply voltage
               consumption : out consumption_type := (0.0,0.0)
              );
    end component;    
	
end package;

package body Nbits is

    function log2 (n : natural) return integer is
      
      variable m, p : integer;
      begin
       m := 0;
       p := 1;
       for i in 0 to n loop
          if p < n then
            m := m + 1;
            p := p * 2;
          end if;
       end loop;
      return m;
  
  end log2;

end package body;