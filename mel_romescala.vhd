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
    X"01", 
    X"11", 
    X"21", 
    X"31", 
    X"41", 
    X"51", 
    X"61", 
    X"71", 
    X"81", 
    X"91", 
    X"A1", 
    X"B1", 
    X"C1",  
    X"D1" 
  );
end package body mel_romescala;
