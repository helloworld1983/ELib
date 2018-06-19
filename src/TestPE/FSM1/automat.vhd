library IEEE;

use IEEE.std_logic_1164.all;

entity automat is 
	port ( clk ,clrn, ina, inb:in std_logic;
	       state:out std_logic_vector(2 downto 0));
end entity;

architecture structural of automat is
component ic163 is
port(clk, clrn, loadn, enp, ent, a, b, c, d:in std_logic;
     rco, qa, qb,qc,qd:out std_logic);
end component;

--componente

component inv is
port(a:in std_logic;
     F: out std_logic);
end component;

component mux4 is
port( A1, A0 : in std_logic;
      I3, I2, I1, I0 : in std_logic;
      Y : out std_logic);
end component;

component or2 is

port (a,b: in std_logic;
	F: out std_logic);
end component;

signal inpt,inld,qa,qb,qc,a,b,c: std_logic;
signal net1, net2, net3 : std_logic;
signal an,bn,qan,qbn: std_logic;

begin

U0:ic163 port map (clk=>clk ,clrn=>clrn,loadn=>inld,enp=>inpt,ent=>inpt,d=>'0',c=>c,b=>b,a=>a,qc=>qc,qb=>qb,qa=>q

--C
U1:mux4 port map(I0=>'0',I1=>qan, I2=>'0', I3=>'0',A1=>qc, A0=>qb, Y=>c);

--B
U2: b<='0';

--A
U3: a<=qbn;

--LD
U4: or2 port map (a=>bn, b=>qa,F=>net1);
U5: mux4 port map(I0=>'1', I1=>'0', I2=>net1, I3=>'0', A1=>qc, A0=>qb, Y=>inld);

--PT
U6: or2 port map (a=>ina, b=>qa,F=>net2);
U7: or2 port map (a=>an, b=>qan, F=>net3);
U8: mux4 port map (I0=>net2, I1=>'0', I2=>net3, I3=>'0',A1=>qc, A0=>qb, Y=>inpt);

--inv--
U9:inv port map (a=>ina, F=>an);
U10:inv port map (a=>inb, F=>bn);
U11:inv port map (a=>qa, F=>qan);
U12:inv port map (a=>qb, F=>qbn);

state<= qc & qb & qa;

end architecture;		