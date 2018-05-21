----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description:  Priority encoder on N bits with activity monitroing
--              - the raw bits of a delay line converter must undergo for 
--                "thermal" encoding - priority encoding is  the second stage of the encoding)
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   bi - bits in
--              - outputs : bo - the priotity number
--                          mo - mask out - to next mask cell
--                          consumption :  port to monitor dynamic and static consumption
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: PElib.vhd, PEGates.vhd, Nbits.vhd
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all; 

library xil_defaultlib;
use xil_defaultlib.PElib.all;
use xil_defaultlib.PEGates.all; 
use xil_defaultlib.Nbits.all;

entity pe_Nbits is
    Generic ( N: natural := 32;
               delay : time := 0 ns);
       Port ( ei : in std_logic;
              bi : in STD_LOGIC_VECTOR (N-1 downto 0);
              bo : out STD_LOGIC_VECTOR (log2(N)-1 downto 0);
              eo : out std_logic;
              gs : out std_logic;
              consumption : out consumption_type := (0.0,0.0));
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

    component pr_encoder_4bit is
        Port ( ei : in STD_LOGIC;
               bi : in STD_LOGIC_VECTOR(3 downto 0);
               bo : out STD_LOGIC_VECTOR(1 downto 0);
               eo,gs : out STD_LOGIC;
               consumption : out consumption_type := (0.0,0.0));
    end component;
    
    component pr_encoder_8bit is
          Port (  I : in STD_LOGIC_VECTOR(7 DOWNTO 0);
                  EI: in STD_LOGIC;
                  Y : out STD_LOGIC_VECTOR(2 DOWNTO 0);
                  GS,EO : out STD_LOGIC;
                  consumption: out consumption_type := (0.0,0.0));
    end component;
    
    component pr_encoder_16bit is
        Port (I: in STD_LOGIC_VECTOR(15 DOWNTO 0);
              EI: in STD_LOGIC;
              Y : out STD_LOGIC_VECTOR(3 DOWNTO 0);
              GS,EO : out STD_LOGIC;
              consumption: out consumption_type := (0.0,0.0));
    end component; 

    component pr_encoder_32bit is
         Port (I: in STD_LOGIC_VECTOR(31 DOWNTO 0);
              EI: in STD_LOGIC;
              Y : out STD_LOGIC_VECTOR(4 DOWNTO 0);
              GS,EO : out STD_LOGIC;
              consumption: out consumption_type := (0.0,0.0));
    end component; 

    signal bi_concat :  STD_LOGIC_VECTOR (32 downto 0) := (others => '0');

begin
    pe0 : if N < 4 generate
	bi_concat(N-1 downto 0) <= bi;
        --pe_4bit : pr_encoder_4bit port map (bi(N-1 downto 0) => bi , bi(3 downto N) => (others => '0'), EI => EI, bo => bo, EO => EO, GS => GS, consumption => consumption ); 
        pe_4bit : pr_encoder_4bit port map (bi => bi_concat(3 downto 0) , EI => EI, bo => bo, EO => EO, GS => GS, consumption => consumption ); 
    end generate;
    pe1 : if N = 4 generate
        pe_4bit : pr_encoder_4bit port map (bi => bi , EI => EI, bo => bo, EO => EO, GS => GS, consumption => consumption ); 
    end generate;
    pe2 : if N > 4 and N < 8 generate
	bi_concat(N-1 downto 0) <= bi;
        pe_8bit : pr_encoder_8bit port map (I => bi_concat(7 downto 0) , EI => EI, Y => bo, EO => EO, GS => GS, consumption => consumption ); 
    end generate;
    pe3 : if N = 8 generate
        pe_8bit : pr_encoder_8bit port map (I => bi , EI => EI, Y => bo, EO => EO, GS => GS, consumption => consumption ); 
    end generate;
    pe4 : if (N > 8 and N < 16) generate
	bi_concat(N-1 downto 0) <= bi;
        pe_16bit : pr_encoder_16bit port map (I => bi_concat(15 downto 0) , EI => EI, Y => bo, EO => EO, GS => GS, consumption => consumption ); 
    end generate;
    pe5 : if (N = 16) generate
        pe_16bit : pr_encoder_16bit port map (I => bi , EI => EI, Y => bo, EO => EO, GS => GS, consumption => consumption ); 
    end generate;
    pe6 : if (N > 16 and N < 32) generate
	bi_concat(N-1 downto 0) <= bi;
        pe_16bit : pr_encoder_32bit port map (I => bi_concat(31 downto 0) , EI => EI, Y => bo, EO => EO, GS => GS, consumption => consumption ); 
    end generate;  
    pe7 : if N = 32 generate
        pe_32bit : pr_encoder_32bit port map (I => bi , EI => EI, Y => bo, EO => EO, GS => GS, consumption => consumption ); 
    end generate;
  
end architecture;
    