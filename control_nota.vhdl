library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity control_nota is
  port (
    clk     : in std_logic;
    reset_l : in std_logic;
    pulsado    : in std_logic;
    rom_dat  : in std_logic;
    muestra : in std_logic_vector(2 downto 0);
    freq: out std_logic_vector(11 downto 0);
    rom_dir  : out std_logic_vector(2 downto 0)
    enable  : out std_logic

  ) ;
end control_nota ; 

architecture arch2 of control_nota is
  TYPE estado is (E_INICIO, E_CARGAR_DIR, E_CARGAR_FREQ, E_ENVIAR_FREQ);
 
SIGNAL EP, ES	: estado;
 
  signal pulsado_prev     : std_logic;
  signal pulsado_ch_down : std_logic;
  signal pulsado_ch_up    : std_logic; --Cambios en el pulsador
-- Cargar la direccion de la rom
  signal ld_dir  : std_logic;
  signal rom_out : std_logic_vector(11 downto 0);
-- Cargar la nota de la rom
  signal ld_dat  : std_logic;
  signal nota    : std_logic_vector(2 downto 0);
  
  signal rom_in : std_logic_vector(2 downto 0);
  signal rom_freq:

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
  
  maquina_de_estados : process( EP, pulsado_ch_up, pulsado_ch_down)
  begin
    case EP is
      when E_INICIO =>  if (pulsado_ch_up = '0') then --Inicio --> Inicio
                          ES <= E_INICIO;
                        elsif pulsado_ch_up = '1' then --Inicio --> Carga
                          ES <= E_CARGAR_DIR;
                        end if ;  
      when E_CARGAR_DIR =>  ES <= E_CARGAR_FREQ; --Carga --> Contar
      when E_CARGAR_FREQ =>  ES <= ENVIAR_FREQ; --Contar --> Espera
      when E_ENVIAR_FREQ =>  if pulsado_ch_down = '0' then --Espera --> Espera
                          ES <= E_ENVIAR_FREQ;
                        elsif pulsado_ch_down = '1' then --Espera --> Shift
                          ES <= E_INICIO;
                        end if;
    end case ;
  end process ; -- ESTSIG
------------------------------------------------------
  --- Unidad de Proceso
  --
  --Pulsacion de 1 a 0
  pulsado_ch_down : process( clk, reset_l )
  begin
	 if reset_l = '0' then
	     pulsado_prev <= '0';
    elsif rising_edge(clk) then
      if(pulsado = '1') then
        pulsado_prev <= '1';
      else
        pulsado_prev <= '0';
    end if ;
  end process ; 
  daclrc_ch_down <= (pulsado xor pulsado_prev) and pulsado_prev;
  ----------------------------------------------------

  -- Pulsacion de 0 a 1
  pulsado_ch_up : process( clk, reset_l )
  begin
    if reset_l = '0' then
      pulsado_prev <= '0';
    elsif rising_edge(clk) then
      if(pulsado = '1') then
        pulsado_prev <= '1';
      else
        pulsado_prev <= '0';
      end if ;
    end if ;
  end process ; 
  pulsado_ch_up <= (pulsado xor pulsado_prev) and pulsado;
  -----------------------------------------------------
  R_DIR : process (clk, reset_l)
  begin
    if reset_l = '0' then
      rom_freq <=  to_unsigned(0,12);
    elsif rising_edge(clk) then
      if ld_dir = '1' then
        rom_freq <= rom_out;
      elsif ld_dir = '0' then
        rom_freq <= rom_freq;---duda
      end if ;
    end if ;
  end process ; 
 
  -----------------------------------------------------
  R_DAT : process (clk, reset_l)
  begin
    if reset_l = '0' then
      rom_in <=  to_unsigned(0,3);
    elsif rising_edge(clk) then
      if ld_dir = '1' then
        rom_in <= nota;
      elsif ld_dir = '0' then
        rom_in <= rom_in;---duda
      end if ;
    end if ;
  end process ; 
  ---------------------------------------------------- Señales
    ld_dir   <= '1' when EP = E_CARGAR_DIR         else '0';
    ld_dat   <= '1' when EP = E_CARGAR_FREQ        else '0';
    enable   <= '1' when EP = E_ENVIAR_FREQ        else '0';
    freq     <= rom_freq;--duda
    rom_dir  <= rom_in;--duda



    end architecture ;