library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;
    use work.nota8rom_pkg.all;

entity control_nota is
  port (
    clk     : in std_logic;
    reset_l : in std_logic;
    pulsado    : in std_logic;
    nota : in std_logic_vector(2 downto 0);
    freq: out std_logic_vector(11 downto 0);
    enable  : out std_logic
  ) ;
end control_nota ; 

architecture arch1 of control_nota is
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
  
  signal rom_in : std_logic_vector(2 downto 0);
  signal rom_freq: std_logic_vector(11 downto 0);
  
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
                        else --Inicio --> Carga direccion
                          ES <= E_CARGAR_DIR;
                        end if ;  
      when E_CARGAR_DIR =>  ES <= E_CARGAR_FREQ; --Carga direccion--> Cargar frecuencia
      when E_CARGAR_FREQ =>  ES <= E_ENVIAR_FREQ; --Contar frecuencia --> enviar frecuencia
      when E_ENVIAR_FREQ =>  if pulsado_ch_down = '0' then --enviar frecuencia --> enviar frecuencia
                                ES <= E_ENVIAR_FREQ;
                             else --enviar frecuencia --> Inicio
                                ES <= E_INICIO;
                             end if;
    end case ;
  end process ; -- ESTSIG
------------------------------------------------------
  --- Unidad de Proceso
  --
  --Pulsacion de 1 a 0
  pulsado_ch_proc : process( clk, reset_l )
  begin
	 if reset_l = '0' then
	     pulsado_prev <= '0';
   elsif rising_edge(clk) then
      if(pulsado = '1') then
        pulsado_prev <= '1';
      else
        pulsado_prev <= '0';
      end if ;
   end if;
  end process ; 
  pulsado_ch_down <= (pulsado xor pulsado_prev) and pulsado_prev;
  pulsado_ch_up <= (pulsado xor pulsado_prev) and pulsado;
  ----------------------------------------------------
  --ROM de frecuencias
  rom_out <= nota8rom(to_integer(unsigned(rom_in)));
  -- Pulsacion de 0 a 1
  
  
  -----------------------------------------------------
  R_DIR : process (clk, reset_l)
  begin
    if reset_l = '0' then
      rom_freq <=  B"0000_0000_0000";
    elsif rising_edge(clk) then
      if ld_dat = '1' then
        rom_freq <= rom_out;
      end if ;
    end if ;
  end process ; 
 
  -----------------------------------------------------
  R_DAT : process (clk, reset_l)
  begin
    if reset_l = '0' then
      rom_in <=  "000";
    elsif rising_edge(clk) then
      if ld_dir = '1' then
        rom_in <= nota;
      end if ;
    end if ;
  end process ; 
  ---------------------------------------------------- Señales
    ld_dir   <= '1' when EP = E_CARGAR_DIR         else '0';
    ld_dat   <= '1' when EP = E_CARGAR_FREQ        else '0';
    enable   <= '1' when EP = E_ENVIAR_FREQ        else '0';
    freq     <= rom_freq;
    end architecture ;