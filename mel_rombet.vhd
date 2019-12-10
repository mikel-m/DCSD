library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mel_rombet is
  type rom_mel_bet is array (0 to 52 ) of std_logic_vector(11 downto 0);
  constant bet27rom : rom_mel_bet;
end mel_rombet;

package body mel_rombet is
  constant bet27rom : rom_mel_bet := ( 
    X"034",
    X"60C",--SI
    X"F01", 
    X"006",--DO
    X"F01", 
    X"106", --RE
    X"F01", 
    X"106", --RE
    X"F01", 
    X"006", --DO
    X"F01", --10
    X"606", --SI
    X"F01", 
    X"506", --LA
    X"F01", 
    X"406", --SOL
    X"F01", 
    X"406", --SOL
    X"F01", 
    X"506", --LA
    X"F01",--20 
    X"606", --SI
    X"F01", 
    X"60C", --SI
    X"F01", 
    X"50C", --LA
    X"F01",
    X"60C", --SI
    X"F01", 
    X"006", --DO
    X"F01", --30
    X"106", --RE
    X"F01",
    X"106", --RE
    X"F01", 
    X"006", --DO
    X"F01", 
    X"606", --SI
    X"F01",--38
    X"506", --LA
    X"F01",
    X"406", --SOL
    X"F01",
    X"406", --SOL
    X"F01",
    X"506", --LA
    X"F01",
    X"606", --SI
    X"F01",
    X"50C", --LA
    X"F01",
    X"40C", --SOL
    X"F01"--52
  );
end package body mel_rombet;
