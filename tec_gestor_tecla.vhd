library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity  tec_gestor_tecla is
  port (
    clk     : in std_logic;
    reset_l : in std_logic;
    codigo2 : in std_logic_vector(7 downto 0);
    pulsado : in std_logic
    vol_plus : out std_logic;
    vol_minus : out std_logic;
    enable : out std_logic;
    nota_mel : in std_logic_vector(3 downto 0) ;
    enable_mel: in std_logic

    
  ) ;
end  tec_gestor_tecla; 

architecture arch of tec_gestor_tecla is
    TYPE t_estado is (E_INICIO, E_ESPERA, E_ESPERA_PULSADO, E_ENABLE_NOTA, E_SUBIR_VOL, E_BAJAR_VOL, E_ESPERA_VOL, E_ESPERA_MEL);
    signal EP, ES, ESTADO: t_estado;
   
    signal nota  : std_logic_vector(3 downto 0);
    signal mel  : std_logic_vector(3 downto 0);
    signal tecla_nota  : std_logic_vector(3 downto 0);
    signal tecla_mel  : std_logic_vector(3 downto 0);
    signal tecla_vol  : std_logic_vector(3 downto 0);
    signal pulsado_ch_up: std_logic;
    signal pulsado_prev: std_logic;
    signal modo : std_logic_vector(1 downto 0) ;
    
    
    constant K_A : std_logic_vector(7 downto 0):= X"1C";
    constant K_S : std_logic_vector(7 downto 0):= X"1B";
    constant K_D : std_logic_vector(7 downto 0):= X"23";
    constant K_F : std_logic_vector(7 downto 0):= X"2B";
    constant K_G : std_logic_vector(7 downto 0):= X"34";
    constant K_H : std_logic_vector(7 downto 0):= X"33";
    constant K_J : std_logic_vector(7 downto 0):= X"3B";
    
    constant K_X : std_logic_vector(7 downto 0):= X"22";
    constant K_C : std_logic_vector(7 downto 0):= X"21";
    constant K_Z : std_logic_vector(7 downto 0):= X"1A";
    constant K_V : std_logic_vector(7 downto 0):= X"2A";
    constant K_B : std_logic_vector(7 downto 0):= X"32";
    constant K_N : std_logic_vector(7 downto 0):= X"31";
    constant K_M : std_logic_vector(7 downto 0):= X"3A";
  
    constant K_UP : std_logic_vector(7 downto 0):= X"75";
    constant K_DOWN : std_logic_vector(7 downto 0):= X"72";
    
    constant K_1 : std_logic_vector(7 downto 0):= X"16";
    --constant K_2 : std_logic_vector(7 downto 0):= X"3A";
    --constant K_3 : std_logic_vector(7 downto 0):= X"3A";
    --constant K_4 : std_logic_vector(7 downto 0):= X"3A";
    
    constant SEL_NULL : std_logic_vector(1 downto 0) := "00" ;
    constant SEL_NOTA : std_logic_vector(1 downto 0) := "01" ;
    constant SEL_VOL  : std_logic_vector(1 downto 0) := "10" ;
    constant SEL_MEL  : std_logic_vector(1 downto 0) := "11" ;
