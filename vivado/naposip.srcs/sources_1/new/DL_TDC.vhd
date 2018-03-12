----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Botond Sandor Kirei
-- 
-- Create Date: 03/05/2018 04:40:07 PM
-- Design Name: Naposip
-- Module Name: DL_TDC - Behavioral
-- Project Name: NAPOSIP
-- Target Devices: 
-- Tool Versions: 
-- Description: Delay line Time-to-digital converter - gate level description
--              - dynamic energy consumption monitoring 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.util.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DL_TDC is
    Generic (nr_etaje : natural :=4;
            delay : time :=1 ns;
            active_front : boolean := true);
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           R : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (log2(nr_etaje)-1 downto 0);
            energy_mon: out natural);
end DL_TDC;

architecture Behavioral of DL_TDC is
    component tdc_n_cell is
        Generic (nr_etaje : natural :=4;
                delay : time :=1 ns;
                active_front : boolean := true);
        Port ( start : in STD_LOGIC;
               stop : in STD_LOGIC;
               R : in STD_LOGIC;
               Q : out STD_LOGIC_VECTOR (1 to nr_etaje);
                energy_mon: out natural);
    end component;
    component mask_Nbits is
        Generic (nr_etaje : natural := 4);
        Port ( RawBits : in STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
               MaskedBits : out STD_LOGIC_VECTOR (nr_etaje-1 downto 0);
               energy_mon : out natural);
    end component;
    component pe_NBits is 
        Generic ( N: natural := 4;
               delay : time := 0 ns);
        Port ( bi : in STD_LOGIC_VECTOR (N-1 downto 0);
           bo : out STD_LOGIC_VECTOR (log2(N)-1 downto 0);
           energy_mon: out integer);
    end component;
    
    signal RawBits, MaskedBits : STD_LOGIC_VECTOR  (nr_etaje - 1 downto 0);
    type en_t is array (1 to 3 ) of natural;
    signal en : en_t;
    type sum_t is array (0 to 3) of natural;
    signal sum : sum_t;
begin

    TDC_core : tdc_n_cell generic map (nr_etaje => nr_etaje) 
                            port map ( start => start,
                                       stop =>stop,
                                       R => R,
                                       Q => RawBits,
                                       energy_mon => en(1));
    Mask : mask_Nbits generic map (nr_etaje => nr_etaje)
                        port map ( RawBits => RawBits,
                                    MaskedBits => MaskedBits,
                                    energy_mon => en(2));
    Encoder : pe_Nbits generic map (N => nr_etaje)
                        port map (bi => MaskedBits,
                                  bo => Q,
                                  energy_mon => en(3));

    sum(0) <= 0;
    sum_up_energy : for I in 1 to 3  generate
        sum_i:    sum(I) <= sum(I-1) + en(I);
    end generate sum_up_energy;
    energy_mon <= sum(3);                             
                                    
end Behavioral;
