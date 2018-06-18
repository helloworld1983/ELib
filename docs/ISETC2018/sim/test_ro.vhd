library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.PELib.all;
use xil_defaultlib.PEGates.all;

entity test_ro is
	generic ( delay : time := 94 ns;
		N : real := 7.0);
end entity;

architecture test of test_ro is
	signal en : std_logic;
	signal cons : consumption_type;
	signal power : real := 0.0;
--	signal cons1, cons2 : consumption_type := (0.0, 0.0);
--	signal delta : real ;
--	signal dynamic_delta : real := 1.0;
begin
	uut : entity xil_defaultlib.ro
	generic map (delay => delay) 
	port map (en => en, cons => cons );
	process begin
		wait for 100 * delay;
		assert false report "End Simulation" severity failure ;
	end process;
	en <= '0', '1' after 10 * delay;

	-- convert energy to power - operating frequency / or time period should be known!!
	--cons1 <=  transport cons after N * delay;
	--delta <= real(delay/1 ns) * 1.0e-9;
	--dynamic_delta <= (cons.dynamic - cons1.dynamic);
	--power <=  0.0 when dynamic_delta = -1.0e+308 else dynamic_delta / N / delta + cons2.static;

	pe : power_estimator generic map (time_window => N * delay) 
		port map (consumption => cons, power => power);
		
end architecture;
