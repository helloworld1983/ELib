library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;
use work.automat.all;

entity test_automat is
generic ( delay : time := 100 ns;
		  N : real := 30.0);
end test_automat;

architecture Behavioral of test_automat is

signal clk,rst : std_logic;   
signal state1,state2,state3 : std_logic_vector(3 downto 0);

constant period : time := 33 ns; 
signal cons1, cons2, cons3: consumption_type;
signal power1, power2, power3 : real := 0.0;
signal area1, area2, area3 : real := 0.0;

begin
automat_refetinta: referinta generic map ( logic_family => HC) port map (CLK => clk, clrn => rst, state => state1, consumption => cons1);
automat_structural: structural generic map ( logic_family => HC) port map (CLK => clk, clrn => rst, state => state2, consumption => cons2);
automat_optimizat: optimizat generic map ( logic_family => HC) port map (CLK => clk, clrn => rst, state => state3,  consumption => cons3); 
 
gen_clk : process   
          begin     
          clk <= '1';     
          wait for period/2;     
          clk <= '0';     
          wait for period/2; 
end process;

gen_rst : process   
          begin     
          rst <= '0';     
          wait for period/2;     
          rst <= '1';     
          wait; 
end process;

pe1 : power_estimator generic map (time_window => N * period) 
		             port map (consumption => cons1, power => power1);
pe2 : power_estimator generic map (time_window => N * period) 
                     port map (consumption => cons2, power => power2);		             
pe3 : power_estimator generic map (time_window => N * period) 
                     port map (consumption => cons3, power => power3);	
                     
area1 <= cons1.area*1.0e6;
area2 <= cons2.area*1.0e6;			             
area3 <= cons3.area*1.0e6;			             
message: process 
         begin
         wait for 1000 * period;
         assert false report "End Simulation" severity failure ;
end process; 
 
end Behavioral;