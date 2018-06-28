library IEEE;
use ieee.std_logic_1164.all;

entity referinta_automat is
port( clk, clrn , ina , inb : in std_logic;
	state_ref: out std_logic_vector(2 downto 0));
	
end entity;

architecture behavior of referinta_automat is
  signal current_state , next_state:std_logic_vector(2 downto 0);

begin
reg: process (CLK)
	begin
	if (clrn = '0') then
		current_state <= "000";
	elsif rising_edge(CLK) then
		current_state <= next_state;
	end if;
end process;

sel:process (current_state,ina,inb)
begin
	case current_state is
		when "000" => if ina ='1' then
				next_state<= "001";
			else
				next_state<= "000";
			end if;

		when "001" => next_state<= "010";

		when "010" => next_state<= "100";

		when "100" => if inb='1' then
				next_state<="001";
				else
				next_state<="101";
				end if;

		when "101" => if ina = '1' then
				next_state<= "101";
				else
				next_state<= "110";
				end if;
		when "110" => next_state <="000";
		when others => next_state <= "000";
	end case;
end process;

state_ref<= current_state;

end behavior ;