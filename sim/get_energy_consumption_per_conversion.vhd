----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2018 02:40:31 PM
-- Design Name: 
-- Module Name: get_energy_estimation_per_conversion - testbench
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


library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity get_energy_estimation_per_conversion is
--Port none
end get_energy_estimation_per_conversion;

architecture testbench of get_energy_estimation_per_conversion is
    component test_all_TDC is
        generic ( nr_etaje : natural := 8 );
    end component;   
begin

    -- generate all 
    
    all_TDCs : for i in 31 to 40 generate
        TDCs : test_all_tdc generic map (nr_etaje => i) ;
    end generate;
        
   
end testbench;
