library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.Nbits.all;

entity test_dff is
end test_dff;

architecture Behavioral of test_dff is
  signal inD,inCk,rst,outQ1,outQ2,outQ3,OutQ4 : std_logic;
  signal en1, en2 : consumption_type;
  signal vcc : real := 5.0;

begin
   test_dff_behav_posedge : entity work.dff_Nbits(Behavioral) 
            generic map (active_edge => true, logic_family => HC)
            port map (D => inD, Ck => inCk, Rn => rst, Qn => outQ1, Vcc => vcc,  consumption => en1);
   test_dff_struct_posedge : entity work.dff_Nbits(Structural2) 
            generic map (active_edge => true, logic_family => HC)
            port map (D => inD, Ck => inCk, Rn => rst, Qn => outQ2, Vcc => vcc, consumption => en2);
   test_dff_behav_negedge : entity work.dff_Nbits(Behavioral) 
            generic map (active_edge => false, logic_family => HC)
            port map (D => inD, Ck => inCk, Rn => rst, Qn => outQ3, Vcc => vcc, consumption => open);
   test_dff_struct_negedge : entity work.dff_Nbits(Structural2) 
            generic map (active_edge => false, logic_family => HC)
            port map (D => inD, Ck => inCk, Rn => rst, Qn => outQ4, Vcc => vcc, consumption => open);
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