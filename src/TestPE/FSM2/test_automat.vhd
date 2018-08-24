library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;


entity test_automat_ctrl is
generic ( delay : time := 100 ns;
		  N : real := 30.0);
end test_automat_ctrl;

architecture Behavioral of test_automat_ctrl is

signal clk,rst : std_logic;   
signal state1,state2,state3 : std_logic_vector(3 downto 0);
signal control_state: std_logic_vector(3 downto 0);   
constant period : time := 33 ns; 
signal cons1, cons2 , cons23: consumption_type;
signal power1, power2, power3 : real := 0.0;
signal vcc : real := 5.0-0.351;

-- component automat is
    -- Generic (delay : time := 1 ns;
             -- logic_family : logic_family_t; -- the logic family of the component
             -- Cload: real := 5.0 ; -- capacitive load
             -- Area: real := 0.0 --parameter area 
              -- );
    -- Port ( CLK : in STD_LOGIC;
           -- RESET : in STD_LOGIC;
           -- Vcc : in real; --supply voltage
           -- Q : out STD_LOGIC_VECTOR (0 to 3);
           -- consumption: out consumption_type := cons_zero );
-- end component;

-- component automat_ctrl is
    -- Generic (delay : time := 1 ns;
             -- logic_family : logic_family_t; -- the logic family of the component
             -- Cload: real := 5.0 ; -- capacitive load
             -- Area: real := 0.0 --parameter area 
              -- );
    -- Port ( CLK : in STD_LOGIC;
           -- RESET : in STD_LOGIC;
           -- Vcc : in real; --supply voltage
           -- Q : out STD_LOGIC_VECTOR (0 to 3);
           -- consumption: out consumption_type := cons_zero );
-- end component;



begin
automat_refetinta: entity work.automat(referinta) generic map ( delay => 0 ns, logic_family => HC) port map (CLK => clk, RESET => rst, Q => _state1, Vcc => vcc, consumption => cons1);
automat_structural: entity work.automat(strutctural) generic map ( delay => 0 ns, logic_family => HC) port map (CLK => clk, RESET => rst, Q => state2, Vcc => vcc, consumption => cons2);
automat_clock_gating: entity work.(optimized) automat generic map ( delay => 0 ns, logic_family => HC) port map (CLK => clk, RESET => rst, Q => state3, Vcc => vcc, consumption => cons3); 
 
gen_clk : process   
          begin     
          clk <= '1';     
          wait for period/2;     
          clk <= '0';     
          wait for period/2; 
end process;

gen_rst : process   
          begin     
          rst <= '1';     
          wait for period/2;     
          clk <= '0';     
          wait; 
end process;

pe1 : power_estimator generic map (time_window => N * period) 
		             port map (consumption => cons1, power => power1);
pe2 : power_estimator generic map (time_window => N * period) 
                     port map (consumption => cons2, power => power2);		             
pe3 : power_estimator generic map (time_window => N * period) 
                     port map (consumption => cons3, power => power3);				             
message: process 
         begin
         wait for 1000 * period;
         assert false report "End Simulation" severity failure ;
end process; 
 
end Behavioral;