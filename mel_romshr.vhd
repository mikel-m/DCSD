library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mel_romshr is
  type rom_mel_shr is array (0 to 52 ) of std_logic_vector(11 downto 0);
  constant shr27rom : rom_mel_shr;
end mel_romshr;

package body mel_romshr is
  constant shr27rom : rom_mel_shr := ( 
    --- I'm Believer
    X"034", --El tamaño maximo de la dirección (por cambiar)
    X"F18",
    --
    X"406",--Sol (N)
    X"F01",
    X"406",--sol(N)
    X"F01",
    X"403",--           sol(C)
    X"F03",
    X"403",--            sol(C)
    X"F03",
    X"406",--sol(N)
    X"F01",

   
  );
end package body mel_romshr;
