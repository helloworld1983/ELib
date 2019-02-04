----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia, Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description: - Nbits package
--              - implements the log2 function used to compute the number of bits to represent an integer value
--              - defines higher function components (counters, registers, adder, multiplier) with power monitoring function
-- Dependencies: PECore.vhd, PEGates.vhd, Nbits.vhd
-- 
-- Revision: 0.04  - enabling elaboration of Nbits components by added pragma synthesis_off/on for 
-- Revision: 0.03  - adding behavioral descirption to dff component 
-- Revision: 0.02 - merging files FA.vhd, Adder_Nbits.vhd, LatchSR.vhd, LatchD.vhd, DFF_Nbuts.vhd, dff.vhd, reg_NBits.vhd,
--					counter_Nbits.vhd, pr_encoder_2bit.vhd, pr_encoder_4bit.vhd, pr_encoder_8bit.vhd, pr_encoder_16bit.vhd,
--					pr_encoder_32bit.vhd, pr_encoder_64bit.vhd, pe_Nbits.vhd
-- Revision: 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.PECore.all;
use work.PEGates.all; 


package Nbits is

    function log2( n:natural ) return integer; 
---------------------------------------------------------------------------------------   
	component FA is
		Generic (delay : time := 1 ns;
		         logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                 Cload : real := 0.0 -- capacitive load
                 );
		Port ( -- pragma synthesis_off
				Vcc : in real ; --supply voltage
				estimation : out estimation_type := est_zero;
				-- pragma synthesis_on
				A : in STD_LOGIC;
				B : in STD_LOGIC;
				Cin : in STD_LOGIC;
				Cout : out STD_LOGIC;
				S : out STD_LOGIC
			   );
	end component;
---------------------------------------------------------------------------------------   
	component adder_Nbits is
		Generic (delay: time:= 0 ns;
				width: natural := 8;
				logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                Cload : real := 0.0 -- capacitive load
                );
		Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero  ;        
               -- pragma synthesis_on
               A : in STD_LOGIC_VECTOR (width-1 downto 0);
			   B : in STD_LOGIC_VECTOR (width-1 downto 0);
			   Cin : in STD_LOGIC;
			   Cout : out STD_LOGIC;
			   S : out STD_LOGIC_VECTOR (width-1 downto 0)
			   );
	end component;
---------------------------------------------------------------------------------------   
	component latchSR is
		Generic (delay : time := 1 ns;
		         logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                 Cload : real := 0.0 -- capacitive load
		         );
		Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero;
               -- pragma synthesis_on
               S : in STD_LOGIC;
			   R : in STD_LOGIC;
			   Q, Qn : inout STD_LOGIC
			   );
	end component;	
---------------------------------------------------------------------------------------   
	component latchD is
		Generic ( delay : time := 1 ns;
	           logic_family : logic_family_t := default_logic_family; -- the logic family of the component
               Cload : real := 0.0; -- capacitive load
			   clock_polarity : std_logic := '1'
               );
		Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero;
               -- pragma synthesis_on
               D : in STD_LOGIC;
               Ck : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q, Qn : inout STD_LOGIC
               );
	end component;
---------------------------------------------------------------------------------------   
	component dff_Nbits is
        Generic (   active_edge : boolean := TRUE;
                    delay : time := 1 ns;
                    logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                    Cload : real := 0.0 -- capacitive load
                    );
		Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero ;         -- pragma synthesis_on
               D : in STD_LOGIC;
               Ck : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q, Qn : out STD_LOGIC
               );
    end component;
---------------------------------------------------------------------------------------      
	component tff is
        Generic (   active_edge : boolean := TRUE;
					delay : time := 1 ns;
                    logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                    Cload : real := 0.0 -- capacitive load
                    );
            Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero; 
               -- pragma synthesis_on
               T : in STD_LOGIC;
               Ck, Rn : in STD_LOGIC;
               Q, Qn : out STD_LOGIC
               );
    end component;
---------------------------------------------------------------------------------------   
    component dff is
		Generic (delay : time := 1 ns;
                 logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                 Cload : real := 0.0 -- capacitive load   
                );
        Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
              estimation : out estimation_type := est_zero; 
               -- pragma synthesis_on
               CP, D, Rdn, SDn : in STD_LOGIC;
               Q, Qn : out STD_LOGIC
              );
    end component;   
---------------------------------------------------------------------------------------   
	component reg_Nbits is
		Generic ( delay: time := 0 ns;
			      width: natural := 8;
				  logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                  Cload : real := 0.0 -- capacitive load
                  );
		Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero;
               --pragma synthesis_on
               D : in STD_LOGIC_VECTOR (width-1 downto 0);
			   Ck : in STD_LOGIC;
			   Rn : in STD_LOGIC;
			   Q : out STD_LOGIC_VECTOR (width-1 downto 0);
			   Qn : out STD_LOGIC_VECTOR (width-1 downto 0)
			   );
	end component;	
---------------------------------------------------------------------------------------   
	component counter_Nbits is
		generic (
				delay : time := 0 ns;
				active_edge : boolean := TRUE;
				width : natural := 8;
				logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                Cload : real := 0.0 -- capacitive load
                );
		Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero; 
               -- pragma synthesis_on
               CLK : in STD_LOGIC;
			   Rn : in STD_LOGIC;
			   Q : out STD_LOGIC_VECTOR (width-1 downto 0)
			   );
	end component;
---------------------------------------------------------------------------------------
	component counter_we_Nbits is
		generic (
				delay : time := 0 ns;
				active_edge : boolean := TRUE;
				width : natural := 8;
				logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                Cload : real := 0.0 -- capacitive load
                );
		Port (-- pragma synthesis_off
               Vcc : in real ; --supply voltage
              estimation : out estimation_type := est_zero; 
               -- pragma synthesis_on
                CLK : in STD_LOGIC;
			   Rn, En : in STD_LOGIC;
			   Q : out STD_LOGIC_VECTOR (width-1 downto 0)
			   );
	end component;
---------------------------------------------------------------------------------------   
	component mux2_1 is
        Generic (delay : time := 1 ns;
				 logic_family : logic_family_t := default_logic_family; -- the logic family of the component
				 Cload : real := 0.0 -- capacitive load 
                );
        Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero; 
               -- pragma synthesis_on
               I : in STD_LOGIC_VECTOR (1 downto 0);
               A : in STD_LOGIC;
               Y : out STD_LOGIC
		       );
    end component;
---------------------------------------------------------------------------------------   
    component mux4_1 is
        Generic (delay : time := 1 ns;
				 logic_family : logic_family_t := default_logic_family; -- the logic family of the component
				 Cload : real := 0.0 -- capacitive load 
                );
        Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero; 
               -- pragma synthesis_on
               I : in STD_LOGIC_VECTOR (3 downto 0);
               A : in STD_LOGIC_VECTOR (1 downto 0);
               Y : out STD_LOGIC
		       );
    end component;
 ---------------------------------------------------------------------------------------   
   component num74163 is
        Generic (delay : time := 1 ns;
				 logic_family : logic_family_t := default_logic_family; -- the logic family of the component
				 Cload : real := 0.0 -- capacitive load 
                );
        Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero; 
               -- pragma synthesis_on
               CLK, CLRN, LOADN, P, T, D ,C ,B ,A : in std_logic;
               Qd, Qc, Qb, Qa, RCO: out std_logic
		         );
    end component;
---------------------------------------------------------------------------------------   
	component pr_encoder_2bit is
    Generic (logic_family : logic_family_t := default_logic_family; -- the logic family of the component
             Cload : real := 0.0 -- capacitive load
              );
        Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero; 
               -- pragma synthesis_on
               ei : in STD_LOGIC;
               bi : in STD_LOGIC_VECTOR(1 downto 0);
               bo : out STD_LOGIC;
               eo, gs : out STD_LOGIC
               );
	end component;
---------------------------------------------------------------------------------------   
	component pr_encoder_4bit is
    Generic (logic_family : logic_family_t := default_logic_family; -- the logic family of the component
             Cload : real := 0.0 -- capacitive load
              );
        Port (  -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero; 
               -- pragma synthesis_on
               ei : in STD_LOGIC;
               bi : in STD_LOGIC_VECTOR(3 downto 0);
               bo : out STD_LOGIC_VECTOR(1 downto 0);
               eo,gs : out STD_LOGIC
               );
	end component;
---------------------------------------------------------------------------------------   
	component pr_encoder_8bit is
        Generic (logic_family : logic_family_t := default_logic_family; -- the logic family of the component
             Cload : real := 0.0 -- capacitive load
              );
        Port (  -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero; 
               -- pragma synthesis_on
               I : in STD_LOGIC_VECTOR(7 DOWNTO 0);
               EI: in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(2 DOWNTO 0);
               GS,EO : out STD_LOGIC
               );
	end component;
---------------------------------------------------------------------------------------   
	component pr_encoder_16bit is
        Generic (logic_family : logic_family_t := default_logic_family; -- the logic family of the component
             Cload : real := 0.0 -- capacitive load
              );
        Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero; 
               -- pragma synthesis_on
              I : in STD_LOGIC_VECTOR(15 DOWNTO 0);
              EI: in STD_LOGIC;
              Y : out STD_LOGIC_VECTOR(3 DOWNTO 0);
              GS,EO : out STD_LOGIC
              );
	end component;
---------------------------------------------------------------------------------------   
	component pr_encoder_32bit is
     Generic (logic_family : logic_family_t := default_logic_family; -- the logic family of the component
             Cload : real := 0.0 -- capacitive load
              );
     Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero;
               -- pragma synthesis_on
              I: in STD_LOGIC_VECTOR(31 DOWNTO 0);
              EI: in STD_LOGIC;
              Y : out STD_LOGIC_VECTOR(4 DOWNTO 0);
              GS,EO : out STD_LOGIC);
	end component;
---------------------------------------------------------------------------------------   
	component pr_encoder_64bit is
        Generic (logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                 Cload : real := 0.0 -- capacitive load
                  );
          Port (-- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero;
               -- pragma synthesis_on
                I: in STD_LOGIC_VECTOR(63 DOWNTO 0);
               EI: in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(5 DOWNTO 0);
               GS,EO : out STD_LOGIC
               );
	end component;
---------------------------------------------------------------------------------------  
	component pe_Nbits is
		Generic ( N: natural := 4;
				   delay : time := 0 ns;
				   logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                   Cload : real := 0.0 -- capacitive load
                   );
		Port (  -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero;
               -- pragma synthesis_on
                ei : in std_logic;        
                bi : in STD_LOGIC_VECTOR (N-1 downto 0);
                bo : out STD_LOGIC_VECTOR (log2(N)-1 downto 0);
               eo : out std_logic;
               gs : out std_logic
               );
	end component;
---------------------------------------------------------------------------------------
    component multip is 
        generic (width:integer:=32 ;
                 delay : time := 0 ns ;
                 logic_family : logic_family_t := default_logic_family ; -- the logic family of the component
                 Cload : real := 0.0 -- capacitive load
                 );	
        port (-- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero;
               -- pragma synthesis_on
              ma,mb : in std_logic_vector (width-1 downto 0); --4/8/16/32
              clk, rst : in std_logic;
              mp : out std_logic_vector (2*width-1 downto 0);--8/16/32/64
              done : out std_logic
              );
    end component;
--------------------------------------------------------------------------------------
    component cmp_cell is
         Generic (delay : time := 0 ns;
                logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                Cload: real := 5.0 ; -- capacitive load
                Area: real := 0.0 --parameter area 
                 );
        Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero;
               -- pragma synthesis_on
               x : in STD_LOGIC;
               y : in STD_LOGIC;
               EQI : in STD_LOGIC;
               EQO : out STD_LOGIC
               );
    end component;
--------------------------------------------------------------------------------------
    component comparator is
        Generic ( width: integer :=4 ; 
                delay : time := 1 ns;
                logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                Cload: real := 5.0 ; -- capacitive load
                Area: real := 0.0 --parameter area 
                 );
        Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero;
               -- pragma synthesis_on
               x : in STD_LOGIC_VECTOR (width-1 downto 0);
               y : in STD_LOGIC_VECTOR (width-1 downto 0);
               EQO : out STD_LOGIC;
               EQI : in STD_LOGIC
               );
    end component;

---------------------------------------------------------------------------------------
    component reg_bidirectional is
        Generic ( width: integer :=4 ; 
                delay : time := 1 ns;
                logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                Cload: real := 5.0 ; -- capacitive load
                Area: real := 0.0 --parameter area 
                 );
        Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero;
               -- pragma synthesis_on
               Input : in STD_LOGIC_VECTOR (width-1 downto 0);
               Clear : in STD_LOGIC;
               CK : in STD_LOGIC;
               S1,S0 : in STD_LOGIC;
               SR, SL : in STD_LOGIC;
               A : out STD_LOGIC_VECTOR (width-1 downto 0)
               );
    end component;
