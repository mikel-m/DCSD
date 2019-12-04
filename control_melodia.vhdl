library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

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
    TYPE t_estado is (E_INICIO, E_CARGAR_TAMA,E_INC_TAMA, E_CARGAR_DATOS, E_INC_FREQ, E_PLAY);
    signal EP, ES, ESTADO: t_estado;
   
    signal clr_dir : std_logic;
    signal ld_mel  : std_logic;
    signal dir : unsigned(11 downto 0);--Corregir
    signal ld_max  : std_logic;
    signal dir_inc  : std_logic;
    signal ld_nota  : std_logic;
    signal ld_tiempo  : std_logic;
    signal clr_d_freq  : std_logic;
    signal clr_cont_t  : std_logic;
    signal d_freq_inc  : std_logic;
    signal d_cont_inc  : std_logic;

    --PULSADO
    signal pulsado_prev : std_logic;
    signal pulsado_ch_down : std_logic;
    signal pulsado_ch_up : std_logic;

    signal cont_t : unsigned(11 downto 0);---ARREGLAR
    signal tiempo : unsigned(11 downto 0);--ARREGLAR
    signal dirm_max_1 : unsigned(11 downto 0);--ARREGLAR
    signal div_freq_eq500 : std_logic;

begin
    --Salida UP
    clr_dir     <= '1'  when EP = E_INICIO else '0';
    ld_mel      <=  '1' when EP = E_INICIO and pulsado_ch_up = '1'  else '0';
    dir         <= B"0000_0000_0001" when pulsado_ch_down = '0' and cont_t = tiempo  and dir = dirm_max_1 else B"0000_0000_0000";
    ld_max      <= '1'  when EP = E_CARGAR_TAMA else '0';
    dir_inc     <= '1'  when EP = E_INC_TAMA else '0';
    ld_nota     <= '1'  when EP = E_CARGAR_DATOS else '0';
    ld_tiempo   <= '1'  when EP = E_CARGAR_DATOS else '0';
    clr_d_freq  <= '1'  when EP = E_CARGAR_DATOS else '0';
    clr_cont_t  <= '1'  when EP = E_CARGAR_DATOS else '0';
    d_freq_inc  <= '1'  when EP = E_INC_FREQ else '0';
    d_cont_inc  <= '1'  when EP = E_PLAY else '0';
    clr_d_freq  <= '1'  when EP = E_PLAY else '0';

    est_pr : process( clk, reset_l )
    begin
        if reset_l = '0' then
        EP <= E_INICIO;
        elsif rising_edge(clk) then
        EP <= ES;
        end if ;
    end process ; -- est_pr
    ESTADO <= EP;

    maquina_de_estados: process (EP,pulsado_ch_up,pulsado_ch_down)
    begin
      case EP is
        when E_INICIO => if pulsado_ch_up = '1' then
                            ES <= E_CARGAR_TAMA;
                          else
                            ES <= E_INICIO;
                          end if;
        when E_CARGAR_TAMA => if pulsado_ch_down = '1' then
                            ES <= E_INC_TAMA;
                          else
                            ES <= E_INICIO;
                          end if;
        when E_INC_TAMA =>if pulsado_ch_down = '1' then
                            ES <= E_CARGAR_DATOS;
                          else
                            ES <= E_INICIO;
                          end if;
        when E_CARGAR_DATOS => if pulsado_ch_down = '1' then
                            ES <= E_INC_FREQ;
                          else
                            ES <= E_INICIO;
                          end if;
        when E_INC_FREQ => if pulsado_ch_down = '0' and div_freq_eq500 = '1' then---ARREGLAR
                            ES <= E_PLAY;
                          elsif pulsado_ch_down = '0' and div_freq_eq500 = '0' then
                            ES <= E_INC_FREQ;
                          elsif pulsado_ch_down = '0' then
                            ES <= E_INICIO;
                          end if;   
        when E_INC_FREQ => if pulsado_ch_down = '0' and cont_t /= tiempo  then---ARREGLAR
                            ES <= E_INC_FREQ;
                          elsif pulsado_ch_down = '0' and cont_t = tiempo  and dir = dirm_max_1 then
                            ES <= E_CARGAR_DATOS;
                          elsif pulsado_ch_down = '0' and cont_t = tiempo  and dir /= dirm_max_1 then
                            ES <= E_INC_TAMA;
                          elsif pulsado_ch_down = '0' then
                            ES <= E_INICIO;
                          end if;                    
               --ACTIVAR LAS SEÑALES SEGÚN EL ESTADO              
      end case;

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
        else if rising_edge(clk) then
          if dif_freq == X"C350" then
          end if;
        end if ;
        
        end if;
