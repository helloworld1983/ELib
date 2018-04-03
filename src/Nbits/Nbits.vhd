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

library xil_defaultlib;
use xil_defaultlib.PELib.all;
use xil_defaultlib.PEGates.all; 


package Nbits is

    function log2( n:natural ) return integer; 
	-- implementation is in adder_Nbits.vhd
	component adder_Nbits is
		generic (delay: time:= 0 ns;
				width: natural := 8);
		Port ( A : in STD_LOGIC_VECTOR (width-1 downto 0);
			   B : in STD_LOGIC_VECTOR (width-1 downto 0);
			   Cin : in STD_LOGIC;
			   Cout : out STD_LOGIC;
			   S : out STD_LOGIC_VECTOR (width-1 downto 0);
			   consumption : out consumption_type := (0.0,0.0));
	end component;
	-- implementation is in adder_Nbits.vhd
	component counter_Nbits is
		generic (
				delay : time := 0 ns;
				active_edge : boolean := TRUE;
				width : natural := 8);
		Port ( CLK : in STD_LOGIC;
			   Rn : in STD_LOGIC;
			   Q : out STD_LOGIC_VECTOR (width-1 downto 0);
			   consumption : out consumption_type := (0.0,0.0));
	end component;
	-- implementation is in FA.vhd
	component FA is
		Generic (delay : time := 1ns );
		Port ( A : in STD_LOGIC;
			   B : in STD_LOGIC;
			   Cin : in STD_LOGIC;
			   Cout : out STD_LOGIC;
			   S : out STD_LOGIC;
			   consumption : out consumption_type := (0.0,0.0));
	end component;
	-- implementation is in DFF.vhd
	component dff is
        Generic ( active_edge : boolean := true;
                delay : time := 1 ns);
        Port ( D : in STD_LOGIC;
               Ck : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q, Qn : out STD_LOGIC;
               consumption : out consumption_type := (0.0,0.0));
    end component;
	-- implementation is in latchD.vhd
	component latchD is
	 Generic ( delay : time := 1 ns);
	   Port ( D : in STD_LOGIC;
			  Ck : in STD_LOGIC;
			  Rn : in STD_LOGIC;
			  Q, Qn : inout STD_LOGIC;
			  consumption : out consumption_type := (0.0,0.0));
	end component;
	-- implementation is in latchSR.vhd	
	component latchSR is
		Generic(delay : time := 1 ns);
		Port ( S : in STD_LOGIC;
			   R : in STD_LOGIC;
			   Q, Qn : inout STD_LOGIC;
			   consumption : out consumption_type := (0.0,0.0));
	end component;
	-- implementation is in pe_Nbits.vhd	
	component pe_Nbits is
		Generic ( N: natural := 4;
				   delay : time := 0 ns);
		Port ( bi : in STD_LOGIC_VECTOR (N-1 downto 0);
			   bo : out STD_LOGIC_VECTOR (log2(N)-1 downto 0);
			   consumption : out consumption_type := (0.0,0.0));
	end component;
	-- implementation is in reg_Nbits.vhd
	component reg_Nbits is
		Generic ( delay: time := 0 ns;
					 width: natural := 8);
		Port ( D : in STD_LOGIC_VECTOR (width-1 downto 0);
			   Ck : in STD_LOGIC;
			   Rn : in STD_LOGIC;
			   Q : out STD_LOGIC_VECTOR (width-1 downto 0);
			   Qn : out STD_LOGIC_VECTOR (width-1 downto 0);
			   consumption : out consumption_type := (0.0,0.0));
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