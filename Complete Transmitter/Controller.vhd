library IEEE;
use IEEE.STD_LOGIC_1164.all;

ENTITY Controller IS
	PORT(
		clk	 			: IN	STD_Logic;
		enableOut		: IN	STD_Logic;  -- OE_i
		valid				: IN	STD_Logic;  -- Valid_i
		loadShift		: IN	STD_Logic;  -- LS_i
		stuffing			: IN	STD_Logic;  -- ST_i
		resetIn			: IN	STD_Logic;  -- rst_i
		
		enablePiso  	: OUT	STD_Logic;  -- E1_o
		enableStuffer 	: OUT	STD_Logic;  -- E2_o
		enableNrzi  	: OUT	STD_Logic;  -- E3_o
		resetOut		  	: OUT	STD_Logic;  -- R_o
		syncData		  	: OUT	STD_Logic;  -- SD_o
		ready		 		: OUT	STD_Logic); -- Ready_o
END Controller;

ARCHITECTURE comportamento OF Controller IS
	TYPE STATE_TYPE IS (estado_0, estado_1, estado_2, estado_3, estado_4, estado_5, estado_6, estado_7, estado_8);
	SIGNAL state: STATE_TYPE;

BEGIN
	PROCESS (clk, enableOut, valid, loadShift, stuffing, resetIn)
	BEGIN
		IF resetIn = '1' THEN
			state <= estado_0;			
		ELSIF clk'EVENT AND clk = '1' THEN 
			CASE state IS					
				WHEN estado_0 =>
						IF valid='1' then state <= estado_1;
						END IF;
				WHEN estado_1 =>
						state <= estado_2;
				WHEN estado_2 =>        
						state <= estado_3;
				WHEN estado_3 =>
						state <= estado_4;
				WHEN estado_4 =>
						IF valid='1' AND loadShift='1' AND stuffing='0' then state <= estado_5;
						ELSIF valid='0' AND loadShift='1' AND stuffing='0' then state <= estado_6;
						END IF;
				WHEN estado_5 =>        
						state <= estado_4;
				WHEN estado_6 =>
						IF stuffing='1' then state <= estado_7;
						ELSE state <= estado_8;
						END IF;
				WHEN estado_7 =>
						state <= estado_8;
				WHEN estado_8 =>
						IF enableOut='0' then state <= estado_0;
						END IF;
			END CASE;
		END IF;
	END PROCESS;

	WITH state SELECT
		resetOut	<=	'1' WHEN estado_0,
						'0' WHEN OTHERS;
	WITH state SELECT
		syncData <=	'1' WHEN estado_0,
						'1' WHEN estado_1,
						'1' WHEN estado_2,
						'1' WHEN estado_3,
						'0' WHEN OTHERS;
	WITH state SELECT
		enablePiso <=	'1' WHEN estado_1,
							'1' WHEN estado_2,
							'1' WHEN estado_3,
							'1' WHEN estado_4,
							'1' WHEN estado_5,
							'0' WHEN OTHERS;
	WITH state SELECT
		enableStuffer <=	'1' WHEN estado_2,
								'1' WHEN estado_3,
								'1' WHEN estado_4,
								'1' WHEN estado_5,
								'1' WHEN estado_6,
								'0' WHEN OTHERS;
	WITH state SELECT
		enableNrzi <=	'1' WHEN estado_3,
							'1' WHEN estado_4,
							'1' WHEN estado_5,
							'1' WHEN estado_6,
							'1' WHEN estado_7,
							'0' WHEN OTHERS;
	WITH state SELECT
		ready	<=	'1' WHEN estado_5,
					'0' WHEN OTHERS;
							
END comportamento;
