----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description:  Priority encoder on 8 bits with activity monitoring (74148)
--              - inputs: I(i), i=(0:7) ; EI(Enable Input) 
--              - outputs : Y, EO(Enable output), GS(Group select)
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: delay_cell.vhd, and_gate.vhd, and3_gate.vhd, and4_gate.vhd, and5_gate.vhd, nand_gate.vhd, nand9_gate.vhd, nor4_gate.vhd
-- Revision: 1.0 - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.util.all;

entity pr_encoder_8bit is
       Port (  I : in STD_LOGIC_VECTOR(7 DOWNTO 0);
               EI: in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(2 DOWNTO 0);
               GS,EO : out STD_LOGIC;
               consumption: out consumption_monitor_type);
end pr_encoder_8bit;

architecture Behavioral of pr_encoder_8bit is

component delay_cell is
    Generic (delay : time :=1 ns;
             parasitic_capacity : real := 1.0e-12;
             area : real := 1.0e-9);
    Port ( a : in STD_LOGIC;
           y : out STD_LOGIC;
           consumption: out consumption_monitor_type);
end component;

component and_gate is
    Generic (delay : time := 1 ns;
             parasitic_capacity : real := 1.0e-12;
             area : real := 1.0e-9);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC;
           consumption : out consumption_monitor_type);
end component;

component and3_gate is
    Generic (delay : time := 1 ns;
             parasitic_capacity : real := 1.0e-12;
             area : real := 1.0e-9);
    Port ( a,b,c : in STD_LOGIC;
           y : out STD_LOGIC;
           consumption: out consumption_monitor_type);
end component;

component and4_gate is
    Generic (delay : time := 1 ns;
            parasitic_capacity : real := 1.0e-12;
            area : real := 1.0e-9);
    Port ( a,b,c,d : in STD_LOGIC;
           y : out STD_LOGIC;
           consumption: out consumption_monitor_type);
end component;

component and5_gate is
    Generic (delay : time := 1 ns;
    parasitic_capacity : real := 1.0e-12;
    area : real := 1.0e-9);
    Port ( a,b,c,d,e : in STD_LOGIC;
           y : out STD_LOGIC;
           consumption: out consumption_monitor_type);
end component;

component nand_gate is
    Generic (delay : time := 1 ns;
             parasitic_capacity : real := 1.0e-12;
             area : real := 1.0e-9);
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC;
           consumption : out consumption_monitor_type);
end component;

component nand9_gate is
     Generic (delay : time :=1 ns;
            parasitic_capacity : real := 1.0e-12;
            area : real := 1.0e-9);
   Port ( x : in STD_LOGIC_VECTOR(8 downto 0);
          y : out STD_LOGIC;
          consumption: out consumption_monitor_type);
end component;

component nor4_gate is
     Generic (delay : time :=1 ns;
   parasitic_capacity : real := 1.0e-12;
   area : real := 1.0e-9);
   Port ( a,b,c,d : in STD_LOGIC;
           y: out STD_LOGIC;
           consumption: out consumption_monitor_type);
end component;

signal net: std_logic_vector (26 downto 1);
type en_t is array (1 to 28 ) of consumption_monitor_type;
signal en : en_t;
type sum_t is array (0 to 28) of consumption_monitor_type;
signal sum : sum_t;

begin

inv1: delay_cell port map(a => I(1), y => net(1), consumption => en(1)); 
inv2: delay_cell port map(a => I(2), y => net(2), consumption => en(2)); 
inv3: delay_cell port map(a => net(2), y => net(3), consumption => en(3)); 
inv4: delay_cell port map(a => I(3), y => net(4), consumption => en(4)); 
inv5: delay_cell port map(a => I(4), y => net(5), consumption => en(5)); 
inv6: delay_cell port map(a => net(5), y => net(6), consumption => en(6));
inv7: delay_cell port map(a => I(5), y => net(7), consumption => en(7)); 
inv8: delay_cell port map(a => net(7), y => net(8), consumption => en(8));
inv9: delay_cell port map(a => I(6), y => net(9), consumption => en(9)); 
inv10: delay_cell port map(a => net(9), y => net(10), consumption => en(10));
inv11: delay_cell port map(a => I(7), y => net(11), consumption => en(11)); 
inv12: delay_cell port map(a => EI, y => net(12), consumption => en(12));
nand9_gate1: nand9_gate port map (x(0) => I(0), x(1) => I(1), x(2) => I(2) , x(3) => I(3) , x(4) => I(4) , x(5) => I(5) , x(6) => I(6) , x(7) => I(7), x(8) => net(12), y => net(13) , consumption => en(28)); 
and_gate1: and_gate port map(a => net(12), b => net(11), y => net(14), consumption => en(13));
and_gate2: and_gate port map(a => net(12), b => net(9), y => net(15), consumption => en(14));
and_gate3: and_gate port map(a => net(12), b => net(7), y => net(16), consumption => en(15));
and_gate4: and_gate port map(a => net(12), b => net(5), y => net(17), consumption => en(16));
and_gate5: and_gate port map(a => net(12), b => net(11), y => net(18), consumption => en(17));
and_gate6: and_gate port map(a => net(12), b => net(9), y => net(19), consumption => en(18));
and_gate7: and_gate port map(a => net(12), b => net(11), y => net(20), consumption => en(19));
and3_gate1: and3_gate port map(a => net(12), b => net(10), c => net(7), y => net(21), consumption => en(20));
and4_gate1: and4_gate port map(a => net(12), b => net(8), c => net(6), d => net(4), y => net(22), consumption => en(21));
and4_gate2: and4_gate port map(a => net(12), b => net(8), c => net(6), d => net(2), y => net(23), consumption => en(22));
and4_gate3: and4_gate port map(a => net(12), b => net(10), c => net(6), d => net(4), y => net(24), consumption => en(23));
and5_gate1: and5_gate port map(a => net(12), b => net(10), c => net(6), d => net(3),e => net(1), y => net(25), consumption => en(24));
nand_gate1: nand_gate port map(a => net(12), b => net(13), y => net(26), consumption => en(25));
nor4_gate1: nor4_gate port map(a => net(14), b => net(15), c => net(16), d => net(17), y => Y(2), consumption => en(26));
nor4_gate2: nor4_gate port map(a => net(18), b => net(19), c => net(22), d => net(23), y => Y(1), consumption => en(27));
nor4_gate3: nor4_gate port map(a => net(20), b => net(21), c => net(24), d => net(25), y => Y(0), consumption => en(28));

EO <= net(13);
GS <= net(26);

sum(0) <= (0.0,0.0);
    sum_up_energy : for I in 1 to 28  generate
                sum_i: sum(I) <= sum(I-1) + en(I);
    end generate sum_up_energy;
    consumption <= sum(28); 

end Behavioral;
