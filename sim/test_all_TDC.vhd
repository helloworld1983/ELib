library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library std;
use std.textio.all;  --include package textio.vhd

library xil_defaultlib;
use xil_defaultlib.PELib.all;
use xil_defaultlib.PEGates.all;
use xil_defaultlib.Nbits.all;

entity test_all_TDC is
    generic ( nr_etaje : natural := 4 );
--  Port ( );
end test_all_TDC;

architecture Behavioral of test_all_TDC is

    component DL_TDC is
        Generic (nr_etaje : natural :=4;
                delay : time := 1 ns;
                active_edge : boolean := true;
                logic_family : logic_family_t; -- the logic family of the component
                gate : component_t; -- the type of the component
                Cload: real := 5.0 -- capacitive load
                );
        Port ( start : in STD_LOGIC;
               stop : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q : out STD_LOGIC_VECTOR (log2(nr_etaje)-1 downto 0);
               Vcc : in real; --supply voltage
               consumption : out consumption_type := (0.0,0.0));
    end component;
    
    component VDL_TDC is
         Generic (nr_etaje : natural :=4;
                    delay1 : time := 2 ns;
                    delay2 : time := 1 ns;
                    logic_family : logic_family_t; -- the logic family of the component
                    gate : component_t; -- the type of the component
                    Cload: real := 5.0 -- capacitive load
                    );
            Port ( start : in STD_LOGIC;
                stop : in STD_LOGIC;
                Rn : in STD_LOGIC; 
                Q : out STD_LOGIC_VECTOR (log2(nr_etaje)-1 downto 0);
                done : out STD_LOGIC; 
                Vcc : in real ; --supply voltage
                consumption : out consumption_type := (0.0,0.0));
     end component;
     
     component GRO_TDC is
         Generic (width : natural := 4;
                 delay : time :=1 ns;
                 logic_family : logic_family_t; -- the logic family of the component
                 gate : component_t; -- the type of the component
                 Cload: real := 5.0 -- capacitive load
                  );
         Port ( start : in STD_LOGIC;
                stop : in STD_LOGIC;
                Q : out STD_LOGIC_VECTOR (width-1 downto 0);
                Vcc : in real ; --supply voltage
                consumption : out consumption_type := (0.0,0.0));
     end component;
     
     component SR_TDC is
         Generic (width : natural := 4;
                 delay : time :=1 ns;
                 logic_family : logic_family_t; -- the logic family of the component
                 gate : component_t; -- the type of the component
                 Cload: real := 5.0 -- capacitive load
                  );
         Port ( start : in STD_LOGIC;
                stop : in STD_LOGIC;
                Q : out STD_LOGIC_VECTOR (width-1 downto 0);
                Vcc : in real ; --supply voltage
                consumption : out consumption_type := (0.0,0.0));
     end component;
     
     procedure start_conversion (
        signal reset, start, stop : out std_logic;
        diff : in time) is
     begin
        start <='0';
        stop <= '0';
        reset <= '0';
        wait for 100 ns;
        reset <= '1';
        wait for 100 ns;
        start <= '1';
        wait for diff;
        stop <= '1';
        wait for 500 ns;
        start <= '0';
        stop <= '0';
        
     end procedure;
     
    signal start, stop, rst, done : STD_LOGIC;
    signal outQ_DL_TDC : STD_LOGIC_VECTOR (nr_etaje - 1 downto 0);
    signal outQ_VDL_TDC : STD_LOGIC_VECTOR (nr_etaje - 1 downto 0);
    signal outQ_GRO_TDC : STD_LOGIC_VECTOR (nr_etaje - 1 downto 0);
    signal outQ_SR_TDC : STD_LOGIC_VECTOR (nr_etaje - 1 downto 0);
    signal energy1, energy2, energy3, energy4: consumption_type;
    signal power1, power2, power3, power4: real := 0.0;
    signal vcc : real := 5.0;

begin
    -- TDC instantiations
    DL_TCD_i: DL_TDC generic map (nr_etaje => 2**nr_etaje, delay => 50 ns, logic_family => HC, gate => none_comp) port map (start => start, stop => stop, Rn => rst, Q => outQ_DL_TDC, Vcc => vcc, consumption => energy1);
    VDL_TDC_i: VDL_TDC generic map (nr_etaje => 2**nr_etaje, delay2 => 100 ns, delay1 => 50 ns, logic_family => HC, gate => none_comp) port map (start => start, stop => stop, Rn => rst, Q => outQ_VDL_TDC, done => done, Vcc => vcc, consumption => energy2);
    GRO_TCD_i: GRO_TDC generic map (width => nr_etaje, delay => 50 ns, logic_family => HC, gate => none_comp) port map (start => start, stop => stop, Q => outQ_GRO_TDC, Vcc => vcc, consumption => energy3);
    SR_TCD_i: SR_TDC generic map (width => nr_etaje, delay => 50 ns, logic_family => HC, gate => none_comp) port map (start => start, stop => stop, Q => outQ_SR_TDC, Vcc => vcc, consumption => energy4);
    
    
    
	pe1 : power_estimator generic map (time_window => 5000 ns) 
		port map (consumption => energy1, power => power1);
	pe2 : power_estimator generic map (time_window => 5000 ns) 
            port map (consumption => energy2, power => power2);
 	pe3 : power_estimator generic map (time_window => 5000 ns) 
                port map (consumption => energy3, power => power3);
    pe4 : power_estimator generic map (time_window => 5000 ns) 
                                port map (consumption => energy4, power => power4);
                
     run_measurement: process
        variable start_en, stop_en : natural := 0;
        variable i : natural;
        variable str : line;
        file fhandler : text;
     begin
        file_open(fhandler, "dynamic_5bit.txt", write_mode);
        for i in 1 to 2**nr_etaje loop
            start_conversion(rst, start, stop, i * 50 ns);
            write(str, energy1.dynamic);
            writeline(fhandler, str);
            write(str, energy2.dynamic);
            writeline(fhandler, str);
            write(str, energy3.dynamic);
            writeline(fhandler, str);
            write(str, energy4.dynamic);
            writeline(fhandler, str);
            write(str, real(NOW / 1 ns));
            writeline(fhandler, str);
        end loop  ;
        --write static comsumption
        file_close(fhandler); 
        file_open(fhandler, "static_5bit.txt", write_mode);
        write(str, energy1.static);
        writeline(fhandler, str);
        write(str, energy2.static);
        writeline(fhandler, str);
        write(str, energy3.static);
        writeline(fhandler, str);
        write(str, energy4.static);
        writeline(fhandler, str);
        file_close(fhandler); 
        assert false report "simulation ended" severity failure;       
     end process;
     
end Behavioral;
