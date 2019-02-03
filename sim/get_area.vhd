library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library std;
use std.textio.all;  --include package textio.vhd
use ieee.math_real.all; -- for random value generation

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity get_area is
end get_area;

architecture Behavioral of get_area is

    component DL_TDC is
        Generic (nr_etaje : natural :=4;
                delay : time := 1 ns;
                active_edge : boolean := true;
                logic_family : logic_family_t; -- the logic family of the component
                Cload: real := 5.0 -- capacitive load
                );
        Port ( start : in STD_LOGIC;
               stop : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q : out STD_LOGIC_VECTOR (log2(nr_etaje)-1 downto 0);
               Vcc : in real; --supply voltage
               estimation : out estimation_type := est_zero);
    end component;
    
    component VDL_TDC is
         Generic (nr_etaje : natural :=4;
                    delay_start : time := 2 ns;
                    delay_stop : time := 1 ns;
                    logic_family : logic_family_t; -- the logic family of the component
                    Cload: real := 5.0 -- capacitive load
                    );
            Port ( start : in STD_LOGIC;
                stop : in STD_LOGIC;
                Rn : in STD_LOGIC; 
                Q : out STD_LOGIC_VECTOR (log2(nr_etaje)-1 downto 0);
                done : out STD_LOGIC; 
                Vcc : in real ; --supply voltage
                estimation : out estimation_type := est_zero);
     end component;
     
     component GRO_TDC is
         Generic (width : natural := 4;
                 delay : time :=1 ns;
                 logic_family : logic_family_t; -- the logic family of the component
                 Cload: real := 5.0 -- capacitive load
                  );
         Port ( start : in STD_LOGIC;
                stop : in STD_LOGIC;
                Q : out STD_LOGIC_VECTOR (width-1 downto 0);
                Vcc : in real ; --supply voltage
                estimation : out estimation_type := est_zero);
     end component;
     
     component SR_TDC is
            Generic (width : natural := 4;
                    delay : time :=1 ns;
                    logic_family : logic_family_t; -- the logic family of the component
                    Cload: real := 5.0 -- capacitive load
                     );
            Port ( start : in STD_LOGIC;
                   stop : in STD_LOGIC;
                   Q : out STD_LOGIC_VECTOR (width-1 downto 0);
                   Vcc : in real ; --supply voltage
                   estimation : out estimation_type := est_zero);
        end component;
      
    signal dl_tdc_area : estimation_type_array (4 to 32) := (others => est_zero);
    signal vdl_tdc_area : estimation_type_array (4 to 32) := (others => est_zero);
    signal gro_tdc_area : estimation_type_array (4 to 32) := (others => est_zero);
    signal sr_tdc_area : estimation_type_array (4 to 32) := (others => est_zero);
begin

    area_estimation: for i in 4 to 32 generate
    -- TDC instantiations
        DL_TCD_i: DL_TDC generic map (nr_etaje => i,logic_family => HC) port map (start => '0', stop => '0', Rn => '0', Q => open, Vcc => 0.0, estimation => dl_tdc_area(i));
        VDL_TDC_i: VDL_TDC generic map (nr_etaje => i,logic_family => HC) port map (start => '0', stop => '0', Rn => '0', Q => open, done => open, Vcc => 0.0, estimation => vdl_tdc_area(i));
        GRO_TCD_i: GRO_TDC generic map (width => log2(i), logic_family => HC) port map (start => '0', stop => '0', Q => open, Vcc => 0.0, estimation => gro_tdc_area(i));
        SR_TCD_i: SR_TDC generic map (width => log2(i), logic_family => HC) port map (start => '0', stop => '0', Q => open, Vcc => 0.0, estimation => sr_tdc_area(i));
    end generate;
    
   run_measurement: process
       file fhandler : text;
       variable str : line;
    begin
        wait for 1 ns;
       file_open(fhandler, "area.csv", write_mode);
	write(str, string'("N, DL, VDL, GRO, SR"));
	writeline(fhandler, str);
       for i in 4 to 32 loop
           write(str, i);
           write(str, string'(","));
           write(str, dl_tdc_area(i).area);
           write(str, string'(","));
           write(str, vdl_tdc_area(i).area);
           write(str, string'(","));
           write(str, gro_tdc_area(i).area);
           writeline(fhandler, str);
           write(str, string'(","));
           write(str, sr_tdc_area(i).area);
           writeline(fhandler, str);
       end loop  ;
       --write static comsumption
       file_close(fhandler); 
       assert false report "simulation ended" severity failure;       
    end process;
     
end Behavioral;
