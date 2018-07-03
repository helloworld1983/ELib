----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description:  Priority encoder on N bits with activity monitroing
--              - parameters :  N - number of input 
--								delay - simulated delay time of an elementary gate
--								logic_family - the logic family of the tristate buffer
--								Cload - load capacitance
--              - inputs:   bi - bits in
--                          VCC -  supply voltage (used to compute static power dissipation)
--                          	   for power estimation only 
--              - outputs : bo - the priotity number
--							EO(Enable output), GS(Group select)
--                          consumption :  port to monitor dynamic and static consumption 
--                          	   for power estimation only 
-- Dependencies: PElib.vhd, PEgates.vhd, Nbits.vhd
-- Revision: 0.02 - Botond Sandor Kirei
-- Revision: 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all; 

library work;
use work.PElib.all;
use work.PEGates.all; 
use work.Nbits.all;

entity pe_Nbits is
          Generic ( N: natural := 4;
				   delay : time := 0 ns;
				   logic_family : logic_family_t; -- the logic family of the component
                   Cload: real := 5.0 -- capacitive load
                   );
		    Port (  ei : in std_logic;
              		bi : in STD_LOGIC_VECTOR (N-1 downto 0);
             		bo : out STD_LOGIC_VECTOR (log2(N)-1 downto 0);
              		eo : out std_logic;
              		gs : out std_logic;
              		Vcc : in real ; --supply voltage
              		consumption : out consumption_type := (0.0,0.0)
              		);
end pe_Nbits;

architecture Behavioral of pe_Nbits is

   signal highest_bit : natural := N-1;

begin

shifting : PROCESS(bi)
   variable i: natural;
begin
   for i in 0 to N-1 loop
      if bi(i) = '1' then 
         highest_bit <= i;
      end if;
   end loop;
end process;

bo <= std_logic_vector(to_unsigned(highest_bit, log2(N))) after delay;
consumption <= (0.0,0.0);

end Behavioral;

architecture structural of pe_Nbits is

    signal bi_concat :  STD_LOGIC_VECTOR (32 downto 0) := (others => '0');

begin
    pe0 : if N < 4 generate
	bi_concat(N-1 downto 0) <= bi;
        --pe_4bit : pr_encoder_4bit port map (bi(N-1 downto 0) => bi , bi(3 downto N) => (others => '0'), EI => EI, bo => bo, EO => EO, GS => GS, consumption => consumption ); 
        pe_4bit : pr_encoder_4bit generic map(logic_family => logic_family, gate => none_comp)  port map (bi => bi_concat(3 downto 0) , EI => EI, bo => bo, EO => EO, GS => GS, Vcc => Vcc, consumption => consumption ); 
    end generate;
    pe1 : if N = 4 generate
        pe_4bit : pr_encoder_4bit generic map(logic_family => logic_family, gate => none_comp) port map (bi => bi , EI => EI, bo => bo, EO => EO, GS => GS, Vcc => Vcc, consumption => consumption ); 
    end generate;
    pe2 : if N > 4 and N < 8 generate
	bi_concat(N-1 downto 0) <= bi;
        pe_8bit : pr_encoder_8bit generic map(logic_family => logic_family, gate => none_comp) port map (I => bi_concat(7 downto 0) , EI => EI, Y => bo, EO => EO, GS => GS, Vcc => Vcc, consumption => consumption ); 
    end generate;
    pe3 : if N = 8 generate
        pe_8bit : pr_encoder_8bit generic map(logic_family => logic_family, gate => none_comp) port map (I => bi , EI => EI, Y => bo, EO => EO, GS => GS, Vcc => Vcc, consumption => consumption ); 
    end generate;
    pe4 : if (N > 8 and N < 16) generate
	bi_concat(N-1 downto 0) <= bi;
        pe_16bit : pr_encoder_16bit generic map(logic_family => logic_family, gate => none_comp) port map (I => bi_concat(15 downto 0) , EI => EI, Y => bo, EO => EO, GS => GS, Vcc => Vcc, consumption => consumption ); 
    end generate;
    pe5 : if (N = 16) generate
        pe_16bit : pr_encoder_16bit generic map(logic_family => logic_family, gate => none_comp) port map (I => bi , EI => EI, Y => bo, EO => EO, GS => GS, Vcc => Vcc, consumption => consumption ); 
    end generate;
    pe6 : if (N > 16 and N < 32) generate
	bi_concat(N-1 downto 0) <= bi;
        pe_16bit : pr_encoder_32bit generic map(logic_family => logic_family, gate => none_comp) port map (I => bi_concat(31 downto 0) , EI => EI, Y => bo, EO => EO, GS => GS, Vcc => Vcc, consumption => consumption ); 
    end generate;  
    pe7 : if N = 32 generate
        pe_32bit : pr_encoder_32bit generic map(logic_family => logic_family, gate => none_comp) port map (I => bi , EI => EI, Y => bo, EO => EO, GS => GS, Vcc => Vcc, consumption => consumption ); 
    end generate;
  
end architecture;
    