#include "stm8s.h"

// --- Deklarace funkc� pro ovl�d�n� TM1637 ---
void setDIO(uint8_t state);
void setCLK(uint8_t state);
void tm_start(void);
void tm_stop(void);
void tm_writeByte(uint8_t b);
void tm_displayCharacter(uint8_t pos, uint8_t character);
void delay_us(uint16_t microseconds);
void testRow4(void);

// --- Deklarace funkc� pro kl�vesnici ---
void initKeypad(void);
char getKey(void);

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

// --- Segmentov� k�d pro ��sla ---
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
    0x6F  
};

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
    GPIO_Init(GPIOC, ROW4_PIN, GPIO_MODE_OUT_PP_LOW_FAST); // ROW4_PIN mus� b�t spr�vn� nastaveno

    // Nastaven� sloupc� jako vstupy s pull-up rezistory
    GPIO_Init(GPIOG, COL1_PIN, GPIO_MODE_IN_PU_NO_IT);
    GPIO_Init(GPIOC, COL2_PIN | COL3_PIN, GPIO_MODE_IN_PU_NO_IT);
}

void testRow4(void) {
    volatile uint32_t i;

    // Nastavte v�echny ��dky na HIGH
    GPIOD->ODR |= ROW1_PIN | ROW2_PIN;
    GPIOE->ODR |= ROW3_PIN;
    GPIOC->ODR |= ROW4_PIN;

    // Nastavte posledn� ��dek (ROW4) na LOW
    GPIOC->ODR &= ~ROW4_PIN;

    // Zpo�d�n�
    for (i = 0; i < 5000; i++);

    // �t�te sloupce
    if (!(GPIOG->IDR & COL1_PIN)) {
        // Sloupec 1 detekov�n
        tm_displayCharacter(0, digitToSegment[1]); // Test: Zobraz 1
    }
    if (!(GPIOC->IDR & COL2_PIN)) {
        // Sloupec 2 detekov�n
        tm_displayCharacter(1, digitToSegment[2]); // Test: Zobraz 2
    }
    if (!(GPIOC->IDR & COL3_PIN)) {
        // Sloupec 3 detekov�n
        tm_displayCharacter(2, digitToSegment[3]); // Test: Zobraz 3
    }
}

char getKey(void) {
    char key = 0;
    int row;
    volatile uint32_t i;

    const char keyMap[4][3] = {
        {'1', '2', '3'},
        {'4', '5', '6'},
        {'7', '8', '9'},
        {'*', '0', '#'} // Posledn� ��dek
    };

    // Vynulov�n� v�ech ��dk� (nastaven� na HIGH)
    GPIOD->ODR |= ROW1_PIN | ROW2_PIN;
    GPIOE->ODR |= ROW3_PIN;
    GPIOC->ODR |= ROW4_PIN; // ROW4_PIN mus� b�t spr�vn� nastaveno

    for (row = 0; row < 4; row++) {
        // Nastaven� aktu�ln�ho ��dku na LOW
        switch (row) {
            case 0: GPIOD->ODR &= ~ROW1_PIN; break;
            case 1: GPIOD->ODR &= ~ROW2_PIN; break;
            case 2: GPIOE->ODR &= ~ROW3_PIN; break;
            case 3: GPIOC->ODR &= ~ROW4_PIN; break; // ROW4_PIN
        }

        // Zpo�d�n� pro stabilizaci sign�lu
        for (i = 0; i < 5000; i++);

        // �ten� sloupc�
        if (!(GPIOG->IDR & COL1_PIN)) { key = keyMap[row][0]; break; }
        if (!(GPIOC->IDR & COL2_PIN)) { key = keyMap[row][1]; break; }
        if (!(GPIOC->IDR & COL3_PIN)) { key = keyMap[row][2]; break; }
    }

    return key;
}


void main(void) {
    char key = 0;
    uint8_t segmentCode;
    char userInput[4] = {' ', ' ', ' ', ' '}; // Pole pro ulo�en� �ty� ��slic
    uint8_t index = 0; // Aktu�ln� index pro zad�n� ��slice
		uint8_t i;

    // Inicializace hodinov�ho syst�mu (16 MHz)
    CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);

    // Inicializace displeje a kl�vesnice
    GPIO_Init(TM_CLK_PORT, TM_CLK_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
    GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
    initKeypad();

    // Vymaz�n� displeje
    for (i = 0; i < 4; i++) {
        tm_displayCharacter(i, 0x00); // Vypnut� v�ech segment�
    }

    // Nekone�n� smy�ka
    while (1) {
        // Z�sk�n� stisknut� kl�vesy
        key = getKey();

        // Pokud byla stisknuta ��seln� kl�vesa
        if (key >= '0' && key <= '9') {
            userInput[index] = key; // Ulo� ��slici do pole
            segmentCode = digitToSegment[key - '0']; // P�evod na segmentov� k�d
            tm_displayCharacter(index, segmentCode); // Zobraz ��slici na p��slu�n� pozici
            index = (index + 1) % 4; // Posu� index (cyklicky mezi 0�3)
        }
    }
}
// Debug podpora (voliteln�)
#ifdef USE_FULL_ASSERT
void assert_failed(uint8_t* file, uint32_t line) {
    while (1);
}
#endif