
-----description


-----

library ieee;
use ieee.std_logic_1164.all;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity auto is
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
end entity;

architecture behavioral of auto is
type state_t is (start, adunare, deplasare, gata, nimic);
signal current_state, next_state : state_t;
signal cnt : integer :=0;
signal clk0, rn0, a0, loadLO0, loadHI0, loadM0, shft0, rsthi0, done0: std_logic;

begin

clk0 <= clk;
rn0 <= rn;
a0 <= a;
	process(clk0)
	begin
		if rising_edge (clk0) then --registru
			if rn0 = '0' then
				current_state <= gata;
			else
				current_state <= next_state;
			end if;
		end if;
	end process; ---------------------------------

	process (current_state, a0, cnt, rn0)
	begin
		if rn0='0' then
			next_state <= gata;
		else
			case (current_state) is
			when start =>
				if (a0 = '1') then
					next_state <= adunare;
				else
					next_state <= nimic; --era deplas
				end if;

			when adunare =>
				next_state <= deplasare;

			when nimic =>
				next_state <= deplasare;

			when deplasare =>
				if (cnt = width) then
					next_state <= gata;
				else
					next_state <= start;
				end if;
			when gata =>
				next_state <= start;

			when others =>
				next_state <= gata;
			end case;
		end if;
	end process;

	process (clk0)
	begin
		if rising_edge (clk0) then
			if current_state = gata then
				cnt <= 0;
			else if current_state = start then
				cnt <= cnt+1;
				end if;
			end if;
		end if;
	end process;

loadHI0 <='1' when current_state = adunare else '0';
loadLO0 <='1' when current_state = gata 	else '0';
loadM0 <= loadLO0;
shft0 <= '1' when current_state = deplasare else '0';
rsthi0 <='0' when current_state = gata else '1';
done0 <='1' when current_state = gata else '0';


loadLO <= loadLO0;
loadHI <= loadHI0;
loadM <= loadM0;
shft <= shft0;
rsthi <= rsthi0;
done <= done0;


cm_i : consumption_monitor generic map ( N=>4, M=>6, logic_family => logic_family, gate => none_comp, Cload => Cload)
                           port map (sin(0) => clk0 , sin(1) => rn0, sin(2) => a0, sin(3) =>loadLO , Vcc => Vcc, sout(0) => loadHI0, sout(1) => loadM0, sout(2) => shft0, sout(3) => rsthi0, sout(4) => done0, consumption => consumption);

end architecture;

architecture stuctural_one_hot of auto is
	signal Q,D : std_logic_vector(4 downto 0);
	signal cons : consumption_type_array (1 to ) := ( others => (0.0,0.0));
	signal consumption : consumption_type := (0.0,0.0);
begin
--  instantierile bistabilelor Q 4..0

-- logica pentru D(4)
-- logica pentru D(3)
-- logica pentru D(2)
-- logica pentru D(1)
-- logica pentru D(0)

-- insumare consumption
 	SUM : sum_up generic map (N=>) port map (cons => cons, consumption => consumption);
end architecture;

architecture stuctural_moore of auto is
	signal Q,D : std_logic_vector(2 downto 0);
	signal cons : consumption_type_array (1 to ) := ( others => (0.0,0.0));
	signal consumption : consumption_type := (0.0,0.0);
begin

--  instantierile bistabilelor Q 2..0

-- logica pentru D(2)
-- logica pentru D(1)
-- logica pentru D(0)

-- insumare consumption
 	SUM : sum_up generic map (N=>) port map (cons => cons, consumption => consumption);
 
end architecture;
