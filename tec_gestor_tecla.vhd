library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity  is
  port (
  ) ;
end  ; 

architecture arch of  is

begin
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
          when K_DOWN => tecla_vol <= '1';
                         sel_mode <= SEL_VOL;
                        
          -------MELODIAS---------
          when K_1 => tecla_mel <= '1';
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
end architecture ;