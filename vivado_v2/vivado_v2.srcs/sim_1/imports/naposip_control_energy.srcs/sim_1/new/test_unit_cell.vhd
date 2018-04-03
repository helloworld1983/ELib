library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_unit_cell is
end test_unit_cell;

architecture Behavioral of test_unit_cell is
 component unit_cell_tdc is
    Port ( inB : in STD_LOGIC;
            Ck : in STD_LOGIC;
            Rn : in STD_LOGIC;
            outB : out STD_LOGIC;
            Q : out STD_LOGIC);
 end component;
 signal inCell,inCk,rst,outCell,outQ : std_logic;
begin
  test_unit_cell : unit_cell_tdc port map (inB => inCell, Ck => inCk, Rn => rst, outB => outCell, Q => outQ);
  
   --generarea semnalului inCell de perioada 10ns si factor de umplere 50%
     gen_inCell : process 
     begin
         inCell <= '0';
         wait for 5.2 ns;
         inCell <= '1';
         wait for 5.2 ns;
     end process;
     
      --generarea semnalului inCk de perioada 10.2ns si factor de umplere 50% intarziat fata de inCell cu 2ns   
     gen_inCk : process 
         begin
             inCk <= '0';
             wait for 5 ns;
             inCk <= '1';
             wait for 5 ns;
     end process;
     
      --generarea semnalului rst astfel incat sa nu influenteze deloc functionarea    
    gen_rst : process 
         begin
             rst <= '1' after 10 ps, '0' after 20 ps;
             wait ; 
    end process;


end Behavioral;
