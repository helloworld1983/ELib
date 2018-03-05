library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;  
use ieee.std_logic_unsigned.all; 

entity adder is
    Generic ( width: integer := 7);
    Port ( A : in STD_LOGIC_VECTOR (0 to width);
           B : in STD_LOGIC_VECTOR (0 to width);
           Cin : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (0 to width);
           Cout : out STD_LOGIC);
end adder;

architecture Behavioral of adder is
signal tmp: std_logic_vector((width+1) downto 0);
begin
tmp <= conv_std_logic_vector(  
                (conv_integer(A) +   
                conv_integer(B) +  
                conv_integer(Cin)),(width +2));  
    S <= tmp(width downto 0);  
    Cout  <= tmp((width+1));
end Behavioral;
