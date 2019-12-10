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
    X"003",
    X"F01",
    X"103",
    X"F01",
    X"203",
    X"F01",
    X"303",
    X"F01",
    X"403",
    X"F01",
    X"503",
    X"F01",
    X"603",
    X"F01",
    X"703",
    X"F01",
    X"803",
    X"F01",
    X"903",
    X"F01",
    X"A03",
    X"F01",
    X"B03",
    X"F01",
    X"C03",
    X"F01",
    X"D03",
    X"F01"
  );
end package body mel_romescala;
