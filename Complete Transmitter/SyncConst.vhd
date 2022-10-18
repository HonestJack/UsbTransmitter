
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SyncConst is
     port(
         syncValue : out STD_LOGIC_VECTOR(7 downto 0)
         );
end SyncConst;


architecture sync of SyncConst is
begin
	syncValue <= "10000000";
end sync;