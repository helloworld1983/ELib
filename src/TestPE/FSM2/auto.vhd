library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;-- ca sa scoti toate erorile de aici, in modulul pe_Nbits.vhd trebuie sa comentezi total componenta multip.vhd

package auto is 

component auto_behavioral is
generic (width:integer:=32; --4/8/16/32
	delay : time := 0 ns ;
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


component auto_structural is
generic (width:integer:=32; --4/8/16/32
	delay : time := 0 ns ;
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

end package;


library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity auto_behavioral is
generic (
    width:integer:=32; --4/8/16/32
	delay : time := 0 ns ;
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

architecture Behavioral of auto_behavioral is
type state_t is (start, adunare, deplasare, gata, nimic);
signal current_state, next_state : state_t;
signal cnt : integer :=0;


begin

	process(clk)
	begin
		if rising_edge (clk) then --registru
			if rn = '0' then
				current_state <= gata;
			else
				current_state <= next_state;
			end if;
		end if;
	end process; ---------------------------------

	process (current_state, a, cnt, rn)
	begin
		if rn='0' then
			next_state <= gata;
		else
			case (current_state) is
			when start =>
				if (a = '1') then
					next_state <= adunare;
				else
					next_state <= nimic; --era deplasare
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

	process (clk)
	begin
		if rising_edge (clk) then
			if current_state = gata then
				cnt <= 0;
			else if current_state = start then
				cnt <= cnt+1;
				end if;
			end if;
		end if;
	end process;

loadHI <='1' when current_state = adunare else '0';
loadLO <='1' when current_state = gata else '0';
loadM <= loadLO;
shft <= '1' when current_state = deplasare else '0';
rsthi <='0' when current_state = gata else '1';
done <='1' when current_state = gata else '0';

consumption <= cons_zero;

end architecture;




library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity auto_structural is
generic (width:integer:=32; --4/8/16/32
	delay : time := 0 ns ;
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
architecture Structural of auto_structural is

signal Q2, Q1, Q0, Q2n, Q1n, Q0n, an, rnn : std_logic ;
signal D2, D1, D0 : STD_LOGIC; 
signal eq, loadLO0, done0: std_logic;
signal cons : consumption_type_array(1 to 23) := (others => cons_zero);
signal net : std_logic_vector(1 to 6);
signal cnt : std_logic_vector(width-1 downto 0);
signal cnt_en, en,enn : std_logic;

begin
compare_cnt_width1: comparator generic map (width => 3, delay => delay, logic_family => logic_family ) port map ( x(0) => Q0, x(1) => Q1, x(2) => Q2,  y(0) => '0' , y(1) => '0',  y(2) => '0' ,EQI => '1', EQO => cnt_en, Vcc => Vcc, consumption => cons(1));
compare_cnt_width2: comparator generic map (width => width, delay => delay, logic_family => logic_family ) port map ( x => cnt,  y => std_logic_vector(to_unsigned(width,width)), EQI => '1', EQO => eq, Vcc => Vcc, consumption => cons(2));
compare_cnt_width3: comparator generic map (width => 3, delay => delay, logic_family => logic_family ) port map ( x(0) => Q0, x(1) => Q1, x(2) => Q2,  y(0) => '1' , y(1) => '1',  y(2) => '0' ,EQI => '1', EQO => en, Vcc => Vcc, consumption => cons(3));
--counter
inv6: inv_gate generic map (delay => 0 ns, logic_family => logic_family ) port map (a => en, y => enn, Vcc => Vcc, consumption => cons(4));
counter : counter_we_Nbits generic  map (width => width, delay => delay, logic_family => logic_family ) port map ( CLK => clk, Rn => enn ,En => cnt_en, Q => cnt, Vcc => Vcc, consumption => cons(5));
--inversoarele
inv4: inv_gate generic map (delay => 0 ns, logic_family => logic_family ) port map (a => a, y => an, Vcc => Vcc, consumption => cons(6));
inv5: inv_gate generic map (delay => 0 ns, logic_family => logic_family ) port map (a => rn, y => rnn, Vcc => Vcc, consumption => cons(7));

--D2
and5_gate1: and5_gate generic map(delay => 0 ns, logic_family => logic_family) port map(a => Q2n, b => Q1n, c => Q0n, d => an ,e => rn , y => D2, Vcc => Vcc, consumption => cons(8));
--D1
and_gate2: and4_gate generic map (delay => delay, logic_family => logic_family) port map (a => Q2n, b => Q1, c => Q0n, d => eq, y => net(1), Vcc => Vcc, consumption => cons(9));
and_gate3: and3_gate generic map (delay => delay, logic_family => logic_family) port map (a => Q2 , b => Q1n , c => Q0n, y => net(2), Vcc => Vcc, consumption => cons(10));
and_gate4: and3_gate generic map (delay => delay, logic_family => logic_family) port map (a => Q2n , b => Q1n , c => Q0, y => net(3), Vcc => Vcc, consumption => cons(11));
or_gate1: or4_gate generic map (delay => delay, logic_family => logic_family) port map (a => net(1), b => net(2), c => net(3), d => rnn, y => D1, Vcc => Vcc, consumption => cons(12));
--D0
and_gate5: and4_gate generic map (delay => delay, logic_family => logic_family) port map (a => Q2n, b => Q1, c => Q0n, d => eq, y => net(4), Vcc => Vcc, consumption => cons(13));
and_gate6: and4_gate generic map (delay => delay, logic_family => logic_family) port map (a => Q2n, b => Q1n, c => Q0n, d => a, y => net(5), Vcc => Vcc, consumption => cons(14));
or_gate2: or3_gate generic map (delay => delay, logic_family => logic_family) port map (a => net(4), b => net(5), c => rnn, y => D0, Vcc => Vcc, consumption => cons(15));

--bistabilele
dff2: dff_Nbits generic map( active_edge => true, delay => delay, logic_family => logic_family ) port map ( D => D2, Ck => clk, Rn => '1', Q => Q2, Qn => Q2n, Vcc => Vcc, consumption => cons(16));
dff1: dff_Nbits generic map( active_edge => true, delay => delay, logic_family => logic_family ) port map ( D => D1, Ck => clk, Rn => '1', Q => Q1, Qn => Q1n, Vcc => Vcc, consumption => cons(17));
dff0: dff_Nbits generic map( active_edge => true, delay => delay, logic_family => logic_family ) port map ( D => D0, Ck => clk, Rn => '1', Q => Q0, Qn => Q0n, Vcc => Vcc, consumption => cons(18));
 
--loadHI
compare1: comparator generic map (width => 3, delay => delay, logic_family => logic_family ) port map ( x(0) => Q0, x(1) => Q1, x(2) => Q2,  y(0) => '1' , y(1) => '0',  y(2) => '0' , EQI => '1', EQO => loadHI, Vcc => Vcc, consumption => cons(19));
--loadLO0                                                                                                                              
compare2: comparator generic map (width => 3, delay => delay, logic_family => logic_family ) port map ( x(0) => Q0, x(1) => Q1, x(2) => Q2,  y(0) => '1' , y(1) => '1',  y(2) => '0' , EQI => '1', EQO => loadLO0, Vcc => Vcc, consumption => cons(20));
--shft                                                                                                                                  
compare3: comparator generic map (width => 3, delay => delay, logic_family => logic_family ) port map ( x(0) => Q0, x(1) => Q1, x(2) => Q2,  y(0) => '0' , y(1) => '1',  y(2) => '0' , EQI => '1', EQO => shft, Vcc => Vcc, consumption => cons(21));
--done0                                                                                                                                 
compare4: comparator generic map (width => 3, delay => delay, logic_family => logic_family ) port map ( x(0) => Q0, x(1) => Q1, x(2) => Q2,  y(0) => '1' , y(1) => '1',  y(2) => '0' , EQI => '1', EQO => done0, Vcc => Vcc, consumption => cons(22));
--rsthi
inv7 : inv_gate generic map (delay => 0 ns, logic_family => logic_family ) port map (a => done0, y => rsthi, Vcc => Vcc, consumption => cons(23));

loadLO <= loadLO0;
loadM <= loadLO0;
done <= done0;

sum_up_i : sum_up generic map (N => 23) port map (cons => cons, consumption => consumption);

end Structural;
