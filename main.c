#include "stm8s.h"
#include "string.h"


// --- Funkce pro ovl�d�n� TM1637 ---
void setDIO(uint8_t state);
void setCLK(uint8_t state);
void tm_start(void);
void tm_stop(void);
void tm_writeByte(uint8_t b);
void tm_displayCharacter(uint8_t pos, uint8_t character);
void delay_us(uint16_t microseconds);
void playTone(uint16_t frequency, uint16_t duration_ms);
void debugEEPROM();




// --- Deklarace pro kl�vesnici ---
void initKeypad(void);
char getKey(void);

// --- KONTROLA K�DU ---
char savedCode[5] = {'1', '2', '3', '4', '\0'}; // V�choz� k�d
uint8_t isLoggedIn = 0;
uint8_t changingCode = 0;

// --- EEPROM funkce ---
void EEPROM_WriteByte(uint8_t address, uint8_t data);
uint8_t EEPROM_ReadByte(uint8_t address);
void saveCodeToEEPROM(char *code);
void loadCodeFromEEPROM(char *code);

// --- Segmentov� k�d pro ��slice ---
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

// --- PINY KL�VESNICE ---
#define ROW1_PIN GPIO_PIN_6  // PD6
#define ROW2_PIN GPIO_PIN_5  // PD5
#define ROW3_PIN GPIO_PIN_0  // PE0
#define ROW4_PIN GPIO_PIN_1  // PC1

#define COL1_PIN GPIO_PIN_0  // PG0
#define COL2_PIN GPIO_PIN_2  // PC2
#define COL3_PIN GPIO_PIN_3  // PC3


