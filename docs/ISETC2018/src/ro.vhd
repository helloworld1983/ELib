library ieee; 
use ieee.std_logic_1164.all; 
library work;
use work.PECore.all;
use work.PEGates.all;

entity ro is
	generic (N : natural:= 3; -- the number of stages in the oscillator
			delay : time := 1 ns); -- propagaion delay of a delay cell
	port ( en : in std_logic;
			Vcc : real :=5.0;
			consumption : out consumption_type );
end entity;

architecture struct of ro is
	signal cons : consumption_type_array (1 to N);
	signal clks : std_logic_vector( N downto 0);
begin
	first_cell : nand_gate generic map ( delay => delay, logic_family => cmos, Cload => 47.0e-12) port map ( a => en, b => clks(0), y => clks(1), Vcc => Vcc, consumption => cons(1));
	cell : for i  in 1 to N-1 generate
		delay_cells : inv_gate generic map ( delay => delay, logic_family => cmos, Cload => 47.0e-12) port map ( a => clks(i), y => clks(i+1), Vcc => Vcc, consumption => cons(i+1));
	end generate;
	clks(0) <= clks(N);
	cons_sum: sum_up generic map (N => N)	port map (cons=> cons, consumption => consumption);
end architecture;