begin
    maquina_de_estados: process (EP, codigo2, pulsado)
    begin
      case EP is
        when E_INICIO => if pulsado_ch_up = '1' then
                            ES <= E_ESPERA;
                          else
                            ES <= E_INICIO;
                          end if;
        when E_ESPERA => if modo = "00" then
                            ES <= E_ESPERA_PULSADO;
                          elsif modo = "01" then
                            ES <= E_ENABLE_NOTA;
                          elsif modo = "10" and tecla_vol = '1' then
                            ES <=  E_SUBIR_VOL;
                          elsif modo = "10" and tecla_vol = '0' then
                            ES <= E_BAJAR_VOL;
                          elsif modo = "11" then
                            ES <= E_ENABLE_MEL;
                          end if;
        when E_ESPERA_PULSADO => if pulsado_ch_down = '0' then
                                    ES <= E_ESPERA_PULSADO;
                                  else
                                    ES <= E_INICIO;
                                  end if;
        when E_ENABLE_NOTA => if pulsado_ch_down = '0' then
                                ES <= E_ENABLE_NOTA;
                              else
                                ES <= E_INICIO;
                              end if;
        when E_SUBIR_VOL => ES <= E_ESPERA_VOL;
        when E_BAJAR_VOL => ES <= E_ESPERA_VOL;
        when E_ESPERA_VOL => if pulsado_ch_down = '0' then
                                ES <= E_ESPERA_VOL;
                              else
                                ES <= E_INICIO;
                              end if;
        when E_ENABLE_MEL => if pulsado_ch_down = '0' then
                                ES <= E_ENABLE_MEL;
                              else
                                ES <= E_INICIO;
                              end if;
                            
               --ACTIVAR LAS SEÑALES SEGÚN EL ESTADO              
      end case;
    end process; 
    tecla_case : process (cod)
    begin
      case cod is
          ------NOTAS------
          when K_A => tecla_nota <= X"0";
                      sel_mode <= SEL_NOTA;
          when K_S => tecla_nota <= X"1";
                      sel_mode <= SEL_NOTA;
          when K_D => tecla_nota <= X"2";
                      sel_mode <= SEL_NOTA;
          when K_F => tecla_nota <= X"3";
                      sel_mode <= SEL_NOTA;
          when K_G => tecla_nota <= X"4";
                      sel_mode <= SEL_NOTA;
          when K_H => tecla_nota <= X"5";
                      sel_mode <= SEL_NOTA;
          when K_J => tecla_nota <= X"6";
                      sel_mode <= SEL_NOTA;
          
          when K_Z => tecla_nota <= X"7";
                      sel_mode <= SEL_NOTA;
          when K_X => tecla_nota <= X"8";
                      sel_mode <= SEL_NOTA;
          when K_C => tecla_nota <= X"9";
                      sel_mode <= SEL_NOTA;
          when K_V => tecla_nota <= X"A";
                      sel_mode <= SEL_NOTA;
          when K_B => tecla_nota <= X"B";
                      sel_mode <= SEL_NOTA;
          when K_N => tecla_nota <= X"C";
                      sel_mode <= SEL_NOTA;
          when K_M => tecla_nota <= X"D";
                      sel_mode <= SEL_NOTA;
      
          -------VOLUMEN---------
          when K_UP => tecla_vol <= '1';
                       sel_mode <= SEL_VOL;
          when K_DOWN => tecla_vol <= '0';
                         sel_mode <= SEL_VOL;
                        
          -------MELODIAS---------
          when K_1 => tecla_mel <= X'0';
                      sel_mode <= SEL_MEL;

          when others => sel_mode <= SEL_NULL;
      end case;
    end process;  
    -- Proceso de ejemplo para copypaste
    -- ej : process( clk, reset_l )
    -- begin
    --   if reset_l = '0' then
    --   elsif rising_edge(clk) then
    --  
    --   end if ;
    -- end process ;
    r_nota : process( clk, reset_l )
    begin
        if reset_l = '0' then
            nota <= X'0'
        elsif rising_edge(clk) then
            if ld_nota = '1' then
                nota <= tecla_nota;
            end if ;
    end if ;
    end process ;

    r_mel : process( clk, reset_l )
    begin
        if reset_l = '0' then
            mel <= X'0'
        elsif rising_edge(clk) then
            if ld_mel = '1' then
                mel <= tecla_mel;
            end if ;
    end if ;
    end process ;
    
    pulsado_ch : process( clk, reset_l )
    begin
        if reset_l = '0' then
            pulsado_prev <= '0';
        elsif rising_edge(clk) then
            if(ps2_clk = '1') then
                pulsado_prev <= '1';
            else
              pulsado_prev <= '0';
            end if;
        end if;
    end process ; 
    pulsado_ch_up <= ( pulsado_prev xor pulsado) and pulsado;
    
    
end architecture ;