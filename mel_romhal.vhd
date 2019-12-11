library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mel_romhal is
  type rom_mel_hal is array (0 to 2) of std_logic_vector(11 downto 0);
  constant halrom : rom_mel_hal;
end mel_romhal;

package body mel_romhal is
  constant halrom : rom_mel_hal := (
    X"002",
    X"003",
    X"F01"


  );
end package body mel_romhal;
