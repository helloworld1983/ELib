library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity test_multiplicator is
	generic (width:integer:=4;
	         N : real := 10.0);
end entity;

architecture test of test_multiplicator is
	
	component multiplicator
		generic (width:integer:=32 ;
                 delay : time := 0 ns ;
                 logic_family : logic_family_t := default_logic_family ; -- the logic family of the component
                 Cload : real := 0.0 -- capacitive load
                 );    
        port (ma,mb : in std_logic_vector (width-1 downto 0); --4/8/16/32
              clk, rn : in std_logic;
              mp : out std_logic_vector (2*width-1 downto 0);--8/16/32/64
              done : out std_logic;
              Vcc : in real ; -- supply voltage
              consumption : out consumption_type := cons_zero
              );
	end component;

signal mat : std_logic_vector (width-1 downto 0) :=(others => '0');--4/8/16/32
signal mbt : std_logic_vector (width-1 downto 0) :=(others => '0');
signal clkt, rstt, tdone : std_logic;
signal mpt : std_logic_vector (2*width-1 downto 0);--8/16/32/64
signal count : std_logic_vector (width-1 downto 0);
constant vcc : real := 5.0;
constant period : time := 33 ns;
signal cons1: consumption_type;
signal power1: real := 0.0;


begin
uut : multiplicator generic map(width => width) port map (ma => mat, mb => mbt, clk => clkt, rn => rstt, mp => mpt, done => tdone, Vcc => vcc, consumption => cons1);

rstt <='1', '0' after 100 ns;

process
	begin
	clkt <= '0';
	wait for 10 ns;
	clkt <= '1';
	wait for 10 ns;
end process;

process (clkt, rstt)
	begin 
	if rstt='1' then count <=(others => '0');
	elsif (rising_edge(clkt)) then
		if count = std_logic_vector(to_unsigned(width,width)) then --13 pt 4 biti/25 pt 8 biti/97 pt 32 biti (N*3+1)
		   count <=(others => '0');
		mat <= mat + '1';
		mbt <= mbt + '1';
		else 
		   count <= count + 1;
		end if;
	end if;
end process;

pe1 : power_estimator generic map (time_window => N * period) 
		             port map (consumption => cons1, power => power1);

end architecture;
