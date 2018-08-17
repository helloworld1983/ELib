library ieee;
use ieee.std_logic_1164.all;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity reg_dep is
	generic (width : natural :=32 ;
	         delay : time := 1 ns ;
             logic_family : logic_family_t := default_logic_family; -- the logic family of the component
             Cload : real := 0.0 -- capacitive load 
             );
                
	port (pin : in std_logic_vector (width-1 downto 0);
	      clk, shft, ld, rst, sin : in std_logic;
	      y : inout std_logic_vector (width-1 downto 0);
	      Vcc : in real ; -- supply voltage
          consumption : out consumption_type := cons_zero);
end entity;

architecture behavioral of reg_dep is 
begin
	process (clk,rst)
	begin
		
		if clk'event and clk ='1' then
			if rst='0' then 
				y<=(others=>'0');  --umple vectorul cu valori de 0		
			elsif ld='1' then
				y<=pin;
			elsif (shft='1') then
				y<=sin&y(width-1 downto 1);
			end if;
		end if;
	end process;
	
	consumption <= cons_zero;
end architecture;
		
