library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;
    use work.nota8rom_pkg.all;

entity ps2 is
  port (
    clk_ps2 : in std_logic;
    reset_l : in std_logic;
    clk     : in std_logic;
    pulsado : out std_logic;
    data    : in std_logic;
    enable  : out std_logic
  ) ;
end ps2 ; 

architecture arch1 of ps2 is
  TYPE estado is (E_INICIO, E_PINCIPIO, E_ESPERA_START, E_CARGAR_BIT,E_ESPERA_1,
        E_ESPERA_2,E_ESPERA_3,E_ESPERA_STOP,E_LECTURA_TERMINADA,E_INICIO_1,E_INICIO_2,E_INICIO_3);
 
SIGNAL EP, ES	: estado;
 --Cambios en el clk
  signal clk_ps2_prev     : std_logic;
  signal clk_ps2_ch_down : std_logic; 
-- Contador
  signal clr_cont  : std_logic;
  signal cont_plus : std_logic;
  signal cont : unsigned(3 downto 0);
  signal cont_eq_8  : std_logic;
--
  signal ld_dat_par : std_logic;
  signal dat_par : std_logic;
  signal dat_par_eq_par :std_logic;
  signal ld_par : std_logic;
  signal par : std_logic;
  signal ld_sr  : std_logic;
  signal sr_in : std_logic_vector(7 downto 0);  --TODO cambiar nombre a r_in
  signal sr_out_0  : std_logic_vector(7 downto 0);-- sr = shift register
  signal sr_out_1  : std_logic_vector(7 downto 0);
  signal sr_out_2  : std_logic_vector(7 downto 0);
  signal ld_pulsado : std_logic;
  constant momento : integer range 1 to 3;
 
  signal pulsado_in: std_logic;
  --señales de ayuda
  signal parity_check: std_logic;

  --Señales de multiplexores (4 entradas de 8 bits)
  signal mux_out : std_logic_vector(7 downto 0);
  signal mux_in_0: std_logic_vector(7 downto 0);
  signal mux_in_1: std_logic_vector(7 downto 0);
  signal mux_in_2: std_logic_vector(7 downto 0);
  signal mux_in_3: std_logic_vector(7 downto 0);

  --señales limpias, perfecto
  
  signal dat_l: std_logic;
  signal clk_ps2_l: std_logic;
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
  
  maquina_de_estados : process( EP,dat_par_eq_par,clk_ps2_ch_down,cont_eq_8,momento,shift_out_0,shift_out_1,shift_out_2)
  begin
    case EP is
      when E_INICIO => ES <= E_PRINCIPIO;
      when E_PRINCIPIO => if clk_ps2_ch_down ='0' and data ='0'then
                            ES <= E_PRINCIPIO;
                        elsif clk_ps2_ch_down ='1' and data ='0' then
                            ES <= E_ESPERA_START;
                        end if;
      when E_ESPERA_START => if clk_ps2_ch_down ='0' then
                            ES <= E_ESPERA_START;
                         elsif clk_ps2_ch_down ='1' then
                            ES <= E_CARGAR_BIT;
                         end if;
      when E_CARGAR_BIT => if (dat='1' or dat='0') and cont_eq_8='0' then
                            ES<= E_ESPERA_2;
                         elsif (dat='1' or dat='0') and cont_eq_8='1' then
                            ES<= E_ESPERA_1;
                        end if ;
      when E_ESPERA_1 => if clk_ps2_ch_down ='0' then
                            ES <= E_ESPERA_1;
                         elsif clk_ps2_ch_down ='1' then
                            ES <= E_ESPERA_3;
                         end if;
      when E_ESPERA_2 => if clk_ps2_ch_down ='0' then
                            ES <= E_ESPERA_2;
                        elsif clk_ps2_ch_down ='1' then
                            ES <= E_CARGAR_BIT;
                        end if;
      when E_ESPERA_3 => if dat_par_eq_par='1' then
                            ES <= E_ESPERAR_STOP;
                         elsif dat_par_eq_par='0' then
                            ES <= E_PRINCIPIO;
                         end if;
      when E_ESPERAR_STOP => if clk_ps2_ch_down ='0' then
                            ES <= E_ESPERAR_STOP;
                            elsif clk_ps2_ch_down ='1' then
                            ES <= E_LECTURA_TERMINADA;
                            end if;
     when E_LECTURA_TERMINADA => if momento = "1" and shift_out_0="F0" then ---ARREGLAR todo este, igualdades
                                ES <= E_PRINCIPIO;
                                elsif  momento = "1" and shift_out_0!="F0" then--arreglar solo bien el ES
                                ES <= E_INICIO_2;
                                elsif  momento = "2" and shift_out_1="F0" then--arreglar solo bien el ES
                                ES <= E_PRINCIPIO;
                                elsif  momento = "2" and shift_out_1!="F0" then--arreglar solo bien el ES
                                ES <= E_INICIO_3;                          
                                elsif  momento = "3" and shift_out_2=shift_out_0 then--arreglar solo bien el ES
                                ES <= E_PRINCIPIO;                                       
                                elsif  momento = "3" and shift_out_2!=shift_out_0 then--arreglar solo bien el ES
                                ES <= E_INICIO_1;                            
                                 end if;
    end case ;
 
  end process ; -- ESTSIG
