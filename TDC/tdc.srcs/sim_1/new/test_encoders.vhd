library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.PElib.all;
use xil_defaultlib.PEGates.all;
use xil_defaultlib.Nbits.all;

entity test_encoders is
end test_encoders;

architecture sim of test_encoders is
 component pr_encoder_32bit is
          Port (I: in STD_LOGIC_VECTOR(31 DOWNTO 0);
               EI: in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(4 DOWNTO 0);
               GS,EO : out STD_LOGIC;
               consumption: out consumption_type := (0.0,0.0));
end component; 

component pr_encoder_8bit is
       Port (  I : in STD_LOGIC_VECTOR(7 DOWNTO 0);
               EI: in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(2 DOWNTO 0);
               GS,EO : out STD_LOGIC;
               consumption: out consumption_type := (0.0,0.0));
end component;

     signal I1 : STD_LOGIC_VECTOR (7  downto 0);
     signal Y1 : STD_LOGIC_VECTOR (2  downto 0);
     signal I2 : STD_LOGIC_VECTOR (31  downto 0);     
     signal Y2 : STD_LOGIC_VECTOR (4 downto 0);     
     signal GS1,EO1,GS2,EO2 : STD_LOGIC;     
begin
intrari1 : process 
            variable i: integer;
            begin
                 for i in 0 to 255 loop
                    I1 <= std_logic_vector(to_unsigned(i,8));
                    wait for 1 ns;
                 end loop;
            end process;
            
intrari2 : process 
           variable i: integer;
           begin
              for i in 0 to 256 loop
                    I2 <= std_logic_vector(to_unsigned(i,32));
                    wait for 1 ns;
              end loop;
          end process;
                        
  encoder1: pr_encoder_8bit port map (I => I1, EI => '1', Y => Y1, EO => EO1, GS => GS1, consumption => open ); 
  encoder2: pr_encoder_32bit port map (I => I2, EI => '1', Y => Y2, EO => EO2, GS => GS2, consumption => open );         
          
end sim;
