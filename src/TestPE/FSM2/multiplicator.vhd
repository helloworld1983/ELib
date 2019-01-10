----------------------------------------------------------------------------------
-- Description: multiplicater on N bits with activity monitoring  
--              - parameters :  delay - simulated delay time of an elementary gate
--                          	width - the lenght of the numbers
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs :  ma, mb - the numbers for multiplication
--                          clk- clock signal
--                          Rn - reset signal
--              - outpus :  mp - result of multiplication
--                          done- indicate the final of multiplication
--                          Vcc- supply voltage 
--                          consumption :  port to monitor dynamic and static consumption
--                          	   for power estimation only 
-- Dependencies: PECore.vhd, PeGates.vhd, Nbits.vhd, auto.vhd, reg_dep.vhd
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;
use work.auto.all;

entity multiplicator is 
	generic (width:integer:=32 ;
	         delay : time := 0 ns ;
	         logic_family : logic_family_t := default_logic_family ; -- the logic family of the component
             Cload : real := 0.0 -- capacitive load
	         );	
	port (ma,mb : in std_logic_vector (width-1 downto 0); --4/8/16/32
	      clk, rn : in std_logic;
	      mp : out std_logic_vector (2*width-1 downto 0);--8/16/32/64
	      done : out std_logic;
	      Vcc : in real ; -- supply voltage
          consumption : out consumption_type := cons_zero
          );
end entity;

architecture behavioral of multiplicator is 

signal my, sum, lo, hi : std_logic_vector (width-1 downto 0);--4/8/16/32
signal  a1 : std_logic;
signal loadHI, loadLO, loadM, shft, rsthi : std_logic;
signal cons : consumption_type_array(1 to 4);

begin

a1 <= lo(0);
--b1 <= '1' when out1=31 else '0';
uut : auto_Structural generic map (width=> width, delay => delay, logic_family => ssxlib ) port map (clk => clk, rn => rn, a => a1, loadHI => loadHI, loadLO => loadLO, loadM => loadM, shft => shft, rsthi => rsthi, done => done, Vcc => Vcc, consumption => cons(1));
M_i : reg_bidirectional generic map (width => width, delay => delay, logic_family => ssxlib) port map (Input => ma, CK => clk, Clear => rn, S1 => '0', S0 => '0', SR => '0', SL => '0', A => my, Vcc => Vcc, consumption => cons(2));
LO_i: reg_bidirectional generic map (width => width, delay => delay, logic_family => ssxlib) port map (Input => mb, CK => clk, Clear => rn, S1 => '1', S0 => '0', SR => '0', SL => '0', A => lo, Vcc => Vcc, consumption => cons(3));
HI_i: reg_bidirectional generic map (width => width, delay => delay, logic_family => ssxlib) port map (Input => sum, CK => clk, Clear => rn, S1 => '0', S0 => '1', SR => '0', SL => '0', A => hi, Vcc => Vcc, consumption => cons(4));

mp <= hi&lo;
sum <= my+hi;

consum: sum_up generic map (N=>4) port map (cons=>cons, consumption=>consumption);
end architecture;