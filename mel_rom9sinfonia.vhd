library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mel_rom_9sinfonia is
  type rom_mel_9sinfonia is array (0 to 54 ) of std_logic_vector(11 downto 0);
  constant sinfoniarom : rom_mel_9sinfonia;
end mel_rom_9sinfonia;

package body mel_rom_9sinfonia is
  constant sinfoniarom : rom_mel_9sinfonia := ( 
    X"036",
    X"60F",--SI
    X"F02", 
    X"70C",--DO
    X"F02", 
    X"80C", --RE
    X"F02", 
    X"80C", --RE
    X"F02", 
    X"70C", --DO
    X"F02", --10
    X"60C", --SI
    X"F02", 
    X"50C", --LA
    X"F02", 
    X"40C", --SOL
    X"F02", 
    X"40C", --SOL
    X"F02", 
    X"50C", --LA
    X"F02",--20 
    X"60C", --SI
    X"F02", 
    X"60F", --SI
    X"F02", 
    X"50C", --LA
    X"F02",
    X"50C", --LA
    X"F02",
    X"60F", --SI
    X"F02", --30
    X"70C", --DO
    X"F02", --
    X"80C", --RE
    X"F02",
    X"80C", --RE
    X"F02", 
    X"70C", --DO
    X"F02", 
    X"60C", --SI
    X"F02",--40
    X"50C", --LA
    X"F02",
    X"40C", --SOL
    X"F02",
    X"40C", --SOL
    X"F02",
    X"50C", --LA
    X"F02",
    X"60C", --SI
    X"F02",--50
    X"50F", --LA
    X"F02",
    X"40F", --SOL
    X"F0F"--54
  );
end package body mel_rom_9sinfonia;