-----------------------------------------------------------------------------------------
--component FSM is
--    Generic ( 
--            logic_family : logic_family_t; -- the logic family of the component
--            Cload: real := 5.0 ; -- capacitive load
--            width : integer := 1;
--			M : natural := 1;
--			S : natural := 1;
--			STT : table ;
--			OET : table 
--             );
--    Port ( bi : in STD_LOGIC_VECTOR (width-1 downto 0);
--           bo : out STD_LOGIC_VECTOR (width-1 downto 0);
--           clk : in STD_LOGIC;
--           Vcc : in real ; -- supply voltage
--           estimation : out estimation_type := est_zero
--           );
--end component;

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

----------------------------------------------------------------------------------
-- Description: Full adder with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs:   A, B - data bit
--                          Cin - input carry
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outputs : S - sum of A and B
--                          Cout - carry out
--                          estimation :  port to monitor power/area estimation
-- Dependencies: PECore.vhd, PEGates.vhd
------------------------------------------------------------estimation

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PEGates.all; 
use work.PECore.all;

entity FA is
        Generic (delay : time := 1 ns;
		         logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                 Cload : real := 0.0 -- capacitive load
                 );
		Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero;
               -- pragma synthesis_on
               A : in STD_LOGIC;
			   B : in STD_LOGIC;
			   Cin : in STD_LOGIC;
			   Cout : out STD_LOGIC;
			   S : out STD_LOGIC
			   );
end FA;

architecture Structural_with_nand_gates of FA is

    signal net: STD_LOGIC_VECTOR(0 to 6);
    -- pragma synthesis_off
    signal estim : estimation_type_array(1 to 9); 
    -- pragma synthesis_on
begin
    
    gate1: nand_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(1),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => A, b=> B, y => net(0));
    gate2: nand_gate generic map  (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(2),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => A, b=> net(0), y => net(1));
    gate3: nand_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(3),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => net(0), b=> B, y => net(2));
    gate4: nand_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(4),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => net(1), b=> net(2), y => net(3));
    gate5: nand_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(5),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => net(3), b=> Cin, y => net(4));
    gate6: nand_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(6),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => net(3), b=> net(4), y => net(5));
   gate7: nand_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(7),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => net(4), b=> Cin, y => net(6));
    gate8: nand_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(8),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => net(4), b=> net(0), y => Cout);
    gate9: nand_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(9),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => net(5), b=> net(6), y => S);

    --+ sumestimationsumptions
    -- pragma synthesis_off
	sum_up_i : sum_up generic map (N => 9) port map (estim => estim, estimation => estimation);
    -- pragma synthesis_on
end Structural_with_nand_gates;

------------------------------------------------------
-- Description: N bit adder with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--                          	width - the width of the number to be added
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs :  A, B - N bit operands
--                          Cin - Carry input
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outpus :  S - sum of A and B
--                          Cout - Carry out
--                          estimation :  port to monitor power/area estimation
-- Dependencies: PECore.vhd, PEGates.vhd, Nbits.vhd
------------------------------------------------------------estimation

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all; 
use work.Nbits.all;

entity adder_Nbits is
    generic (   delay: time:= 0 ns;
				width: natural := 8;
				logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                Cload : real := 0.0 -- capacitive load
                );
		Port ( -- pragma synthesis_off
		       Vcc : in real ; --supply voltage
			   estimation : out estimation_type := est_zero;
			   -- pragma synthesis_on
			   A : in STD_LOGIC_VECTOR (width-1 downto 0);
			   B : in STD_LOGIC_VECTOR (width-1 downto 0);
			   Cin : in STD_LOGIC;
			   Cout : out STD_LOGIC;
			   S : out STD_LOGIC_VECTOR (width-1 downto 0)			   
			   );
end adder_Nbits;

architecture Behavioral of adder_Nbits is

    signal Cint: STD_LOGIC_VECTOR(0 to width);
    -- pragma synthesis_off
    signal estim : estimation_type_array(1 to width);
     -- pragma synthesis_on
begin

    Cint(0) <= Cin;
    GEN_FA : for i in 0 to width-1 generate
        FAi: FA  generic map (delay => 0 ns, logic_family => logic_family) port map (
            -- pragma synthesis_off
            Vcc => Vcc, estimation => estim(i+1), 
            -- pragma synthesis_on
            A => A(i), B => B(i), Cin => Cint(i), Cout => Cint(i+1), S => S(i));
        end generate GEN_FA;    
    Cout <= Cint(width);
    
    --+ summing up consumption
    -- pragma synthesis_off
	sum_up_i : sum_up generic map ( N => width) port map (estim => estim, estimation => estimation);
    -- pragma synthesis_on
  
end Behavioral;

--------------------------------------------------------------------
--Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description: SR type latch with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs:   S - set, active logic '0'
--                          R - reset, active logic '0' 
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outputs : Q, Qn - 
--                          estimation :  port to monitor power/area estimation
-- Dependencies: PECore.vhd, PEGates.vhd
-----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PEGates.all; 
use work.PECore.all;

entity latchSR is
Generic(delay : time := 1 ns;
		        logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                Cload : real := 0.0 -- capacitive load
		        );
		Port ( -- pragma synthesis_off
			   Vcc : in real ; --supply voltage
			   estimation : out estimation_type := est_zero;
			   -- pragma synthesis_on
			   S : in STD_LOGIC;
			   R : in STD_LOGIC;
			   Q, Qn : inout STD_LOGIC
			      );
end entity;

architecture Strcutural of latchSR is
    -- pragma synthesis_off
    signal estim : estimation_type_array(1 to 2);
    -- pragma synthesis_on
begin

    nand_gate1_1 : nand_gate generic map (delay => delay, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(1),
        Vcc => Vcc,
        -- pragma synthesis_on
         a => Qn, b => S, y => Q);
    nand_gate1_2 : nand_gate generic map (delay => 0.1 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(2),
        Vcc => Vcc,
        -- pragma synthesis_on
         a => Q, b => r, y => Qn);
    
    --+ summing up consumptions
    -- pragma synthesis_off
	sum_up_i : sum_up generic map (N => 2) port map (estim => estim, estimation => estimation);
    -- pragma synthesis_on
end Strcutural;

---------------------------------------------------------------------------estimation Desestimation type latch with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--								clock_polarity - if '0' then CK is active low, if '1' then CK is active high
--              - inputs:   D - data bit
--                          Ck - clock, active '1' high
--                          Rn - reset, active '0' low
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outputs : Q, Qn - a nand b
--                          estimation :  port to monitor power/area estimation
-- Dependencies: PECore.vhd, PEGates.vhd, Nbits.vhd
-----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all; 
use work.Nbits.all;

entity latchD is
        Generic ( delay : time := 1 ns;
	           logic_family : logic_family_t := default_logic_family; -- the logic family of the component
               Cload : real := 0.0; -- capacitive load
               clock_polarity : std_logic := '1'
			   );
	    Port ( -- pragma synthesis_off
			  Vcc : in real ; --supply voltage
			  estimation : out estimation_type := est_zero;
			  -- pragma synthesis_on
			  D : in STD_LOGIC;
			  Ck : in STD_LOGIC;
			  Rn : in STD_LOGIC;
			  Q, Qn : inout STD_LOGIC
			  );
end latchD;

architecture Structural of latchD is

     signal net: STD_LOGIC_VECTOR (1 to 4);
     -- pragma synthesis_off
     signal estim : estimation_type_array(1 to 4);
     -- pragma synthesis_oN
begin

    gate1: nand_gate generic map (delay => delay, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(1),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => D, b =>Ck, y => net(1));
    gate2: nand_gate generic map (delay => delay, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(2),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => net(1), b => Ck, y => net(2));
    gate3: and_gate  generic map (delay => delay, logic_family =>  logic_family) 
    port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(3),
        -- pragma synthesis_on
        a => Rn, b => net(2), y => net(3));
    latch4: latchSR generic map (delay => delay, logic_family => logic_family)
     port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(4),
        -- pragma synthesis_on
        S=>net(1), R=>net(3), Q=>Q, Qn=>Qn );
    
    --+ consumption monitoring
   -- pragma synthesis_off
   sum : sum_up generic map (N => 4) port map (estim => estim, estimation => estimation);
    -- pragma synthesis_on
end Structural;

architecture Behavioral of latchD is

     signal internal: STD_LOGIC;

begin

    process (Ck, Rn, D)
	begin
		if Rn = '0'  then internal <= '0';
		elsif Ck = clock_polarity then internal  <= D;
		end if;
	end process;
	Q <= internal after delay;
	Qn <= not internal after delay;
    --+ consumption monitoring
	-- pragma synthesis_off
	cm_i : PAEstimator generic map ( N=>3, M=>2, logic_family => logic_family, gate => dff_rising_edge, Cload => Cload) port map (sin(0) => Ck, sin(1) => D, sin(2) => Rn, sout(0) => internal, sout(1) => internal, estimation => estimation);
	-- pragma synthesis_on

end Behavioral;

----------------------------------------------------------------------------------
-- Descriptestimation fliestimation activity monitoring and Reset
--				- behavioral and structural descriptions, use structural description for consumption estimation
--              - parameters :  delay - simulated delay time of an elementary gate
--                              active_edge - configure DFF to estimationn positive or negative edge of clock
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs:   D - data bit
--                          Ck - clock, active edge selected by active_edge parameter
--							Rn - reset, active on logic '0'
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outputs : Q, Qn - a nand b
--                          estimation :  port to monitor power/area estimation
-- Dependencies: PECore.vhd, PeGates.vhd, Nbits.vhd
-----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity dff_Nbits is
    Generic (   active_edge : boolean := TRUE;
                delay : time := 1 ns;
                logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                Cload : real := 0.0 -- capacitive load
                );
        Port ( --pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero;
                --pragma synthesis_on
               D : in STD_LOGIC;
               Ck : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q, Qn : out STD_LOGIC
               );
end dff_Nbits;

architecture Behavioral of dff_Nbits is

    signal Qint: STD_LOGIC := '0';
    signal en1, en2: natural;
begin

    rising_active: if active_edge generate
        process(Rn, Ck)
          begin
               if Rn = '0' then
                    Qint <= '0';
                else
                    if rising_edge(Ck) then 
                        Qint <= D;
                    end if;
            end if;
          end process;
    end generate rising_active;

    falling_active: if not active_edge generate
        process(Rn, Ck)
          begin
                if Rn = '0' then
                    Qint <= '0';
                else
                    if falling_edge(Ck) then 
                        Qint <= D;
                    end if;
                end if;
          end process;
     end generate falling_active;
      
    Q <= Qint after delay;
    Qn <= not Qint after delay;
    -- pragma synthesis_off
    estimation <= est_zero;
    -- pragma synthesis_on
end Behavioral;

architecture Structural of dff_Nbits is
   
    signal net: STD_LOGIC_VECTOR (2 to 4);
    signal Ckn,Cknn: std_logic;
    -- pragma synthesis_off
    signal estim : estimation_type_array(1 to 4) := (others => est_zero);
    -- pragma synthesis_on
begin

    falling_active: if (not active_edge) generate
        inversor1: inv_gate generic map (delay =>  0 ns, logic_family => logic_family ) port map (
        -- pragma synthesis_off
        estimation => estim(1), Vcc => Vcc,
        -- pragma synthesis_on
        a => Ck, y => Ckn);
    end generate falling_active ;
    
    rising_active: if (active_edge) generate
         -- pragma synthesis_off
	     estim(1) <= est_zero;
	     -- pragma synthesis_on
         Ckn <= Ck;  
    end generate rising_active;
    
    inversor2: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(4),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => Ckn, y => Cknn);
    master: latchD generic map (delay => delay, logic_family => logic_family)   port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(2), 
        -- pragma synthesis_on
            D => D, Ck => Cknn, Rn => Rn, Q => net(2)); 
    slave : latchD generic map (delay => delay, logic_family => logic_family)
        port map (
            -- pragma synthesis_off
            Vcc => Vcc, estimation => estim(3),
            -- pragma synthesis_on
            D => net(2), Ck => Ckn, Rn => Rn, Q => net(3), Qn => net(4));        
     
    Q <= net(3);
    Qn <= net(4);
    
    -- pragma synthesis_off
    sum : sum_up generic map (N => 4) port map (estim => estim, estimation => estimation);
    -- pragma synthesis_on
