library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity test_auto is
    Generic ( width : integer := 3;
              delay : time := 0 ns;
              N : real := 30.0   
             );
end test_auto;

architecture Behavioral of test_auto is

component auto is
generic (width:integer:=32; --4/8/16/32
	delay : time := 1 ns ;
    logic_family : logic_family_t := default_logic_family; -- the logic family of the component
    Cload : real := 0.0 -- capacitive load
    );
port(clk,rn : in std_logic;
	 a : in std_logic;
	 loadLO : inout std_logic;
	 loadHI, loadM, shft, rsthi, done : out std_logic;
	 Vcc : in real ; -- supply voltage
     consumption : out consumption_type := cons_zero);
end component;


signal a_in, clk_in ,rst_in, eq_in : std_logic;
signal  loadLO0, loadHI0, loadM0, shft0, rsthi0, done0: std_logic;
constant period : time := 20 ns; 
signal cons1, cons2 : consumption_type;
signal power1, power2 : real := 0.0;
signal Vcc : real := 5.0-0.351;

begin
auto1 : entity work.auto(Structural) generic map ( width => width , delay => delay, logic_family => ssxlib, Cload => 10.0e-12 ) port map (clk => clk_in, rn => rst_in, a => a_in, loadLO => loadLO0, loadHI => loadHI0, loadM => loadM0, shft => shft0, rsthi => rsthi0, done => done0, Vcc => Vcc, consumption => cons1);
auto2 : entity work.auto(Behavioral) generic map ( width => width , delay => delay, logic_family => ssxlib, Cload => 10.0e-12 ) port map (clk => clk_in, rn => rst_in, a => a_in, loadLO => loadLO0, loadHI => loadHI0, loadM => loadM0, shft => shft0, rsthi => rsthi0, done => done0, Vcc => Vcc, consumption => cons2);

gen_clk : process   
          begin     
          clk_in <= '1';     
          wait for period;     
          clk_in <= '0';     
          wait for period; 
end process;

gen_rst : process   
          begin     
          rst_in <= '1';     
          wait for 4*period;     
          rst_in <= '0';     
          wait; 
end process;

gen_a : process   
          begin     
          a_in <= '1';     
          wait for 3*period;     
          a_in <= '0';     
          wait for 3*period; 
end process;


pe1 : power_estimator generic map (time_window => N * period) 
		             port map (consumption => cons1, power => power1);
pe2 : power_estimator generic map (time_window => N * period) 
                     port map (consumption => cons2, power => power2);		             
		             
message: process 
         begin
         wait for 1000 * period;
         assert false report "End Simulation" severity failure ;
end process; 


end Behavioral;
