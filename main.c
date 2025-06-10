#include "stm8s.h"
#include "milis.h"


// Adresa EEPROM, kde bude uložen PIN (4 bajty)
#define EEPROM_PIN_ADDR 0x4000

// Výchozí PIN - pøi prvním spuštìní nebo pokud v EEPROM není uložen správný PIN
const char defaultPIN[4] = {'1', '2', '3', '4'};

// PIN naètený z EEPROM
char storedPIN[4];  


// --- TM1637 ---
void setDIO(uint8_t state);
void setCLK(uint8_t state);
void tm_start(void);
void tm_stop(void);
void tm_writeByte(uint8_t b);
void tm_displayCharacter(uint8_t pos, uint8_t character);
void delay_us(uint16_t microseconds);


// --- Klávesnice ---
void initKeypad(void);
char getKey(void);


// --- Bzuèák ---
void buzzerInit(void);
void beepSuccess(void);
void beepFail(void);
void beepTone(uint16_t freq, uint16_t duration_ms);


//LED
void blinkLED(uint8_t times, char color);
void beepAndBlink(uint16_t frequency, uint16_t duration_ms, GPIO_TypeDef* port, GPIO_Pin_TypeDef pin);


// --- Segmentový kód ---
const uint8_t digitToSegment[] = {
    0x3F, // 0
    0x06, // 1
    0x5B, // 2
    0x4F, // 3
    0x66, // 4
    0x6D, // 5
    0x7D, // 6
    0x07, // 7
    0x7F, // 8
    0x6F  // 9
};


// --- PINY TM1637 ---
#define TM_CLK_PORT  GPIOB
#define TM_CLK_PIN   GPIO_PIN_5
#define TM_DIO_PORT  GPIOB
#define TM_DIO_PIN   GPIO_PIN_4


// --- PINY KLÁVESNICE ---
#define ROW1_PIN GPIO_PIN_6  // PD6
#define ROW2_PIN GPIO_PIN_5  // PD5
#define ROW3_PIN GPIO_PIN_0  // PE0
#define ROW4_PIN GPIO_PIN_1  // PC1

#define COL1_PIN GPIO_PIN_0  // PG0
#define COL2_PIN GPIO_PIN_2  // PC2
#define COL3_PIN GPIO_PIN_3  // PC3


// --- Bzuèák na PD3 ---
#define BUZZER_PORT GPIOD
#define BUZZER_PIN  GPIO_PIN_3



void setDIO(uint8_t state) {
    if (state) GPIO_WriteHigh(TM_DIO_PORT, TM_DIO_PIN);
    else GPIO_WriteLow(TM_DIO_PORT, TM_DIO_PIN);
}

void setCLK(uint8_t state) {
    if (state) GPIO_WriteHigh(TM_CLK_PORT, TM_CLK_PIN);
    else GPIO_WriteLow(TM_CLK_PORT, TM_CLK_PIN);
}


void tm_start(void) {
    setCLK(1);
    setDIO(1);
    delay_us(2);
    setDIO(0);
    delay_us(2);
    setCLK(0);
}

void tm_stop(void) {
    setCLK(0);
    delay_us(2);
    setDIO(0);
    delay_us(2);
    setCLK(1);
    delay_us(2);
    setDIO(1);
}

void tm_writeByte(uint8_t b) {
    uint8_t i;
    for (i = 0; i < 8; i++) {
        setCLK(0);
        setDIO(b & 0x01);
        delay_us(3);
        setCLK(1);
        delay_us(3);
        b >>= 1;
    }

    // ACK
    setCLK(0);
    GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_IN_FL_NO_IT); // input
    delay_us(5);
    setCLK(1);
    delay_us(5);
    setCLK(0);
    GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_OUT_PP_LOW_FAST); // output
}

void tm_displayCharacter(uint8_t pos, uint8_t character) {
    tm_start();
    tm_writeByte(0x40); 
    tm_stop();

    tm_start();
    tm_writeByte(0xC0 | pos); 
    tm_writeByte(character);
    tm_stop();

    tm_start();
    tm_writeByte(0x88); // display ON, brightness medium
    tm_stop();
}

void delay_us(uint16_t us) {
    uint16_t i;
    for (i = 0; i < us; i++) {
        _asm("nop"); _asm("nop"); _asm("nop"); _asm("nop");
        _asm("nop"); _asm("nop"); _asm("nop"); _asm("nop");
    }
}

