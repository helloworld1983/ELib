----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: Power Estimation 
-- Description: - VHDL package
--              - implements the log2 function used to compute the number of bits to represent a value
--              - defines the interface for static and dynamic power estimation
--              - defines operations with the interface
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: none
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package util is
--  Port ( );
    function log2( n:natural ) return integer; 
 --   function log2floor (n : natural) return integer;
    type consumption_monitor_type is record
        dynamic : real; -- ment to represent dynamic comsumption
        static : real; -- ment to represent static consmption
    end record consumption_monitor_type;
    function "+" (a,b:consumption_monitor_type) return consumption_monitor_type;
    component activity_monitor is
        port ( signal_in : in STD_LOGIC;
               activity : out natural := 0);
    end component; 
    --constant Capacity : real := 1e-12;
    constant Vdd : real := 3.3;
    constant Ileackage : real := 1.0e-9;
end util;

package body util is

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
  
  function "+" (a,b:consumption_monitor_type) return consumption_monitor_type is
    variable sum : consumption_monitor_type;
  begin
    sum.dynamic := a.dynamic + b.dynamic;
    sum.static := a.static + b.static;
    return sum;
  end function;

  
end util;
