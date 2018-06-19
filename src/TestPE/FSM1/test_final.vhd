library ieee;
use ieee.std_logic_1164.all;

entity test_final is
end test_final;

architecture testbench of test_final is
component automat
port (clk, clrn, ina, inb: in std_logic;
	state : out std_logic_vector(2 downto 0));
 end component;
component referinta_automat
	port (clk, clrn, ina, inb: in std_logic;
		state_ref : out std_logic_vector(2 downto 0 ));
 end component;
  signal clk, clrn, a, b : std_logic;
   signal state, state_ref : std_logic_vector(2 downto 0);
   constant period : time := 20 ns;
begin

-- instantierea modulului testat
  UUT : automat port map (clk => clk, clrn => clrn, ina=> a , inb => b, state => state); --instantierea referintei
 REF : referinta_automat port map ( clk => clk, clrn => clrn, ina => a, inb => b, state_ref => state_ref); --scenarii
scenario : process

	begin

a <= '0';
b <= '0';
clrn <= '0';
wait for period;
clrn <= '1';
 wait for 2*period;
a <= '1';
wait for 2*period;
b <= '1';
 wait for 2*period;
b <= '0' ;
wait for 2*period;
a <='0';
wait 
end process;
 gen_clk: process
begin
clk <= '1';
wait for period/2;
clk <= '0';
wait for period/2;
end process;
check: process (state)
begin
	if state /= state_ref then
 	 report "Rezultat diferit de referinta!";
	end if;
	end process;
end testbench;
 