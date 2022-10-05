ENTITY BitStuffer IS
	PORT(
		clk	   	: IN	BIT;
		dataIn		: IN	BIT;
		enable		: IN	BIT;
		reset			: IN	BIT;
		dataOut	  	: OUT	BIT;
		stopPiso	  	: OUT	BIT);
END BitStuffer;

ARCHITECTURE comportamento OF BitStuffer IS
	TYPE STATE_TYPE IS (estado_0, estado_1, estado_2, estado_3, estado_4, estado_5, estado_6);
	SIGNAL state: STATE_TYPE;

BEGIN
	PROCESS (clk, dataIn, enable, reset)
	BEGIN
		IF reset = '1' THEN
			state <= estado_0;			
		ELSIF clk'EVENT AND clk = '1' AND enable = '1' THEN 
			CASE state IS					
				WHEN estado_0 =>
						IF dataIn='1' then state <= estado_1;
						END IF;
				WHEN estado_1 =>
						IF dataIn='1' then state <= estado_2;
						ELSE state <= estado_0;
						END IF;
				WHEN estado_2 =>        
						IF dataIn='1' then state <= estado_3;
						ELSE state <= estado_0;
						END IF;
				WHEN estado_3 =>
						IF dataIn='1' then state <= estado_4;
						ELSE state <= estado_0;
						END IF;
				WHEN estado_4 =>
						IF dataIn='1' then state <= estado_5;
						ELSE state <= estado_0;
						END IF;
				WHEN estado_5 =>
						IF dataIn='1' then state <= estado_6;
						ELSE state <= estado_0;
						END IF;
				WHEN estado_6 =>
						state <= estado_0;
			END CASE;
		END IF;
	END PROCESS;

	WITH state SELECT
		dataOut 	<=	'0'	WHEN	estado_0,
						'1'	WHEN	OTHERS;
	WITH state SELECT
		stopPiso <=	'1'	WHEN	estado_6,
						'0'	WHEN	OTHERS;
END comportamento;
