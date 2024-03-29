library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity enviar_muestra is
  port (
    clk     : in std_logic;
    reset_l : in std_logic;
    bclk    : in std_logic;
    daclrc  : in std_logic;
    muestra : in std_logic_vector(15 downto 0);
    siguiente_muestra: out std_logic;
    dacdat  : out std_logic
  ) ;
end enviar_muestra ; 

architecture arch1 of enviar_muestra is
  TYPE t_estado is (E_INICIO, E_CARGAR, E_CONTAR, E_ESPERA, E_SHIFT);
  -- constant E_INICIO : integer range 0 to 4 := 0;
  -- constant E_CARGAR : integer range 0 to 4 := 1;
  -- constant E_CONTAR : integer range 0 to 4 := 2;
  -- constant E_ESPERA : integer range 0 to 4 := 3;
  -- constant E_SHIFT  : integer range 0 to 4 := 4;

SIGNAL EP, ES, ESTADO	: t_estado;
  -- Señales
  -- signal ESTADO : integer range 0 to 4;
  -- signal EP     : integer range 0 to 4; -- Estado Presente
  -- signal ES     : integer range 0 to 4; -- Estado Siguiente

  signal daclrc_prev  : std_logic;
  signal daclrc_ch    : std_logic; -- Cambio en DACLRC
  signal bclk_prev    : std_logic;
  signal bclk_ch_down : std_logic; -- Cambio en BCLK
  
  
  signal cont              : unsigned(4 downto 0); -- Counter
  signal clr_cont          : std_logic; -- Counter
  signal cont_plus         : std_logic; -- Counter
  signal cont_eq_16        : std_logic; -- Counter
  signal ld_sr             : std_logic; -- Shifter
  signal sl                : std_logic; -- Shifter
  signal dat_shift_out     : std_logic_vector(15 downto 0); -- Shifter
  



begin
------------------------------------------------------
  --- Unidad de control
  UC : process( clk, reset_l )
  begin
    if reset_l = '0' then
      EP <= E_INICIO;
    elsif rising_edge(clk) then
      EP <= ES;
    end if ;
  end process ; -- UC
  
  ESTSIG : process( EP, daclrc_ch, bclk_ch_down, DACLRC, cont_eq_16 )
  begin
    case EP is
      when E_INICIO =>  if (daclrc_ch = '0') or (daclrc_ch = '1' and bclk_ch_down = '0') then --Inicio --> Inicio
                          ES <= E_INICIO;
                        elsif daclrc_ch = '1' and bclk_ch_down = '1' and DACLRC = '1' then --Inicio --> Carga
                          ES <= E_CARGAR;
                        else --Inicio --> Contar
                          ES <= E_CONTAR;
                        end if ;  
      when E_CARGAR =>  ES <= E_CONTAR; --Carga --> Contar
      when E_CONTAR =>  ES <= E_ESPERA; --Contar --> Espera
      when E_ESPERA =>  if bclk_ch_down = '0' then --Espera --> Espera
                          ES <= E_ESPERA;
                        else--Espera --> Shift
                          ES <= E_SHIFT;
                        end if;
      when E_SHIFT =>   if cont_eq_16 = '0' then --Shift --> Contar
                          ES <= E_CONTAR;
                        else --Shift --> Inicio
                            ES <= E_INICIO;
                        end if ;
    end case ;
  end process ; -- ESTSIG
------------------------------------------------------
  --- Unidad de Proceso
  --
  --Cambio de canal
  daclrc_change : process( clk, reset_l )
  begin
	 if reset_l = '0' then
	     daclrc_prev <= '0';
    elsif rising_edge(clk) then
        daclrc_prev <= daclrc;
    end if ;
  end process ; -- daclrc_change
  daclrc_ch <= daclrc xor daclrc_prev;
        ----------------------------------------------------
  --Cambio de BCLK --reset
  bclk_change_down : process( clk, reset_l )
  begin
    if reset_l = '0' then
      bclk_prev <= '0';
    elsif rising_edge(clk) then
      if(bclk = '1') then
        bclk_prev <= '1';
      else
        bclk_prev <= '0';
      end if ;
    end if ;
  end process ; -- bclk_change_down
  bclk_ch_down <= (bclk xor bclk_prev) and bclk_prev;
  -----------------------------------------------------
  contador : process( clk ,reset_l )
  begin
    if reset_l = '0' then
      cont <=  to_unsigned(0,5);
    elsif rising_edge(clk) then
      if cont_plus = '1' then
        cont <= cont + 1;
      elsif clr_cont = '1' then
        cont <= to_unsigned(0,5);
      end if ;
      
      if cont = to_unsigned(16,5) then
        cont_eq_16 <= '1';
      else
        cont_eq_16 <= '0';
      end if;
    end if ;
  end process ; -- contador
  ----------------------------------------------------
  shifter : process( clk , reset_l)
    begin
        if reset_l = '0' then
            dat_shift_out <= "0000000000000000";
        elsif rising_edge(clk) then
            if ld_sr = '1' then
              dat_shift_out <= muestra;
            elsif sl = '1' then
                dat_shift_out <= dat_shift_out(14 DOWNTO 0) & dat_shift_out(15);
            end if ;
        end if ;
    end process ; -- shifter
    ---------------------------------------------------- Señales
    sl                <= '1' when EP = E_SHIFT                                                              else '0';
    ld_sr             <= '1' when EP = E_INICIO and daclrc_ch = '1' and bclk_ch_down = '1' and DACLRC = '1' else '0';
    cont_plus         <= '1' when EP = E_CONTAR                                                             else '0';
    clr_cont          <= '1' when EP = E_INICIO                                                             else '0';
    siguiente_muestra <= '1' when EP = E_CARGAR                                                             else '0';
    dacdat <= dat_shift_out(15);
    ESTADO <= EP;
end architecture ;