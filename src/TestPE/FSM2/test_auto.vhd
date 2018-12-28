library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;
use work.auto.all;


entity test_auto is
    Generic ( width : integer := 8;
              delay : time := 1 ns;
              N : real := 10.0   
             );
end test_auto;

architecture Behavioral of test_auto is

signal a_in, clk_in ,rst_in : std_logic;
signal  loadLO0, loadHI0, loadM0, shft0, rsthi0, done0: std_logic;
signal  loadLO1, loadHI1, loadM1, shft1, rsthi1, done1: std_logic;
constant period : time := 20 ns; 
signal cons1, cons2: consumption_type := (0.0,0.0,0.0);
signal power1, power2 : real := 0.0;
signal area1, area2 : real := 0.0;
signal Vcc : real := 5.0;
 

begin
auto1 : auto_Structural generic map ( width => width , delay => delay, logic_family => ssxlib, Cload => 10.0e-12 ) port map (clk => clk_in, rn => rst_in, a => a_in, loadLO => loadLO0, loadHI => loadHI0, loadM => loadM0, shft => shft0, rsthi => rsthi0, done => done0, Vcc => Vcc, consumption => cons1);
auto2 : auto_Behavioral generic map ( width => width , delay => delay, logic_family => ssxlib, Cload => 10.0e-12 ) port map (clk => clk_in, rn => rst_in, a => a_in, loadLO => loadLO1, loadHI => loadHI1, loadM => loadM1, shft => shft1, rsthi => rsthi1, done => done1, Vcc => Vcc, consumption => cons2);

gen_clk : process   
          begin     
          clk_in <= '1';     
          wait for period;     
          clk_in <= '0';     
          wait for period; 
end process;

gen_rst : process   
          begin     
          rst_in <= '0';     
          wait for 6*period;     
          rst_in <= '1';     
          wait until done1 = '1';
          wait for period;
end process;

gen_a : process   
          begin     
          a_in <= '1';     
          wait for 10*period;     
          a_in <= '0';     
          wait for 10*period; 
end process;


pe1 : power_estimator generic map (time_window => N * period) 
		             port map (consumption => cons1, power => power1);
pe2 : power_estimator generic map (time_window => N * period) 
                     port map (consumption => cons2, power => power2);		             


area1 <= cons1.area*1.0e6;
area2 <= cons2.area*1.0e6;	
		             
message: process 
         begin
         wait for 1000 * period;
         assert false report "End Simulation" severity failure ;
end process; 



end Behavioral;
