library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

library work;
use work.PEcore.all;
use work.PEGates.all;

entity test_sr_cell is
generic ( delay : time := 10 ns;
		  N : real := 6.0);
end test_sr_cell;

architecture Behavioral of test_sr_cell is
    signal start : std_logic;
	signal cons : consumption_type;
	signal power : real := 0.0;
	signal ck : std_logic_vector ( 1 to 6);
	
begin

uut : entity work.sr_cell
	generic map (delay => delay, logic_family => HC) 
	port map (start => start, CLK => ck, Vcc => 5.0 ,consumption => cons );

	--start <= '1', '0' after 10 * delay;
	gen_start : process   
              begin     
              start <= '0' ;     
              wait for 50 ns;     
              start <= '1';     
              wait; 
    end process;
	
	pe : power_estimator generic map (time_window => N * delay) port map (consumption => cons, power => power);

end Behavioral;
