library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mel_romescala is
  type rom_mel_escala is array (0 to 14) of std_logic_vector(7 downto 0);
  constant escala15rom : rom_mel_escala;
end mel_romescala;

package body mel_romescala is
  constant escala15rom : rom_mel_escala := (
    X"0E", 
    X"02", 
    X"12", 
    X"22", 
    X"32", 
    X"42", 
    X"52", 
    X"62", 
    X"72", 
    X"82", 
    X"92", 
    X"A2", 
    X"B2", 
    X"C2",  
    X"D2" 
  );
end package body mel_romescala;
