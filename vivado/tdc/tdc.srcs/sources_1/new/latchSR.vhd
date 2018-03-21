----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- Project Name: NAPOSIP
-- Description: SR type latch with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--              - inputs:   S - set, active logic '0'
--                          R - reset, active logic '0' 
--              - outputs : Q, Qn - 
--                          consumption :  port to monitor dynamic and static consumption
-- Dependencies: nand_gate.vhd, util.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.util.all;

entity latchSR is

    Generic (delay : time := 1 ns);
    Port ( S : in STD_LOGIC;
           R : in STD_LOGIC;
           Q, Qn : inout STD_LOGIC;
           consumption : out consumption_monitor_type);
end latchSR;

architecture Strcutural of latchSR is

    component nand_gate is
        Generic (delay : time :=1 ns);
        Port ( a,b : in STD_LOGIC;
               y : out STD_LOGIC;
               consumption : out consumption_monitor_type);
    end component nand_gate;
    -- energy monitroing signals
    type cons_t is array (1 downto 0) of consumption_monitor_type;
    signal cons: cons_t;

begin

    nand_gate1_1 : nand_gate generic map (delay => delay) port map ( a => Qn, b => S, y => Q, consumption =>cons(0));
    nand_gate1_2 : nand_gate generic map (delay => delay) port map ( a => Q, b => r, y => Qn, consumption =>cons(1));
    -- energy monitoring   
    -- for simulation only
    consumption <= cons(0) + cons(1);
    -- for simulation only
end Strcutural;
