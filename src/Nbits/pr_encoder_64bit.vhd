----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description:  Priority encoder on 64 bits with activity monitoring (74148)
--              - inputs: I(i), i=(0:63) ; EI(Enable Input) 
--              - outputs : Y, EO(Enable output), GS(Group select)
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: pr_encoder_8bit
-- Revision: 1.0 - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.PELib.all;

entity pr_encoder_64bit is
          Port (I: in STD_LOGIC_VECTOR(63 DOWNTO 0);
               EI: in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(5 DOWNTO 0);
               GS,EO : out STD_LOGIC;
               consumption: out consumption_monitor_type);
end pr_encoder_64bit;

architecture Behavioral of pr_encoder_64bit is

component pr_encoder_8bit is
Port (  I : in STD_LOGIC_VECTOR(7 DOWNTO 0);
               EI: in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(2 DOWNTO 0);
               GS,EO : out STD_LOGIC;
               consumption: out consumption_monitor_type);
end component;

signal net: std_logic_vector (19 downto 1);
type en_t is array (1 to 9 ) of consumption_monitor_type;
signal en : en_t;
type sum_t is array (0 to 9) of consumption_monitor_type;
signal sum : sum_t;

begin
encoder1: pr_encoder_8bit port map ( I(0) => I(0), I(1) => I(1), I(2) => I(2), I(3) => I(3), I(4) => I(4), I(5) => I(5), I(6) => I(6), I(7) => I(7), EI => net(1), Y(0) => net(9), Y(1) => net(10), Y(2) => net(11), GS => net(12), consumption => en(1));
encoder2: pr_encoder_8bit port map ( I(0) => I(8), I(1) => I(9), I(2) => I(10), I(3) => I(11), I(4) => I(12), I(5) => I(13), I(6) => I(14), I(7) => I(15), EI => net(2), Y(0) => net(9), Y(1) => net(10), Y(2) => net(11), EO => net(1), GS => net(13), consumption => en(2));
encoder3: pr_encoder_8bit port map ( I(0) => I(16), I(1) => I(17), I(2) => I(18), I(3) => I(19), I(4) => I(20), I(5) => I(21), I(6) => I(22), I(7) => I(23), EI => net(3), Y(0) => net(9), Y(1) => net(10), Y(2) => net(11), EO => net(2), GS => net(14), consumption => en(3));
encoder4: pr_encoder_8bit port map ( I(0) => I(24), I(1) => I(25), I(2) => I(26), I(3) => I(27), I(4) => I(28), I(5) => I(29), I(6) => I(30), I(7) => I(31), EI => net(4), Y(0) => net(9), Y(1) => net(10), Y(2) => net(11), EO => net(3), GS => net(15), consumption => en(4));
encoder5: pr_encoder_8bit port map ( I(0) => I(32), I(1) => I(33), I(2) => I(34), I(3) => I(35), I(4) => I(36), I(5) => I(37), I(6) => I(38), I(7) => I(39), EI => net(5), Y(0) => net(9), Y(1) => net(10), Y(2) => net(11), EO => net(4), GS => net(16), consumption => en(5));
encoder6: pr_encoder_8bit port map ( I(0) => I(40), I(1) => I(41), I(2) => I(42), I(3) => I(43), I(4) => I(44), I(5) => I(45), I(6) => I(46), I(7) => I(47), EI => net(6), Y(0) => net(9), Y(1) => net(10), Y(2) => net(11), EO => net(5), GS => net(17), consumption => en(6));
encoder7: pr_encoder_8bit port map ( I(0) => I(48), I(1) => I(49), I(2) => I(50), I(3) => I(51), I(4) => I(52), I(5) => I(53), I(6) => I(54), I(7) => I(55), EI => net(7), Y(0) => net(9), Y(1) => net(10), Y(2) => net(11), EO => net(6), GS => net(18), consumption => en(7));
encoder8: pr_encoder_8bit port map ( I(0) => I(56), I(1) => I(57), I(2) => I(58), I(3) => I(59), I(4) => I(60), I(5) => I(61), I(6) => I(62), I(7) => I(63), EI => EI, Y(0) => net(9), Y(1) => net(10), Y(2) => net(11), EO => net(7), GS => net(19), consumption => en(8));
encoder9: pr_encoder_8bit port map ( I(0) => net(12), I(1) => net(13), I(2) => net(14), I(3) => net(15), I(4) => net(16), I(5) => net(17), I(6) => net(18), I(7) => net(19), EI => '0', Y(0) => Y(3), Y(1) => Y(4), Y(2) => Y(5), GS => net(8), consumption => en(9));

Y(0) <= net(9);
Y(1) <= net(10);
Y(2) <= net(11);
GS <= net(8);

sum(0) <= (0.0,0.0);
    sum_up_energy : for I in 1 to 9  generate
                sum_i: sum(I) <= sum(I-1) + en(I);
    end generate sum_up_energy;
    consumption <= sum(9); 


end Behavioral;
