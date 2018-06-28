library ieee;
use ieee.std_logic_1164.all;

entity test_final is
end test_final;

architecture testbench of test_final is
component automat
port (clk, clrn, ina, inb: in std_logic;
	state : out std_logic_vector(2 downto 0);
	power : out real := 0.0);
 end component;
component referinta_automat
	port (clk, clrn, ina, inb: in std_logic;
		state_ref : out std_logic_vector(2 downto 0 )
		);
 end component;
  signal clk, clrn, a, b : std_logic;
   signal state, state_ref : std_logic_vector(2 downto 0);
   constant period : time := 1000 ns;

signal power : real;

begin

-- instantierea modulului testat
  UUT : automat port map (clk => clk, clrn => clrn, ina=> a , inb => b, state => state, power => power); --instantierea referintei
 REF : referinta_automat port map ( clk => clk, clrn => clrn, ina => a, inb => b, state_ref => state_ref); --scenarii

 
 reset_gen_b : process

	begin
		b <= '1';
		clrn <= '0';
		wait for period;
		clrn <= '1';
		wait for 4*period;
		b <= '0';
		wait;
	end process;
gen_a : process

	begin
		a <= '0';
		wait for 3 * period;
		a <= '1';
		wait for 3 * period;
	end process;
	
 gen_clk: process begin
	clk <= '1';
	wait for period/2;
	clk <= '0';
	wait for period/2;
end process;

check: process (state_ref)
begin
	if (Clrn = '1') then
		assert  state = state_ref report "Rezultat diferit de referinta!" severity error ;
	end if;
end process;

end testbench;
 