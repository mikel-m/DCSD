library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity limpiar_senales is
  port (
    clk            : in std_logic;
    reset_l        : in std_logic;
    ps2_clk        : in std_logic;
    ps2_dat        : in std_logic;
    ps2_clk_limpio : out std_logic;
    ps2_dat_limpio : out std_logic
  ) ;
end limpiar_senales ; 

architecture arch1 of limpiar_senales is

begin

    ps2_clk_limpio <= pl2_clk;
    ps2_dat_limpio <= pl2_dat;
end architecture ;