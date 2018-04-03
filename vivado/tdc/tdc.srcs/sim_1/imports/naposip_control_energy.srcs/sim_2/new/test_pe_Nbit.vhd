library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
 
library xil_defaultlib;
use xil_defaultlib.util.all;

entity test_pe_Nbit is
    generic (N : natural := 9);
end entity;

architecture sim_2 of test_pe_Nbit is
    component pe_Nbit is
        Generic ( N: natural := 4;
                   delay : time := 0 ns;
                   b_active : std_logic := '1');
        Port ( 
               ei : in std_logic;
               bi : in STD_LOGIC_VECTOR (N-1 downto 0);
               bo : out STD_LOGIC_VECTOR (log2(N)-1 downto 0);
               eo : out std_logic;
               gs : out std_logic;
               consumption : out consumption_monitor_type);
    end component;

begin

        uut: pe_Nbit generic map (N=>N) port map (bi => bi, bo =>bo);
        
        test_p : process 
            variable i: integer;
            begin
                 for i in 1 to 10 loop
                    bi <= std_logic_vector(to_unsigned(i,N));
                    wait for 1 ns;
                 end loop;
            end process;
            
        
end architecture;
