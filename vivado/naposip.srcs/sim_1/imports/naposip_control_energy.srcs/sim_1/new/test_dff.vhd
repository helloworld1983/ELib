library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.util.all;

entity test_dff is
end test_dff;

architecture Behavioral of test_dff is
-- component dff is
--   Port ( D : in STD_LOGIC;
--            Ck : in STD_LOGIC;
--            Rn : in STD_LOGIC;
--            Q, Qn : out STD_LOGIC);
--  end component;
  signal inD,inCk,rst,outQ1,outQ2,outQ3,OutQ4 : std_logic;
  signal en1, en2 : natural;

begin
   test_dff_behav_posedge : entity xil_defaultlib.dff(Behavioral) 
            generic map (active_edge => true)
            port map (D => inD, Ck => inCk, Rn => rst, Qn => outQ1, activity => en1);
   test_dff_struct_posedge : entity xil_defaultlib.dff(Structural2) 
            generic map (active_edge => true)
            port map (D => inD, Ck => inCk, Rn => rst, Qn => outQ2, activity => en2);
   test_dff_behav_negedge : entity xil_defaultlib.dff(Behavioral) 
            generic map (active_edge => false)
            port map (D => inD, Ck => inCk, Rn => rst, Qn => outQ3, activity => open);
   test_dff_struct_negedge : entity xil_defaultlib.dff(Structural2) 
            generic map (active_edge => false)
            port map (D => inD, Ck => inCk, Rn => rst, Qn => outQ4, activity => open);
    --generarea semnalului inD de perioada 100ns si factor de umplere 50%
    gen_inD : process 
    begin
        inD <= '0';
        wait for 50 ns;
        inD <= '1';
        wait for 50 ns;
    end process;
    
     --generarea semnalului inCk de perioada 1.13us si factor de umplere 50%    
    gen_inCk : process 
        begin
            inCk <= '0';
            wait for 565 ns;
            inCk <= '1';
            wait for 565 ns;
    end process;
    
     --generarea semnalului rst de perioada 2.26us si factor de umplere 10% cu un delay de inceput de 830ns    
   gen_rst : process 
        begin
            rst <='1', '0' after 50 ns, '1' after 100 ns;
            wait; 
   end process;

end Behavioral;