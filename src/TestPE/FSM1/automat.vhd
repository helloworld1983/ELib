library IEEE;
use IEEE.std_logic_1164.all;
use work.PElib.all;
use work.PEGates.all;

entity automat is 
	port ( clk, clrn, ina, inb: in std_logic;
	       state:out std_logic_vector(2 downto 0);
		   power : out real);
end entity;

architecture structural of automat is


	signal inpt,inld,qa,qb,qc,a,b,c: std_logic;
	signal net1, net2, net3 : std_logic;
	signal an,bn,qan,qbn: std_logic;
	
	signal cons : consumption_type_array (1 to 11) := ( others => (0.0,0.0));
	signal consumption : consumption_type := (0.0,0.0);
begin

	U0:num74163 generic map (logic_family => HC, gate => and_comp) port map (clk=>clk, clrn=>clrn, loadn=>inld, p => inpt, t => inpt, d=>'0', c=>c, b=>b, a=>a, qd => open, qc=>qc, qb=>qb, qa=>qa, VCC => 5.0, consumption => cons(11));

	--C
	U1:mux4_1 generic map (delay => 2 ns, logic_family => HC, Cload => 10.0e-12) port map(I(0)=>'0',I(1)=>qan, I(2)=>'0', I(3)=>'0',A(1)=>qc, A(0)=>qb, Y=>c, VCC => 5.0, consumption => cons(1));

	--B
	U2: b<='0';

	--A
	U3: a<=qbn;

	--LD
	U4: or_gate generic map (delay => 2 ns, logic_family => HC, gate => or_comp, Cload => 10.0e-12) port map (a=>bn, b=>qa,y=>net1, VCC => 5.0, consumption => cons(2));
	U5: mux4_1 generic map (delay => 3 ns, logic_family => HC, Cload => 10.0e-12) port map(I(0)=>'1', I(1)=>'0', I(2)=>net1, I(3)=>'0', A(1)=>qc, A(0)=>qb, Y=>inld, VCC => 5.0, consumption => cons(3));

	--PT
	U6: or_gate generic map (delay => 3 ns, logic_family => HC, gate => or_comp, Cload => 10.0e-12) port map (a=>ina, b=>qa,y=>net2, VCC => 5.0, consumption => cons(4));
	U7: or_gate generic map (delay => 2 ns, logic_family => HC, gate => or_comp, Cload => 10.0e-12) port map (a=>an, b=>qan, y=>net3, VCC => 5.0, consumption => cons(5));
	U8: mux4_1 generic map (delay => 3 ns, logic_family => HC, Cload => 10.0e-12) port map (I(0)=>net2, I(1)=>'0', I(2)=>net3, I(3)=>'0',A(1)=>qc, A(0)=>qb, Y=>inpt, VCC => 5.0, consumption => cons(6));

	--inv--
	U9:inv_gate generic map (delay => 2 ns, logic_family => HC, gate => inv_comp, Cload => 10.0e-12) port map (a=>ina, y=>an, VCC => 5.0, consumption => cons(7));
	U10:inv_gate generic map (delay => 1 ns, logic_family => HC, gate => inv_comp, Cload => 10.0e-12) port map (a=>inb, y=>bn, VCC => 5.0, consumption => cons(8));
	U11:inv_gate generic map (delay => 2 ns, logic_family => HC, gate => inv_comp, Cload => 10.0e-12) port map (a=>qa, y=>qan, VCC => 5.0, consumption => cons(9));
	U12:inv_gate generic map (delay => 1 ns, logic_family => HC, gate => inv_comp, Cload => 10.0e-12) port map (a=>qb, y=>qbn, VCC => 5.0, consumption => cons(10));
	
	state<= qc & qb & qa;

	U13 : sum_up generic map (N=>11) port map (cons => cons, consumption => consumption);
	
	U14 : power_estimator generic map (time_window => 10000 ns) port map (consumption => consumption, power => power );
end architecture;		