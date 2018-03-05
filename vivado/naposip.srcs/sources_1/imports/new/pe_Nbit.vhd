----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2018 04:23:52 PM
-- Design Name: 
-- Module Name: pe_Nbit - Behavioral
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
use IEEE.numeric_std.all; 
library xil_defaultlib;
use xil_defaultlib.util.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pe_Nbit is
    Generic ( N: natural := 4;
               delay : time := 0 ns);
    Port ( bi : in STD_LOGIC_VECTOR (N-1 downto 0);
           bo : out STD_LOGIC_VECTOR (log2(N)-1 downto 0);
           energy_mon: out integer);
end pe_Nbit;

architecture Behavioral of pe_Nbit is

   signal highest_bit : natural := N-1;

begin

shifting : PROCESS(bi)
   variable i: natural;
begin
   for i in 0 to N-1 loop
      if bi(i) = '1' then 
         highest_bit <= i;
      end if;
   end loop;
end process;

bo <= std_logic_vector(to_unsigned(highest_bit, log2(N))) after delay;
energy_mon <= 0;

end Behavioral;
