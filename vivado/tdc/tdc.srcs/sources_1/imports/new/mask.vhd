----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/17/2018 04:40:52 PM
-- Design Name: 
-- Module Name: mask - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mask is
    Generic (delay_inv, delay_and, delay_or : time:=0 ns);
    Port ( cb : in STD_LOGIC; -- current bit
           pb : in STD_LOGIC; --previous bit
           mi : in STD_LOGIC; --mask in bit
           b : out STD_LOGIC; -- masked bit - output of the current stage
           mo : out STD_LOGIC; --mask out bit
           energy_mon : out natural); -- energy monitoring
end mask;

architecture Behavioral of mask is
begin
    b <= cb and (not mi);
    mo <= mi  or ( (not cb) and pb);
    energy_mon <= 0;
end Behavioral;

architecture Structural of mask is

    component delay_cell 
      Generic (delay : time :=1 ns);
      Port ( a : in STD_LOGIC;
             y : out STD_LOGIC;
             energy_mon: out natural);
      end component;
     component and_gate
     Generic (delay : time :=1 ns);
     Port ( a : in STD_LOGIC;
            b : in STD_LOGIC;
            y : out STD_LOGIC);
    end component;        
      component or_gate
    Generic (delay : time :=1 ns);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC);
   end component; 
   
   component energy_count is
   
        Port ( in_en : in STD_LOGIC;
             out_en : out natural);
   end component;
    
    signal mi_n, cb_n, net : std_logic;
    type en_t is array (1 to 8 ) of natural;
    signal en : en_t;
    signal sum : natural:=0;
 begin
 
     inv_g1: delay_cell generic map (delay => delay_inv) port map (a => mi, y => mi_n);
     and_g1: and_gate generic map (delay => delay_and) port map (a => cb, b=>mi_n, y =>b);
     
     inv_g2: delay_cell generic map (delay => delay_inv) port map (a => cb, y => cb_n);
     and_g2: and_gate generic map (delay => delay_and) port map (a=>pb, b=> cb_n, y=>net);
     or_g1: or_gate generic map (delay => delay_or) port map (a=> mi, b=> net, y=>mo);
     
     energy_1 : energy_count port map (out_en => en(1), in_en => mi);
     energy_2 : energy_count port map (out_en => en(2), in_en => mi);
     energy_3 : energy_count port map (out_en => en(3), in_en => cb);
     energy_4 : energy_count port map (out_en => en(4), in_en => cb);
     energy_5 : energy_count port map (out_en => en(5), in_en => pb);
     energy_6 : energy_count port map (out_en => en(6), in_en => mi_n);
     energy_7 : energy_count port map (out_en => en(7), in_en => cb_n);
     energy_8 : energy_count port map (out_en => en(8), in_en => net);
     
     process(en)
                  begin
                  label1: for I in 1 to 8 loop
                              sum <= (sum + en(I));
                          end loop;
                  end process;
      energy_mon <= sum;
      
 end architecture;