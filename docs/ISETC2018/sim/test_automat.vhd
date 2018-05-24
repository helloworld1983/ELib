library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.PELib.all;
use work.PEGates.all;


entity test_automat is
generic ( delay : time := 100 ns;
		  N : real := 7.0);
end test_automat;

architecture Behavioral of test_automat is

signal clk, clrn, a, b : std_logic;   
signal state: std_logic_vector(2 downto 0);   
constant period : time := 40 ns; 
signal cons : consumption_type;
signal power : real := 0.0;

begin
maping: entity work.automat_secv generic map (delay => delay) port map (Clock => clk, Clearn => clrn, a => a, b => b, Q => state, consumption => cons); 

scenario : process  
           begin 
          --initials values  
            clrn <= '0';     
            a <= '0';    
            b <= '0';  
            wait for period;     
            clrn <= '1';     
            wait for 20*period;     
             a <= '0';    
             b <= '1';
             wait for 3*period;
             a <= '1';    
             b <= '0';
             wait for 3*period;
             a <= '1';    
             b <= '0';
             wait for 3*period;
             a <= '1';    
             b <= '1';
             wait for 12*period;  
end process; 
gen_clk : process   
          begin     
          clk <= '1';     
          wait for period/2;     
          clk <= '0';     
          wait for period/2; 
end process;

pe : power_estimator generic map (time_window => N * delay) 
		             port map (consumption => cons, power => power);
		             
message: process 
         begin
         wait for 100 * delay;
         assert false report "End Simulation" severity failure ;
end process; 
 
end Behavioral;