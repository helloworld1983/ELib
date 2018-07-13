----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description: test consumption monitor interface
-- Dependencies: PELib.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;

entity test_consumptiom_metering is
end test_consumptiom_metering;

architecture Behavioral of test_consumptiom_metering is
    signal a,b : std_logic;
    signal c: consumption_type;
    
    component activity_monitor is
        Port ( signal_in : in STD_LOGIC;
               activity : out consumption_type);
    end component;
begin

    process begin
        a <= '1';
        wait for 10 ns;
        a <= '0';
        wait;
    end process;
    
    A1 : activity_monitor port map (activity => c, signal_in => a);

end Behavioral;
