#include "stm8s.h"
#include "milis.h"

// Adresa EEPROM, kde bude ulo�en PIN (4 bajty)
#define EEPROM_PIN_ADDR 0x4000

// V�choz� PIN - p�i prvn�m spu�t�n� nebo pokud v EEPROM nen� ulo�en spr�vn� PIN
const char defaultPIN[4] = {'1', '2', '3', '4'};

char storedPIN[4];   // PIN na�ten� z EEPROM


// --- TM1637 ---
void setDIO(uint8_t state);
void setCLK(uint8_t state);
void tm_start(void);
void tm_stop(void);
void tm_writeByte(uint8_t b);
void tm_displayCharacter(uint8_t pos, uint8_t character);
void delay_us(uint16_t microseconds);

// --- Kl�vesnice ---
void initKeypad(void);
char getKey(void);

// --- Bzu��k ---
void buzzerInit(void);
void beepSuccess(void);
void beepFail(void);
void beepTone(uint16_t freq, uint16_t duration_ms);

// --- Segmentov� k�d ---
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

// --- Bzu��k na PD3 ---
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
    tm_writeByte(0x40); // auto-increment mode
    tm_stop();

    tm_start();
    tm_writeByte(0xC0 | pos); // start address + position
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

        for (i = 0; i < 1000; i++); // mal� zpo�d�n�

        for (col = 0; col < 3; col++) {
            uint8_t colState = 1;

            switch (col) {
                case 0: colState = !(GPIOG->IDR & COL1_PIN); break;
                case 1: colState = !(GPIOC->IDR & COL2_PIN); break;
                case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
            }

            if (colState) {
                for (i = 0; i < 30000; i++); // debounce

                // potvrzen� kl�vesy
                switch (col) {
                    case 0: colState = !(GPIOG->IDR & COL1_PIN); break;
                    case 1: colState = !(GPIOC->IDR & COL2_PIN); break;
                    case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
                }

                if (colState) {
                    key = keyMap[row][col];

                    // �ek�n� na uvoln�n� kl�vesy
                    while (1) {
                        uint8_t released = 0;
                        switch (col) {
                            case 0: released = (GPIOG->IDR & COL1_PIN) != 0; break;
                            case 1: released = (GPIOC->IDR & COL2_PIN) != 0; break;
                            case 2: released = (GPIOC->IDR & COL3_PIN) != 0; break;
                        }
                        if (released) break;
                    }

                    // Obnovit ��dek na HIGH
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

        // Obnovit ��dek na HIGH
        switch (row) {
            case 0: GPIOD->ODR |= ROW1_PIN; break;
            case 1: GPIOD->ODR |= ROW2_PIN; break;
            case 2: GPIOE->ODR |= ROW3_PIN; break;
            case 3: GPIOC->ODR |= ROW4_PIN; break;
        }
    }

    return 0; // ��dn� kl�vesa
}


// --- Bzu��k ---
void buzzerInit(void) {
    // nastavit PD3 jako v�stup (push-pull)
    GPIO_Init(BUZZER_PORT, BUZZER_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
    GPIO_WriteLow(BUZZER_PORT, BUZZER_PIN);
}

void beepTone(uint16_t freq, uint16_t duration_ms) {
	uint32_t i;
	
    // jednoduch� p�pnut� pomoc� delay a togglov�n� pinu
    uint32_t delay = 1000000 / (freq * 2); // poloviny periody v us
    uint32_t cycles = (uint32_t)freq * duration_ms / 1000;

    for (i = 0; i < cycles; i++) {
        GPIO_WriteHigh(BUZZER_PORT, BUZZER_PIN);
        delay_us(delay);
        GPIO_WriteLow(BUZZER_PORT, BUZZER_PIN);
        delay_us(delay);
    }
}

void beepSuccess(void) {
    beepTone(1000, 100);
}

void beepFail(void) {
    beepTone(500, 100);
    delay_us(100000);
    beepTone(500, 100);
}

// --- Funkce pro EEPROM ---
uint8_t EEPROM_ReadByte(uint16_t addr) {
    // �ten� bajtu z EEPROM
    return *((uint8_t*)addr);
}


void EEPROM_WriteByte(uint16_t addr, uint8_t data) {
    // Povolen� z�pisu do EEPROM
    FLASH_Unlock(FLASH_MEMTYPE_DATA);
    FLASH_ProgramByte(addr, data);
    FLASH_Lock(FLASH_MEMTYPE_DATA);
}

// --- Na�ten� PIN z EEPROM nebo nastaven� defaultn�ho ---
void loadPINfromEEPROM(void) {
    uint8_t i;
    uint8_t valid = 1;
    for (i = 0; i < 4; i++) {
        storedPIN[i] = EEPROM_ReadByte(EEPROM_PIN_ADDR + i);
        // Kontrola, �e v EEPROM je ��slo '0' a� '9'
        if (storedPIN[i] < '0' || storedPIN[i] > '9') {
            valid = 0;
        }
    }
    if (!valid) {
        // EEPROM neobsahuje validn� PIN, ulo��me defaultn�
        for (i = 0; i < 4; i++) {
            storedPIN[i] = defaultPIN[i];
            EEPROM_WriteByte(EEPROM_PIN_ADDR + i, defaultPIN[i]);
        }
    }
}

// --- Ulo�en� PIN do EEPROM ---
void savePINtoEEPROM(const char* newPIN) {
    uint8_t i;
    for (i = 0; i < 4; i++) {
        storedPIN[i] = newPIN[i];
        EEPROM_WriteByte(EEPROM_PIN_ADDR + i, newPIN[i]);
    }
}

// --- Porovn�n� dvou PIN� ---
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
        // Zapnout v�e (v�echny 4 pozice na '8')
        for (j = 0; j < 4; j++) {
            tm_displayCharacter(j, 0x7F); // 0x7F = v�echny segmenty ON
        }
        delay_us(300000);  // ~300 ms (pot�ebuje� del�� delay, m��e� upravit)
        
        // Vypnout v�e (v�echny 4 pozice pr�zdn�)
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
    blinkDisplay(2); // blikni 2x po resetu
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

    initKeypad();
    buzzerInit();
    init_milis();

    for (i = 0; i < 4; i++) {
        tm_displayCharacter(i, 0x00);
    }

    loadPINfromEEPROM();

    while (1) {
        key = getKey();

        // Tla��tko factory reset
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

        // Timeout automatick�ho odhl�en�
        if (loggedIn) {
            uint32_t now = milis();
            if ((now - loginStartTime) >= LOGIN_TIMEOUT_MS) {
                // Odhl�en�
                beepTone(1000, 500);  // dlouh� t�n 500ms
                for (k = 0; k < 2; k++) {
                    for (j = 0; j < 4; j++) tm_displayCharacter(j, 0xFF);
                    delay_ms(200);
                    for (j = 0; j < 4; j++) tm_displayCharacter(j, 0x00);
                    delay_ms(200);
                }
                loggedIn = 0;
                index = 0;
                for (i = 0; i < 4; i++) {
                    userInput[i] = ' ';
                    tm_displayCharacter(i, 0x00);
                }
            }
        }

        if (key != 0) {
            if (key >= '0' && key <= '9') {
                if (index < 4) {
                    userInput[index] = key;
                    tm_displayCharacter(index, digitToSegment[key - '0']);
                    index++;

                    if (index == 4) {
                        // Po zad�n� 4 ��slic zkontroluj PIN (pokud nen� p�ihl�en)
                        if (!loggedIn) {
                            if (comparePIN(userInput, storedPIN)) {
                                beepSuccess();
                                for (k = 0; k < 2; k++) {
                                    for (j = 0; j < 4; j++) tm_displayCharacter(j, 0x7F);
                                    delay_ms(200);
                                    for (j = 0; j < 4; j++) tm_displayCharacter(j, 0x00);
                                    delay_ms(200);
                                }
                                loggedIn = 1;
                                loginStartTime = milis();
                            } else {
                                beepFail();
                            }
                            // Vymaz�n� vstupu v�dy po kontrole
                            index = 0;
                            for (j = 0; j < 4; j++) {
                                userInput[j] = ' ';
                                tm_displayCharacter(j, 0x00);
                            }
                        }
                    }
                }
            } else if (key == '*') {
                // Maz�n� posledn� ��slice
                if (index > 0) {
                    index--;
                    userInput[index] = ' ';
                    tm_displayCharacter(index, 0x00);
                }
            } else if (key == '#') {
                // Pokud je p�ihl�en� a zad� 4 ��slice, m��e zm�nit PIN
                if (loggedIn && index == 4) {
                    savePINtoEEPROM(userInput);
                    beepSuccess();
                    blinkDisplay(2);  // blikni displej 2x

                    // Aktualizovat ulo�en� PIN v RAM
                    for (j = 0; j < 4; j++) {
                        storedPIN[j] = userInput[j];
                    }

                    // Ihned odhl�sit u�ivatele po zm�n� PINu
                    loggedIn = 0;
                    index = 0;
                    for (j = 0; j < 4; j++) {
                        userInput[j] = ' ';
                        tm_displayCharacter(j, 0x00);
                    }
                }
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
