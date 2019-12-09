library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mel_rombet is
  type rom_mel_bet is array (0 to 26 ) of std_logic_vector(7 downto 0);
  constant bet27rom : rom_mel_bet;
end mel_rombet;

package body mel_rombet is
  constant bet27rom : rom_mel_bet := ( 
    X"1A",
    X"62",--si
    X"F0", 
    X"01", 
    X"F0", 
    X"11", 
    X"F0", 
    X"11", 
    X"F0", 
    X"01", 
    X"F0", 
    X"61", 
    X"F0", 
    X"51", 
    X"F0", 
    X"41", 
    X"F0", 
    X"41", 
    X"F0", 
    X"51", 
    X"F0", 
    X"11", 
    X"91", 
    X"A1", 
    X"B1", 
    X"C1",  
    X"D1" 
  );
end package body mel_rombet;
