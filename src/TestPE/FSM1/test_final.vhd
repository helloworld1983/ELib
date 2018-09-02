library ieee;
use ieee.std_logic_1164.all;
use work.PECore.all;
use work.automat.all;

entity test_final is
end test_final;

architecture testbench of test_final is

   signal clk, clrn, a, b : std_logic;
   signal state1, state2, state_ref : std_logic_vector(2 downto 0);
   constant period : time := 100 ns;

	signal power1, power2 : real;
	signal area1, area2 : real;
	
	signal cons1, cons2 : consumption_type;

begin

-- instantierea modulului testat
 A1 : automat_implementare1 port map (clk => clk, clrn => clrn, ina=> a , inb => b, state => state1, consumption => cons1); --instantierea implementarii cu numarator 74163
 A2 : automat_implementare2 port map (clk => clk, clrn => clrn, ina=> a , inb => b, state => state2, consumption => cons2); --instantierea implementarii cu bistabile 74hc74
 REF : automat_referinta port map ( clk => clk, clrn => clrn, ina => a, inb => b, state_ref => state_ref); --instantierea referintei

scenario : process begin
	a <= '1';
	b <= '0';
	clrn <= '0';
	wait for 2*period;
	clrn <= '1';
	wait;
end process;

 gen_clk: process
begin
clk <= '1';
wait for period/2;
clk <= '0';
wait for period/2;
end process;
check1: process (state1)
begin
	if state1 /= state_ref then
 	 report "Rezultat diferit de referinta!";
	end if;
	end process;
check2: process (state2)
begin
	if state2 /= state_ref then
 	 report "Rezultat diferit de referinta!";
	end if;
	end process;	
	
pe1 : power_estimator generic map (time_window => 500 * period) 
		             port map (consumption => cons1, power => power1);
pe2 : power_estimator generic map (time_window => 1000 * period) 
                     port map (consumption => cons2, power => power2);		             
                     
area1 <= cons1.area*1.0e6;
area2 <= cons2.area*1.0e6;			             
	
end testbench;
 