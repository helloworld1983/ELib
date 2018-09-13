
-----description


-----

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
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


cm_i : consumption_monitor generic map ( N=>4, M=>5, logic_family => logic_family, gate => none_comp, Cload => Cload)
                           port map (sin(0) => clk0 , sin(1) => rn0, sin(2) => a0, sin(3) =>loadLO , Vcc => Vcc, sout(0) => loadHI0, sout(1) => loadM0, sout(2) => shft0, sout(3) => rsthi0, sout(4) => done0, consumption => consumption);

end architecture;


architecture Structural of auto is

signal Q2, Q1, Q0, Q2n, Q1n, Q0n, an, rnn : std_logic ;
signal D2, D1, D0 : STD_LOGIC; 
signal eq0, loadLO0, rsthi0: std_logic;
signal cons : consumption_type_array(1 to 21) := (others => cons_zero);
signal net : std_logic_vector(1 to 5);

component comparator is
    Generic ( width: integer :=4 ; 
            delay : time := 1 ns;
            logic_family : logic_family_t; -- the logic family of the component
            Cload: real := 5.0 ; -- capacitive load
            Area: real := 0.0 --parameter area 
             );
    Port ( x : in STD_LOGIC_VECTOR (width-1 downto 0);
           y : in STD_LOGIC_VECTOR (width-1 downto 0);
           --EQI : in STD_LOGIC;
           EQO : out STD_LOGIC;
           Vcc : in real ; -- supply voltage
           consumption : out consumption_type := cons_zero
           );
end component;

	signal cnt : std_logic_vector(width-1 downto 0);
	signal cnt_en : std_logic;
begin

--eq0 <= eq;
compare_cnt_width1: comparator generic map (width => width, delay => delay, logic_family => logic_family ) port map ( x => cnt,  y => std_logic_vector(to_unsigned(width,width)), EQO => eq0, Vcc => Vcc, consumption => cons(1));
compare_cnt_width2: comparator generic map (width => 3, delay => delay, logic_family => logic_family ) port map ( x(0) => Q0, x(1) => Q1, x(2) => Q2,  y(0) => '0' , y(1) => '0',  y(2) => '0' , EQO => cnt_en, Vcc => Vcc, consumption => cons(2));
--contor
counter : counter_Nbits generic  map (width => width, delay => delay, logic_family => logic_family ) port map ( CLK => CLK, Rn => cnt_en, Q=> cnt, Vcc => Vcc, consumption => cons(3));
--inversoarele
inv4: inv_gate generic map (delay => 0 ns, logic_family => logic_family ) port map (a => a, y => an, Vcc => Vcc, consumption => cons(4));
inv5: inv_gate generic map (delay => 0 ns, logic_family => logic_family ) port map (a => rn, y => rnn, Vcc => Vcc, consumption => cons(5));

--D2
and5_gate1: and5_gate generic map(delay => 0 ns, logic_family => logic_family) port map(a => Q2n, b => Q1n, c => Q0n, d => an ,e => rn , y => D2, Vcc => Vcc, consumption => cons(6));
--D1
and_gate2: and4_gate generic map (delay => delay, logic_family => logic_family) port map (a => Q2n, b => Q1, c => Q0n, d => eq0, y => net(1), Vcc => Vcc, consumption => cons(7));
and_gate3: and3_gate generic map (delay => delay, logic_family => logic_family) port map (a => Q2 , b => Q1n , c => Q0n, y => net(2), Vcc => Vcc, consumption => cons(8));
and_gate4: and3_gate generic map (delay => delay, logic_family => logic_family) port map (a => Q2n , b => Q1n , c => Q0, y => net(3), Vcc => Vcc, consumption => cons(9));
or_gate1: or4_gate generic map (delay => delay, logic_family => logic_family) port map (a => net(1), b => net(2), c => net(3), d => rnn, y => D1, Vcc => Vcc, consumption => cons(10));
--D0
and_gate5: and4_gate generic map (delay => delay, logic_family => logic_family) port map (a => Q2n, b => Q1, c => Q0n, d => eq0, y => net(4), Vcc => Vcc, consumption => cons(11));
and_gate6: and4_gate generic map (delay => delay, logic_family => logic_family) port map (a => Q2n, b => Q1n, c => Q0n, d => a, y => net(5), Vcc => Vcc, consumption => cons(12));
or_gate2: or3_gate generic map (delay => delay, logic_family => logic_family) port map (a => net(4), b => net(5), c => rnn, y => D0, Vcc => Vcc, consumption => cons(13));

--bistabilele
dff2: dff_Nbits generic map( active_edge => true, delay => delay, logic_family => logic_family ) port map ( D => D2, Ck => clk, Rn => rn, Q => Q2, Qn => Q2n, Vcc => Vcc, consumption => cons(14));
dff1: dff_Nbits generic map( active_edge => true, delay => delay, logic_family => logic_family ) port map ( D => D1, Ck => clk, Rn => rn, Q => Q1, Qn => Q1n, Vcc => Vcc, consumption => cons(15));
dff0: dff_Nbits generic map( active_edge => true, delay => delay, logic_family => logic_family ) port map ( D => D0, Ck => clk, Rn => rn, Q => Q0, Qn => Q0n, Vcc => Vcc, consumption => cons(16));
 
--loadHI0
compare1: comparator generic map (width => 3, delay => delay, logic_family => logic_family ) port map ( x(0) => Q0, x(1) => Q1, x(2) => Q2,  y(0) => '1' , y(1) => '0',  y(2) => '0' , EQO => loadHI, Vcc => Vcc, consumption => cons(17));
--loadLO0
compare2: comparator generic map (width => 3, delay => delay, logic_family => logic_family ) port map ( x(0) => Q0, x(1) => Q1, x(2) => Q2,  y(0) => '1' , y(1) => '1',  y(2) => '0' , EQO => loadLO0, Vcc => Vcc, consumption => cons(18));
--shft
compare3: comparator generic map (width => 3, delay => delay, logic_family => logic_family ) port map ( x(0) => Q0, x(1) => Q1, x(2) => Q2,  y(0) => '0' , y(1) => '1',  y(2) => '0' , EQO => shft, Vcc => Vcc, consumption => cons(19));
--rsthi0
compare4: comparator generic map (width => 3, delay => delay, logic_family => logic_family ) port map ( x(0) => Q0, x(1) => Q1, x(2) => Q2,  y(0) => '1' , y(1) => '1',  y(2) => '0' , EQO => rsthi0, Vcc => Vcc, consumption => cons(20));
--done0
inv6 : inv_gate generic map (delay => 0 ns, logic_family => logic_family ) port map (a => rsthi0, y => done, Vcc => Vcc, consumption => cons(21));

loadLO <= loadLO0;
loadM <= loadLO0;
rsthi <= rsthi0;

sum_up_i : sum_up generic map (N => 21) port map (cons => cons, consumption => consumption);

end Structural;
