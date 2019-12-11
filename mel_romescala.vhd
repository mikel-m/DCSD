library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mel_romescala is
  type rom_mel_escala is array (0 to 28) of std_logic_vector(11 downto 0);
  constant escala15rom : rom_mel_escala;
end mel_romescala;

package body mel_romescala is
  constant escala15rom : rom_mel_escala := (
    X"024",
    X"006",
    X"F02",
    X"106",
    X"F02",
    X"206",
    X"F02",
    X"306",
    X"F02",
    X"406",
    X"F02",
    X"506",
    X"F02",
    X"606",
    X"F02",
    X"706",
    X"F02",
    X"806",
    X"F02",
    X"906",
    X"F02",
    X"A06",
    X"F02",
    X"B06",
    X"F02",
    X"C06",
    X"F02",
    X"D06",
    X"F02"
  );
end package body mel_romescala;
