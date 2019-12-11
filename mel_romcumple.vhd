library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mel_romcumple is
  type rom_mel_cumple is array (0 to 50) of std_logic_vector(11 downto 0);
  constant cumplerom : rom_mel_cumple;
end mel_romcumple;

package body mel_romcumple is
  constant cumplerom : rom_mel_cumple := (
    X"032",
    X"408",--SOL
    X"F02", 
    X"408",--SOL
    X"F06", 
    X"50C", --LA
    X"F06", 
    X"40C", --SOL
    X"F03", 
    X"70C", --DO
    X"F03", --10
    X"60F", --SI
    X"F0C", 
    X"408", --SOL
    X"F02", 
    X"408", --SOL
    X"F06", 
    X"50C", --LA
    X"F06", 
    X"40C", --SOL
    X"F06",--20 
    X"80C", --RE
    X"F06", 
    X"70F", --DO
    X"F06", 
    X"708", --DO
    X"F02",
    X"904", --MI
    X"F06", --
    X"B0C", --SOL
    X"F06", --30
    X"90C", --MI
    X"F06",
    X"70C", --DO
    X"F06", 
    X"60C", --SI
    X"F06",
    X"20C", --LA
    X"F06", 
    X"A08", --FA
    X"F02", --40
    X"A08", --FA
    X"F06",
    X"90C", --MI
    X"F06",
    X"70C", --DO
    X"F06",
    X"80C", --RE--47
    X"F06",
    X"70C", --DO--49
    X"F0F"
  
  
  
  
  
  
  
  
  
    -- X"01C",
    -- X"506",--LA
    -- X"F01", 
    -- X"506",--LA
    -- X"F03", 
    -- X"006", --DO
    -- X"F01", 
    -- X"006", --DO
    -- X"F01", 
    -- X"206", --MI
    -- X"F01", --10
    -- X"206", --MI
    -- X"F03", 
    -- X"10C", --RE
    -- X"F09", 
    -- X"406", --SOL
    -- X"F01", 
    -- X"406", --SOL
    -- X"F01", 
    -- X"606", --SI
    -- X"F01",--20 
    -- X"606", --SI
    -- X"F01", 
    -- X"10C", --RE
    -- X"F01", 
    -- X"106", --RE
    -- X"F01",
    -- X"00C", --DO
    -- X"F06" --28
    -- X"006",--LA
    -- X"F01", 
    -- X"006",--LA
    -- X"F01", 
    -- X"006", --DO
    -- X"F01", 
    -- X"006", --DO
    -- X"F01", 
    -- X"206", --MI
    -- X"F01", --10
    -- X"206", --MI
    -- X"F01", 
    -- X"10C", --RE
    -- X"F06", 
    -- X"406", --SOL
    -- X"F01", 
    -- X"406", --SOL
    -- X"F01", 
    -- X"606", --SI
    -- X"F01",--20 
    -- X"606", --SI
    -- X"F01", 
    -- X"10C", --RE
    -- X"F01", 
    -- X"106", --RE
    -- X"F01",
    -- X"00C", --DO
    -- X"F01" --30

  );
end package body mel_romcumple;
