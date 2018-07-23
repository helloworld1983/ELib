----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: SR latch Time-to-digital converter 
--              - parameters :  width-number of SR blocks
--                              delay - simulated delay time of an elementary gate
--                              logic_family - the logic family of the tristate buffer
--                              gate-type of gate 
--								Cload - load capacitance
--              - inputs:   start - active on positive front
--                          stop - active front is selected by active_edge parameter
--                          Vcc - supply voltage
--              - outputs : Q - processed output
--                          consumption :  port to monitor dynamic and static consumption
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: SR_cell.vhd, counter_Nbits.vhd, adder_NBits.vhd, reg_Nbit.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity SR_TDC is
    Generic (width : natural := 4;
            delay : time :=1 ns;
            logic_family : logic_family_t; -- the logic family of the component
            Cload: real := 5.0 -- capacitive load
             );
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (width-1 downto 0);
           Vcc : in real ; --supply voltage
           consumption : out consumption_type := cons_zero);
end SR_TDC;

architecture Behavioral of SR_TDC is
	component sr_cell is
		Generic (delay : time :=1 ns;
				logic_family : logic_family_t := HC; -- the logic family of the component
			   Cload: real := 5.0 -- capacitive load
			   );
		Port ( 
			   start : in STD_LOGIC;
			   CLK : out STD_LOGIC_VECTOR (1 to 6);
			   Vcc : in real := 5.0 ; --supply voltage
			   consumption : out consumption_type := cons_zero);
	end component;

    signal ck: STD_LOGIC_VECTOR(1 to 6);
    signal C1, C2, C3, C4, C5, C6, C12, C123, C1234, C12345, C123456: STD_LOGIC_VECTOR(width - 1 downto 0);
    signal carry: STD_LOGIC_VECTOR(1 to 5);
    signal Rn : std_logic;
    --consumption monitoring
    signal cons : consumption_type_array(1 to 13);


begin

--internal reset signal
    Rn <=  start;
-- instances used by the SR TDC
base_cell: sr_cell generic map(delay => delay, logic_family => logic_family) port map (start => start, CLK => ck, Vcc => Vcc, consumption => cons(1));
counter1: counter_Nbits generic map (active_edge => FALSE, width => width, logic_family => logic_family) port map (CLK => ck(1), Rn => Rn, Q => C1 , Vcc => Vcc, consumption => cons(2));
counter2: counter_Nbits generic map (active_edge => FALSE, width => width, logic_family => logic_family) port map (CLK => ck(2), Rn => Rn, Q => C2, Vcc => Vcc, consumption => cons(3));
counter3: counter_Nbits generic map (active_edge => FALSE, width => width, logic_family => logic_family) port map (CLK => ck(3), Rn => Rn, Q => C3, Vcc => Vcc, consumption => cons(4));
counter4: counter_Nbits generic map (active_edge => FALSE, width => width, logic_family => logic_family) port map (CLK => ck(4), Rn => Rn, Q => C4 , Vcc => Vcc, consumption => cons(5));
counter5: counter_Nbits generic map (active_edge => FALSE, width => width, logic_family => logic_family) port map (CLK => ck(5), Rn => Rn, Q => C5, Vcc => Vcc, consumption => cons(6));
counter6: counter_Nbits generic map (active_edge => FALSE, width => width, logic_family => logic_family) port map (CLK => ck(6), Rn => Rn, Q => C6, Vcc => Vcc, consumption => cons(7));
adder1: adder_Nbits generic map (delay => 0 ns, width => width, logic_family => logic_family) port map (Cin => '0', A => C1, B => C2, Cout => carry(1), S => C12, Vcc => Vcc, consumption => cons(8));
adder2: adder_Nbits generic map (delay => 0 ns, width => width, logic_family => logic_family) port map (Cin => carry(1), A => C12, B => C3, Cout => carry(2), S => C123, Vcc => Vcc, consumption => cons(9));
adder3: adder_Nbits generic map (delay => 0 ns, width => width, logic_family => logic_family) port map (Cin => carry(2), A => C123, B => C4, Cout => carry(3), S => C1234, Vcc => Vcc, consumption => cons(10));
adder4: adder_Nbits generic map (delay => 0 ns, width => width, logic_family => logic_family) port map (Cin => carry(3), A => C1234, B => C5, Cout => carry(4), S => C12345, Vcc => Vcc, consumption => cons(11));
adder5: adder_Nbits generic map (delay => 0 ns, width => width, logic_family => logic_family) port map (Cin => carry(4), A => C12345, B => C6, Cout => carry(5), S => C123456, Vcc => Vcc, consumption => cons(12));
reg: reg_Nbits generic map (width => width, logic_family => logic_family) port map (D => C123456, Ck => stop, Rn => '1', Q => Q, Vcc => Vcc, consumption => cons(13));

    --+ consumption monitoring
    -- for behavioral simulation only
    sum : sum_up generic map (N => 13) port map (cons => cons, consumption => consumption);
    --- for behavioral simulation only


end Behavioral;