end Structural;
---------------------------------------------------------------------------------
------------------------------------------------------------
-- Description: T type flip flop with activity monitoring
--				- behavioral and structural descriptions, use structural description for consumption estimation
--              - parameters :  delay - simulated delay time of an elementary gate
--								logic_family - the logic family of the tristate buffer
--								Cestimation capacitance
--              - inputs:   T - data bit
--                          Ck - clock, active edge selected by active_edge parameter
--							
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outputs : Q, Qn - a nand b
--                          estimation :  port to monitor power/area estimation
-- Dependencies: PECore.vhd, PeGates.vhd, Nbits.vhd
-----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity tff is
    Generic (   active_edge : boolean:=true;
                delay : time := 1 ns;
                logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                Cload : real := 0.0 -- capacitive load
                );
        Port ( -- pragma synthesis_off
               Vcc : in real ; --supply voltage
               estimation : out estimation_type := est_zero;
               -- pragma synthesis_on
               T : in STD_LOGIC;
               Ck, Rn : in STD_LOGIC;
               Q, Qn : out STD_LOGIC
               );
End tff;

architecture Structural of tff is
   
    signal net: STD_LOGIC_VECTOR (1 to 2);
    -- pragma synthesis_off
    signal estim : estimation_type_array(1 to 2);
    -- pragma synthesis_on

begin
 gate1: dff_Nbits generic map (active_edge => true, delay => 0 ns) port map (
    -- pragma synthesis_off
    Vcc=> Vcc, estimation => estim(1), 
    -- pragma synthesis_on
    D => net(1), Ck => Ck, Rn => Rn, Q =>net(2), Qn => open);
 gate2: xor_gate generic map (delay => 0 ns) port map (
    -- pragma synthesis_off
      Vcc => Vcc, estimation => estim(2), 
    -- pragma synthesis_on
    a => T, b =>net(2), y => net(1));  
 Q<= net(2); 
     
    -- pragma synthesis_oFF
    sum : sum_up generic map (N => 2) port map (estim => estim, estimation => estimation);
    -- pragma synthesis_on
end Structural;

----------------------------------------------------------------------------------
-- Description: D type flip flop wiestimation monestimationt and Reset  
--              - parameters :  delay - simulated delay time of an elementary gate
--                              active_edge - configure DFF to be active on positive or negative edge of clock
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs:   D - data bit
--                          CP - clock, active edge selected by active_edge parameter
--                          RDn - Reset, active logic '0'
--                          SDn - Set, active logic '0'
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outputs : Q, Qn - a nand b
--                          estimation :  port to monitor power/area estimation
-- Dependencies: PECore.vhd, PeGates.vhd, Nbits.vhd
---------------------------------------------------------------------------------estimationIEEE;
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;

LIBRARY work;
use work.PECore.all;
use work.PEGates.all;

entity dff is
	Generic (delay : time := 1 ns;
	         logic_family : logic_family_t := default_logic_family; -- the logic family of the component
			 Cload : real := 0.0 -- capacitive load    
			);
    Port ( --pragma synthesis_off
           Vcc : in real ; --supply voltage
		   estimation : out estimation_type := est_zero;
		   --pragma synthesis_on
		   CP, D, Rdn, SDn : in STD_LOGIC;
		   Q, Qn : out STD_LOGIC
		  );
end entity;


architecture Structural of dff is

	signal RD, SD, Dn, Dnn: std_logic;
	signal C, Cn : std_logic;
	signal t1, t2 : std_logic;
	signal nor1, nor2, nor3, nor4 : std_logic;
	signal estim : estimation_type_array(1 to 16);

begin
	
	inv1: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(1),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => d, y => dn);  --dn <= not d;
	inv2: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	    -- pragma synthesis_off
        estimation => estim(2),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => dn, y => dnn);  --dnn <= not dn;
	inv3: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
        estimation => estim(3),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => sdn, y => SD);   --SD <= not sdn;
	inv4: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	    -- pragma synthesis_off
        estimation => estim(4),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => rdn, y => RD);    --RD <= not rdn;
	inv5: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	     -- pragma synthesis_off
        estimation => estim(5),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => CP, y => Cn);  --Cn <= not CP;
	inv6: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	    -- pragma synthesis_off
        estimation => estim(6),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => Cn, y => C);  --C <= not Cn;
	
	tristate1: tristate_buf generic map (delay => 0 ns, logic_family => logic_family ) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(7),
	   -- pragma synthesis_on
	   a => dnn, en => C, y => t1); --t1 <= 'Z' when C = '1' else dnn;
	tristate2: tristate_buf generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	    Vcc => Vcc, estimation => estim(8), 
	   -- pragma synthesis_on
	   a => nor1, en => Cn, y => t1); --t1 <= 'Z' when Cn = '1' else nor1;
	
	nor_gate1: nor_gate generic map (delay => delay, logic_family => logic_family) port map ( 
	   -- pragma synthesis_off
	    Vcc => Vcc, estimation => estim(9),
	   -- pragma synthesis_on
	   a => t1, b => SD, y => nor2);  --nor2 <= (t1 nor SD)  after delay;
	nor_gate2: nor_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(10), 
	   -- pragma synthesis_on
	   a => nor2, b => RD, y => nor1); --	nor1 <= nor2 nor RD;
	
	tristate3: tristate_buf generic map (delay => 0 ns, logic_family => logic_family) port map (
	    -- pragma synthesis_off
	    Vcc => Vcc, estimation => estim(11),
	   -- pragma synthesis_on
	   a => nor3, en => C,  y => t2);   --t2 <= 'Z' when C = '1' else nor3;
    tristate4: tristate_buf generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
         Vcc => Vcc, estimation => estim(12),
        -- pragma synthesis_on
        a => nor2, en => Cn,  y => t2);  --t2 <= 'Z' when Cn = '1' else nor2;
    
    nor_gate3: nor_gate generic map (delay => delay, logic_family => logic_family) port map ( 
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(13), 
        -- pragma synthesis_on
        a => t2, b => RD, y => nor4);  --	nor4 <= (t2  nor RD) after delay;
    nor_gate4: nor_gate generic map (delay => 0 ns, logic_family => logic_family) port map ( 
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(14),
        -- pragma synthesis_on
        a => nor4, b => SD, y => nor3) ; --	nor3 <= nor4 nor SD;

    inv7: inv_gate generic map (delay => delay, logic_family => logic_family,  Cload => Cload) port map (
        -- pragma synthesis_off
        estimation => estim(15),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => nor4, y => Qn);  --	Qn <= not nor4 after delay;
	inv8: inv_gate generic map (delay => delay, logic_family => logic_family, Cload => Cload) port map (
        -- pragma synthesis_off
        estimation => estim(16),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => t2, y => Q);  --	Q <= not t2 after delay;

    -- pragma synthesis_off
    sum : sum_up generic map (N => 16) port map (estim => estim, estimation => estimation);
	-- pragma synthesis_on
	end Structural;

architecture Behavioral of dff is
	signal internal : std_logic;
begin
	-- behavior
	process (CP,SDn,Rdn)
	begin
		if (SDn = '0') and (Rdn = '1') then internal <= '1';
		elsif (SDn = '1') and (Rdn = '0') then internal <= '0';
		elsif (SDn = '0') and (Rdn = '0') then internal <= '0'; 
		elsif rising_edge(CP) then internal <= D;
		end if;
	end process;
	Q <= internal after delay;
	Qn <= not internal after delay;

	-- pragma synthesis_off
	cm_i : PAEstimator generic map ( N=>4, M=>2, logic_family => logic_family, gate => dff_rising_edge, Cload => Cload)
		port map (sin(0) => CP, sin(1) => d, sin(2) => SDn, sin(3) => Rdn, Vcc => Vcc, sout(0) => internal, sout(1) => internal,estimation => estimation);
	-- pragma synthesis_on
end Behavioral;

----------------------------------------------------------------------------------
-- Description: N bit register with activity monitoring and Reset
--				behavioral and structural description, use structural for consumption estimation
--              - parameters :  delay - simulated delay time of an elementary gate
--                          	active_edge  - rising_edge of clock signal
--                               width - thenumber of DFF cells in the register
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs :  Clk - clock, active on rising edge
--                          D - configurable length input 
--                          Rn - reset, active logic '0'
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outpus :  Q, Qn - configurable length outputs
--                          estimation :  port to monitor power/area estimation
--									for power estimation only 
-- Dependencies: PECore.vhd, PeGates.vhd, Nbits.vhd
-----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all; 
use work.Nbits.all;

entity reg_Nbits is
    Generic ( delay: time := 0 ns;
			      width: natural := 8;
				  logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                  Cload : real := 0.0 -- capacitive load
                  );
		Port ( -- pragma synthesis_off
		       Vcc : in real ; --supply voltage
			   estimation : out estimation_type := est_zero;
			   -- pragma synthesis_on
		       D : in STD_LOGIC_VECTOR (width-1 downto 0);
			   Ck : in STD_LOGIC;
			   Rn : in STD_LOGIC;
			   Q : out STD_LOGIC_VECTOR (width-1 downto 0);
			   Qn : out STD_LOGIC_VECTOR (width-1 downto 0)
			   
			   );
end reg_Nbits;

architecture Behavioral of reg_Nbits is

begin

    registre: process(Rn, Ck)
    begin 
        if Rn = '0' then
           Q <= (others => '0');
        else
           if rising_edge(Ck) then
            Q <= D;
           end if;
        end if;
    end process;
    -- pragma synthesis_off
    estimation <= est_zero;
    -- pragma synthesis_on
end Behavioral;

architecture Structural of reg_Nbits is
     signal estim : estimation_type_array(1 to width);
begin

    registre:  for i in 0 to width-1 generate
        dffi : dff_Nbits generic map (delay => 0 ns, active_edge => TRUE, logic_family => logic_family) port map (
           --pragma synthesis_off
            Vcc => Vcc, estimation => estim(i+1),
            -- pragma synthesis_on
            D => D(i), Ck => Ck, Rn => Rn, Q => Q(i), Qn => open);
    end generate registre;
    --pragma synthesis_off
	sum_up_i : sum_up generic map (N => width) port map (estim => estim, estimation => estimation);
	--pragma synthesis_on
end Structural;

----------------------------------------------------------------------------------
-- Description: Ripple counter with activity monitoring and Reset 
--              - parameters :  delay - simulated delay time of an elementary gate
--                          	active_edge  - the active clock front of DFFs
--                          	width - the number of DFF cells in the counter
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs :  Clk - clock, active edge selected by active_edge param
--                          Rn - reset, active logic '0'
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outpus :  Q - counter value
--                          estimation :  port to monitor power/area estimation
--                          	   for power estimation only 
-- Dependencies: PECore.vhd, PeGates.vhd, Nbits.vhd
-----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all; 
use work.Nbits.all;

entity counter_Nbits is
    generic (
				delay : time := 0 ns;
				active_edge : boolean := TRUE;
				width : natural := 8;
				logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                Cload : real := 0.0 -- capacitive load
                );
		Port ( -- pragma synthesis_off
		       Vcc : in real ; --supply voltage
			   estimation : out estimation_type := est_zero;
			   -- pragma synthesis_on
			   CLK : in STD_LOGIC;
			   Rn : in STD_LOGIC;
			   Q : out STD_LOGIC_VECTOR (width-1 downto 0)
			   );
end counter_Nbits;

architecture Structural of counter_Nbits is

    signal ripple: STD_LOGIC_VECTOR (width downto 0);
    signal feedback : STD_LOGIC_VECTOR (width-1 downto 0);
    signal estim : estimation_type_array(1 to width);

begin

    ripple(0) <= CLK;
    gen_dff:  for i in 0 to width-1 generate
            gen_i : dff_Nbits generic map (delay => 0 ns, active_edge => active_edge, logic_family => logic_family) port map (
                    --pragma synthesis_off
                    Vcc => Vcc, estimation => estim(i+1),
                    --pragma synthesis_on
                    D => feedback(i), Ck => ripple(i), Rn => Rn, Q => ripple(i+1), Qn => feedback(i));
    end generate gen_dff;
    --feedback_d <= feedback estimation
    Q <= ripple(width downto 1);
    
    --pragma synthesis_off
    sum_up_i : sum_up generic map (N => width) port map (estim => estim, estimation => estimation);
    --pragma synthesis_on
end Structural;
-----------------------------------------------------------------------
-- Description: Ripple counter with activity monitoring, Reset and Enable
--              - parameters :  delay - simulated delay time of an elementary gate
---                          	active_edge  - the active clock front of DFFs
--                          	width - the number of DFF cells in the counter
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs :  Clk - clock, active edge selected by active_edge param
--                          Rn - reset, active logic '0'
--                          En - enable, active logic '1'
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outpus :  Q - counter value
--                          estimation :  port to monitor power/area estimation
--                          	   for power estimation only 
-- Dependencies: PECore.vhd, PeGates.vhd, Nbits.vhd
-----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.PECore.all;
use work.PEGates.all; 
use work.Nbits.all;

