library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;
    use work.mel_romescala.all;

entity  control_melodia is
  port (
    clk     : in std_logic;
    reset_l : in std_logic;
    pulsado : in std_logic;
    nota : in std_logic_vector(3 downto 0) ;
    nota_mel : in std_logic_vector(3 downto 0) ;
    enable_mel: in std_logic
    ---FALTAN y ARREGLAR
  ) ;
end  control_melodia; 

architecture arch of control_melodia is
    constant TIME_UNIT std_logic_vector(23 downto 0) := X"B7_1B00" ;

    TYPE t_estado is (E_INICIO, E_CARGAR_TAMA,E_INC_TAMA, E_CARGAR_DATOS, E_INC_FREQ, E_PLAY);
    signal EP, ES, ESTADO: t_estado;
   
    signal clr_dir : std_logic;
    signal ld_mel  : std_logic;
    signal dir : unsigned(7 downto 0);--Corregir
    signal ld_max  : std_logic;
    signal dir_inc  : std_logic;
    signal ld_nota  : std_logic;
    signal ld_tiempo  : std_logic;
    signal clr_d_freq  : std_logic;
    signal clr_cont_t  : std_logic;
    signal d_freq_inc  : std_logic;
    signal d_freq  : unsigned(23 downto 0);
    signal d_cont_inc  : std_logic;
  
    --PULSADO
    signal pulsado_prev : std_logic;
    signal pulsado_ch_down : std_logic;
    signal pulsado_ch_up : std_logic;

    signal cont_t : unsigned(3 downto 0); -- Contador de tiempo
    signal tiempo : unsigned(3 downto 0); -- Registro de tiempo
    signal dirm_max_1 : unsigned(7 downto 0);--ARREGLAR
    signal div_freq_eq500 : std_logic;

    signal rom_in : std_logic_vector(7 downto 0) ;
    signal rom_max : std_logic_vector(7 downto 0) ;
    signal rom_out_tiempo : std_logic_vector(3 downto 0) ;
    signal rom_out_nota : std_logic_vector(3 downto 0) ;
    signal 
begin
    --Salida UP
    clr_dir     <= '1'  when EP = E_INICIO else '0';
    ld_mel      <=  '1' when EP = E_INICIO and pulsado_ch_up = '1'  else '0';
    dir         <= X"001" when pulsado_ch_down = '0' and cont_t = tiempo  and dir = dirm_max_1 else X"00";
    ld_max      <= '1'  when EP = E_CARGAR_TAMA else '0';
    dir_inc     <= '1'  when EP = E_INC_TAMA else '0';
    ld_nota     <= '1'  when EP = E_CARGAR_DATOS else '0';
    ld_tiempo   <= '1'  when EP = E_CARGAR_DATOS else '0';
    clr_d_freq  <= '1'  when EP = E_CARGAR_DATOS else '0';
    clr_cont_t  <= '1'  when EP = E_CARGAR_DATOS else '0';
    d_freq_inc  <= '1'  when EP = E_INC_FREQ else '0';
    d_cont_inc  <= '1'  when EP = E_PLAY else '0';
    clr_d_freq  <= '1'  when EP = E_PLAY else '0';
    div_freq_eq500 <= '1' when d_freq = TIME_UNIT else '0';
  
    rom_out_tiempo <= mel_romescala(to_integer(unsigned(rom_in)))(3 downto 0);
    rom_out_nota <= mel_romescala(to_integer(unsigned(rom_in)))(7 downto 4);
    
    est_pr : process( clk, reset_l )
    begin
        if reset_l = '0' then
        EP <= E_INICIO;
        elsif rising_edge(clk) then
        EP <= ES;
        end if ;
    end process ; -- est_pr
    ESTADO <= EP;

    maquina_de_estados: process (EP,pulsado_ch_up,pulsado_ch_down,div_freq_eq500, cont_t, tiempo, dir, dirm_max_1)
    begin
      case EP is
        when E_INICIO => if pulsado_ch_up = '1' then
                            ES <= E_CARGAR_TAMA;
                          else
                            ES <= E_INICIO;
                          end if;
        when E_CARGAR_TAMA => if pulsado_ch_down = '0' then
                            ES <= E_INC_TAMA;
                          else
                            ES <= E_INICIO;
                          end if;
        when E_INC_TAMA =>if pulsado_ch_down = '0' then
                            ES <= E_CARGAR_DATOS;
                          else
                            ES <= E_INICIO;
                          end if;
        when E_CARGAR_DATOS => if pulsado_ch_down = '0' then
                            ES <= E_INC_FREQ;
                          else
                            ES <= E_INICIO;
                          end if;
        when E_INC_FREQ => if pulsado_ch_down = '0' and div_freq_eq500 = '1' then---ARREGLAR
                            ES <= E_PLAY;
                          elsif pulsado_ch_down = '0' and div_freq_eq500 = '0' then
                            ES <= E_INC_FREQ;
                          elsif pulsado_ch_down = '0' then
                            ES <= E_PLAY;
                          else
                            ES <= E_INICIO;
                          end if;   
        when E_PLAY =>    if pulsado_ch_down = '0' and cont_t /= tiempo  then---ARREGLAR
                            ES <= E_INC_FREQ;
                          elsif pulsado_ch_down = '0' and cont_t = tiempo  and dir = dirm_max_1 then
                            ES <= E_CARGAR_DATOS;
                          elsif pulsado_ch_down = '0' and cont_t = tiempo  and dir /= dirm_max_1 then
                            ES <= E_INC_TAMA;
                          else
                            ES <= E_INICIO;
                          end if;                              
      end case;
     end process;

      pulsado_ch : process( clk, reset_l )
      begin
          if reset_l = '0' then
              pulsado_prev <= '0';
          elsif rising_edge(clk) then
              if(pulsado = '1') then
                pulsado_prev <= '1';
              else
                pulsado_prev <= '0';
              end if;
          end if;
      end process ; 
      pulsado_ch_up <= ( pulsado_prev xor pulsado) and pulsado;
      pulsado_ch_down <= (pulsado_prev xor pulsado) and pulsado_prev;

      proc_div_freq : process( clk, reset_l )
      begin
        if reset_l = '0' then
          d_freq <= X"00";
        elsif rising_edge(clk) then
          if dif_freq = TIME_UNIT then
            d_freq <= X"00";
          elsif clr_d_freq = '1' then
            d_freq <= X"00";
          elsif d_freq_inc = '1' then
            d_freq <= d_freq + 1;
          end if;
        end if ;
      end process;
        
      contador_dir : process( clk ,reset_l )
      begin
        if reset_l = '0' then
          dir <= X"00";
        elsif rising_edge(clk) then
          if dir_inc = '1' then
            dir <= dir + 1;
          elsif clr_dir = '1' then
            dir <= X"00";
          end if ;
        end if ;
      end process ;
        --end if;
        
    cont_t_counter : process( clk, reset_l )
    begin
      if reset_l = '0' then
        cont_t <= X"0";
      elsif rising_edge(clk) then
        if clr_cont_t = '1' then
          cont_t <= X"0";
        elsif d_cont_inc = '1' then
          cont_t <= cont_t + 1;
        end if ;
      end if ;

    end process ; -- cont_t_counter
