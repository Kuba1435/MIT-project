   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
  15                     .const:	section	.text
  16  0000               _digitToSegment:
  17  0000 3f            	dc.b	63
  18  0001 06            	dc.b	6
  19  0002 5b            	dc.b	91
  20  0003 4f            	dc.b	79
  21  0004 66            	dc.b	102
  22  0005 6d            	dc.b	109
  23  0006 7d            	dc.b	125
  24  0007 07            	dc.b	7
  25  0008 7f            	dc.b	127
  26  0009 6f            	dc.b	111
  68                     ; 48 void setDIO(uint8_t state) {
  70                     	switch	.text
  71  0000               _setDIO:
  75                     ; 49     if (state) GPIO_WriteHigh(TM_DIO_PORT, TM_DIO_PIN);
  77  0000 4d            	tnz	a
  78  0001 270b          	jreq	L72
  81  0003 4b10          	push	#16
  82  0005 ae5005        	ldw	x,#20485
  83  0008 cd0000        	call	_GPIO_WriteHigh
  85  000b 84            	pop	a
  87  000c 2009          	jra	L13
  88  000e               L72:
  89                     ; 50     else GPIO_WriteLow(TM_DIO_PORT, TM_DIO_PIN);
  91  000e 4b10          	push	#16
  92  0010 ae5005        	ldw	x,#20485
  93  0013 cd0000        	call	_GPIO_WriteLow
  95  0016 84            	pop	a
  96  0017               L13:
  97                     ; 51 }
 100  0017 81            	ret
 136                     ; 53 void setCLK(uint8_t state) {
 137                     	switch	.text
 138  0018               _setCLK:
 142                     ; 54     if (state) GPIO_WriteHigh(TM_CLK_PORT, TM_CLK_PIN);
 144  0018 4d            	tnz	a
 145  0019 270b          	jreq	L15
 148  001b 4b20          	push	#32
 149  001d ae5005        	ldw	x,#20485
 150  0020 cd0000        	call	_GPIO_WriteHigh
 152  0023 84            	pop	a
 154  0024 2009          	jra	L35
 155  0026               L15:
 156                     ; 55     else GPIO_WriteLow(TM_CLK_PORT, TM_CLK_PIN);
 158  0026 4b20          	push	#32
 159  0028 ae5005        	ldw	x,#20485
 160  002b cd0000        	call	_GPIO_WriteLow
 162  002e 84            	pop	a
 163  002f               L35:
 164                     ; 56 }
 167  002f 81            	ret
 193                     ; 58 void tm_start(void) {
 194                     	switch	.text
 195  0030               _tm_start:
 199                     ; 59     setCLK(1);
 201  0030 a601          	ld	a,#1
 202  0032 ade4          	call	_setCLK
 204                     ; 60     setDIO(1);
 206  0034 a601          	ld	a,#1
 207  0036 adc8          	call	_setDIO
 209                     ; 61     delay_us(2);
 211  0038 ae0002        	ldw	x,#2
 212  003b cd00e4        	call	_delay_us
 214                     ; 62     setDIO(0);
 216  003e 4f            	clr	a
 217  003f adbf          	call	_setDIO
 219                     ; 63     delay_us(2);
 221  0041 ae0002        	ldw	x,#2
 222  0044 cd00e4        	call	_delay_us
 224                     ; 64     setCLK(0);
 226  0047 4f            	clr	a
 227  0048 adce          	call	_setCLK
 229                     ; 65 }
 232  004a 81            	ret
 258                     ; 67 void tm_stop(void) {
 259                     	switch	.text
 260  004b               _tm_stop:
 264                     ; 68     setCLK(0);
 266  004b 4f            	clr	a
 267  004c adca          	call	_setCLK
 269                     ; 69     delay_us(2);
 271  004e ae0002        	ldw	x,#2
 272  0051 cd00e4        	call	_delay_us
 274                     ; 70     setDIO(0);
 276  0054 4f            	clr	a
 277  0055 ada9          	call	_setDIO
 279                     ; 71     delay_us(2);
 281  0057 ae0002        	ldw	x,#2
 282  005a cd00e4        	call	_delay_us
 284                     ; 72     setCLK(1);
 286  005d a601          	ld	a,#1
 287  005f adb7          	call	_setCLK
 289                     ; 73     delay_us(2);
 291  0061 ae0002        	ldw	x,#2
 292  0064 ad7e          	call	_delay_us
 294                     ; 74     setDIO(1);
 296  0066 a601          	ld	a,#1
 297  0068 ad96          	call	_setDIO
 299                     ; 75 }
 302  006a 81            	ret
 349                     ; 77 void tm_writeByte(uint8_t b) {
 350                     	switch	.text
 351  006b               _tm_writeByte:
 353  006b 88            	push	a
 354  006c 88            	push	a
 355       00000001      OFST:	set	1
 358                     ; 79     for (i = 0; i < 8; i++) {
 360  006d 0f01          	clr	(OFST+0,sp)
 362  006f               L711:
 363                     ; 80         setCLK(0);
 365  006f 4f            	clr	a
 366  0070 ada6          	call	_setCLK
 368                     ; 81         setDIO(b & 0x01);
 370  0072 7b02          	ld	a,(OFST+1,sp)
 371  0074 a401          	and	a,#1
 372  0076 ad88          	call	_setDIO
 374                     ; 82         delay_us(3);
 376  0078 ae0003        	ldw	x,#3
 377  007b ad67          	call	_delay_us
 379                     ; 83         setCLK(1);
 381  007d a601          	ld	a,#1
 382  007f ad97          	call	_setCLK
 384                     ; 84         delay_us(3);
 386  0081 ae0003        	ldw	x,#3
 387  0084 ad5e          	call	_delay_us
 389                     ; 85         b >>= 1;
 391  0086 0402          	srl	(OFST+1,sp)
 392                     ; 79     for (i = 0; i < 8; i++) {
 394  0088 0c01          	inc	(OFST+0,sp)
 398  008a 7b01          	ld	a,(OFST+0,sp)
 399  008c a108          	cp	a,#8
 400  008e 25df          	jrult	L711
 401                     ; 89     setCLK(0);
 403  0090 4f            	clr	a
 404  0091 ad85          	call	_setCLK
 406                     ; 90     GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_IN_FL_NO_IT); // input
 408  0093 4b00          	push	#0
 409  0095 4b10          	push	#16
 410  0097 ae5005        	ldw	x,#20485
 411  009a cd0000        	call	_GPIO_Init
 413  009d 85            	popw	x
 414                     ; 91     delay_us(5);
 416  009e ae0005        	ldw	x,#5
 417  00a1 ad41          	call	_delay_us
 419                     ; 92     setCLK(1);
 421  00a3 a601          	ld	a,#1
 422  00a5 cd0018        	call	_setCLK
 424                     ; 93     delay_us(5);
 426  00a8 ae0005        	ldw	x,#5
 427  00ab ad37          	call	_delay_us
 429                     ; 94     setCLK(0);
 431  00ad 4f            	clr	a
 432  00ae cd0018        	call	_setCLK
 434                     ; 95     GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_OUT_PP_LOW_FAST); // back to output
 436  00b1 4be0          	push	#224
 437  00b3 4b10          	push	#16
 438  00b5 ae5005        	ldw	x,#20485
 439  00b8 cd0000        	call	_GPIO_Init
 441  00bb 85            	popw	x
 442                     ; 96 }
 445  00bc 85            	popw	x
 446  00bd 81            	ret
 493                     ; 98 void tm_displayCharacter(uint8_t pos, uint8_t character) {
 494                     	switch	.text
 495  00be               _tm_displayCharacter:
 497  00be 89            	pushw	x
 498       00000000      OFST:	set	0
 501                     ; 99     tm_start();
 503  00bf cd0030        	call	_tm_start
 505                     ; 100     tm_writeByte(0x40); // auto-increment mode
 507  00c2 a640          	ld	a,#64
 508  00c4 ada5          	call	_tm_writeByte
 510                     ; 101     tm_stop();
 512  00c6 ad83          	call	_tm_stop
 514                     ; 103     tm_start();
 516  00c8 cd0030        	call	_tm_start
 518                     ; 104     tm_writeByte(0xC0 | pos); // start address + position
 520  00cb 7b01          	ld	a,(OFST+1,sp)
 521  00cd aac0          	or	a,#192
 522  00cf ad9a          	call	_tm_writeByte
 524                     ; 105     tm_writeByte(character);
 526  00d1 7b02          	ld	a,(OFST+2,sp)
 527  00d3 ad96          	call	_tm_writeByte
 529                     ; 106     tm_stop();
 531  00d5 cd004b        	call	_tm_stop
 533                     ; 108     tm_start();
 535  00d8 cd0030        	call	_tm_start
 537                     ; 109     tm_writeByte(0x88); // display ON, brightness = medium
 539  00db a688          	ld	a,#136
 540  00dd ad8c          	call	_tm_writeByte
 542                     ; 110     tm_stop();
 544  00df cd004b        	call	_tm_stop
 546                     ; 111 }
 549  00e2 85            	popw	x
 550  00e3 81            	ret
 594                     ; 113 void delay_us(uint16_t us) {
 595                     	switch	.text
 596  00e4               _delay_us:
 598  00e4 89            	pushw	x
 599  00e5 89            	pushw	x
 600       00000002      OFST:	set	2
 603                     ; 115     for (i = 0; i < us; i++) {
 605  00e6 5f            	clrw	x
 606  00e7 1f01          	ldw	(OFST-1,sp),x
 609  00e9 200f          	jra	L571
 610  00eb               L171:
 611                     ; 116         _asm("nop"); _asm("nop"); _asm("nop"); _asm("nop");
 614  00eb 9d            nop
 619  00ec 9d            nop
 624  00ed 9d            nop
 629  00ee 9d            nop
 631                     ; 117         _asm("nop"); _asm("nop"); _asm("nop"); _asm("nop");
 634  00ef 9d            nop
 639  00f0 9d            nop
 644  00f1 9d            nop
 649  00f2 9d            nop
 651                     ; 115     for (i = 0; i < us; i++) {
 653  00f3 1e01          	ldw	x,(OFST-1,sp)
 654  00f5 1c0001        	addw	x,#1
 655  00f8 1f01          	ldw	(OFST-1,sp),x
 657  00fa               L571:
 660  00fa 1e01          	ldw	x,(OFST-1,sp)
 661  00fc 1303          	cpw	x,(OFST+1,sp)
 662  00fe 25eb          	jrult	L171
 663                     ; 119 }
 666  0100 5b04          	addw	sp,#4
 667  0102 81            	ret
 691                     ; 121 void initKeypad(void) {
 692                     	switch	.text
 693  0103               _initKeypad:
 697                     ; 123     GPIO_Init(GPIOD, ROW1_PIN | ROW2_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
 699  0103 4be0          	push	#224
 700  0105 4b60          	push	#96
 701  0107 ae500f        	ldw	x,#20495
 702  010a cd0000        	call	_GPIO_Init
 704  010d 85            	popw	x
 705                     ; 124     GPIO_Init(GPIOE, ROW3_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
 707  010e 4be0          	push	#224
 708  0110 4b01          	push	#1
 709  0112 ae5014        	ldw	x,#20500
 710  0115 cd0000        	call	_GPIO_Init
 712  0118 85            	popw	x
 713                     ; 125     GPIO_Init(GPIOC, ROW4_PIN, GPIO_MODE_OUT_PP_LOW_FAST); // ROW4_PIN musí být správnì nastaveno
 715  0119 4be0          	push	#224
 716  011b 4b02          	push	#2
 717  011d ae500a        	ldw	x,#20490
 718  0120 cd0000        	call	_GPIO_Init
 720  0123 85            	popw	x
 721                     ; 128     GPIO_Init(GPIOG, COL1_PIN, GPIO_MODE_IN_PU_NO_IT);
 723  0124 4b40          	push	#64
 724  0126 4b01          	push	#1
 725  0128 ae501e        	ldw	x,#20510
 726  012b cd0000        	call	_GPIO_Init
 728  012e 85            	popw	x
 729                     ; 129     GPIO_Init(GPIOC, COL2_PIN | COL3_PIN, GPIO_MODE_IN_PU_NO_IT);
 731  012f 4b40          	push	#64
 732  0131 4b0c          	push	#12
 733  0133 ae500a        	ldw	x,#20490
 734  0136 cd0000        	call	_GPIO_Init
 736  0139 85            	popw	x
 737                     ; 130 }
 740  013a 81            	ret
 776                     	switch	.const
 777  000a               L62:
 778  000a 00001388      	dc.l	5000
 779                     ; 132 void testRow4(void) {
 780                     	switch	.text
 781  013b               _testRow4:
 783  013b 5204          	subw	sp,#4
 784       00000004      OFST:	set	4
 787                     ; 136     GPIOD->ODR |= ROW1_PIN | ROW2_PIN;
 789  013d c6500f        	ld	a,20495
 790  0140 aa60          	or	a,#96
 791  0142 c7500f        	ld	20495,a
 792                     ; 137     GPIOE->ODR |= ROW3_PIN;
 794  0145 72105014      	bset	20500,#0
 795                     ; 138     GPIOC->ODR |= ROW4_PIN;
 797  0149 7212500a      	bset	20490,#1
 798                     ; 141     GPIOC->ODR &= ~ROW4_PIN;
 800  014d 7213500a      	bres	20490,#1
 801                     ; 144     for (i = 0; i < 5000; i++);
 803  0151 ae0000        	ldw	x,#0
 804  0154 1f03          	ldw	(OFST-1,sp),x
 805  0156 ae0000        	ldw	x,#0
 806  0159 1f01          	ldw	(OFST-3,sp),x
 809  015b 2009          	jra	L332
 810  015d               L722:
 814  015d 96            	ldw	x,sp
 815  015e 1c0001        	addw	x,#OFST-3
 816  0161 a601          	ld	a,#1
 817  0163 cd0000        	call	c_lgadc
 820  0166               L332:
 823  0166 96            	ldw	x,sp
 824  0167 1c0001        	addw	x,#OFST-3
 825  016a cd0000        	call	c_ltor
 827  016d ae000a        	ldw	x,#L62
 828  0170 cd0000        	call	c_lcmp
 830  0173 25e8          	jrult	L722
 831                     ; 147     if (!(GPIOG->IDR & COL1_PIN)) {
 833  0175 c6501f        	ld	a,20511
 834  0178 a501          	bcp	a,#1
 835  017a 2606          	jrne	L732
 836                     ; 149         tm_displayCharacter(0, digitToSegment[1]); // Test: Zobraz 1
 838  017c ae0006        	ldw	x,#6
 839  017f cd00be        	call	_tm_displayCharacter
 841  0182               L732:
 842                     ; 151     if (!(GPIOC->IDR & COL2_PIN)) {
 844  0182 c6500b        	ld	a,20491
 845  0185 a504          	bcp	a,#4
 846  0187 2606          	jrne	L142
 847                     ; 153         tm_displayCharacter(1, digitToSegment[2]); // Test: Zobraz 2
 849  0189 ae015b        	ldw	x,#347
 850  018c cd00be        	call	_tm_displayCharacter
 852  018f               L142:
 853                     ; 155     if (!(GPIOC->IDR & COL3_PIN)) {
 855  018f c6500b        	ld	a,20491
 856  0192 a508          	bcp	a,#8
 857  0194 2606          	jrne	L342
 858                     ; 157         tm_displayCharacter(2, digitToSegment[3]); // Test: Zobraz 3
 860  0196 ae024f        	ldw	x,#591
 861  0199 cd00be        	call	_tm_displayCharacter
 863  019c               L342:
 864                     ; 159 }
 867  019c 5b04          	addw	sp,#4
 868  019e 81            	ret
 871                     	switch	.const
 872  000e               L542_keyMap:
 873  000e 31            	dc.b	49
 874  000f 32            	dc.b	50
 875  0010 33            	dc.b	51
 876  0011 34            	dc.b	52
 877  0012 35            	dc.b	53
 878  0013 36            	dc.b	54
 879  0014 37            	dc.b	55
 880  0015 38            	dc.b	56
 881  0016 39            	dc.b	57
 882  0017 2a            	dc.b	42
 883  0018 30            	dc.b	48
 884  0019 23            	dc.b	35
 945                     ; 161 char getKey(void) {
 946                     	switch	.text
 947  019f               _getKey:
 949  019f 5215          	subw	sp,#21
 950       00000015      OFST:	set	21
 953                     ; 162     char key = 0;
 955  01a1 0f0f          	clr	(OFST-6,sp)
 957                     ; 166     const char keyMap[4][3] = {
 957                     ; 167         {'1', '2', '3'},
 957                     ; 168         {'4', '5', '6'},
 957                     ; 169         {'7', '8', '9'},
 957                     ; 170         {'*', '0', '#'} // Poslední øádek
 957                     ; 171     };
 959  01a3 96            	ldw	x,sp
 960  01a4 1c0003        	addw	x,#OFST-18
 961  01a7 90ae000e      	ldw	y,#L542_keyMap
 962  01ab a60c          	ld	a,#12
 963  01ad cd0000        	call	c_xymov
 965                     ; 174     GPIOD->ODR |= ROW1_PIN | ROW2_PIN;
 967  01b0 c6500f        	ld	a,20495
 968  01b3 aa60          	or	a,#96
 969  01b5 c7500f        	ld	20495,a
 970                     ; 175     GPIOE->ODR |= ROW3_PIN;
 972  01b8 72105014      	bset	20500,#0
 973                     ; 176     GPIOC->ODR |= ROW4_PIN; // ROW4_PIN musí být správnì nastaveno
 975  01bc 7212500a      	bset	20490,#1
 976                     ; 178     for (row = 0; row < 4; row++) {
 978  01c0 5f            	clrw	x
 979  01c1 1f14          	ldw	(OFST-1,sp),x
 981  01c3               L113:
 982                     ; 180         switch (row) {
 984  01c3 1e14          	ldw	x,(OFST-1,sp)
 986                     ; 184             case 3: GPIOC->ODR &= ~ROW4_PIN; break; // ROW4_PIN
 987  01c5 5d            	tnzw	x
 988  01c6 270b          	jreq	L742
 989  01c8 5a            	decw	x
 990  01c9 270e          	jreq	L152
 991  01cb 5a            	decw	x
 992  01cc 2711          	jreq	L352
 993  01ce 5a            	decw	x
 994  01cf 2714          	jreq	L552
 995  01d1 2016          	jra	L123
 996  01d3               L742:
 997                     ; 181             case 0: GPIOD->ODR &= ~ROW1_PIN; break;
 999  01d3 721d500f      	bres	20495,#6
1002  01d7 2010          	jra	L123
1003  01d9               L152:
1004                     ; 182             case 1: GPIOD->ODR &= ~ROW2_PIN; break;
1006  01d9 721b500f      	bres	20495,#5
1009  01dd 200a          	jra	L123
1010  01df               L352:
1011                     ; 183             case 2: GPIOE->ODR &= ~ROW3_PIN; break;
1013  01df 72115014      	bres	20500,#0
1016  01e3 2004          	jra	L123
1017  01e5               L552:
1018                     ; 184             case 3: GPIOC->ODR &= ~ROW4_PIN; break; // ROW4_PIN
1020  01e5 7213500a      	bres	20490,#1
1023  01e9               L123:
1024                     ; 188         for (i = 0; i < 5000; i++);
1026  01e9 ae0000        	ldw	x,#0
1027  01ec 1f12          	ldw	(OFST-3,sp),x
1028  01ee ae0000        	ldw	x,#0
1029  01f1 1f10          	ldw	(OFST-5,sp),x
1032  01f3 2009          	jra	L723
1033  01f5               L323:
1037  01f5 96            	ldw	x,sp
1038  01f6 1c0010        	addw	x,#OFST-5
1039  01f9 a601          	ld	a,#1
1040  01fb cd0000        	call	c_lgadc
1043  01fe               L723:
1046  01fe 96            	ldw	x,sp
1047  01ff 1c0010        	addw	x,#OFST-5
1048  0202 cd0000        	call	c_ltor
1050  0205 ae000a        	ldw	x,#L62
1051  0208 cd0000        	call	c_lcmp
1053  020b 25e8          	jrult	L323
1054                     ; 191         if (!(GPIOG->IDR & COL1_PIN)) { key = keyMap[row][0]; break; }
1056  020d c6501f        	ld	a,20511
1057  0210 a501          	bcp	a,#1
1058  0212 2615          	jrne	L333
1061  0214 96            	ldw	x,sp
1062  0215 1c0003        	addw	x,#OFST-18
1063  0218 1f01          	ldw	(OFST-20,sp),x
1065  021a 1e14          	ldw	x,(OFST-1,sp)
1066  021c a603          	ld	a,#3
1067  021e cd0000        	call	c_bmulx
1069  0221 72fb01        	addw	x,(OFST-20,sp)
1070  0224 f6            	ld	a,(x)
1071  0225 6b0f          	ld	(OFST-6,sp),a
1075  0227 204a          	jra	L513
1076  0229               L333:
1077                     ; 192         if (!(GPIOC->IDR & COL2_PIN)) { key = keyMap[row][1]; break; }
1079  0229 c6500b        	ld	a,20491
1080  022c a504          	bcp	a,#4
1081  022e 2615          	jrne	L533
1084  0230 96            	ldw	x,sp
1085  0231 1c0004        	addw	x,#OFST-17
1086  0234 1f01          	ldw	(OFST-20,sp),x
1088  0236 1e14          	ldw	x,(OFST-1,sp)
1089  0238 a603          	ld	a,#3
1090  023a cd0000        	call	c_bmulx
1092  023d 72fb01        	addw	x,(OFST-20,sp)
1093  0240 f6            	ld	a,(x)
1094  0241 6b0f          	ld	(OFST-6,sp),a
1098  0243 202e          	jra	L513
1099  0245               L533:
1100                     ; 193         if (!(GPIOC->IDR & COL3_PIN)) { key = keyMap[row][2]; break; }
1102  0245 c6500b        	ld	a,20491
1103  0248 a508          	bcp	a,#8
1104  024a 2615          	jrne	L733
1107  024c 96            	ldw	x,sp
1108  024d 1c0005        	addw	x,#OFST-16
1109  0250 1f01          	ldw	(OFST-20,sp),x
1111  0252 1e14          	ldw	x,(OFST-1,sp)
1112  0254 a603          	ld	a,#3
1113  0256 cd0000        	call	c_bmulx
1115  0259 72fb01        	addw	x,(OFST-20,sp)
1116  025c f6            	ld	a,(x)
1117  025d 6b0f          	ld	(OFST-6,sp),a
1121  025f 2012          	jra	L513
1122  0261               L733:
1123                     ; 178     for (row = 0; row < 4; row++) {
1125  0261 1e14          	ldw	x,(OFST-1,sp)
1126  0263 1c0001        	addw	x,#1
1127  0266 1f14          	ldw	(OFST-1,sp),x
1131  0268 9c            	rvf
1132  0269 1e14          	ldw	x,(OFST-1,sp)
1133  026b a30004        	cpw	x,#4
1134  026e 2e03          	jrsge	L23
1135  0270 cc01c3        	jp	L113
1136  0273               L23:
1137  0273               L513:
1138                     ; 196     return key;
1140  0273 7b0f          	ld	a,(OFST-6,sp)
1143  0275 5b15          	addw	sp,#21
1144  0277 81            	ret
1147                     	switch	.const
1148  001a               L143_userInput:
1149  001a 20            	dc.b	32
1150  001b 20            	dc.b	32
1151  001c 20            	dc.b	32
1152  001d 20            	dc.b	32
1227                     ; 200 void main(void) {
1228                     	switch	.text
1229  0278               _main:
1231  0278 5206          	subw	sp,#6
1232       00000006      OFST:	set	6
1235                     ; 201     char key = 0;
1237                     ; 203     char userInput[4] = {' ', ' ', ' ', ' '}; // Pole pro uložení ètyø èíslic
1239  027a 96            	ldw	x,sp
1240  027b 1c0001        	addw	x,#OFST-5
1241  027e 90ae001a      	ldw	y,#L143_userInput
1242  0282 a604          	ld	a,#4
1243  0284 cd0000        	call	c_xymov
1245                     ; 204     uint8_t index = 0; // Aktuální index pro zadání èíslice
1247  0287 0f05          	clr	(OFST-1,sp)
1249                     ; 208     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
1251  0289 4f            	clr	a
1252  028a cd0000        	call	_CLK_HSIPrescalerConfig
1254                     ; 211     GPIO_Init(TM_CLK_PORT, TM_CLK_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
1256  028d 4be0          	push	#224
1257  028f 4b20          	push	#32
1258  0291 ae5005        	ldw	x,#20485
1259  0294 cd0000        	call	_GPIO_Init
1261  0297 85            	popw	x
1262                     ; 212     GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
1264  0298 4be0          	push	#224
1265  029a 4b10          	push	#16
1266  029c ae5005        	ldw	x,#20485
1267  029f cd0000        	call	_GPIO_Init
1269  02a2 85            	popw	x
1270                     ; 213     initKeypad();
1272  02a3 cd0103        	call	_initKeypad
1274                     ; 216     for (i = 0; i < 4; i++) {
1276  02a6 0f06          	clr	(OFST+0,sp)
1278  02a8               L104:
1279                     ; 217         tm_displayCharacter(i, 0x00); // Vypnutí všech segmentù
1281  02a8 7b06          	ld	a,(OFST+0,sp)
1282  02aa 5f            	clrw	x
1283  02ab 95            	ld	xh,a
1284  02ac cd00be        	call	_tm_displayCharacter
1286                     ; 216     for (i = 0; i < 4; i++) {
1288  02af 0c06          	inc	(OFST+0,sp)
1292  02b1 7b06          	ld	a,(OFST+0,sp)
1293  02b3 a104          	cp	a,#4
1294  02b5 25f1          	jrult	L104
1295  02b7               L704:
1296                     ; 223         key = getKey();
1298  02b7 cd019f        	call	_getKey
1300  02ba 6b06          	ld	(OFST+0,sp),a
1302                     ; 226         if (key >= '0' && key <= '9') {
1304  02bc 7b06          	ld	a,(OFST+0,sp)
1305  02be a130          	cp	a,#48
1306  02c0 25f5          	jrult	L704
1308  02c2 7b06          	ld	a,(OFST+0,sp)
1309  02c4 a13a          	cp	a,#58
1310  02c6 24ef          	jruge	L704
1311                     ; 227             userInput[index] = key; // Ulož èíslici do pole
1313  02c8 96            	ldw	x,sp
1314  02c9 1c0001        	addw	x,#OFST-5
1315  02cc 9f            	ld	a,xl
1316  02cd 5e            	swapw	x
1317  02ce 1b05          	add	a,(OFST-1,sp)
1318  02d0 2401          	jrnc	L63
1319  02d2 5c            	incw	x
1320  02d3               L63:
1321  02d3 02            	rlwa	x,a
1322  02d4 7b06          	ld	a,(OFST+0,sp)
1323  02d6 f7            	ld	(x),a
1324                     ; 228             segmentCode = digitToSegment[key - '0']; // Pøevod na segmentový kód
1326  02d7 7b06          	ld	a,(OFST+0,sp)
1327  02d9 5f            	clrw	x
1328  02da 97            	ld	xl,a
1329  02db 1d0030        	subw	x,#48
1330  02de d60000        	ld	a,(_digitToSegment,x)
1331  02e1 6b06          	ld	(OFST+0,sp),a
1333                     ; 229             tm_displayCharacter(index, segmentCode); // Zobraz èíslici na pøíslušné pozici
1335  02e3 7b06          	ld	a,(OFST+0,sp)
1336  02e5 97            	ld	xl,a
1337  02e6 7b05          	ld	a,(OFST-1,sp)
1338  02e8 95            	ld	xh,a
1339  02e9 cd00be        	call	_tm_displayCharacter
1341                     ; 230             index = (index + 1) % 4; // Posuò index (cyklicky mezi 0–3)
1343  02ec 7b05          	ld	a,(OFST-1,sp)
1344  02ee 5f            	clrw	x
1345  02ef 97            	ld	xl,a
1346  02f0 5c            	incw	x
1347  02f1 a604          	ld	a,#4
1348  02f3 cd0000        	call	c_smodx
1350  02f6 01            	rrwa	x,a
1351  02f7 6b05          	ld	(OFST-1,sp),a
1352  02f9 02            	rlwa	x,a
1354  02fa 20bb          	jra	L704
1389                     ; 236 void assert_failed(uint8_t* file, uint32_t line) {
1390                     	switch	.text
1391  02fc               _assert_failed:
1395  02fc               L334:
1396                     ; 237     while (1);
1398  02fc 20fe          	jra	L334
1423                     	xdef	_main
1424                     	xdef	_digitToSegment
1425                     	xdef	_getKey
1426                     	xdef	_initKeypad
1427                     	xdef	_testRow4
1428                     	xdef	_delay_us
1429                     	xdef	_tm_displayCharacter
1430                     	xdef	_tm_writeByte
1431                     	xdef	_tm_stop
1432                     	xdef	_tm_start
1433                     	xdef	_setCLK
1434                     	xdef	_setDIO
1435                     	xdef	_assert_failed
1436                     	xref	_GPIO_WriteLow
1437                     	xref	_GPIO_WriteHigh
1438                     	xref	_GPIO_Init
1439                     	xref	_CLK_HSIPrescalerConfig
1440                     	xref.b	c_x
1459                     	xref	c_smodx
1460                     	xref	c_bmulx
1461                     	xref	c_xymov
1462                     	xref	c_lcmp
1463                     	xref	c_ltor
1464                     	xref	c_lgadc
1465                     	end
