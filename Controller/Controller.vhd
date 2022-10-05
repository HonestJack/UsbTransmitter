ENTITY Controller IS
	PORT(
		clk	 			: IN	BIT;
		enableOut		: IN	BIT;
		stuffing			: IN	BIT;
		loadShift		: IN	BIT;
		valid				: IN	BIT;
		resetIn			: IN	BIT;
		enablePiso  	: OUT	BIT;
		enableStuffer 	: OUT	BIT;
		enableNrzi  	: OUT	BIT;
		resetOut		  	: OUT	BIT;
		syncData		  	: OUT	BIT;
		Ready		 		: OUT	BIT);
END Controller;

ARCHITECTURE comportamento OF Controller IS
	TYPE STATE_TYPE IS (estado_0, estado_1, estado_2, estado_3, estado_4, estado_5, estado_6, estado_7, estado_8);
	SIGNAL state: STATE_TYPE;

BEGIN
	PROCESS (clk, dataIn, enableIn, reset)
	BEGIN
		IF reset = '1' THEN
			state <= estado_0;			
		ELSIF clk'EVENT AND clk = '1' THEN 
			CASE state IS					
				WHEN estado_0 =>
						IF enableIn='1' THEN
							IF dataIn='1' then state <= estado_1;
							ELSE state <= estado_2;
							END IF;
						END IF;
				WHEN estado_1 =>
						IF enableIn='0' then state <= estado_3;
						ELSIF dataIn='0' then state <= estado_2;
						END IF;
				WHEN estado_2 =>
						IF enableIn='0' then state <= estado_3;
						ELSIF dataIn='1' then state <= estado_1;
						END IF;
				WHEN estado_3 =>        
						state <= estado_4;
				WHEN estado_4 =>
						state <= estado_5;
				WHEN estado_5 =>
						state <= estado_0;
			END CASE;
		END IF;
	END PROCESS;

	WITH state SELECT
		dataOutMinus 	<=	'0' WHEN estado_1,
								'1' WHEN estado_2,
								'0' WHEN estado_3,
								'0' WHEN estado_4,
								'0' WHEN estado_5,
								'1' WHEN OTHERS;
	WITH state SELECT
		dataOutPlus 	<=	'1' WHEN estado_1,
								'0' WHEN estado_2,
								'1' WHEN estado_3,
								'0' WHEN estado_4,
								'1' WHEN estado_5,
								'0' WHEN OTHERS;
	WITH state SELECT
		enableOut 		<=	'0' WHEN	estado_0,
								'1' WHEN	OTHERS;				
END comportamento;
