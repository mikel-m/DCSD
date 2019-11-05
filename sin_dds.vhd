library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use work.sin256rom_pkg.all;

entity sin_dds is 
 port(	clk_50 		:  in  std_logic;
		reset 		:  in  std_logic;
		freq 		:  in  std_logic_vector(11 downto 0); -- frecuencia en hz (entero, sin decimales)
		voldec 		: in std_logic_vector(3 downto 0); -- nivel de reducción de volumen (0 a 15)
		nextsample 	: in std_logic;
		enable 		: in std_logic;
		sample 		:  out  std_logic_vector(15 downto 0));
end sin_dds;

architecture a of sin_dds is 
  signal fase : unsigned(12 downto 0);
  signal next_fase : unsigned(12 downto 0);
  signal addr : unsigned(7 downto 0);
  signal dat : signed(15 downto 0);
  
begin
	process (clk_50, reset)
	begin
		if (reset='1') then
			fase <= (others => '0');
		elsif (clk_50'event and clk_50='1') then
			if (enable='1' and nextsample='1') then
				fase <= next_fase;
			end if;
		end if;
	end process;
	
	next_fase <= fase + unsigned(freq);
	
	addr <= fase(12 downto 5);
	
	dat <= sin256rom(to_integer(addr));
	
	sample <= std_logic_vector(resize(shift_right(dat,to_integer(unsigned(voldec))), 16)) when enable='1' else x"0000";

end architecture a;