entity counter_we_Nbits is
    generic (
				delay : time := 0 ns;
				active_edge : boolean := TRUE;
				width : natural := 8;
				logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                Cload : real := 0.0 -- capacitive load
                );
		Port ( CLK : in STD_LOGIC;
			   Rn, En : in STD_LOGIC;
			   Q : out STD_LOGIC_VECTOR (width-1 downto 0);
			   Vcc : in real ; --supply voltage
			   estimation : out estimation_type := est_zero
			   );
end counter_we_Nbits;

architecture Structural of counter_we_Nbits is

    signal qi: STD_LOGIC_VECTOR (width-1 downto 0);
    signal T : STD_LOGIC_VECTOR (width-1 downto 0);
    signal estim : estimation_type_array(0 to 2*width-1);

begin

	T(0) <= En;
    gen_tff:  for i in 0 to width-1 generate
            gen_i : tff generic map (delay => 0 ns, logic_family => logic_family) port map (
                -- pragma synthesis_off
                Vcc => Vcc, estimation => estim(i), 
                -- pragma synthesis_on
                T => T(i), Ck => Clk, Rn => Rn, Q => QI(i), Qn => open);
    end generate gen_tff;
    gen_and:  for i in 0 to width-2 generate
            gen_i : and_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
                -- pragma synthesis_off
                Vcc => Vcc, estimation => estim(i+width),  
                -- pragma synthesis_on
                a => T(i), b =>QI(i), y => T(i+1));
    end generate gen_and;
    Q <= QI;
    --+ consumption monitoring section
    -- pragma synthesis_off
    sum_up_i : sum_up generic map (N => 2*width) port map (estim => estim, estimation => estimation);
    -- pragma synthesis_on
end Structural;



-----------------------------------------------------------------------
-- Description: Multiplexor with 2 inputs and activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--                          	active_edge  - the active clock front of DFFs
--                          	width - the number of DFF cells in the counter
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs:   I(0:1) - std_logic_vector 
--              			A - std_logic - address input
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outputs : Y-std_logic
--              			estimation :  port to monitor power/area estimation
--                          	   for power estimation only 
-- Dependencies: PECore.vhd, PeGates.vhd
-------------------------------------------------------------------------------estimationy IEEE;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.PECore.all;
use work.PEGates.all; 
use work.Nbits.all;

entity mux2_1 is
    Generic (delay : time := 1 ns;
             logic_family : logic_family_t := default_logic_family; -- the logic family of the component
             Cload : real := 0.0 -- capacitive load 
             );
       Port ( --pragma synthesis_off
             Vcc : in real ; -- supply voltage
             estimation : out estimation_type := est_zero;
             --pragma synthesis_on
             I : in STD_LOGIC_VECTOR (0 to 1);
             A : in STD_LOGIC;
             Y : out STD_LOGIC
             
              );
end mux2_1;

architecture Structural of mux2_1 is
	signal net1,net2,net3: std_logic;
	signal estim : estimation_type_array(1 to 4);
begin

	inv1: inv_gate generic map(delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(1),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => A, y =>net1);
	and1: and_gate generic map(delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(2),
	   -- pragma synthesis_on
	   a => net1, b => I(0),  y => net2 );
	and2: and_gate generic map(delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	    Vcc => Vcc, estimation => estim(3), 
	   -- pragma synthesis_on
	   a => A, b => I(1),y => net3 );
	or1: or_gate generic map(delay => 0 ns, logic_family => logic_family, Cload => Cload) port map (
	   -- pragma synthesis_off
	    Vcc => Vcc, estimation => estimation,
	      -- pragma synthesis_on
	   a => net2, b => net3, y => Y );
	-- pragma synthesis_off   
	sum : sum_up generic map (N => 4) port map (estim => estim, estimation => estimation);
    -- pragma synthesis_on
end Structural;

 architecture Behavioral of mux2_1 is
    signal addr : STD_LOGIC;
    signal internal: STD_LOGIC;
 begin
	addr <= A;
	internal <= I(0) when addr = '0'
		    else I(1) when addr = '1';
	Y <= internal;
	-- pragma synthesis_off
	cm_i : PAEstimator generic map ( N=>3, M=>1, logic_family => logic_family, gate => mux2, Cload => Cload)
            port map (sin(0) => I(0), sin(1) => I(1), sin(2) => addr, Vcc => Vcc , sout(0) => internal, estimation => estimation);
	-- pragma synthesis_on
	end Behavioral;
 
 ----------------------------------------------------------------------------------
-- Description: Multiplexor with 4 inputs and activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--                          	active_edge  - the active clock front of DFFs
--                          	width - the number of DFF cells in the counter
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs:   I(0:3) - std_logic_vector 
--              			A(0:1) - std_logic_vector - address input
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outputs : Y-std_logic
--              			estimation :  port to monitor power/area estimation
--                          	   for power estimation only 
-- Dependencies: PECore.vhd, PeGates.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity mux4_1 is
    Generic (delay : time := 1 ns;
			 logic_family : logic_family_t := default_logic_family; -- the logic family of the component
			 Cload : real := 0.0 -- capacitive load 
             );
        Port ( -- pragma synthesis_off 
               Vcc : in real ; -- supply voltage
		       estimation : out estimation_type := est_zero;
		       -- pragma synthesis_on
		       I : in STD_LOGIC_VECTOR (0 to 3);
               A : in STD_LOGIC_VECTOR (1 downto 0);
               Y : out STD_LOGIC

		       );
end mux4_1;

 architecture Behavioral of mux4_1 is
       signal addr : STD_LOGIC_VECTOR (1 downto 0);
       signal internal: STD_LOGIC;
 begin
	
	addr <= A;
	internal <= I(0) when addr = "00"
		else I(1) when addr = "01"
		else I(2) when addr = "10"
		else I(3) when addr = "11";
	Y <= internal;
	
	 -- pragma synthesis_off 
	cm_i : PAEstimator generic map ( N=>6, M=>1, logic_family => logic_family, gate => mux4, Cload => Cload)
		port map (sin(0) => I(0), sin(1) => I(1), sin(2) => I(2),sin(3) => I(3), sin(4) => addr(0), sin(5) => addr(1) , Vcc => Vcc, sout(0) => internal, estimation => estimation);
    -- pragma synthesis_on 
 end Behavioral; 

architecture Structural of mux4_1 is
	signal net1,net2: std_logic;
	-- pragma synthesis_off
	signal estim : estimation_type_array(1 to 3);
	--pragma synthesis_on
begin
	mux2_one: mux2_1 generic map(delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(1),
	   -- pragma synthesis_on
	   I(0) => I(0), I(1) => I(1), A => A(0),  Y => net1);
	mux2_two: mux2_1 generic map(delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	    Vcc => Vcc, estimation => estim(2), 
	   -- pragma  synthesis_on
	   I(0) => I(2), I(1) => I(3), A => A(0),Y => net2);
	mux2_three: mux2_1 generic map(delay => 0 ns, logic_family => logic_family, Cload => Cload) port map (
	   -- pragma synthesis_off
	    Vcc => Vcc,  estimation => estim(3),
	   -- pragma synthesis_on
	   I(0) => net1, I(1) => net2, A => A(1), Y => Y);
	--pragma synthesis_off
	sum : sum_up generic map (N => 3) port map (estim => estim, estimation => estimation) ;
    --pragma synthesis_on
end Structural;

 
-----------------------------------------------------------------------
-- Description: Counter 74163 with activity monitoring 
--              - parameters :  delay - simulatedestimation of estimationry gate
--                          	active_edge  - the active clock front of DFFs
--                          	width - the number of DFF cells in the counter
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs:  CK, CLRN, LOADN, PT, D, C, B, A - std_logic  
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outputs : Qd, Qc, Qb, Qa, RCO - std_logic
--              			estimation :  port to monitor power/area estimation
--                          	   for power estimation only 
-- Dependencies: PECore.vhd, PeGates.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity num74163 is
    Generic (delay : time := 1 ns;
			 logic_family : logic_family_t := default_logic_family; -- the logic family of the component
			 Cload : real := 0.0 -- capacitive load 
            );
        Port ( --pragrma synthesis_off
                Vcc : in real ; -- supply voltage
		        estimation : out estimation_type := est_zero;
		        --pragma synthesi_on
                CLK, CLRN, LOADN, P, T, D ,C ,B ,A : in std_logic;
                 Qd, Qc, Qb, Qa, RCO: out std_logic
		         );
end num74163;

architecture Behavioral of num74163 is
	signal counter : std_logic_vector (3 downto 0);
	signal ck,cl,ld,en,dd,cc,bb,aa,qdd,qcc,qbb,qaa,rrco: std_logic;
begin
	ck <= CLK;
	cl <= CLRN;
	ld <= LOADN;
	en <= P;
	dd <= D;
	cc <= C;
	bb <= B;
	aa <= A;
	functionare: process(ck,cl)
				 begin
				 if cl = '0' then
					   counter <= "0000";
				 elsif rising_edge(ck) then
				 if (ld = '0') then
					   counter <= dd & cc & bb & aa;
				 elsif ( en = '1') then 
					   counter <= counter + 1;
		   end if;
	   end if;
	end process;

	qdd <= counter(3) after delay;
	qcc <= counter(2) after delay;
	qbb <= counter(1) after delay;
	qaa <= counter(0) after delay;
	rrco <= '1' after delay when (en = '1' and counter = "1111") else '0' after delay;

	RCO <= rrco;
	Qd <= qdd;
	Qc <= qcc;
	Qb <= qbb;
	Qa <= qaa;
	
	--estimation <=est_zero;
	cm_i : PAEstimator generic map ( N=>8, M=>5, logic_family => logic_family, gate => num163, Cload => Cload)
			port map (sin(0) => ck, sin(1) => cl, sin(2) => ld, sin(3) => en, sin(4) => dd, sin(5) => cc, sin(6) => bb, sin(7) => aa, Vcc => Vcc, sout(0) => qdd, sout(1) => qcc, sout(2) => qbb, sout(3) => qaa, sout(4) => rrco, estimation => estimation);
end Behavioral;


architecture Structural of num74163 is
-- implementation follows schematic in https://assets.nexperia.com/documents/data-sheet/74HC_HCT163.pdf
	signal CPn , MR, PE : std_logic;
	signal DFF0Qn, DFF1Qn, DFF2Qn, DFF3Qn : std_logic;
	signal DFF0Q, DFF1Q, DFF2Q, DFF3Q : std_logic;
	signal D0, D1, D2, D3 : std_logic;
	signal DFF0, DFF1, DFF2, DFF3 : std_logic;
	signal D01, D11, D21, D31 : std_logic;
	signal D02, D12, D22, D32 : std_logic;
	signal C0, C1, C2, C3 : std_logic;
	signal L0, L1, L2, L3, L31, L32 : std_logic;
	signal CET, CEP, TC, CE, Load, Reset : std_logic;
	signal net1, net2 : std_logic;
	signal estim : estimation_type_array(1 to 46);
