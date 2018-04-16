library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.PELib.all;
use xil_defaultlib.PEGates.all;
use xil_defaultlib.Nbits.all;


entity test_encoders is
  generic (N : natural := 8);
end test_encoders;

architecture sim of test_encoders is
        component pr_encoder_64bit is
          Port (I: in STD_LOGIC_VECTOR(63 DOWNTO 0);
               EI: in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(5 DOWNTO 0);
               GS,EO : out STD_LOGIC;
               consumption: out consumption_monitor_type);
       end component;
       
      component pr_encoder_8bit is
              Port (  I : in STD_LOGIC_VECTOR(7 DOWNTO 0);
                      EI: in STD_LOGIC;
                      Y : out STD_LOGIC_VECTOR(2 DOWNTO 0);
                      GS,EO : out STD_LOGIC;
                      consumption: out consumption_monitor_type);
       end component;
       signal I: std_logic_vector(8 downto 1);          
begin
test_p : process 
            variable i: integer;
            begin
                 for i in 1 to 8 loop
                    I <= std_logic_vector(to_unsigned(i,N));
                    wait for 1 ns;
                 end loop;
            end process;
  encoder1: pr_encoder_8bit port map (I => I, EI => 0); 
  encoder2: pr_encoder_64bit port map (I => I, EI => 0);         
          
end sim;
