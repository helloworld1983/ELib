library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library std;
use std.textio.all;  --include package textio.vhd

library xil_defaultlib;
use xil_defaultlib.util.all;

entity test_all_TDC is
--  Port ( );
end test_all_TDC;

architecture Behavioral of test_all_TDC is

component DL_TDC is
    Generic (nr_etaje : natural :=4);
    Port ( start : in STD_LOGIC;
           stop : in STD_LOGIC;
           Rn : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (log2(nr_etaje)-1 downto 0);
           consumption : out consumption_monitor_type);
end component;

component VDL_TDC is
     Generic (nr_etaje : natural :=4);
     Port ( start : in STD_LOGIC;
            stop : in STD_LOGIC;
            Rn : in STD_LOGIC;
            Q : out STD_LOGIC_VECTOR (log2(nr_etaje)-1 downto 0);
            consumption : out consumption_monitor_type);
 end component;
 
 component GRO_TDC is
     Generic (width : natural := 8;
            delay : time :=1 ns);
     Port ( start : in STD_LOGIC;
            stop : in STD_LOGIC;
            Q : out STD_LOGIC_VECTOR (0 to width-1);
            consumption : out consumption_monitor_type);
 end component;
 
 procedure start_conversion (
    signal reset, start, stop : out std_logic;
    diff : in time) is
 begin
    start <='0';
    stop <= '0';
    reset <= '0';
    wait for 10 ns;
    reset <= '1';
    wait for 10 ns;
    start <= '1';
    wait for diff;
    stop <= '1';
    wait for 10 ns;
    start <= '0';
    stop <= '0';
    
 end procedure;
 
 constant nr_etaje : natural :=4;
 signal start,stop,rst : STD_LOGIC;
 signal outQ_DL_TDC : STD_LOGIC_VECTOR (nr_etaje - 1 downto 0);
 signal outQ_VDL_TDC : STD_LOGIC_VECTOR (nr_etaje - 1 downto 0);
 signal outQ_GRO_TDC : STD_LOGIC_VECTOR (nr_etaje - 1 downto 0);
 signal energy1, energy2, energy3: consumption_monitor_type;

begin

    
DL_TCD_i: DL_TDC generic map (nr_etaje => 2**nr_etaje) port map (start => start, stop => stop, Rn => rst, Q => outQ_DL_TDC, consumption => energy1);
VDL_TDC_i: VDL_TDC generic map (nr_etaje => 2**nr_etaje) port map (start => start, stop => stop, Rn => rst, Q => outQ_VDL_TDC, consumption => energy2);
GRO_TCD_i: GRO_TDC generic map (delay => 1 ns, width => nr_etaje) port map (start => start, stop => stop, Q => outQ_GRO_TDC, consumption => energy3);

----generarea semnalului start de f=11MHz
--      gen_start : process 
--      begin
--          start <= '0';
--          wait for 50 ns;
--          start <= '1';
--          wait for 50 ns;
--      end process;
      
----generarea semnalului stop de f=10MHz   
--  gen_stop : process 
--      begin
--          stop <= '0';
--          wait for 45 ns;
--          stop <= '1';
--          wait for 45 ns;
--      end process;
       
----generarea semnalului rst astfel incat sa nu influenteze deloc functionarea    
--     gen_rst : process 
--          begin
--              rst <= '1' after 10 ps, '0' after 20 ps;
--              wait ; 
--     end process;
     run_measurement: process
        variable start_en, stop_en : natural := 0;
        variable i : natural;
        variable str : line;
        file fhandler : text;
     begin
        file_open(fhandler, "myfile.txt", write_mode);
        for i in 1 to 8 loop
            start_conversion(rst, start, stop, i * 1 ns);
            write(str, energy1.dynamic);
            writeline(fhandler, str);
            write(str, energy2.dynamic);
            writeline(fhandler, str);
            write(str, energy3.dynamic);
            writeline(fhandler, str);
            write(str, energy1.static);
            writeline(fhandler, str);
            write(str, energy2.static);
            writeline(fhandler, str);
            write(str, energy3.static);
            writeline(fhandler, str);
        end loop  ;
        file_close(fhandler); 
	    assert false report "simulation ended" severity failure;       
     end process;
     
end Behavioral;