begin

	dff0_I : dff generic map (delay => 1 ns, logic_family => logic_family, Cload => Cload) port map (
	   --pragma synthesis_off
	    Vcc => Vcc, estimation => estim(1),
	   --pragma synthesis_on
	   CP => CPn, D => DFF0, RDn => '1',  SDn => '1', Qn => DFF0Q, Q => DFF0Qn);
	dff1_I : dff generic map (delay => 2 ns, logic_family => logic_family, Cload => Cload) port map (
	   --pragma synthesis_off
	  Vcc => Vcc, estimation => estim(2) , 
	   --pragma synthesis_on
	   CP => CPn, D => DFF1, RDn => '1', SDn => '1', Qn => DFF1Q, Q => DFF1Qn);
	dff2_I : dff generic map (delay => 1 ns, logic_family => logic_family, Cload => Cload) port map (
	   --pragma synthesis_off
	   Vcc => Vcc, estimation => estim(3), 
	   --pragma synthesis_on
	   CP => CPn, D => DFF2, RDn => '1', SDn => '1', Qn => DFF2Q, Q => DFF2Qn);
	dff3_I : dff generic map (delay => 2 ns, logic_family => logic_family, Cload => Cload) port map (
	   --pragma synthesis_off
	   Vcc => Vcc,  estimation => estim(4), 
	   --pragma synthesis_on
	   CP => CPn, D => DFF3, RDn => '1', SDn => '1', Qn => DFF3Q, Q => DFF3Qn);
	
	
	inv1: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(5),   Vcc => Vcc,
        -- pragma synthesis_on
        a => clk, y => CPn);  --CPn <= not clk;
	inv2: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(6),   Vcc => Vcc,
        -- pragma synthesis_on
        a => DFF0Qn, y => Qa);  --Qa <= not DFF0Qn;
	inv3: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(7),   Vcc => Vcc,
        -- pragma synthesis_on
        a => DFF1Qn,y => Qb);  --Qb <= not DFF1Qn;
	inv4: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(8),   Vcc => Vcc,
        -- pragma synthesis_on
        a => DFF2Qn, y => Qc); --Qc <= not DFF2Qn;
	inv5: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(9),   Vcc => Vcc,
        -- pragma synthesis_on
        a => DFF3Qn, y => Qd);--Qd <= not DFF3Qn;
	inv6: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(10),   Vcc => Vcc,
        -- pragma synthesis_on
        a => CLRN, y => MR); --MR <= not CLRN;
	
	tristate1: tristate_buf generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	    Vcc => Vcc, estimation => estim(11), 
	   -- pragma synthesis_on
	    a => LOADN, en => '1', y => PE); --PE <= LOADN;
	tristate2: tristate_buf generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	    Vcc => Vcc, estimation => estim(12), 
	   -- pragma synthesis_on
	   a => A, en => '1', y => D0); --D0 <= A; (--not A)
	tristate3: tristate_buf generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(13), 
	   -- pragma synthesis_on
	   a => B, en => '1',  y => D1);  --D1 <= B; (--not B)
	tristate4: tristate_buf generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(14), 
	   -- pragma synthesis_on
	   a => C, en => '1',  y => D2);  --D2 <= C; --not C;
	tristate5: tristate_buf generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(15),
	   -- pragma synthesis_on
	   a => D, en => '1',   y => D3);  --D3 <= D; --not D;
	tristate6: tristate_buf generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(16),
	   -- pragma synthesis_on
	   a => T, en => '1',   y => CET);  --CET <= T;
	tristate7: tristate_buf generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(17), 
	   -- pragma synthesis_on
	   a => P, en => '1',  y => CEP);  --CEP <= P;
	inv7: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc,  estimation => estim(18),
        -- pragma synthesis_on
        a => TC, y => RCO);--RCO <= not TC;
	and5_gate1: and5_gate generic map (delay => 0 ns, logic_family => logic_family) port map ( 
	   -- pragma synthesis_off
	   Vcc => Vcc , estimation => estim(19), 
	   -- pragma synthesis_on
	   a => DFF0Q, b => DFF1Q, c => DFF2Q, d => DFF3Q, e => CET, y => TC); --TC <= (DFF0Q and DFF1Q and DFF2Q and DFF3Q and CET);
	nand_gate1 : nand_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(20),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => CET, b=> CEP, y => CE); --CE <=  CET nand CEP;
	
	nor_gate1: nor_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(21), 
	   -- pragma synthesis_on
	   a => MR, b=> PE, y => LOAD); -- LOAD <= MR nor PE;
	nor_gate2: nor_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(22), 
	   -- pragma synthesis_on
	   a => Load, b=> MR, y => Reset); --Reset <= Load nor MR;
	
	inv8: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(23),
        -- pragma synthesis_on
        a => CE, y => C0); --C0 <= not CE;
	nor_gate3: nor_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(24),
	   -- pragma synthesis_on 
	   a => CE, b=> DFF0Qn, y => C1); -- C1 <= CE nor DFF0Qn;
	or3_gate1: or3_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	    Vcc => Vcc, estimation => estim(25), 
	  -- pragma synthesis_on
	   a => CE, b=> DFF0Qn, c => DFF1Qn,y => net1); --(CE or DFF0Qn or DFF1Qn)
	inv9: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(26),Vcc => Vcc,
        -- pragma synthesis_on
        a => net1, y => C2);--	C2 <= not (CE or DFF0Qn or DFF1Qn);
    or4_gate1: or4_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
         Vcc => Vcc, estimation => estim(27), 
        -- pragma synthesis_on
        a => CE, b=> DFF0Qn, c => DFF1Qn, d => DFF2Qn,y => net2); --(CE or DFF0Qn or DFF1Qn or DFF2Qn)
    inv10: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        estimation => estim(28),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => net2, y => C3);--    C3 <= not (CE or DFF0Qn or DFF1Qn or DFF2Qn);
	
	xnor_gate1 : xnor_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(29),
	   -- pragma synthesis_on
	   a => C0, b=> DFF0Qn,  y => L0); --L0 <= C0 xnor DFF0Qn;
	xnor_gate2 : xnor_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(30), 
	-- pragma synthesis_on
	   a => C1, b=> DFF1Qn, y => L1);--L1 <= C1 xnor DFF1Qn;
	xnor_gate3 : xnor_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(31),
	   -- pragma synthesis_on
	   a => C2, b=> DFF2Qn,  y => L2); --L2 <= C2 xnor DFF2Qn;
	
	or_gate1 : or_gate  generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(32), 
	 -- pragma synthesis_on
	   a => L31, b=> L32, y => L3); --L3 <= L31 or L32 (L3 <= C3 xnor DFF3Qn;)
    and_gate1: and_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc,  estimation=> estim(33), 
	   -- pragma synthesis_on
	   a => C3, b => DFF3Qn, y => L31); --L31 <= C3 and DFF3Qn;
    nor_gate4: nor_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(34), 
        -- pragma synthesis_on
	   a => C3, b => DFF3Qn, y => L32); --L32 <= C3 nor DFF3Qn;
    and_gate2: and_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(35), 
        -- pragma synthesis_on
	   a => D0, b => load, y => D01); --D01 <= D0 and load;
    and_gate3: and_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(36), 
	   -- pragma synthesis_on
	   a => D1, b => load, y => D11);--D11 <= D1 and load;
	and_gate4: and_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(37), 
	   -- pragma synthesis_on
	   a => D2, b => load, y => D21);--D21 <= D2 and load;
	and_gate5: and_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(38), 
	   -- pragma synthesis_on
	   a => D3, b => load, y => D31);--D31 <= D3 and load;
	and_gate6: and_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(39), 
	  -- pragma synthesis_on
	   a => L0, b => Reset, y => D02); --D02 <= L0 and Reset;
	and_gate7: and_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(40), 
	   -- pragma synthesis_on
	   a => L1, b=> Reset, y => D12);--D12 <= L1 and Reset;
	and_gate8: and_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(41), 
	   -- pragma synthesis_on
	   a => L2, b=> Reset, y => D22);--D22 <= L2 and Reset;
	and_gate9: and_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(42),
	   -- pragma synthesis_on
	   a => L3, b=> Reset,  y => D32);--D32 <= L3 and Reset;
	
	nor_gate5: nor_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(43), 
	   -- pragma synthesis_on
	   a => D01, b => D02, y => DFF0);--DFF0 <= D01 nor D02;
	nor_gate6: nor_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	    Vcc => Vcc, estimation => estim(44), 
	   -- pragma synthesis_on
	   a => D11, b => D12,y => DFF1);--DFF1 <= D11 nor D12;
	nor_gate7: nor_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	   Vcc => Vcc, estimation => estim(45),
	   -- pragma synthesis_on
	   a => D21, b => D22,  y => DFF2);--DFF2 <= D21 nor D22;
	nor_gate8: nor_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
	   -- pragma synthesis_off
	    Vcc => Vcc, estimation => estim(46), 
	   -- pragma synthesis_on
	   a => D31, b => D32,y => DFF3);--DFF3 <= D31 nor D32;
	-- pragma synthesis_off
	sum : sum_up generic map (N => 46) port map (estim => estim, estimation => estimation );
	-- pragma synthesis_on
end architecture;

-----------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia, Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description:  Priority encoder on 2 bits with activity monitroing
--              - parameters :  logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs:   bi - bits in
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outputs : bo - the priotity number
--                          mo - mask out - to next mask cell
--                          estimation :  port to monitor power/area estimation
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: PECore.vhd, PEGates.vhd, Nbits.vhd
-- Revision: 0.02 - Added comments
-- Revision: 0.01 - File Created
------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

library work;
use work.PECore.all;
use work.PEGates.all; 
use work.Nbits.all;

entity pr_encoder_2bit is
    Generic (logic_family : logic_family_t := default_logic_family; -- the logic family of the component
             Cload : real := 0.0 -- capacitive load
              );
    Port ( --pragma synthesis_off
           Vcc: in real; -- supply voltage
           estimation : out estimation_type := est_zero;
           --pragma synthesis_on
           ei : in STD_LOGIC;
           bi : in STD_LOGIC_VECTOR(1 downto 0);
           bo : out STD_LOGIC;
           eo, gs : out STD_LOGIC
           );
end pr_encoder_2bit;

architecture  Behavioral of pr_encoder_2bit is
    signal eo_intern : std_logic;
begin

     eo_intern <= not (ei or (bi(1)) or (bi(0)));
     eo <= eo_intern;
     gs <=  ei nor (eo_intern);
     -- ls348 are iesiri cu inalta impedanta
     --bo <= bi(1) when (ei = '1' and eo = '1') else 'Z';
     bo <= bi(1); 
     --pragma synthesis_off
    estimation <=est_zero;
    --pragma synthesis_on

end Behavioral;

architecture structural of pr_encoder_2bit is
    signal tristate_enable, eo_intern : std_logic;
    signal estim : estimation_type_array(1 to 2);
begin
     -- gs <=  ei nor eo;
    nor1: nor_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        --pragma synthesis_off
        Vcc => Vcc, estimation => estim(1), 
        --pragma synthesis_on
        a => ei, b => eo_intern,  y => gs);
    -- eo <= ei nor bi(1) nor bi(0);
    nor2: nor3_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        --pragma synthesis_off
        Vcc => Vcc, estimation => estim(2),
        --pragma synthesis_on
        a => ei, b => bi(1), c => bi(0), y => gs);
    --bo(0) <= bi(1) when (ei = '1' and eo = '1') else 'Z';
    --and1: and_gate port map (a => ei, b => eo, y => tristate_enable, estimation => en3);
    --buffer1 : tristate_buf portestimationbi(1), en => tristate_enable, y => bo, estimation => en4); 
    bo <= bi(1);
    eo <= eo_intern;
    --pragma synthesis_off
    sum_up1 : sum_up generic map (N => 2) port map (estim => estim, estimation => estimation);
    --pragma synthesis_on
end architecture;

-----------------------------------------------------------------------
-- Description:  Priority encoder on 4 bits with consumption monitoroing
--              - parameters :  logic_family - the logic famiestimationristestimation
--								Cload - load capacitance
--              - inputs:   bi - bits in
--                          VCC -  supply voltage (used to compute static power dissipation)
--                       	   for power estimation only 
--              - outputs : bo - the priotity number
--                          mo - mask out - to next mask cell
--                          estimation :  port to monitor power/area estimation 
--                          	   for power estimation only 
-- Dependencies: PECore.vhd, PEGates.vhd, Nbits.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;


entity pr_encoder_4bit is
    Generic (logic_family : logic_family_t := default_logic_family; -- the logic family of the component
             Cload : real := 0.0 -- capacitive load
              );
    Port ( --pragma synthesis_off
           Vcc : in real ; -- supply voltage
           estimation : out estimation_type := est_zero;
           --pragma synthesis_on
           ei : in STD_LOGIC;
           bi : in STD_LOGIC_VECTOR(3 downto 0);
           bo : out STD_LOGIC_VECTOR(1 downto 0);
           eo,gs : out STD_LOGIC
        );
end pr_encoder_4bit;

architecture Behavioral of pr_encoder_4bit is

    signal net1,net2,net3 : std_logic;
     --pragma synthesis_off
    signal estim : estimation_type_array(1 to 5);
     --pragma synthesis_on
begin

inv1: inv_gate generic map (delay => 0 ns, logic_family => logic_family ) port map (
        -- pragma synthesis_off
        estimation => estim(1),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => bi(2), y => net1);
and_gate1 : and_gate generic map (delay => 0 ns, logic_family => logic_family ) port map (
      --pragma synthesis_off
      Vcc => Vcc, estimation => estim(2), 
      --pragma synthesis_on
      a => net1, b => bi(1), y => net3);
or_gate1: or_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
    --pragma synthesis_off
    Vcc => Vcc, estimation => estim(3), 
    --pragma synthesis_on
    a => bi(3),  b => bi(2), y => net2);
or_gate2: or_gate generic map (delay => 0 ns, logic_family => logic_family ) port map (
    --pragma synthesis_off
    Vcc => Vcc, estimation => estim(4), 
    --pragma synthesis_on
    a => bi(3), b => net3, y => bo(0)); 
