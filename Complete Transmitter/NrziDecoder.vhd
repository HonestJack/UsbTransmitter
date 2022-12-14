LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY NrziDecoder IS
	PORT(
		clk	   	: IN	STD_Logic;
		dataIn		: IN	STD_Logic;
		enable		: IN	STD_Logic;
		reset			: IN	STD_Logic;
		dataOut	  	: OUT	STD_Logic);
END NrziDecoder;

ARCHITECTURE comportamento OF NrziDecoder IS
	TYPE STATE_TYPE IS (estado_0, estado_1);
	SIGNAL state: STATE_TYPE;
BEGIN
	PROCESS (clk, dataIn, enable, reset)
	BEGIN
		IF reset = '1' THEN
			state <= estado_0;			
		ELSIF clk'EVENT AND clk = '1' AND enable = '1' THEN 
			CASE state IS
				WHEN estado_0 =>
						IF dataIn='0' then state <= estado_1;
						END IF;
				WHEN estado_1 =>
						IF dataIn='0' then state <= estado_0;
						END IF;
			END CASE;
		END IF;
	END PROCESS;

	WITH state SELECT
		dataOut 	<=	'0'	WHEN	estado_0,
						'1'	WHEN	estado_1;
END comportamento;
