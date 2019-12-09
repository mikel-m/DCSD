library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package nota8rom_pkg is
  type rom_nota is array (0 to 13) of std_logic_vector(11 downto 0);
  constant nota8rom : rom_nota;
end nota8rom_pkg;

package body nota8rom_pkg is
  constant nota8rom : rom_nota := (
    B"0001_0000_0101", --DO
    B"0001_0010_0101", --RE
    B"0001_0100_1001", --MI
    B"0001_0101_1101", --FA
    B"0001_1000_0111", --SOL
    B"0001_1011_1000", --LA
    B"0001_1110_1101", --SI
    B"0010_0000_1011",  --DO_A
    B"0010_0100_1011", --RE_A
    B"0010_1001_0011", --MI_A
    B"0010_1011_1010", --FA_A
    B"0011_0000_1111", --SOL_A
    B"0011_0111_0000", --LA_A
    B"0011_1101_1011"  --SI_A

  );
end package body nota8rom_pkg;
