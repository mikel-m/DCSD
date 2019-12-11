library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mel_rom_soundofsilence is
  type rom_mel_soundofsilence is array (0 to 122 ) of std_logic_vector(11 downto 0);
  constant soundofsilence_rom : rom_mel_soundofsilence;
end mel_rom_soundofsilence;

package body mel_rom_soundofsilence is
  constant soundofsilence_rom : rom_mel_soundofsilence := ( 
    X"07A",
    X"50C",--LA
    X"F02", 
    X"50C",--LA
    X"F06", 
    X"70C", --DO
    X"F02", 
    X"70C", --DO
    X"F02", 
    X"90C", --MI
    X"F02", --10
    X"90C", --MI
    X"F06", 
    X"810", --RE
    X"F1C", 
    X"40C", --SOL
    X"F02", 
    X"40C", --SOL
    X"F02", 
    X"60C", --SI
    X"F02",--20 
    X"60C", --SI
    X"F02", 
    X"80F", --RE
    X"F02", 
    X"80C", --RE
    X"F02",
    X"718", --DO
    X"F0F", 
    X"70C",--DO
    X"F02",--30 
    X"70C",--DO
    X"F02", 
    X"90C", --MI
    X"F02", 
    X"90C", --MI
    X"F02", 
    X"B0C", --SOL
    X"F02", 
    X"B0C", --SOL
    X"F02", --40
    X"C16", --LA
    X"F0C", 
    X"C0B", --LA
    X"F00",
    X"C0B", --LA
    X"F02", 
    X"B0F", --SOL
    X"F0F",
    X"70C",--DO
    X"F02",--50 
    X"70C",--DO
    X"F02", 
    X"90C", --MI
    X"F02", 
    X"90C", --MI
    X"F02", 
    X"B0C", --SOL
    X"F02", 
    X"B0C", --SOL
    X"F02", --60
    X"C16", --LA
    X"F0C", 
    X"C0B", --LA
    X"F00",
    X"C0B", --LA
    X"F02", 
    X"B0F", --SOL
    X"F1F",  
    X"70C", --DO
    X"F02",--70
    X"70C", --DO
    X"F02", --
    X"70C", --DO
    X"F08", 
    X"70C", --DO
    X"F02",
    X"70C", --DO
    X"F02", --
    X"C16", --LA
    X"F0C", --80
    X"C08", --LA
    X"F01",
    X"C08", --LA
    X"F0F", 
    X"C0C", --LA
    X"F0F", 
    X"D0C", --SI
    X"F02",
    X"70C", --DO
    X"F02", --90
    X"70C", --DO
    X"F02", 
    X"C08", --LA
    X"F01",
    X"C08", --LA
    X"F02", 
    X"C16", --LA
    X"F0C",
    X"B16", --SOL
    X"F08",--100
    X"C0C", --LA
    X"F02",
    X"B0C", --SOL
    X"F02",
    X"916", --MI
    X"F0C",
    X"70C", --DO
    X"F02",
    X"70C", --DO
    X"F02",--110
    X"B16", --SOL
    X"F08",
    X"D08", --SI
    X"F01",
    X"D08", --SI
    X"F02",
    X"708", --DO
    X"F01",
    X"708", --DO
    X"F02",--120
    X"C16", --LA
    X"F1F"--122
  );
end package body mel_rom_soundofsilence;
