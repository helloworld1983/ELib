
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity test_encoders is
end test_encoders;

architecture sim of test_encoders is
 component pr_encoder_32bit is
          Generic (logic_family : logic_family_t; -- the logic family of the component
              gate : component_t; -- the type of the component
              Cload: real := 5.0 -- capacitive load
               );
      Port (I: in STD_LOGIC_VECTOR(31 DOWNTO 0);
               EI: in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(4 DOWNTO 0);
               GS,EO : out STD_LOGIC;
               Vcc : in real; --supply voltage
               consumption: out consumption_type := cons_zero);
end component; 

component pr_encoder_8bit is
       Generic (logic_family : logic_family_t; -- the logic family of the component
             gate : component_t; -- the type of the component
             Cload: real := 5.0 -- capacitive load
              );
       Port (  I : in STD_LOGIC_VECTOR(7 DOWNTO 0);
               EI: in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(2 DOWNTO 0);
               GS,EO : out STD_LOGIC;
               Vcc : in real;  -- supply voltage
               consumption: out consumption_type := cons_zero);
end component;

     signal I1 : STD_LOGIC_VECTOR (7  downto 0);
     signal Y1 : STD_LOGIC_VECTOR (2  downto 0);
     signal I2 : STD_LOGIC_VECTOR (31  downto 0);     
     signal Y2 : STD_LOGIC_VECTOR (4 downto 0);     
     signal GS1,EO1,GS2,EO2 : STD_LOGIC;     
     signal EI : std_logic;
     signal vcc: real := 5.0;
begin
intrari1 : process 
            variable i: integer;
            begin
                 for i in 0 to 7 loop
                    I1 <= std_logic_vector(to_unsigned(i,8));
                    wait for 2 ns;
                 end loop;
            end process;
            
intrari2 : process 
           variable i: integer;
           begin
              for i in 0 to 255 loop
                    I2 <= std_logic_vector(to_unsigned(i,32));
                    wait for 2 ns;
              end loop;
              I2 <= (others => '1');
              for i in 0 to 31 loop
                    wait for 2 ns;
                    I2 <= '0' & I2(31 downto 1); 
              end loop;
          end process;
  EI <= '0', '1' after 1 ns;                      
  encoder1: pr_encoder_8bit generic map(logic_family => HC, gate => none_comp) port map (I => I1, EI => EI, Y => Y1, EO => EO1, GS => GS1,Vcc => vcc, consumption => open ); 
  encoder2: pr_encoder_32bit generic map(logic_family => HC, gate => none_comp) port map (I => I2, EI => EI, Y => Y2, EO => EO2, GS => GS2, Vcc => vcc, consumption => open );         
          
end sim;
