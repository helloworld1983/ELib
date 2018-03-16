----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2018 02:55:40 PM
-- Design Name: 
-- Module Name: latchSR - Behavioral
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

entity latchSR is
    Port ( S : in STD_LOGIC;
           R : in STD_LOGIC;
           Q : inout STD_LOGIC;
           Qn : inout STD_LOGIC;
           energy_mon : out natural);
end latchSR;

architecture Behavioral of latchSR is

    component energy_sum is
        Generic( mult: integer:=1);
        Port ( sum_in : in natural;
               sum_out : out natural;
               energy_mon : in std_logic);
    end component;
    type en_t is array (3 downto 0) of natural;
    signal en: en_t;
begin

    Q <= Qn nand S;
    Qn <= Q nand R;
    
    
    energy1: energy_sum port map (sum_in => 0, sum_out => en(0), energy_mon => S);
    energy2: energy_sum generic map (mult => 2) port map (sum_in => en(0), sum_out => en(1), energy_mon => R);
    energy3: energy_sum generic map (mult => 2) port map (sum_in => en(1), sum_out => en(2), energy_mon => Q);
    energy4: energy_sum port map (sum_in => en(2), sum_out => en(3), energy_mon => Qn);
    
    energy_mon <= en(3);

end Behavioral;
