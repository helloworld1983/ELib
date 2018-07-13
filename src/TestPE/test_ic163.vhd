library IEEE;
use IEEE.std_logic_1164.all;
use work.PELib.all;
use work.PEGates.all;
use work.Nbits.all;

entity test_ic163 is
end entity;

architecture testbench of test_ic163 is 	
  component num74163 	
    Generic (delay : time := 1 ns;
                   logic_family : logic_family_t; -- the logic family of the component
                   gate : component_t; -- the type of the component
                   Cload : real := 5.0 -- capacitive load 
                  );
          Port ( CLK, CLRN, LOADN, P, T, D ,C ,B ,A : in std_logic;
                   Qd, Qc, Qb, Qa, RCO: out std_logic;
                   Vcc : in real ; -- supply voltage
                   consumption : out consumption_type := (0.0,0.0)
                   );
         end component;
  	
  signal clk, clrn, loadn, p, t, a, b, c, d : std_logic; 	
  signal rco, qa, qb, qc, qd : std_logic; 	
  signal rco2, qa2, qb2, qc2, qd2 : std_logic; 	
  signal cons, cons2 : consumption_type;
  signal pow, pow2 : real;
  constant period : time := 1000 ns;	
  signal vcc : real := 5.0;
begin  	
  -- instantierea modulului testat 	
  UUT_behav : entity work.num74163(behavioral) 
  generic map (logic_family => HC)
  port map (clk => clk, clrn => clrn, loadn => loadn, 	
    p => p, t => t, a => a, b => b, c => c, d => d, 	
    rco => rco, qa => qa, qb => qb, qc => qc, qd => qd, Vcc => vcc, consumption => cons); 	
   -- instantsierea modulului testat 	
  UUT_struct : entity work.num74163(Structural) 
    generic map (logic_family => HC)
	port map (clk => clk, clrn => clrn, loadn => loadn, 	
    p => p, t => t, a => a, b => b, c => c, d => d, 	
    rco => rco2, qa => qa2, qb => qb2, qc => qc2, qd => qd2, Vcc => vcc, consumption => cons2); 	    	
  -- scenariu 	
   pe : power_estimator generic map (time_window => 4000 ns) port map (consumption => cons, power => pow);
   pe2 : power_estimator generic map (time_window => 4000 ns) port map (consumption => cons2, power => pow2);
  
  scenario : process  	
  begin 	
    -- valori initiale 	
    clrn <= '1'; 	
    loadn <= '1'; 	
    a <= '0'; b <= '0'; c <= '1'; d <= '1'; 	
    p <= '0'; t <= '0'; 	
    wait for 28 ns; 	
    clrn <= '0';   -- activarea semnalului CLRN 	
    wait for 52 ns;  -- se mentine semnalul CLRN timp de 52 ns 	
    clrn <= '1'; 	

  loadn <= '0';  	-- activarea semnalului LOADN 	
    wait for period;  	-- mentinerea comenzii (1 ciclu de tact) 	
    loadn <= '1';  	-- dezactivarea semnalului LOADN 	
    p <= '1';   	-- activarea semnalelor ENP si ENT 	
    t <= '1'; 		
    wait for 6 * period; 	-- mentinerea comenzii (6 cicli de tact) 	
    p <= '0';   	-- dezactivarea ENP 	
    wait for 3 * period; 	-- mentinerea comenzii (3 cicli de tact) 	
    p <= '1';   	-- activarea ENP 	
    t <= '0';   	-- dezactivarea ENT 	
    wait;    	-- astepta pana la infinit 	
  end process; 		
   		
  gen_clk : process 		
  begin 		
    clk <= '0'; 		
    wait for period / 2; 		
    clk <= '1'; 		
    wait for period / 2;  		
  end process; 		
  
  
     		
end testbench;		
