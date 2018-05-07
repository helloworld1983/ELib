
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.PELib.all;
use xil_defaultlib.PEGates.all;
use xil_defaultlib.Nbits.all;

entity pr_encoder_2bit is
    Port ( ei : in STD_LOGIC;
           bi : in STD_LOGIC_VECTOR(1 downto 0);
           bo : out STD_LOGIC;
           eo, gs : out STD_LOGIC;
           consumption : out consumption_type := (0.0,0.0));
end pr_encoder_2bit;

architecture Behavioral of pr_encoder_2bit is
    signal eo_intern : std_logic;
begin

     eo_intern <= not (ei or (bi(1)) or (bi(0)));
     eo <= eo_intern;
     gs <=  ei nor (eo_intern);
     -- ls348 are iesiri cu inalta impedanta
     --bo <= bi(1) when (ei = '1' and eo = '1') else 'Z';
     bo <= bi(1); 
    consumption <= (0.0,0.0);

end Behavioral;

architecture structural of pr_encoder_2bit is
    signal en1, en2, en3, en4 : consumption_type;
    signal tristate_enable, eo_intern : std_logic;
begin
     -- gs <=  ei nor eo;
    nor1: nor_gate port map (a => ei, b => eo_intern,  y => gs, consumption => en1);
    -- eo <= ei nor bi(1) nor bi(0);
    nor2: nor3_gate port map (a => ei, b => bi(1), c => bi(0), y => gs, consumption => en2);
    --bo(0) <= bi(1) when (ei = '1' and eo = '1') else 'Z';
    --and1: and_gate port map (a => ei, b => eo, y => tristate_enable, consumption => en3);
    --buffer1 : tristate_buf port map (a => bi(1), en => tristate_enable, y => bo, consumption => en4); 
    bo <= bi(1);
    eo <= eo_intern;
    consumption <= en1 + en2 + en3 + en4;

end architecture;