void initKeypad(void) {
    // Nastavení øádkù jako výstupy
    GPIO_Init(GPIOD, ROW1_PIN | ROW2_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
    GPIO_Init(GPIOE, ROW3_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
    GPIO_Init(GPIOC, ROW4_PIN, GPIO_MODE_OUT_PP_LOW_FAST);

    // Nastavení sloupcù jako vstupy s pull-up rezistory
    GPIO_Init(GPIOG, COL1_PIN, GPIO_MODE_IN_PU_NO_IT);
    GPIO_Init(GPIOC, COL2_PIN | COL3_PIN, GPIO_MODE_IN_PU_NO_IT);
}

char getKey(void) {
    const char keyMap[4][3] = {
        {'1', '2', '3'},
        {'4', '5', '6'},
        {'7', '8', '9'},
        {'*', '0', '#'}
    };

    int row, col;
    char key = 0;
    uint32_t i;

    // Vynulování øádkù (nastavení HIGH)
    GPIOD->ODR |= ROW1_PIN | ROW2_PIN;
    GPIOE->ODR |= ROW3_PIN;
    GPIOC->ODR |= ROW4_PIN;

    for (row = 0; row < 4; row++) {
        // Nastavení aktuálního øádku na LOW
        switch (row) {
            case 0: GPIOD->ODR &= ~ROW1_PIN; break;
            case 1: GPIOD->ODR &= ~ROW2_PIN; break;
            case 2: GPIOE->ODR &= ~ROW3_PIN; break;
            case 3: GPIOC->ODR &= ~ROW4_PIN; break;
        }

        for (i = 0; i < 1000; i++); // malé zpoždìní

        for (col = 0; col < 3; col++) {
            uint8_t colState = 1;

            switch (col) {
                case 0: colState = !(GPIOG->IDR & COL1_PIN); break;
                case 1: colState = !(GPIOC->IDR & COL2_PIN); break;
                case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
            }

            if (colState) {
                for (i = 0; i < 30000; i++); // debounce

                // potvrzení klávesy
                switch (col) {
                    case 0: colState = !(GPIOG->IDR & COL1_PIN); break;
                    case 1: colState = !(GPIOC->IDR & COL2_PIN); break;
                    case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
                }

                if (colState) {
                    key = keyMap[row][col];

                    // èekání na uvolnìní klávesy
                    while (1) {
                        uint8_t released = 0;
                        switch (col) {
                            case 0: released = (GPIOG->IDR & COL1_PIN) != 0; break;
                            case 1: released = (GPIOC->IDR & COL2_PIN) != 0; break;
                            case 2: released = (GPIOC->IDR & COL3_PIN) != 0; break;
                        }
                        if (released) break;
                    }

                    // Obnovit øádek na HIGH
                    switch (row) {
                        case 0: GPIOD->ODR |= ROW1_PIN; break;
                        case 1: GPIOD->ODR |= ROW2_PIN; break;
                        case 2: GPIOE->ODR |= ROW3_PIN; break;
                        case 3: GPIOC->ODR |= ROW4_PIN; break;
                    }

                    return key;
                }
            }
        }

        // Obnovit øádek na HIGH
        switch (row) {
            case 0: GPIOD->ODR |= ROW1_PIN; break;
            case 1: GPIOD->ODR |= ROW2_PIN; break;
            case 2: GPIOE->ODR |= ROW3_PIN; break;
            case 3: GPIOC->ODR |= ROW4_PIN; break;
        }
    }

    return 0; // žádná klávesa
}


// --- Bzuèák ---
void buzzerInit(void) {
    // nastavit PD3 jako výstup (push-pull)
    GPIO_Init(BUZZER_PORT, BUZZER_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
    GPIO_WriteLow(BUZZER_PORT, BUZZER_PIN);
}

void beepTone(uint16_t freq, uint16_t duration_ms) {
	uint32_t i;
	
    // jednoduché pípnutí pomocí delay a togglování pinu
    uint32_t delay = 1000000 / (freq * 2); // poloviny periody v us
    uint32_t cycles = (uint32_t)freq * duration_ms / 1000;

    for (i = 0; i < cycles; i++) {
        GPIO_WriteHigh(BUZZER_PORT, BUZZER_PIN);
        delay_us(delay);
        GPIO_WriteLow(BUZZER_PORT, BUZZER_PIN);
        delay_us(delay);
    }
}



// Funkce, ktera paralelne blika a prehrava success ton po prihlaseni
void beepSuccess(void) {
    uint16_t freq = 3000;
    uint16_t totalDuration = 300;  
    uint16_t chunkDuration = 50;   
    uint16_t elapsed = 0;
    uint8_t ledOn = 0;

    while (elapsed < totalDuration) {
        if (ledOn) {
            GPIO_WriteLow(GPIOE, GPIO_PIN_5);
            ledOn = 0;
        } else {
            GPIO_WriteHigh(GPIOE, GPIO_PIN_5);
            ledOn = 1;
        }

        beepTone(freq, chunkDuration);

        elapsed += chunkDuration;
    }

    GPIO_WriteLow(GPIOC, GPIO_PIN_4);
}


void beepFail(void) {
    beepTone(600, 100);  
    delay_ms(50);
    beepTone(600, 100);  
}

// --- Funkce pro EEPROM ---
uint8_t EEPROM_ReadByte(uint16_t addr) {
    // Ètení bajtu z EEPROM
    return *((uint8_t*)addr);
}


void EEPROM_WriteByte(uint16_t addr, uint8_t data) {
    // Povolení zápisu do EEPROM
    FLASH_Unlock(FLASH_MEMTYPE_DATA);
    FLASH_ProgramByte(addr, data);
    FLASH_Lock(FLASH_MEMTYPE_DATA);
}

// --- Naètení PIN z EEPROM nebo nastavení defaultního ---
void loadPINfromEEPROM(void) {
    uint8_t i;
    uint8_t valid = 1;
    for (i = 0; i < 4; i++) {
        storedPIN[i] = EEPROM_ReadByte(EEPROM_PIN_ADDR + i);
        // Kontrola, že v EEPROM je èíslo '0' až '9'
        if (storedPIN[i] < '0' || storedPIN[i] > '9') {
            valid = 0;
        }
    }
    if (!valid) {
        // EEPROM neobsahuje validní PIN, uložíme defaultní
        for (i = 0; i < 4; i++) {
            storedPIN[i] = defaultPIN[i];
            EEPROM_WriteByte(EEPROM_PIN_ADDR + i, defaultPIN[i]);
        }
    }
}

// --- Uložení PIN do EEPROM ---
void savePINtoEEPROM(const char* newPIN) {
    uint8_t i;
    for (i = 0; i < 4; i++) {
        storedPIN[i] = newPIN[i];
        EEPROM_WriteByte(EEPROM_PIN_ADDR + i, newPIN[i]);
    }
}

// --- Porovnání dvou PINù ---
uint8_t comparePIN(const char* a, const char* b) {
    uint8_t i;
    for (i = 0; i < 4; i++) {
        if (a[i] != b[i]) return 0;
    }
    return 1;
}


void blinkDisplay(uint8_t times) {
    uint8_t i, j;
    for (i = 0; i < times; i++) {
        for (j = 0; j < 4; j++) {
            tm_displayCharacter(j, 0x7F); 
        }
        delay_us(300000); 
        
        for (j = 0; j < 4; j++) {
            tm_displayCharacter(j, 0x00);
        }
        delay_us(300000);
    }
}


// --- factory reset ---
void factoryResetPIN(void) {
    savePINtoEEPROM(defaultPIN);
    beepSuccess();
    blinkDisplay(2); 
}

void blinkLED(uint8_t times, char color){
	    uint8_t i;
			if (color == 'r'){
				for (i = 0; i < times; i++) {
					GPIO_WriteHigh(GPIOC, GPIO_PIN_4); 
					delay_ms(250);
					GPIO_WriteLow(GPIOC, GPIO_PIN_4);  
				}
			}
			else{
					for (i = 0; i < times; i++) {
						GPIO_WriteHigh(GPIOE, GPIO_PIN_5);
						delay_ms(500);
						GPIO_WriteLow(GPIOE, GPIO_PIN_5);
						delay_ms(500);
				}
			}

}


void logoutSignal(void) {
    uint8_t i;
    uint8_t j;
    uint8_t k;

    for (i = 0; i < 2; i++) {
        beepTone(1000, 100);
        delay_ms(100);
    }

    for (i = 0; i < 2; i++) {
        GPIO_WriteHigh(GPIOC, GPIO_PIN_4);
        delay_ms(200);
        GPIO_WriteLow(GPIOC, GPIO_PIN_4);
        delay_ms(200);
    }

    for (k = 0; k < 2; k++) {
        for (j = 0; j < 4; j++) tm_displayCharacter(j, 0xFF);
        delay_ms(200);
        for (j = 0; j < 4; j++) tm_displayCharacter(j, 0x00);
        delay_ms(200);
    }
}


void main(void) {
    char key = 0;
    char userInput[4] = {' ', ' ', ' ', ' '};
    uint8_t index = 0;
    uint8_t i, j, k;
    uint8_t loggedIn = 0;
    uint32_t loginStartTime = 0;
    const uint32_t LOGIN_TIMEOUT_MS = 5000;

    CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);

    GPIO_Init(TM_CLK_PORT, TM_CLK_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
    GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
    GPIO_Init(GPIOE, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT);
		
		// LED PIN init
		GPIO_Init(GPIOC, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_FAST); // èervená LED
		GPIO_Init(GPIOE, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST); // zelená LED
		
		
		// EXTERNAL DEVICE
		GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_FAST);//PD4
		GPIO_WriteLow(GPIOD, GPIO_PIN_4); 

    initKeypad();
    buzzerInit();
    init_milis();

    for (i = 0; i < 4; i++) {
        tm_displayCharacter(i, 0x00);
    }

    loadPINfromEEPROM();

    while (1) {
        key = getKey();


        // Tlaèítko factory reset
        if (GPIO_ReadInputPin(GPIOE, GPIO_PIN_4) == RESET) {
            factoryResetPIN();
            while (GPIO_ReadInputPin(GPIOE, GPIO_PIN_4) == RESET);
            index = 0;
            for (i = 0; i < 4; i++) {
                userInput[i] = ' ';
                tm_displayCharacter(i, 0x00);
            }
            loggedIn = 0;
        }

        // Automatického odhlášení
					if (loggedIn) {
							uint32_t now = milis();
							if ((now - loginStartTime) >= LOGIN_TIMEOUT_MS) {
									logoutSignal();
					
									loggedIn = 0;
									index = 0;
									for ( i = 0; i < 4; i++) {
											userInput[i] = ' ';
											tm_displayCharacter(i, 0x00);
									}
									GPIO_WriteLow(GPIOD, GPIO_PIN_4);
							}
					}

				// Kontrola zmacknute klavesy a overeni pinu
        if (key != 0) {
            if (key >= '0' && key <= '9') {
                if (index < 4) {
                    userInput[index] = key;
                    tm_displayCharacter(index, digitToSegment[key - '0']);
                    index++;

										// cekat na userinput 4 cislic
                    if (index == 4) {
											
												// pokud neni prihlasen overit pin
                        if (!loggedIn) {

                            if (comparePIN(userInput, storedPIN)) {
																beepSuccess();
																loggedIn = 1;
                                loginStartTime = milis();
																GPIO_WriteHigh(GPIOD, GPIO_PIN_4);
                            } else {
                                beepFail();
																blinkLED(1, 'r');
                            }
														
														// vymazani user inputu
                            index = 0;
                            for (j = 0; j < 4; j++) {
                                userInput[j] = ' ';
                                tm_displayCharacter(j, 0x00);
                            }
                        }
                    }
                }
            } else if (key == '*') {
                // Mazání poslední èíslice
                if (index > 0) {
                    index--;
                    userInput[index] = ' ';
                    tm_displayCharacter(index, 0x00);
                }
            } else if (key == '#') {
                // Pokud je pøihlášený a zadá 4 èíslice, mùže zmìnit PIN po stisknuti #
                if (loggedIn && index == 4) {
                    savePINtoEEPROM(userInput);
                    blinkDisplay(2);  
										
                    // Aktualizovat uložený PIN v RAM
                    for (j = 0; j < 4; j++) {
                        storedPIN[j] = userInput[j];
                    }

                    // Ihned odhlásit uživatele po zmìnì PINu -> safety future
                    loggedIn = 0;
                    index = 0;
										blinkLED(1, '');
                    for (j = 0; j < 4; j++) {
                        userInput[j] = ' ';
                        tm_displayCharacter(j, 0x00);
                    }
										GPIO_WriteLow(GPIOD, GPIO_PIN_4);
                }
            }
        }
    }
}




// Debug podpora (volitelné)
#ifdef USE_FULL_ASSERT
void assert_failed(uint8_t* file, uint32_t line) {
    while (1);
}
#endif
