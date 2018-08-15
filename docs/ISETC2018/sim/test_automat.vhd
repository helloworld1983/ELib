library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.PECore.all;
use work.PEGates.all;


entity test_automat is
generic ( delay : time := 100 ns;
		  N : real := 30.0);
end test_automat;

architecture Behavioral of test_automat is

signal clk, clrn, a, b : std_logic;   
signal state: std_logic_vector(2 downto 0);   
constant period : time := 33 ns; 
signal cons : consumption_type;
signal power : real := 0.0;
signal vcc : real := 5.0-0.351;

component automat_secv is
    Generic (delay : time := 1 ns;
             logic_family : logic_family_t; -- the logic family of the component
              Cload: real := 5.0 -- capacitive load
              );
    Port ( Clock, Clearn, a, b : in std_logic;  
           Q : out std_logic_vector(2 downto 0);
           Vcc : in real ; --supply voltage
           consumption : out consumption_type);
end component;



begin
maping: automat_secv generic map ( delay => 0 ns, logic_family => HC, Cload => 10.0e-12) port map (Clock => clk, Clearn => clrn, a => a, b => b, Q => state, Vcc => vcc, consumption => cons); 

scenario : process  
           begin 
          --initials values  
            clrn <= '0';     
            a <= '0';    
            b <= '1';  
            wait for 2*period;     
            clrn <= '1';     
             wait;  
end process; 
gen_clk : process   
          begin     
          clk <= '1';     
          wait for period/2;     
          clk <= '0';     
          wait for period/2; 
end process;

pe : power_estimator generic map (time_window => N * period) 
		             port map (consumption => cons, power => power);
		             
message: process 
         begin
         wait for 1000 * period;
         assert false report "End Simulation" severity failure ;
end process; 
 
end Behavioral;

configuration Behavioral_c of test_automat is
	for Behavioral
		for maping : automat_secv  
			use configuration work.automat_secv_behavioral;
		end for;
	end for;
end configuration;
