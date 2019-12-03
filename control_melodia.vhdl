library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity  control_melodia is
  port (
   
  ) ;
end  tec_gestor_tecla; 

architecture arch of control_melodia is
    TYPE t_estado is (E_INICIO, E_CARGAR_TAMAÑO,E_INC_TAMAÑO, E_CARGAR_DATOS, E_INC_FREQ, E_, E_ESPERA_VOL, E_ENABLE_MEL);
    signal EP, ES, ESTADO: t_estado;
   

begin
    --Salida UP
    

    est_pr : process( clk, reset_l )
    begin
        if reset_l = '0' then
        EP <= E_INICIO;
        elsif rising_edge(clk) then
        EP <= ES;
        end if ;
    end process ; -- est_pr
    ESTADO <= EP;

    maquina_de_estados: process (EP,sado_ch_up)
    begin
      case EP is
        when E_INICIO => if pulsado_ch_up = '1' then
                            ES <= E_ESPERA;
                          else
                            ES <= E_INICIO;
                          end if;
        when E_ESPERA => if r_modo_out = "00" then
                            ES <= E_ESPERA_PULSADO;
                          elsif r_modo_out = "01" then
                            ES <= E_ENABLE_NOTA;
                          elsif r_modo_out = "10" and tecla_vol = '1' then
                            ES <=  E_SUBIR_VOL;
                          elsif r_modo_out = "10" and tecla_vol = '0' then
                            ES <= E_BAJAR_VOL;
                          elsif r_modo_out = "11" then
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


      proc_div_freq : process( clk, reset_l )
      begin
        if reset_l = '0' then
        else if rising_edge(clk) then
          if dif_freq == X"C350" then
          end if;
        end if ;
        
        end if;
