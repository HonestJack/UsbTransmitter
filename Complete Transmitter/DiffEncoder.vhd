LIBRARY ieee; 						-- declara a biblioteca IEEE
USE ieee.std_logic_1164.all; 	-- declara o uso do pacote std_logic_1164 da biblioteca IEEE

ENTITY DiffEncoder IS
	PORT(
		clk	 			: IN	STD_Logic;
		dataIn			: IN	STD_Logic;
		enableIn			: IN	STD_Logic;
		reset				: IN	STD_Logic;
		dataOutPlus		: OUT	STD_Logic;
		dataOutMinus  	: OUT	STD_Logic;
		enableOut 		: OUT	STD_Logic);
END DiffEncoder;

ARCHITECTURE comportamento OF DiffEncoder IS
	TYPE STATE_TYPE IS (estado_0, estado_1, estado_2, estado_3, estado_4);
	SIGNAL state: STATE_TYPE;

BEGIN
	PROCESS (clk, dataIn, enableIn, reset)
	BEGIN
		IF reset = '1' THEN
			state <= estado_0;			
		ELSIF clk'EVENT AND clk = '1' THEN 
			CASE state IS					
				WHEN estado_0 =>
						IF enableIn='1' then state <= estado_1;
						END IF;
				WHEN estado_1 =>
						IF enableIn='0' then state <= estado_2;
						END IF;
				WHEN estado_2 =>        
						state <= estado_3;
				WHEN estado_3 =>
						state <= estado_4;
				WHEN estado_4 =>
						state <= estado_0;
			END CASE;
		END IF;
	END PROCESS;

	WITH state SELECT
		dataOutMinus 	<=	not dataIn WHEN estado_1,
								'0' WHEN OTHERS;
	WITH state SELECT
		dataOutPlus 	<=	dataIn WHEN estado_1,
								'1' WHEN estado_4,
								'0' WHEN OTHERS;
	WITH state SELECT
		enableOut 		<=	'0' WHEN	estado_0,
								'1' WHEN	OTHERS;				
END comportamento;
