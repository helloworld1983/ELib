----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2018 04:46:38 PM
-- Design Name: 
-- Module Name: mask_Nbit - Structural
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

entity mask_Nbits is
    Generic (nr_etaje : natural := 4);
    Port ( RawBits : in STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
           MaskedBits : out STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
           energy_mon : out natural);
end mask_Nbits;

architecture Structural of mask_Nbits is
    component mask is
        Generic (delay_inv, delay_and, delay_or : time:=0 ns);
        Port ( cb : in STD_LOGIC; -- current bit
               pb : in STD_LOGIC; --previous bit
               mi : in STD_LOGIC; --mask in bit
               b : out STD_LOGIC; -- masked bit - output of the current stage
               mo : out STD_LOGIC; --mask out bit
               energy_mon : out natural); -- energy monitoring
    end component mask;

    signal RawB : STD_LOGIC_VECTOR (nr_etaje downto 0);
    signal M : STD_LOGIC_VECTOR (nr_etaje downto 0); -- Mask Bits

    --energy monitoring signals
    type en_t is array (1 to nr_etaje ) of natural;
    signal en : en_t;
    type sum_t is array (0 to nr_etaje ) of natural;
    signal sum : sum_t;  
      
begin

     RawB <= RawBits & '0';
     M(0) <= '0';
   mask_x :
    for I in 1 to nr_etaje generate
        mask_i : mask port map ( cb => RawB(I), pb => RawB(I-1), mi => M(I-1), b=>MaskedBits(I - 1), mo => M(I), energy_mon => en (I));
    end generate mask_x;
    -- energy monitoring section 
    -- not for sinthesis  
    sum(0) <= 0;
     sum_up_energy : for I in 1 to nr_etaje  generate
         sum_i:    sum(I) <= sum(I-1) + en(I);
     end generate sum_up_energy;
     energy_mon <= sum(3);
     
end Structural;
