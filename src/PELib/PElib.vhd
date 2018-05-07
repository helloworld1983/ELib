----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: Power Estimation 
-- Description: - VHDL package
--              - defines the interface for static and dynamic power estimation
--              - defines operations with the interface
--              - dynamic power dissipation can be estimated using the activity signal 
--              - defines gate primitives with power monitoring function
-- Dependencies: activity_monitor.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package PElib is
    type consumption_type is record
        dynamic : real; -- ment to represent dynamic comsumption
        static : real; -- ment to represent static consumption
    end record consumption_type;
    function "+" (a,b:consumption_type) return consumption_type;
    component activity_monitor is
        port ( signal_in : in STD_LOGIC;
               activity : out natural := 0);
    end component; 
    --constant Capacity : real := 1e-12;
    constant Vcc : real := 5.0;
    --constant Ileackage : real := 1.0e-6;
    
    
end PElib;

package body PElib is
 
  function "+" (a,b:consumption_type) return consumption_type is
    variable sum : consumption_type;
  begin
    sum.dynamic := a.dynamic + b.dynamic;
    sum.static := a.static + b.static;
    return sum;
  end function;
  
end PElib;