------------------------------------------------------
  --- Unidad de Proceso
  --
  --Pulsacion de 1 a 0
  clk_ps2_ch : process( clk, reset_l )
  begin
	 if reset_l = '0' then
	     clk_ps2_prev <= '0';
   elsif rising_edge(clk) then
      if(clk_ps2_l = '1') then
        clk_ps2_prev <= '1';
      else
        clk_ps2_prev <= '0';
      end if ;
   end if;
  end process ; 
  clk_ps2_ch_down <= (clk_ps2_l xor clk_ps2_prev) and clk_ps2_prev;
  ----------------------------------------------------
  -- Pulsacion de 0 a 1
  

  --Shifters y eso (TODO: Cambiar por registros normales)
  sr_in <= dat_l & mux_out(6 downto 0);-- Esto hace de SR

  lds : process( momento, ld_sr )
  begin
    if ld_sr = '1' then
      if momento = to_integer(1,2) then
        ld_sr_0 <= '1';
        ld_sr_1 <= '0';
        ld_sr_2 <= '0';
      elsif momento = to_integer(2,2) then
        ld_sr_0 <= '0';
        ld_sr_1 <= '1';
        ld_sr_2 <= '0';
      elsif momento = to_integer(3,2) then
        ld_sr_0 <= '0';
        ld_sr_1 <= '0';
        ld_sr_2 <= '1';
      else
        ld_sr_0 <= '0';
        ld_sr_1 <= '0';
        ld_sr_2 <= '0';
      end if;

    else
      ld_sr_0 <= '0';
      ld_sr_1 <= '0';
      ld_sr_2 <= '0';
    end if ;
  end process ; -- lds
-- Unidades Combinacionales
  mux : process( momento, mux_in_0, mux_in_1, mux_in_2, mux_in_3 ) --WIP
  begin
    mux_out <=  -- WIP
  end process ; -- mux
-

--- Unidades Secuenciales
  

  sr_0 : process( clk, reset_l )
  begin
    if reset_l = '0' then
      shift_out_0 <= B"0000_0000";
    elsif rising_edge(clk) then
        if ld_sr_0 = '1' then
          sr_out_0 <= sr_in;
        end if ;
    end if ;
  end process ; -- sr_0

  sr_1 : process( clk, reset_l )
  begin
    if reset_l = '0' then
      shift_out_1 <= B"0000_0000";
    elsif rising_edge(clk) then
        if ld_sr_1 = '1' then
          sr_out_1 <= sr_in;
        end if ;
    end if ;
  end process ; -- sr_1

  sr_2 : process( clk, reset_l )
  begin
    if reset_l = '0' then
      shift_out_2 <= B"0000_0000";
    elsif rising_edge(clk) then
        if ld_sr_2 = '1' then
          sr_out_2 <= sr_in;
        end if ;
    end if ;
  end process ; -- sr_2

  r_par : process( clk,reset_l )
  begin
    if reset_l = '0' then
      par <= '0';
    elsif rising_edge(clk) then
      if ld_par = '1' then
        par <= not par;
      end if;        
    end if ;
  end process ; -- r_par
  
  r_dat_par : process( clk,reset_l )
  begin
    if reset_l = '0' then
      dat_par <= '0';
    elsif rising_edge(clk) then
      if ld_par = '1' then
        dat_par <= dat_l;
      end if;        
    end if ;
  end process ; -- r_par
  
  count_8 : process( clk,reset_l )
  begin
    if reset_l = '0' then
      cont <= to_unsigned(0,3);
    elsif rising_edge(clk) then
      if clr_cont = '1' then
        cont <= to_unsigned(0,3);
      elsif cont_plus = '1' then
        cont <= cont + 1;
      end if ;
    end if ;
  end process ; -- count_8
  
  r_pulsado : process( clk, reset_l )
  begin
    if reset_l = '0' then
      pulsado <= '0';
    elsif rising_edge(clk) then
      if ld_pulsado then
        pulsado <= pulsado_in;
      end if ;  
    end if ;
  end process ; -- r_pulsado

  -- Proceso de ejemplo para copypaste
  ej : process( clk, reset_l )
  begin
    if reset_l = '0' then
    elsif rising_edge(clk) then
      
    end if ;
  end process ;

  end architecture ;