----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2018 04:32:13 PM
-- Design Name: 
-- Module Name: util - Behavioral
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

package util is
--  Port ( );
    function log2( n:natural ) return integer; 
 --   function log2floor (n : natural) return integer;
     
end util;

package body util is

--function log2( n : natural) return integer is
--    variable temp    : natural := n;
--    variable ret_val : integer := 0; 
--  begin					
--    while temp >= 1 loop
--      ret_val := ret_val + 1;
--      temp    := temp / 2;     
--    end loop;
  	
--    return ret_val;
--  end function;
  
function log2 (n : natural) return integer is
  
  variable m, p : integer;
  begin
   m := 0;
   p := 1;
   for i in 0 to n loop
      if p < n then
        m := m + 1;
        p := p * 2;
      end if;
   end loop;
  return m;
  
  end log2;
  
  -- purpose: computes floor(log2(n))
--  function log2 (n : natural) return integer is
  
--  variable m, p : integer;
--  begin
--   m := -1;
--   p := 1;
--   for i in 0 to n loop
--    if p <= n then
--        m := m + 1;
--        p := p * 2;
--    end if;
--   end loop;
--  return m;
  
--  end log2;  
  
end util;
