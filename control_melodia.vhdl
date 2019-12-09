library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;
    use work.mel_romescala.all;
    use work.mel_rombet.all;


entity  control_melodia is
  port (
    clk     : in std_logic;
    reset_l : in std_logic;
    pulsado : in std_logic;
    cod_mel : in std_logic_vector(1 downto 0) ;
    nota_mel : out std_logic_vector(3 downto 0) ;
    enable_mel: out std_logic
  ) ;
end  control_melodia; 

architecture arch of control_melodia is
    constant TIME_UNIT : unsigned(23 downto 0) := X"5B_8D_80" ;
    --constant TIME_UNIT : unsigned(23 downto 0) := X"00_00_80" ;

    TYPE t_estado is (E_INICIO, E_CARGAR_TAMA,E_INC_TAMA, E_CARGAR_DATOS, E_DISABLE_MEL, E_INC_FREQ, E_PLAY);
    signal EP, ES, ESTADO: t_estado;
   
    signal clr_dir : std_logic;
    signal ld_mel  : std_logic;
    signal r_mel : std_logic_vector(1 downto 0);
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
    
    signal r_nota : std_logic_vector(3 downto 0) ; --Hacer mas cosas
    signal r_tiempo : std_logic_vector(3 downto 0) ;
    signal r_max : unsigned(7 downto 0) ;    
  
    --PULSADO
    signal pulsado_prev : std_logic;
    signal pulsado_ch_down : std_logic;
    signal pulsado_ch_up : std_logic;

    signal cont_t : unsigned(3 downto 0); -- Contador de tiempo
    signal div_freq_eq500 : std_logic;

    signal rom_in : std_logic_vector(7 downto 0) ;
    signal rom_out_tiempo : std_logic_vector(3 downto 0) ;
    signal rom_out_nota : std_logic_vector(3 downto 0) ;
    signal rom_out_max : std_logic_vector(7 downto 0);
    signal rom_out : std_logic_vector(7 downto 0);
    signal set_dir: std_logic;

begin

    nota_mel <= r_nota;
    enable_mel <= '1' when r_nota /= X"F" and EP /= E_DISABLE_MEL else '0';

    --Salida UP
    clr_dir     <= '1' when EP = E_INICIO else '0';
    ld_mel      <= '1' when EP = E_INICIO and pulsado_ch_up = '1'  else '0';
    set_dir     <= '1' when EP = E_PLAY and pulsado_ch_down = '0' and cont_t = unsigned(r_tiempo)  and dir = r_max else '0';
    ld_max      <= '1' when EP = E_CARGAR_TAMA else '0';
    dir_inc     <= '1' when EP = E_INC_TAMA else '0';
    ld_nota     <= '1' when EP = E_CARGAR_DATOS else '0';
    ld_tiempo   <= '1' when EP = E_CARGAR_DATOS else '0';
    clr_d_freq  <= '1' when EP = E_CARGAR_DATOS or EP = E_PLAY else '0';
    clr_cont_t  <= '1' when EP = E_CARGAR_DATOS else '0';
    d_freq_inc  <= '1' when EP = E_INC_FREQ else '0';
    d_cont_inc  <= '1' when EP = E_PLAY else '0';
    div_freq_eq500 <= '1' when d_freq = TIME_UNIT else '0';

    est_pr : process( clk, reset_l )
    begin
        if reset_l = '0' then
        EP <= E_INICIO;
        elsif rising_edge(clk) then
        EP <= ES;
        end if ;
    end process ; -- est_pr
    ESTADO <= EP;

    maquina_de_estados: process (EP,pulsado_ch_up,pulsado_ch_down,div_freq_eq500, cont_t, r_tiempo, dir, r_max)
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
                            ES <= E_DISABLE_MEL;
                          else
                            ES <= E_INICIO;
                          end if;
        when E_DISABLE_MEL => if pulsado_ch_down = '0' then
                                ES <= E_INC_FREQ;
                              else
                                  ES <= E_INICIO;
                              end if ;
        when E_INC_FREQ => if pulsado_ch_down = '0' and div_freq_eq500 = '1' then---ARREGLAR
                            ES <= E_PLAY;
                          elsif pulsado_ch_down = '0' and div_freq_eq500 = '0' then
                            ES <= E_INC_FREQ;
                          elsif pulsado_ch_down = '0' then
                            ES <= E_PLAY;
                          else
                            ES <= E_INICIO;
                          end if;   
        when E_PLAY =>    if pulsado_ch_down = '0' and cont_t /= unsigned(r_tiempo)  then---ARREGLAR
                            ES <= E_INC_FREQ;
                          elsif pulsado_ch_down = '0' and cont_t = unsigned(r_tiempo)  and dir = r_max then
                            ES <= E_CARGAR_DATOS;
                          elsif pulsado_ch_down = '0' and cont_t = unsigned(r_tiempo)  and dir /= r_max then
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
        d_freq <= X"00_00_00";
      elsif rising_edge(clk) then
        if d_freq = TIME_UNIT then
          d_freq <= X"00_00_00";
        elsif clr_d_freq = '1' then
          d_freq <= X"00_00_00";
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
        elsif set_dir = '1' then
          dir <= X"01";
        elsif clr_dir = '1' then
          dir <= X"00";
        end if ;
      end if ;
    end process ;
      
    
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
    
    reg_mel : process( clk, reset_l )
    begin
      if reset_l = '0' then
        r_mel <= "00";
      elsif rising_edge(clk) then
        if ld_mel = '1' then
          r_mel <= cod_mel;
        end if ;
      end if ;
    end process ; -- reg_mel

    rom_in <= std_logic_vector(dir);
    mux_mel : process( r_mel, rom_in )
    begin
      case r_mel is
        when "00"   => rom_out <= escala15rom(to_integer(unsigned(rom_in)));
        when "01"   => rom_out <= bet27rom(to_integer(unsigned(rom_in)));
        when "10"   => rom_out <= X"00";
        when "11"   => rom_out <= X"00";
        when others => rom_out <= X"00";
      end case;
    end process ; -- mux_mel

    rom_out_tiempo <= rom_out(3 downto 0);
    rom_out_nota   <= rom_out(7 downto 4);
    rom_out_max    <= rom_out;
    
   

    proc_r_nota : process( clk, reset_l )
    begin
      if reset_l = '0' then
        r_nota <= X"0";
      elsif rising_edge(clk) then
        if ld_nota = '1' then
          r_nota <= rom_out_nota;
        end if ;
      end if ;
    end process ;

    proc_r_tiempo : process( clk, reset_l )
    begin
      if reset_l = '0' then
        r_tiempo <= X"0";
      elsif rising_edge(clk) then
        if ld_tiempo = '1' then
          r_tiempo <= rom_out_tiempo;
        end if ;
      end if ;
    end process ;

    proc_r_max : process( clk, reset_l )
    begin
      if reset_l = '0' then
        r_max <= X"00";
      elsif rising_edge(clk) then
        if ld_max = '1' then
          r_max <= unsigned(rom_out_max);
        end if ;
      end if ;
    end process ;
  end architecture;