or3_gate1: or3_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
    --pragma synthesis_off
    Vcc => Vcc, estimation => estim(5), 
    --pragma synthesis_on
    a => net2, b => bi(1), c => bi(0), y => gs); 
 
 bo(1) <= net2;
 
    -- consumption monitoring
    -- for simulation only
    --pragma synthesis_off                             
    sum_up1 : sum_up generic map (N => 5) port map (estim => estim, estimation => estimation);
    --pragma synthesis_on
end Behavioral;

-- this solution should be further tested
architecture Structural of pr_encoder_4bit is
   
    signal net0, net1,net2,net3, net4 : std_logic;
    --pragma synthesis_off
    signal estim : estimation_type_array(1 to 4);    
    --pragma synthesis_on
begin
    U1: pr_encoder_2bit generic map (logic_family => logic_family) port map (
        --pragma synthesis_off
        Vcc => Vcc, estimation => estim(1), 
        --pragma synthesis_on
         ei => ei,  bi => bi(3 downto 2), bo => net0, eo => net1, gs => net2);
    --bo(0) <= net0;
    bo(1) <= net2;
    U2: pr_encoder_2bit generic map (logic_family => logic_family ) port map (
        --pragma synthesis_off
        Vcc => Vcc, estimation => estim(2),
        --pragma synthesis_on
        ei => net1,  bi => bi(1 downto 0), bo => net3, eo => eo, gs => net4);
                                         
    U3: or_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        --pragma synthesis_off
        Vcc => Vcc, estimation =>  estim(3),
        --pragma synthesis_on
        a => net0, b => net3, y => bo(0));
    U4: or_gate generic map (delay => 0 ns, logic_family => logic_family) port map (
        --pragma synthesis_off
        Vcc => Vcc, estimation => estim(4),
        --pragma synthesis_on
        a => net2, b => net4, y => gs);
    
     -- consumption monitoring
     --pragma synthesis_off                              
    sum_up1 : sum_up generic map (N => 4) port map (estim => estim, estimation => estimation);
     --pragma synthesis_on
end Structural;

architecture Structural2 of pr_encoder_4bit is

    signal to_bo : STD_LOGIC_VECTOR(2 DOWNTO 0);

begin

    U1: pr_encoder_8bit generic map (logic_family => logic_family) port map (
        --pragma synthesis_off
        Vcc => Vcc, estimation => estimation, 
        --pragma synthesis_on
         ei => ei,  I(3 downto 0) => bi, I(7 downto 4) => (others => '0'), Y => to_bo, eo => eo, gs => gs);
    bo <= to_bo(1 downto 0);
end Structural2;

----------------------------------------------------------------------------------
-- Description: 8 to 3 bit priority encoder bits with activity monitoring (74148)
--              - parameters :  logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs: I(i), i=(0:7) ; EI(Enable Input) 
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outputs : Y, EO(Enable output), GS(Group select)
--                          estimation :  port to monitor power/area estimation 
--                          	   for power estimation only 
-- Dependencies: PECore.vhd, PEgates.vhd, Nbits.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity pr_encoder_8bit is
    Generic (logic_family : logic_family_t := default_logic_family; -- the logic family of the component
             Cload : real := 0.0 -- capacitive load
              );
       Port (  --pragma synthesis_off
               Vcc : in real;  -- supply voltage
               estimation : out estimation_type := est_zero;
               --pragma synthesis_on
               I : in STD_LOGIC_VECTOR(7 DOWNTO 0);
               EI: in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(2 DOWNTO 0);
               GS,EO : out STD_LOGIC        
            );
end pr_encoder_8bit;

architecture Behavioral of pr_encoder_8bit is

    signal net: std_logic_vector (18 downto 1);
    --pragma synthesis_off
    signal estim : estimation_type_array(1 to 22);
    --pragma synthesis_on
begin

    inv1: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(1),
        -- pragma synthesis_on
        a => I(2), y => net(1)); 
    inv2: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        estimation => estim(2),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => I(4), y => net(2));
    inv3: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        estimation => estim(3),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => I(5), y => net(3)); 
    inv4: inv_gate generic map (delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        estimation => estim(4),
        Vcc => Vcc,
        -- pragma synthesis_on
        a => I(6), y => net(4)); 
    nor8_gate1: nor8_gate generic map(delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(5),
        -- pragma synthesis_on
         x(0) => I(0), x(1) => I(1), x(2) => I(2) , x(3) => I(3) , x(4) => I(4) , x(5) => I(5) , x(6) => I(6) , x(7) => I(7),  y => net(5)); 
    and_gate1: and_gate generic map(delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(6),
        -- pragma synthesis_on
        a => EI, b => I(7), y => net(6));
    and_gate2: and_gate generic map(delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(7),
        -- pragma synthesis_on
        a => EI, b => I(6), y => net(7));
    and_gate3: and_gate generic map(delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(8),
        -- pragma synthesis_on
        a => EI,b => I(5), y => net(8));
    and_gate4: and_gate generic map(delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(9),
        -- pragma synthesis_on
        a => EI, b => I(4), y => net(9));
    and_gate5: and_gate generic map(delay => 0 ns,  logic_family => logic_family) port map(
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(10),
        -- pragma synthesis_on
        a => EI, b => I(7), y => net(10));
    and_gate6: and_gate generic map(delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(11),
        -- pragma synthesis_on
        a => EI, b => I(6), y => net(11));
    and_gate7: and_gate generic map(delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(12),
        -- pragma synthesis_on
        a => EI, b => I(7), y => net(12));
    and_gate8: and_gate generic map(delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(13),
        -- pragma synthesis_on
        a => EI, b => net(5), y => net(18));
    and3_gate1: and3_gate generic map(delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(14),
        -- pragma synthesis_on
        a => EI, b => net(4), c => I(5), y => net(13));
    and4_gate1: and4_gate generic map(delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(15),
        -- pragma synthesis_on
        a => EI, b => net(3), c => net(2), d => I(3), y => net(14));
    and4_gate2: and4_gate generic map(delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(16),
        -- pragma synthesis_on
         a => EI, b => net(3), c => net(2), d => I(2), y => net(15));
    and4_gate3: and4_gate generic map(delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(17),
        -- pragma synthesis_on 
        a => EI, b => net(4), c => net(2), d => I(3), y => net(16));
    and5_gate1: and5_gate generic map(delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(18),
        -- pragma synthesis_on       
        a => EI, b => net(4), c => net(2), d => net(1),e => I(1), y => net(17));
    or4_gate1: or4_gate generic map(delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(19),
        -- pragma synthesis_on
        a => net(6), b => net(7), c => net(8), d => net(9), y => Y(2));
    or4_gate2: or4_gate generic map(delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(20),
        -- pragma synthesis_on        
        a => net(10), b => net(11), c => net(14), d => net(15), y => Y(1));
    or4_gate3: or4_gate generic map(delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(21),
        -- pragma synthesis_on
        a => net(12), b => net(13), c => net(16), d => net(17), y => Y(0));
    xor_gate1: xor_gate generic map(delay => 0 ns, logic_family => logic_family) port map(
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(22),
        -- pragma synthesis_on
        a => EI, b => net(18), y => GS);
    
    EO <= net(18);
      
    --+ summing up consumption
    -- pragma synthesis_off
	sum_up_i : sum_up generic map (N => 22) port map (estim => estim, estimation => estimation);
    -- pragma synthesis_on
 
end Behavioral;

----------------------------------------------------------------------------------
-- Description:  Priority encoder on 32 bits with acestimationtoring (74148 cascading)
--              - parameters :  logic_family - the logic family of theestimationuffeestimation		Cload - load capacitance
--              - inputs: I(i), i=(0:31) ; EI(Enable Input) 
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outputs : Y, EO(Enable output), GS(Group select)
--                          estimation :  port to monitor power/area estimation 
--                          	   for power estimation only 
-- Dependencies: PECore.vhd, PEgates.vhd, Nbits.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity pr_encoder_16bit is
    Generic (logic_family : logic_family_t := default_logic_family; -- the logic family of the component
             Cload : real := 0.0 -- capacitive load
              );
     Port (   -- pragma synthesis_off
              Vcc : in real; --supply voltage
              estimation : out estimation_type := est_zero;
              -- pragma synthesis_on
              I: in STD_LOGIC_VECTOR(15 DOWNTO 0);
              EI: in STD_LOGIC;
              Y : out STD_LOGIC_VECTOR(3 DOWNTO 0);
              GS,EO : out STD_LOGIC
              );
end pr_encoder_16bit;


architecture Behavioral of pr_encoder_16bit is

	signal net: std_logic_vector (19 downto 1);
    signal estim : estimation_type_array(1 to 7);

begin
    
	encoder1: pr_encoder_8bit generic map(logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(1),
        -- pragma synthesis_on
         I(0) => I(15), I(1) => I(14), I(2) => I(13), I(3) => I(12), I(4) => I(11),  I(5) => I(10), I(6) => I(9), I(7) => I(8), EI => net(10), Y(0) => net(11), Y(1) => net(12), Y(2) => net(13), GS => net(14), EO => net(15));
	encoder2: pr_encoder_8bit generic map(logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(2),
        -- pragma synthesis_on
         I(0) => I(7), I(1) => I(6), I(2) => I(5), I(3) => I(4), I(4) => I(3), I(5) => I(2), I(6) => I(1), I(7) => I(0), EI => net(15), Y(0) => net(16), Y(1) => net(17), Y(2) => net(18),GS => net(19), EO => EO);
	or_gate1 : or_gate  generic map(delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(3),
        -- pragma synthesis_on
        a => net(4), b => net(14), y => Y(3));
	or4_gate1: or4_gate generic map(delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(4),
        -- pragma synthesis_on
        a => net(3), b => net(8), c => net(13),d => net(18), y => Y(2));
	or4_gate2: or4_gate generic map(delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(5),
        -- pragma synthesis_on
        a => net(2), b => net(7), c => net(12),d => net(17), y => Y(1));
	or4_gate3: or4_gate generic map(delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(6),
        -- pragma synthesis_on
        a => net(1), b => net(1), c => net(11),d => net(16), y => Y(0));
	or4_gate4: or4_gate generic map(delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(7),
        -- pragma synthesis_on
        a => net(4), b => net(9), c => net(14),d => net(19), y => GS);

    --+ summing up consumption
    -- pragma synthesis_off
	sum_up_i : sum_up generic map (N => 7) port map (estim => estim, estimation => estimation);
    -- pragma synthesis_on

end Behavioral;


architecture Structural of pr_encoder_16bit is

	signal to_y : std_logic_vector(4 downto 0);
begin

    pe_32bit : pr_encoder_32bit generic map(logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estimation,
        -- pragma synthesis_on
        I(15 downto 0) => I , I(31 downto 16) => (others => '0'), EI => EI, Y => to_y, EO => EO, GS => GS); 
	Y <= to_y(3 downto 0);
	
end Structural;

----------------------------------------------------------------------------------
-- Description:  Priority encoder on 32 bits with activity monitoring (74148 cascading)
--              - parameters :  logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs: I(i), i=(0:31) ; EI(Enable Input) 
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outputs : Y, EO(Enable output), GS(Group select)
--                          estimation :  port to monitor power/area estimation 
--                          	   for power estimation only 
-- Dependencies: PECore.vhd, PEgates.vhd, Nbits.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity pr_encoder_32bit is
     Generic (logic_family : logic_family_t := default_logic_family; -- the logic family of the component
             Cload : real := 0.0 -- capacitive load
              );
     Port (   -- pragma synthesis_off
              Vcc : in real; --supply voltage
              estimation : out estimation_type := est_zero;
              -- pragma synthesis_on
              I: in STD_LOGIC_VECTOR(31 DOWNTO 0);
              EI: in STD_LOGIC;
              Y : out STD_LOGIC_VECTOR(4 DOWNTO 0);
              GS,EO : out STD_LOGIC
              );
end pr_encoder_32bit;

architecture Behavioral of pr_encoder_32bit is
    signal net: std_logic_vector (19 downto 1);
    signal GSI: std_logic_vector (3 downto 0);
    signal estim : estimation_type_array(1 to 10);

