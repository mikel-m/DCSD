library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity tec_limpiar_senales is
  port (
    clk            : in std_logic;
    reset_l        : in std_logic;
    ps2_clk        : in std_logic;
    ps2_dat        : in std_logic;
    ps2_clk_limpio : out std_logic;
    ps2_dat_limpio : out std_logic
  ) ;
end tec_limpiar_senales ; 

architecture arch1 of tec_limpiar_senales is

  signal ps2_clk_hist : std_logic_vector(7 downto 0);
  signal ps2_dat_hist : std_logic_vector(7 downto 0);
begin

  limpieza : process( clk, reset_l )
  begin
    if reset_l = '0' then
      ps2_clk_hist <= X"00";
      ps2_dat_hist <= X"00";
      ps2_clk_limpio <= '0';
      ps2_dat_limpio <= '1';
    elsif rising_edge(clk) then
      ps2_clk_hist <= ps2_clk & ps2_clk_hist(7 downto 1);
      ps2_dat_hist <= ps2_dat & ps2_dat_hist(7 downto 1);
      
      if ps2_clk_hist = X"FF" and ps2_dat_hist = X"FF" then
        ps2_clk_limpio <= '1';
        ps2_dat_limpio <= '1';
      elsif ps2_clk_hist = X"FF"  and ps2_dat_hist = X"00" then
        ps2_clk_limpio <= '1';
        ps2_dat_limpio <= '0';
      elsif ps2_clk_hist = X"00"  and ps2_dat_hist = X"FF" then
        ps2_clk_limpio <= '0';
        ps2_dat_limpio <= '1';
      elsif ps2_clk_hist = X"00"  and ps2_dat_hist = X"00" then
        ps2_clk_limpio <= '0';
        ps2_dat_limpio <= '0';
      end if ;
    end if ;
  end process ; -- limpieza

end architecture ;