// Funkce pro nastaven� DIO a CLK
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
    // Nastaven� ��dk� jako v�stupy
    GPIO_Init(GPIOD, ROW1_PIN | ROW2_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
    GPIO_Init(GPIOE, ROW3_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
    GPIO_Init(GPIOC, ROW4_PIN, GPIO_MODE_OUT_PP_LOW_FAST);

    // Nastaven� sloupc� jako vstupy s pull-up rezistory
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

    // Vynulov�n� ��dk� (nastaven� HIGH)
    GPIOD->ODR |= ROW1_PIN | ROW2_PIN;
    GPIOE->ODR |= ROW3_PIN;
    GPIOC->ODR |= ROW4_PIN;

    for (row = 0; row < 4; row++) {
        // Nastaven� aktu�ln�ho ��dku na LOW
        switch (row) {
            case 0: GPIOD->ODR &= ~ROW1_PIN; break;
            case 1: GPIOD->ODR &= ~ROW2_PIN; break;
            case 2: GPIOE->ODR &= ~ROW3_PIN; break;
            case 3: GPIOC->ODR &= ~ROW4_PIN; break;
        }

        // Kr�tk� zpo�d�n� pro stabilizaci
        for (i = 0; i < 1000; i++);

        // Kontrola sloupc�
        for (col = 0; col < 3; col++) {
            uint8_t colState = 1;

            switch (col) {
                case 0: colState = !(GPIOG->IDR & COL1_PIN); break;
                case 1: colState = !(GPIOC->IDR & COL2_PIN); break;
                case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
            }

            if (colState) {
                // Zpo�d�n� pro debounce
                for (i = 0; i < 30000; i++);

                // Znovu ov��it, jestli je kl�vesa st�le stisknut�
                switch (col) {
                    case 0: colState = !(GPIOG->IDR & COL1_PIN); break;
                    case 1: colState = !(GPIOC->IDR & COL2_PIN); break;
                    case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
                }

                if (colState) {
                    key = keyMap[row][col];

                    // Po�kej na uvoln�n�
                    while (1) {
                        switch (col) {
                            case 0: if (GPIOG->IDR & COL1_PIN) break;
                            case 1: if (GPIOC->IDR & COL2_PIN) break;
                            case 2: if (GPIOC->IDR & COL3_PIN) break;
                        }
                        break;
                    }

                    // Obnovit ��dek zp�t na HIGH
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

        // Obnovit aktu�ln� ��dek na HIGH
        switch (row) {
            case 0: GPIOD->ODR |= ROW1_PIN; break;
            case 1: GPIOD->ODR |= ROW2_PIN; break;
            case 2: GPIOE->ODR |= ROW3_PIN; break;
            case 3: GPIOC->ODR |= ROW4_PIN; break;
        }
    }

    return 0; // ��dn� kl�vesa
}

void playTone(uint16_t frequency, uint16_t duration_ms) {
    uint32_t delay = 1000000UL / (frequency * 2); // polo�as periody (us)
    uint32_t cycles = (uint32_t)frequency * duration_ms / 1000;
		uint32_t i;

    for (i = 0; i < cycles; i++) {
        GPIO_WriteHigh(GPIOD, GPIO_PIN_3); // nap�. PD3
        delay_us(delay);
        GPIO_WriteLow(GPIOD, GPIO_PIN_3);
        delay_us(delay);
    }
}

// --- EEPROM implementace ---
void EEPROM_WriteByte(uint8_t address, uint8_t data) {
    while ((FLASH->IAPSR & FLASH_IAPSR_DUL) == 0); // �ekej na odem�en�
    *(PointerAttr uint8_t *)(uint16_t)(FLASH_DATA_START_PHYSICAL_ADDRESS + address) = data;
    FLASH->IAPSR &= (uint8_t)(~FLASH_IAPSR_EOP); // Potvr� z�pis
}

uint8_t EEPROM_ReadByte(uint8_t address) {
    return *(PointerAttr uint8_t *)(uint16_t)(FLASH_DATA_START_PHYSICAL_ADDRESS + address);
}

void saveCodeToEEPROM(char *code) {
		uint8_t i;
    for ( i = 0; i < 4; i++) {
        EEPROM_WriteByte(0xA0 + i, code[i]);
        playTone(1000 + (code[i] - '0') * 100, 100); // Indikace z�pisu
    }
}

void loadCodeFromEEPROM(char *code) {
	uint8_t i;
    for ( i = 0; i < 4; i++) {
        code[i] = EEPROM_ReadByte(0xA0 + i); // Na�ti hodnotu z EEPROM
    }
    code[4] = '\0'; // Ukon�i �et�zec
}

void debugEEPROM(void) {
		uint8_t i;
		uint8_t k;

    char debugCode[5];
    loadCodeFromEEPROM(debugCode);
    // Debug: p�ehraj t�n podle obsahu EEPROM
		for ( i = 0; i < 4; i++) {
				playTone(500 + ((debugCode[i] - '0') * 200), 100);
				delay_us(200000); // Pauza mezi t�ny
		}

    if (strlen(debugCode) == 4 && debugCode[0] >= '0' && debugCode[0] <= '9') {
        // EEPROM obsahuje platn� k�d
        playTone(2000, 300); // Jeden dlouh� t�n
    } else {
        // EEPROM obsahuje neplatn� data
        for (k = 0; i < 3; i++) {
            playTone(1000, 150); // T�i kr�tk� t�ny
            delay_us(150000);   // Pauza mezi t�ny
        }
    }
}



void main(void) {
    char key = 0;
    char userInput[5] = {' ', ' ', ' ', ' ', '\0'};
    uint8_t index = 0;
    uint8_t i;
		uint8_t l;

    // Inicializace hodinov�ho syst�mu
    CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);

    // Inicializace displeje a kl�vesnice
    GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST);
    GPIO_Init(GPIOB, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_FAST);
    GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); // V�stup pro zvuk
    initKeypad();

		// Na�ten� k�du z EEPROM
		loadCodeFromEEPROM(savedCode);
		

		for (i = 0; i < 4; i++) {
				if (savedCode[i] >= '0' && savedCode[i] <= '9') {
						playTone(1000 + (savedCode[i] - '0') * 100, 100); // P�ehraj hodnoty
				} else {
						playTone(500, 300); // T�n pro chybnou hodnotu
				}
				delay_us(200000);
		}
		
		// Kontrola platnosti k�du
		if (strlen(savedCode) != 4) {
				playTone(500, 300); // T�n pro neplatnou d�lku
		} else if (savedCode[0] < '0' || savedCode[0] > '9') {
				playTone(700, 300); // T�n pro neplatn� prvn� znak
		}
				
		if (strlen(savedCode) != 4 || savedCode[0] < '0' || savedCode[0] > '9') {
				playTone(500, 300); // T�n pro neplatnou d�lku
				strcpy(savedCode, "1234"); // Nastav v�choz� k�d
				saveCodeToEEPROM(savedCode); // Ulo� v�choz� k�d do EEPROM
				playTone(1500, 300); // Indikace inicializace
		} else {
				playTone(2000, 300); // T�n pro spr�vn� data
		}


    while (1) {
        key = getKey();

        // Pokud je stisknuta kl�vesa a nen� pln� zad�n�
        if (key >= '0' && key <= '9' && index < 4) {
            userInput[index++] = key;
            playTone(2000, 100);
        }
        // Pokud je stisknuto tla��tko zm�ny k�du (#)
        else if (key == '#' && isLoggedIn) {
            changingCode = 1;
            index = 0; // Resetuj index
            playTone(1500, 200);
        }

        // Zobraz aktu�ln� vstup na displeji
        for (i = 0; i < 4; i++) {
            if (userInput[i] >= '0' && userInput[i] <= '9') {
                tm_displayCharacter(i, digitToSegment[userInput[i] - '0']);
            } else {
                tm_displayCharacter(i, 0x00); // Vypni segment, pokud nen� zad�no ��slo
            }
        }

        // Pokud je zad�no 4 ��slic
        if (index == 4) {
            userInput[4] = '\0'; // Ukon�i vstup jako �et�zec

            if (changingCode) {
                // Ulo� nov� k�d
                strcpy(savedCode, userInput);
                saveCodeToEEPROM(savedCode);
                changingCode = 0;
                playTone(1800, 300);
            } else if (strcmp(savedCode, userInput) == 0) {
                // �sp�n� p�ihl�en�
                isLoggedIn = 1;
                playTone(1500, 400);
            } else {
                // Ne�sp�n� p�ihl�en�
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


// Debug podpora (voliteln�)
#ifdef USE_FULL_ASSERT
void assert_failed(uint8_t* file, uint32_t line) {
    while (1);
}
#endif