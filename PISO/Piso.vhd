
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Piso is
     port(
         clk : in STD_LOGIC;
         reset : in STD_LOGIC;
			enable : in STD_LOGIC;
         load : in STD_LOGIC;
         dataIn : in STD_LOGIC_VECTOR(7 downto 0);
			loadShift: out STD_LOGIC;
         dataOut : out STD_LOGIC
         );
end Piso;


architecture piso_arc of Piso is
	SIGNAL counter : Integer range 0 to 255;
begin

    piso : process (clk, reset, enable, load, dataIn) is
    variable temp : std_logic_vector (7 downto 0);
	 begin
		if reset = '1' then
			temp := (others=>'0');
			counter <= 0;			
		elsif clk'event AND clk = '1' AND enable = '1' then
			if (counter=8) then
				counter <= 0;
				loadShift <= '1';
            temp := dataIn ;
			else
				counter <= counter + 1;
				loadShift <= '0';
            dataOut <= temp(7);
            temp := temp(6 downto 0) & '0';
			end if;
		end if;
	end process piso;
end piso_arc;