library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mel_romshr is
  type rom_mel_shr is array (0 to 169 ) of std_logic_vector(11 downto 0);
  constant shr27rom : rom_mel_shr;
end mel_romshr;

package body mel_romshr is
  constant shr27rom : rom_mel_shr := ( 
    --- I'm Believer
    X"0A9", --169 lineas
    X"F18",
    X"406",--Sol (N)
    X"F01",
    X"406",--sol(N)
    X"F01",
    X"403",--           sol(C)
    X"F03",
    X"403",--            sol(C)
    X"F03",
    X"406",--sol(N)
    X"F01",
    --
    X"506", --la(N)
    X"F01",
    X"506" --la(N)
    X"F01",
    X"506", --la(N)
    X"F01",
    X"706", --Do'(N)
    X"F01",
    --
    X"60C", --Si (B)
    X"F01",
    X"503", --La(c)
    X"F03",
    X"40C", --Sol(B)
    X"F01",
    --
    X"F06",--silencio
    ---------- primera estrofa
    X"406",--Sol (N)
    X"F01",
    X"406",--sol(N)
    X"F01",
    X"403",--           sol(C)
    X"F03",
    X"403",--            sol(C)
    X"F03",
    X"406",--sol(N)
    X"F01",
    --
    X"506", --la(N)
    X"F01",
    X"506" --la(N)
    X"F01",
    X"506", --la(N)
    X"F01",
    X"706", --Do'(N)
    X"F01",
    --
    X"60C", --Si (B)
    X"F01",
    X"F06", --silencio
    --
    X"706", --do (n)
    X"F01",
    X"703",--           do(C)
    X"F03",
    X"703",--           do(C)
    X"F03",
    X"606", --si (n)
    X"F06",
    X"506", --la(n)
    X"F01",
    -------------------segunda estrofa
    X"406",--Sol (N)
    X"F01",
    X"406",--sol(N)
    X"F01",
    X"F09", --silencio(t=3)
    --
    X"703",--           do(C)
    X"F03",
    X"703",--           do(C)
    X"F03",
    X"606", --si (n)
    X"F06",
    X"506", --la(n)
    X"F01",
    --
    X"406",--Sol (N)
    X"F01",
    X"406",--sol(N)
    X"F01",
    X"F09", --silencio(t=3)
    --
    X"703",--           do(C)
    X"F03",
    X"703",--           do(C)
    X"F03",
    X"606", --si (n)
    X"F06",
    X"506", --la(n)
    X"F01",
    --
    X"403", --sol(n)
    X"F01",
    X"403", --sol(n)
    X"F01",
    X"403", --sol(n)
    X"F01",
    X"603", --sol(n)
    X"F01",
    ------------tercera estrofa
    X"80C", --re(B)
    X"F01",
    X"F09", --silencio(t=3)
    -- Inicio bis
    X"403",--           sol(C)
    X"F03",
    X"403",--            sol(C)
    X"F03",
    X"403", --sol(n)
    X"F01",
    X"603", --si(n)
    X"F01",
    --
    X"803", --re'(n)
    X"F0C",
    --
    X"903",--           mi'(C)
    X"F03",
    X"903",--            mi'(C)
    X"F03",
    X"903", --mi'(n)
    X"F01",
    X"903", --mi'(n)
    X"F01",
    --
    X"903", --mi'(n)
    X"F01",
    X"803", --re'(n)
    X"F06",
    --fin bis
    -- Inicio bis
    X"403",--           sol(C)
    X"F03",
    X"403",--            sol(C)
    X"F03",
    X"403", --sol(n)
    X"F01",
    X"603", --si(n)
    X"F01",
    --
    X"803", --re'(n)
    X"F0C",
    --
    X"903",--           mi'(C)
    X"F03",
    X"903",--            mi'(C)
    X"F03",
    X"903", --mi'(n)
    X"F01",
    X"903", --mi'(n)
    X"F01",
    --
    X"903", --mi'(n)
    X"F01",
    X"803", --re'(n)
    X"F06",
    --fin bis
    --
    X"403", --sol(n)
    X"F01",
    X"603", --si(n)
    X"F01",
    --Cuarta estrofa
    X"803", --re'(n)
    X"F09",
    --
    X"903",--           mi'(C)
    X"F03",
    X"903",--            mi'(C)
    X"F03",
    X"903", --mi'(n)
    X"F01",
    X"903", --mi'(n)
    X"F01",
    --
    X"903", --mi'(n)
    X"F01",
    X"803", --re'(n)
    X"F01",
    X"803", --re'(n)
    X"F01",
    X"803", --re'(n)
    X"F01",
    --
    X"803", --re'(n)
    X"F01",
    X"703", --do'(n)
    X"F01",
    X"703", --do'(n)
    X"F01",
    X"503", --la(n)
    X"F01",
    --
    X"50C", --la (redonda) FIN
    X"F01"
  );
end package body mel_romshr;