begin
    
    encoder1: pr_encoder_8bit generic map(logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(1) , 
        -- pragma synthesis_on
         I(7) => I(31), I(6) => I(30), I(5) => I(29), I(4) => I(28), I(3) => I(27), I(2) => I(26), I(1) => I(25), I(0) => I(24), EI => EI, Y(0) => net(1), Y(1) => net(2), Y(2) => net(3), GS => net(4), EO => net(5));
    encoder2: pr_encoder_8bit generic map(logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(2) , 
        -- pragma synthesis_on
         I(7) => I(23), I(6) => I(22), I(5) => I(21), I(4) => I(20), I(3) => I(19), I(2) => I(18), I(1) => I(17), I(0) => I(16), EI => net(5), Y(0) => net(6), Y(1) => net(7), Y(2) => net(8),GS => net(9), EO => net(10));
    encoder3: pr_encoder_8bit generic map(logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(3) , 
        -- pragma synthesis_on
         I(7) => I(15), I(6) => I(14), I(5) => I(13), I(4) => I(12), I(3) => I(11), I(2) => I(10), I(1) => I(9),  I(0) => I(8), EI => net(10), Y(0) => net(11), Y(1) => net(12), Y(2) => net(13), GS => net(14), EO => net(15));
    encoder4: pr_encoder_8bit generic map(logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(4) , 
        -- pragma synthesis_on
         I(7) => I(7),  I(6) => I(6),  I(5) => I(5),  I(4) => I(4),  I(3) => I(3),  I(2) => I(2),  I(1) => I(1),  I(0) => I(0), EI => net(15), Y(0) => net(16), Y(1) => net(17), Y(2) => net(18),GS => net(19), EO => EO);
    or_gate1 : or_gate  generic map(delay => 0 ns, logic_family =>logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(5) , 
        -- pragma synthesis_on
        a => net(4), b => net(9), y => Y(4));
    or_gate2 : or_gate  generic map(delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(6) , 
        -- pragma synthesis_on
        a => net(4), b => net(14), y => Y(3));
    or4_gate1: or4_gate generic map(delay => 0 ns, logic_family => logic_family)  port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(7) , 
        -- pragma synthesis_on
        a => net(3), b => net(8), c => net(13),d => net(18), y => Y(2));
    or4_gate2: or4_gate generic map(delay => 0 ns, logic_family => logic_family)  port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(8) , 
        -- pragma synthesis_on
      a => net(2), b => net(7), c => net(12),d => net(17), y => Y(1));
    or4_gate3: or4_gate generic map(delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(9) , 
        -- pragma synthesis_on
        a => net(1), b => net(6), c => net(11),d => net(16), y => Y(0));
    or4_gate4: or4_gate generic map(delay => 0 ns, logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(10) , 
        -- pragma synthesis_on
        a => net(4), b => net(9), c => net(14),d => net(19), y => GS);
 
    --+ summing up consumption
    -- pragma synthesis_off
	sum_up_i : sum_up generic map (N=>10) port map (estim => estim, estimation => estimation);
    -- pragma synthesis_on

end Behavioral;


-----------------------------------------------------------------------
-- Description:  Priority encoder on 64 bits with activity monitoring (74148)estimation       - parameters :  logic_family - the logic family of the tristate buffer
--              - parameters :  logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs: I(i), i=(63:0) ; EI(Enable Input) 
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outputs : Y, EO(Enable output), GS(Group select)
--                          estimation :  port to monitor power/area estimation 
--                          	   for power estimation only 
-- Dependencies: PECore.vhd, PEgates.vhd, Nbits.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity pr_encoder_64bit is
        Generic (logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                 Cload : real := 0.0 -- capacitive load
                 );
          Port (
               -- pragma synthesis_off
               Vcc : in real; --supply voltage
               estimation : out estimation_type := est_zero;
               -- pragma synthesis_on
               I: in STD_LOGIC_VECTOR(63 DOWNTO 0);
               EI: in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(5 DOWNTO 0);
               GS,EO : out STD_LOGIC
               );
end pr_encoder_64bit;

architecture Behavioral of pr_encoder_64bit is

	signal net: std_logic_vector (19 downto 1);
	signal estim : estimation_type_array(1 to 9);

begin
	encoder1: pr_encoder_8bit generic map (logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(1) , 
        -- pragma synthesis_on
         I(0) => I(0), I(1) => I(1), I(2) => I(2), I(3) => I(3), I(4) => I(4), I(5) => I(5), I(6) => I(6), I(7) => I(7), EI => net(1), Y(0) => net(9), Y(1) => net(10), Y(2) => net(11), GS => net(12));
	encoder2: pr_encoder_8bit generic map (logic_family => logic_family) port map (
        -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(2) , 
        -- pragma synthesis_on
         I(0) => I(8), I(1) => I(9), I(2) => I(10), I(3) => I(11), I(4) => I(12), I(5) => I(13), I(6) => I(14), I(7) => I(15), EI => net(2), Y(0) => net(9), Y(1) => net(10), Y(2) => net(11), EO => net(1), GS => net(13));
	encoder3: pr_encoder_8bit generic map (logic_family => logic_family) port map (
	    -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(3) , 
        -- pragma synthesis_on
         I(0) => I(16), I(1) => I(17), I(2) => I(18), I(3) => I(19), I(4) => I(20), I(5) => I(21), I(6) => I(22), I(7) => I(23), EI => net(3), Y(0) => net(9), Y(1) => net(10), Y(2) => net(11), EO => net(2), GS => net(14));
	encoder4: pr_encoder_8bit generic map (logic_family => logic_family) port map (
	    -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(4) , 
        -- pragma synthesis_on
         I(0) => I(24), I(1) => I(25), I(2) => I(26), I(3) => I(27), I(4) => I(28), I(5) => I(29), I(6) => I(30), I(7) => I(31), EI => net(4), Y(0) => net(9), Y(1) => net(10), Y(2) => net(11), EO => net(3), GS => net(15));
	encoder5: pr_encoder_8bit generic map (logic_family => logic_family) port map (
	    -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(5) , 
        -- pragma synthesis_on
         I(0) => I(32), I(1) => I(33), I(2) => I(34), I(3) => I(35), I(4) => I(36), I(5) => I(37), I(6) => I(38), I(7) => I(39), EI => net(5), Y(0) => net(9), Y(1) => net(10), Y(2) => net(11), EO => net(4), GS => net(16));
	encoder6: pr_encoder_8bit generic map (logic_family => logic_family) port map (
	    -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(6) , 
        -- pragma synthesis_on
         I(0) => I(40), I(1) => I(41), I(2) => I(42), I(3) => I(43), I(4) => I(44), I(5) => I(45), I(6) => I(46), I(7) => I(47), EI => net(6), Y(0) => net(9), Y(1) => net(10), Y(2) => net(11), EO => net(5), GS => net(17));
	encoder7: pr_encoder_8bit generic map (logic_family => logic_family) port map (
	    -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(7) , 
        -- pragma synthesis_on
         I(0) => I(48), I(1) => I(49), I(2) => I(50), I(3) => I(51), I(4) => I(52), I(5) => I(53), I(6) => I(54), I(7) => I(55), EI => net(7), Y(0) => net(9), Y(1) => net(10), Y(2) => net(11), EO => net(6), GS => net(18));
	encoder8: pr_encoder_8bit generic map (logic_family => logic_family) port map (
	    -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(8) , 
        -- pragma synthesis_on
         I(0) => I(56), I(1) => I(57), I(2) => I(58), I(3) => I(59), I(4) => I(60), I(5) => I(61), I(6) => I(62), I(7) => I(63), EI => EI, Y(0) => net(9), Y(1) => net(10), Y(2) => net(11), EO => net(7), GS => net(19));
	encoder9: pr_encoder_8bit generic map (logic_family => logic_family) port map (
	    -- pragma synthesis_off
        Vcc => Vcc, estimation => estim(9) , 
        -- pragma synthesis_on
         I(0) => net(12), I(1) => net(13), I(2) => net(14), I(3) => net(15), I(4) => net(16), I(5) => net(17), I(6) => net(18), I(7) => net(19), EI => '0', Y(0) => Y(3), Y(1) => Y(4), Y(2) => Y(5), GS => net(8));

	Y(0) <= net(9);
	Y(1) <= net(10);
	Y(2) <= net(11);
	GS <= net(8);
    -- pragma synthesis_off
	sum_up_i : sum_up generic map (N => 9) port map (estim => estim, estimation => estimation);
	-- pragma synthesis_on
end Behavioral;

----------------------------------------------------------------------------------
-- Description:  Priority encoder on N bits with activity monitroing
--              - parameters :  N - number of input 
--								delay - simulated delay time of an elementary gate
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs:   bi - bits in
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outputs : bo - the priotity number
--							EO(Enable output), GS(Group select)
--                          estimation :  port to monitor power/area estimation 
--                          	   for power estimation only 
-- Dependencies: PECore.vhd, PEgates.vhd, Nbits.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all; 

library work;
use work.PECore.all;
use work.PEGates.all; 
use work.Nbits.all;

entity pe_Nbits is
          Generic ( N: natural := 4;
				   delay : time := 0 ns;
				   logic_family : logic_family_t := default_logic_family; -- the logic family of the component
                   Cload : real := 0.0 -- capacitive load
                   );
		    Port (  -- pragma synthesis_off
              		Vcc : in real ; --supply voltage
              		estimation : out estimation_type := est_zero;
		            -- pragma synthesis_on
		            ei : in std_logic;
              		bi : in STD_LOGIC_VECTOR (N-1 downto 0);
             		bo : out STD_LOGIC_VECTOR (log2(N)-1 downto 0);
              		eo : out std_logic;
              		gs : out std_logic
              		);
end pe_Nbits;

architecture Behavioral of pe_Nbits is

   signal highest_bit : natural := N-1;

begin

shifting : PROCESS(bi)
   variable i: natural;
begin
   for i in 0 to N-1 loop
      if bi(i) = '1' then 
         highest_bit <= i;
      end if;
   end loop;
end process;

bo <= std_logic_vector(to_unsigned(highest_bit, log2(N))) after delay;
-- pragma synthesis_off
estimation <=est_zero;
-- pragma synthesis_on
end Behavioral;

architecture structural of pe_Nbits is

    signal bi_concat :  STD_LOGIC_VECTOR (32 downto 0) := (others => '0');

begin
    pe0 : if N < 4 generate
	bi_concat(N-1 downto 0) <= bi;
        --pe_4bit : pr_encoder_4bit port map (bi(N-1 downto 0) => bi , bi(3 downto N) => (others => '0'),estimationbo => bo, EO => EO, GS => GS, estimation => estimation ); 
        pe_4bit : pr_encoder_4bit port map (
            --pragma synthesis_off
            Vcc => Vcc, estimation => estimation,
            --pragma synthesis_on
            bi => bi_concat(3 downto 0) , EI => EI, bo => bo, EO => EO, GS => GS ); 
    end generate;
    pe1 : if N = 4 generate
        pe_4bit : pr_encoder_4bit port map(
            --pragma synthesis_off
            Vcc => Vcc, estimation => estimation,
            --pragma synthesis_on
            bi => bi , EI => EI, bo => bo, EO => EO, GS => GS ); 
    end generate;
    pe2 : if N > 4 and N < 8 generate
	bi_concat(N-1 downto 0) <= bi;
        pe_8bit : pr_encoder_8bit port map (
            --pragma synthesis_off
            Vcc => Vcc, estimation => estimation,
            --pragma synthesis_on
            I => bi_concat(7 downto 0) , EI => EI, Y => bo, EO => EO, GS => GS); 
    end generate;
    pe3 : if N = 8 generate
        pe_8bit : pr_encoder_8bit port map (
            --pragma synthesis_off
            Vcc => Vcc, estimation => estimation,
            --pragma synthesis_on
            I => bi , EI => EI, Y => bo, EO => EO, GS => GS); 
    end generate;
    pe4 : if (N > 8 and N < 16) generate
	bi_concat(N-1 downto 0) <= bi;
        pe_16bit : pr_encoder_16bit port map (
            --pragma synthesis_off
            Vcc => Vcc, estimation => estimation,
            --pragma synthesis_on
            I => bi_concat(15 downto 0) , EI => EI, Y => bo, EO => EO, GS => GS ); 
    end generate;
    pe5 : if (N = 16) generate
        pe_16bit : pr_encoder_16bit port map (
            --pragma synthesis_off
            Vcc => Vcc, estimation => estimation,
            --pragma synthesis_on
            I => bi , EI => EI, Y => bo, EO => EO, GS => GS ); 
    end generate;
    pe6 : if (N > 16 and N < 32) generate
	bi_concat(N-1 downto 0) <= bi;
        pe_16bit : pr_encoder_32bit port map (
            --pragma synthesis_off
            Vcc => Vcc, estimation => estimation,
            --pragma synthesis_on
            I => bi_concat(31 downto 0) , EI => EI, Y => bo, EO => EO, GS => GS ); 
    end generate;  
    pe7 : if N = 32 generate
        pe_32bit : pr_encoder_32bit port map (
            --pragma synthesis_off
            Vcc => Vcc, estimation => estimation,
            --pragma synthesis_on
            I => bi , EI => EI, Y => bo, EO => EO, GS => GS); 
    end generate;
  
