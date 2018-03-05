library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_dff is
end test_dff;

architecture Behavioral of test_dff is
 component dff is
   Port ( D : in STD_LOGIC;
            Ck : in STD_LOGIC;
            R : in STD_LOGIC;
            Q, Qn : out STD_LOGIC);
  end component;
  signal inD,inCk,rst,outQ : std_logic;
begin
   test_dff : dff port map (D => inD, Ck => inCk, R => rst, Q => outQ);
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
            rst <= '1' after 830 ns, '0' after 1056 ns;
            wait for 2.26 us; 
   end process;

end Behavioral;