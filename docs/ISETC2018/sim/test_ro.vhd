library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

library work;
use work.PECore.all;
use work.PEGates.all;

entity test_ro is
	generic ( delay : time := 94 ns;
		N : real := 7.0);
end entity;

architecture test of test_ro is
	signal en : std_logic;
	signal cons : consumption_type;
	signal power : real := 0.0;
begin
	uut : entity work.ro generic map (delay => delay) port map (en => en, VCC => 5.0, cons => cons );
	process begin
		wait for 100 * delay;
		assert false report "End Simulation" severity failure ;
	end process;
	en <= '0', '1' after 10 * delay;

	pe : power_estimator generic map (time_window => N * delay) 
		port map (consumption => cons, power => power);
		
end architecture;