end architecture;
------------------------------------------------------------------------------------
---- Description: multiplicater on N bits with activity monitoring  
----              - parameters :  delay - simulated delay time of an elementary gate
----                          	width - the lenght of the numbers
----								logic_family - the logic family of the tristate buffer
----								Cload - load capacitance
----              - inputs :  ma, mb - the numbers for multiplication
----                          clk- clock signal
----                          Rn - reset signal
----              - outpus :  mp - result of multiplication
----                          done- indicate the final of multiplication
----                          Vcc- supply voltage 
----                          estimation :  port to monitor power/area estimation
----                          	   for power estimation only 
---- Dependencies: PECore.vhd, PeGates.vhd, Nbits.vhd, auto.vhd, reg_dep.vhd
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;

--use work.PECore.all;
--use work.PEGates.all;
--use work.Nbits.all;
--use work.auto.all;

--entity multip is 
--	generic (width:integer:=32 ;
--	         delay : time := 0 ns ;
--	         logic_family : logic_family_t := default_logic_family ; -- the logic family of the component
--             Cload : real := 0.0 -- capacitive load
--	         );	
--	port (ma,mb : in std_logic_vector (width-1 downto 0); --4/8/16/32
--	      clk, rst : in std_logic;
--	      mp : out std_logic_vector (2*width-1 downto 0);--8/16/32/64
--	      done : out std_logic;
--	      Vcc : in real ; -- supply voltage
--          consumption : out consumption_type := cons_zero
--          );
--end entity;

--architecture behavioral of multip is 

--signal my, sum, lo, hi : std_logic_vector (width-1 downto 0);--4/8/16/32
--signal rn, a1 : std_logic;
--signal loadHI, loadLO, loadM, shft, rsthi : std_logic;
--signal cons : consumption_type_array(1 to 4);

--begin

--a1 <= lo(0);
----b1 <= '1' when out1=31 else '0';
--uut : auto_Structural generic map (width=> width, delay => delay, logic_family => ssxlib ) port map (clk => clk, rn => rn, a => a1, loadHI => loadHI, loadLO => loadLO, loadM => loadM, shft => shft, rsthi => rsthi, done => done, Vcc => Vcc, estimation => estim(1));
--M_i : reg_bidirectional generic map (width => width, delay => delay, logic_family => ssxlib) port map (Input => ma, CK => clk, Clear => rn, S1 => '0', S0 => '0', SR => '0', SL => '0', A => my, Vcc => Vcc, estimation => estim(2));
--LO_i: reg_bidirectional generic map (width => width, delay => delay, logic_family => ssxlib) port map (Input => mb, CK => clk, Clear => rn, S1 => '1', S0 => '0', SR => '0', SL => '0', A => lo, Vcc => Vcc, estimation => estim(3));
--HI_i: reg_bidirectional generic map (width => width, delay => delay, logic_family => ssxlib) port map (Input => sum, CK => clk, Clear => rn, S1 => '0', S0 => '1', SR => '0', SL => '0', A => hi, Vcc => Vcc, estimation => estim(4));

--mp <= hi&lo;
--sum <= my+hi;

--consum: sum_up generic map (N=>4) port map (estim => estim, consumption=>consumption);
--end architecture;
    
----------------------------------------------------------------------------------
-- Description: basic cell of iterative comparator circuit with activity monitoring  
--              - parameters :  delay - simulated delay time of an elementary gate
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--                              Area -  area parameter
--              - inputs :  x,y - numbers to be compared 
--                          EQI- carry input
--              - outpus :  EQO - result of comparation
--                          Vcc- supply voltage 
--                          consumption :  port to monitor dynamic and static consumption
--                          	   for power estimation only 
-- Dependencies: xnor_gate.vhd, and_gate.vhd
----------------------------------------------------------------------------------library IEEE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all; 
use work.Nbits.all;

entity cmp_cell is
     Generic (delay : time := 0 ns;
            logic_family : logic_family_t := default_logic_family; -- the logic family of the component
            Cload: real := 5.0 ; -- capacitive load
            Area: real := 0.0 --parameter area 
             );
    Port ( x : in STD_LOGIC;
           y : in STD_LOGIC;
           EQI : in STD_LOGIC;
           EQO : out STD_LOGIC;
           Vcc : in real  ; -- supply voltage
           estimation : out estimation_type := est_zero);
end cmp_cell;

architecture Behavioral of cmp_cell is

signal net: std_logic;
signal estim : estimation_type_array(1 to 2) := (others => est_zero);


begin
xnor_gate1 : xnor_gate generic map (delay => 0 ns, logic_family => logic_family)
    port map (
        --pragma synthesis_off
        Vcc => Vcc, estimation => estim(1),
        --pragma synthesis_on
         a => x, b=> y, y => net);
and_gate1: and_gate generic map(delay => 0 ns, logic_family => logic_family) 
    port map (
       --pragma synthesis_off
        Vcc => Vcc, estimation => estim(2), 
        --pragma synthesis_on
        a => net, b => EQI, y => EQO);

sum : sum_up generic map (N=>2) port map (estim => estim, estimation => estimation);

end Behavioral;


----------------------------------------------------------------------------------
-- Description: iterative comparator circuit on N bits with activity monitoring  
--              - parameters :  delay - simulated delay time of an elementary gate
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs :  x,y - numbers to be compared 
--                       
--              - outpus :  EQO - result of comparation
--                          Vcc- supply voltage 
--                          estimation :  port to monitor power/area estimation
--                          	   for power estimation only 
-- Dependencies: cmp_cell.vhd 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.PECore.all;
use work.PEGates.all; 
use work.Nbits.all;

entity comparator is
    Generic ( width: integer :=4 ; 
            delay : time := 1 ns;
            logic_family : logic_family_t; -- the logic family of the component
            Cload: real := 5.0 ; -- capacitive load
            Area: real := 0.0 --parameter area 
             );
    Port ( x : in STD_LOGIC_VECTOR (width-1 downto 0);
           y : in STD_LOGIC_VECTOR (width-1 downto 0);
           EQI : in STD_LOGIC;
           EQO : out STD_LOGIC;
           Vcc : in real ; -- supply voltage
           estimation : out estimation_type := est_zero
           );
end comparator;

architecture Behavioral of comparator is

signal EQ : STD_LOGIC_VECTOR (width downto 0);
signal estim : estimation_type_array(1 to width);
 
begin


EQ(0) <=EQI;

gen_cmp_cells:  for i in 0 to width-1 generate
        gen_i : cmp_cell generic map (delay => 0 ns, logic_family => logic_family)
             port map (
                --pragma synthesis_off
                Vcc => Vcc, estimation => estim(i+1), 
                --pragma synthesis_on
                x => x(i), y => y(i), EQI => EQ(i), EQO => EQ(i+1));
end generate gen_cmp_cells;        

EQO<=EQ(width);

sum_up_i : sum_up generic map (N => width) port map (estim => estim, estimation => estimation);

end Behavioral;


----------------------------------------------------------------------------------
-- Descriptioestimationiversal shift register with activity monitoring and Clear
--              - parameters :  delay - simulated delay time of an elementary gate
--                          	width - the length of the words
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs :  Input--the input word 
--                          Clear--the signal for reset
--                          CK-- clock signal
--                          S0,S1--conditioning signals (S0='0', S1='0' - no change; S0='0', S1='1' - shift right; S0='1', S1='0' - shift left; S0='1', S1='1' - parallel load)
--              - outpus :  A - the output word
--                          Vcc  -- supply voltage
--                          estimation :  port to monitor power/area estimation
--									for power estimation only 
-- Dependencies: PECore.vhd, PeGates.vhd, Nbits.vhd, dff_Nbits.vhd, mux4_1.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.PECore.all;
use work.PEGates.all; 
use work.Nbits.all;

entity reg_bidirectional is
    Generic ( width: integer :=4 ; 
            delay : time := 1 ns;
            logic_family : logic_family_t:= default_logic_family; -- the logic family of the component
            Cload: real := 5.0 ; -- capacitive load
            Area: real := 0.0 --parameter area 
             );
    Port ( Input : in STD_LOGIC_VECTOR (width-1 downto 0);
           Clear : in STD_LOGIC;
           CK : in STD_LOGIC;
           S1,S0 : in STD_LOGIC;
           SR, SL : IN STD_LOGIC;
           A : out STD_LOGIC_VECTOR (width-1 downto 0);
           Vcc : in real ; -- supply voltage
           estimation : out estimation_type := est_zero
           );
end entity;

architecture Behavioral of reg_bidirectional is


signal outmux: STD_LOGIC_VECTOR (width-1 downto 0);
signal outdff: STD_LOGIC_VECTOR (width+1 downto 0);
signal estim : estimation_type_array(1 to 2*width);

begin

OUTDFF(0)<=SL;
gen_cells:  for i in  width-1 downto 0 generate
        gen_dff: dff_Nbits generic map (delay => 0 ns,active_edge => TRUE, logic_family => logic_family)
         port map (
            --pragma synthesis_off
            Vcc => Vcc, estimation => estim(i + 1),
            --pragma synthesis_on
            D => outmux(i) , Ck => CK, Rn => Clear, Q => outdff(i), Qn => open);
        gen_mux: mux4_1 generic map( delay => 0 ns, logic_family => logic_family ) 
            port map(
                 --pragma synthesis_off
                 Vcc => Vcc,  estimation => estim(i + width + 1),
                 --pragma synthesis_on
                  I(3) => Input(i), I(2) => outdff(i+2), I(1) => outdff(i), I(0) => outdff(i+1), A(1) => S1, A(0) => S0, Y => outmux(i));
end generate gen_cells;

OUTDFF(width+1)<= SR;        

A <= outdff(width downto 1);
-- pragma synthesis_off
sum_up_i : sum_up generic map (N =>2*width) port map (estim => estim, estimation => estimation);
-- pragma  synthesis_on

end Behavioral;

------------------------------------------------------------------------------------
---- Engineer: Botond Sandor Kirei
---- Project Name: NAPOSIP
---- Description:  Parameterizable implemenation of a state mashine, with D-type Flip Flops and multiplexers
----              - parameters :  logic_family - the logic family of the tristate bufferestimation			Cestimation capacitance
----								N - number of input signals
----								M - number of output signals
----								M - number of states
----								STT - State Transition Table
----								OET - Output Encoding Table
----              - inputs:   bi - bits in
----							clk - clock signal
----                          VCC -  supply voltage (used to compute static power dissipation)
----                          	   for power estimation only 
----              - outputs : bo - bits out
----                          estimation :  port to monitor power/area estimation
----              - dynamic power dissipation can be estimated using the activity signal 
---- Dependencies: PECore.vhd, PEGates.vhd, Nbits.vhd
---- Revision: 0.02 - Added comments
---- Revision: 0.01 - File Created
------------------------------------------------------------------------------------
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--library work;
--use work.PECore.all;
--use work.PEGates.all; 
--use work.Nbits.all;

--entity FSM is
--    Generic ( 
--            logic_family : logic_family_t; -- the logic family of the component
--            Cload: real := 5.0 ; -- capacitive load
--            N : natural := 1;
--			M : natural := 1;
--			S : natural := 1;
--			STT : table ;
--			OET : table 
--             );
--    Port ( bi : in STD_LOGIC_VECTOR (N-1 downto 0);
--           bo : out STD_LOGIC_VECTOR (N-1 downto 0);
--           clk : in STD_LOGIC;
--           Vcc : in real ; -- supply voltage
--           consumption : out consumption_type := cons_zero
--           );
--end entity;

--architecture Behavioral of FSM is


--signal outmux: STD_LOGIC_VECTOR (N-1 downto 0);
--signal outdff: STD_LOGIC_VECTOR (N-1 downto 0);
--signal cons : consumption_type_array(1 to 2*N);
--signal state : std_logic_vector(S-1 downto 0) := STT(1).state;

--begin

----state transition
--process (clk)
--begin
--	if rising_edge(clk) then
--		for i in 1 to STT'right loop
--			if state = STT(i).state and bi = STT(i).control then
--				state <= STT(i).output;
--			end if;
--		end loop;
--	end if;
--end process;

----poutput decoding

--process (state)
--begin
--	bo <= (others => '0');
--	for i in 1 to STT'right loop
--		if state = OET(i).state and bi = OET(i).control then
--			bo <= STT(i).output;
--		end if;
--	end loop;
--end process; 

--estimation <=cons_zero;

--end Behavioral;