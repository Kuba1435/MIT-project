#include "stm8s.h"
#include "string.h"


// --- Funkce pro ovládání TM1637 ---
void setDIO(uint8_t state);
void setCLK(uint8_t state);
void tm_start(void);
void tm_stop(void);
void tm_writeByte(uint8_t b);
void tm_displayCharacter(uint8_t pos, uint8_t character);
void delay_us(uint16_t microseconds);
void playTone(uint16_t frequency, uint16_t duration_ms);
void debugEEPROM();




// --- Deklarace pro klávesnici ---
void initKeypad(void);
char getKey(void);

// --- KONTROLA KÓDU ---
char savedCode[5] = {'1', '2', '3', '4', '\0'}; // Výchozí kód
uint8_t isLoggedIn = 0;
uint8_t changingCode = 0;

// --- EEPROM funkce ---
void EEPROM_WriteByte(uint8_t address, uint8_t data);
uint8_t EEPROM_ReadByte(uint8_t address);
void saveCodeToEEPROM(char *code);
void loadCodeFromEEPROM(char *code);

// --- Segmentový kód pro èíslice ---
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


// Funkce pro nastavení DIO a CLK
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
    GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_OUT_PP_LOW_FAST); // back to output
}

void tm_displayCharacter(uint8_t pos, uint8_t character) {
    tm_start();
    tm_writeByte(0x40); // auto-increment mode
    tm_stop();

    tm_start();
    tm_writeByte(0xC0 | pos); // start address + position
    tm_writeByte(character);
    tm_stop();

    tm_start();
    tm_writeByte(0x88); // display ON, brightness = medium
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

        // Krátké zpoždìní pro stabilizaci
        for (i = 0; i < 1000; i++);

        // Kontrola sloupcù
        for (col = 0; col < 3; col++) {
            uint8_t colState = 1;

            switch (col) {
                case 0: colState = !(GPIOG->IDR & COL1_PIN); break;
                case 1: colState = !(GPIOC->IDR & COL2_PIN); break;
                case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
            }

            if (colState) {
                // Zpoždìní pro debounce
                for (i = 0; i < 30000; i++);

                // Znovu ovìøit, jestli je klávesa stále stisknutá
                switch (col) {
                    case 0: colState = !(GPIOG->IDR & COL1_PIN); break;
                    case 1: colState = !(GPIOC->IDR & COL2_PIN); break;
                    case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
                }

                if (colState) {
                    key = keyMap[row][col];

                    // Poèkej na uvolnìní
                    while (1) {
                        switch (col) {
                            case 0: if (GPIOG->IDR & COL1_PIN) break;
                            case 1: if (GPIOC->IDR & COL2_PIN) break;
                            case 2: if (GPIOC->IDR & COL3_PIN) break;
                        }
                        break;
                    }

                    // Obnovit øádek zpìt na HIGH
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

        // Obnovit aktuální øádek na HIGH
        switch (row) {
            case 0: GPIOD->ODR |= ROW1_PIN; break;
            case 1: GPIOD->ODR |= ROW2_PIN; break;
            case 2: GPIOE->ODR |= ROW3_PIN; break;
            case 3: GPIOC->ODR |= ROW4_PIN; break;
        }
    }

    return 0; // Žádná klávesa
}

void playTone(uint16_t frequency, uint16_t duration_ms) {
    uint32_t delay = 1000000UL / (frequency * 2); // poloèas periody (us)
    uint32_t cycles = (uint32_t)frequency * duration_ms / 1000;
		uint32_t i;

    for (i = 0; i < cycles; i++) {
        GPIO_WriteHigh(GPIOD, GPIO_PIN_3); // napø. PD3
        delay_us(delay);
        GPIO_WriteLow(GPIOD, GPIO_PIN_3);
        delay_us(delay);
    }
}

// --- EEPROM implementace ---
void EEPROM_WriteByte(uint8_t address, uint8_t data) {
    while ((FLASH->IAPSR & FLASH_IAPSR_DUL) == 0); // Èekej na odemèení
    *(PointerAttr uint8_t *)(uint16_t)(FLASH_DATA_START_PHYSICAL_ADDRESS + address) = data;
    FLASH->IAPSR &= (uint8_t)(~FLASH_IAPSR_EOP); // Potvrï zápis
}

uint8_t EEPROM_ReadByte(uint8_t address) {
    return *(PointerAttr uint8_t *)(uint16_t)(FLASH_DATA_START_PHYSICAL_ADDRESS + address);
}

void saveCodeToEEPROM(char *code) {
		uint8_t i;
    for ( i = 0; i < 4; i++) {
        EEPROM_WriteByte(0xA0 + i, code[i]);
        playTone(1000 + (code[i] - '0') * 100, 100); // Indikace zápisu
    }
}

void loadCodeFromEEPROM(char *code) {
	uint8_t i;
    for ( i = 0; i < 4; i++) {
        code[i] = EEPROM_ReadByte(0xA0 + i); // Naèti hodnotu z EEPROM
    }
    code[4] = '\0'; // Ukonèi øetìzec
}

void debugEEPROM(void) {
		uint8_t i;
		uint8_t k;

    char debugCode[5];
    loadCodeFromEEPROM(debugCode);
    // Debug: pøehraj tón podle obsahu EEPROM
		for ( i = 0; i < 4; i++) {
				playTone(500 + ((debugCode[i] - '0') * 200), 100);
				delay_us(200000); // Pauza mezi tóny
		}

    if (strlen(debugCode) == 4 && debugCode[0] >= '0' && debugCode[0] <= '9') {
        // EEPROM obsahuje platný kód
        playTone(2000, 300); // Jeden dlouhý tón
    } else {
        // EEPROM obsahuje neplatná data
        for (k = 0; i < 3; i++) {
            playTone(1000, 150); // Tøi krátké tóny
            delay_us(150000);   // Pauza mezi tóny
        }
    }
}



void main(void) {
    char key = 0;
    char userInput[5] = {' ', ' ', ' ', ' ', '\0'};
    uint8_t index = 0;
    uint8_t i;
		uint8_t l;

    // Inicializace hodinového systému
    CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);

    // Inicializace displeje a klávesnice
    GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST);
    GPIO_Init(GPIOB, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_FAST);
    GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); // Výstup pro zvuk
    initKeypad();

		// Naètení kódu z EEPROM
		loadCodeFromEEPROM(savedCode);
		

		for (i = 0; i < 4; i++) {
				if (savedCode[i] >= '0' && savedCode[i] <= '9') {
						playTone(1000 + (savedCode[i] - '0') * 100, 100); // Pøehraj hodnoty
				} else {
						playTone(500, 300); // Tón pro chybnou hodnotu
				}
				delay_us(200000);
		}
		
		// Kontrola platnosti kódu
		if (strlen(savedCode) != 4) {
				playTone(500, 300); // Tón pro neplatnou délku
		} else if (savedCode[0] < '0' || savedCode[0] > '9') {
				playTone(700, 300); // Tón pro neplatný první znak
		}
				
		if (strlen(savedCode) != 4 || savedCode[0] < '0' || savedCode[0] > '9') {
				playTone(500, 300); // Tón pro neplatnou délku
				strcpy(savedCode, "1234"); // Nastav výchozí kód
				saveCodeToEEPROM(savedCode); // Ulož výchozí kód do EEPROM
				playTone(1500, 300); // Indikace inicializace
		} else {
				playTone(2000, 300); // Tón pro správná data
		}


    while (1) {
        key = getKey();

        // Pokud je stisknuta klávesa a není plné zadání
        if (key >= '0' && key <= '9' && index < 4) {
            userInput[index++] = key;
            playTone(2000, 100);
        }
        // Pokud je stisknuto tlaèítko zmìny kódu (#)
        else if (key == '#' && isLoggedIn) {
            changingCode = 1;
            index = 0; // Resetuj index
            playTone(1500, 200);
        }

        // Zobraz aktuální vstup na displeji
        for (i = 0; i < 4; i++) {
            if (userInput[i] >= '0' && userInput[i] <= '9') {
                tm_displayCharacter(i, digitToSegment[userInput[i] - '0']);
            } else {
                tm_displayCharacter(i, 0x00); // Vypni segment, pokud není zadáno èíslo
            }
        }

        // Pokud je zadáno 4 èíslic
        if (index == 4) {
            userInput[4] = '\0'; // Ukonèi vstup jako øetìzec

            if (changingCode) {
                // Ulož nový kód
                strcpy(savedCode, userInput);
                saveCodeToEEPROM(savedCode);
                changingCode = 0;
                playTone(1800, 300);
            } else if (strcmp(savedCode, userInput) == 0) {
                // Úspìšné pøihlášení
                isLoggedIn = 1;
                playTone(1500, 400);
            } else {
                // Neúspìšné pøihlášení
                playTone(300, 700);
            }

            // Reset vstupu
            index = 0;
            for (i = 0; i < 4; i++) {
                userInput[i] = ' ';
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