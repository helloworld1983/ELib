library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity test_pe_Nbit is
    generic (N : natural := 9);
end entity;

architecture sim_2 of test_pe_Nbit is
    signal bi : STD_LOGIC_VECTOR (N-1  downto 0);
    signal bo : STD_LOGIC_VECTOR (log2(N)-1 downto 0);
    signal vcc: real := 5.0;
begin

        uut: pe_Nbits generic map (N=>N , logic_family => hc) port map (ei=>'0', bi => bi, bo =>bo,eo => open, gs => open, Vcc => vcc, consumption => open);
        
        test_p : process 
            variable i: integer;
            begin
                 for i in 1 to 10 loop
                    bi <= std_logic_vector(to_unsigned(i,N));
                    wait for 1 ns;
                 end loop;
            end process;
            
        
end architecture;
