   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
  15                     .const:	section	.text
  16  0000               _defaultPIN:
  17  0000 31            	dc.b	49
  18  0001 32            	dc.b	50
  19  0002 33            	dc.b	51
  20  0003 34            	dc.b	52
  21  0004               _digitToSegment:
  22  0004 3f            	dc.b	63
  23  0005 06            	dc.b	6
  24  0006 5b            	dc.b	91
  25  0007 4f            	dc.b	79
  26  0008 66            	dc.b	102
  27  0009 6d            	dc.b	109
  28  000a 7d            	dc.b	125
  29  000b 07            	dc.b	7
  30  000c 7f            	dc.b	127
  31  000d 6f            	dc.b	111
  73                     ; 74 void setDIO(uint8_t state) {
  75                     	switch	.text
  76  0000               _setDIO:
  80                     ; 75     if (state) GPIO_WriteHigh(TM_DIO_PORT, TM_DIO_PIN);
  82  0000 4d            	tnz	a
  83  0001 270b          	jreq	L72
  86  0003 4b10          	push	#16
  87  0005 ae5005        	ldw	x,#20485
  88  0008 cd0000        	call	_GPIO_WriteHigh
  90  000b 84            	pop	a
  92  000c 2009          	jra	L13
  93  000e               L72:
  94                     ; 76     else GPIO_WriteLow(TM_DIO_PORT, TM_DIO_PIN);
  96  000e 4b10          	push	#16
  97  0010 ae5005        	ldw	x,#20485
  98  0013 cd0000        	call	_GPIO_WriteLow
 100  0016 84            	pop	a
 101  0017               L13:
 102                     ; 77 }
 105  0017 81            	ret
 141                     ; 79 void setCLK(uint8_t state) {
 142                     	switch	.text
 143  0018               _setCLK:
 147                     ; 80     if (state) GPIO_WriteHigh(TM_CLK_PORT, TM_CLK_PIN);
 149  0018 4d            	tnz	a
 150  0019 270b          	jreq	L15
 153  001b 4b20          	push	#32
 154  001d ae5005        	ldw	x,#20485
 155  0020 cd0000        	call	_GPIO_WriteHigh
 157  0023 84            	pop	a
 159  0024 2009          	jra	L35
 160  0026               L15:
 161                     ; 81     else GPIO_WriteLow(TM_CLK_PORT, TM_CLK_PIN);
 163  0026 4b20          	push	#32
 164  0028 ae5005        	ldw	x,#20485
 165  002b cd0000        	call	_GPIO_WriteLow
 167  002e 84            	pop	a
 168  002f               L35:
 169                     ; 82 }
 172  002f 81            	ret
 198                     ; 84 void tm_start(void) {
 199                     	switch	.text
 200  0030               _tm_start:
 204                     ; 85     setCLK(1);
 206  0030 a601          	ld	a,#1
 207  0032 ade4          	call	_setCLK
 209                     ; 86     setDIO(1);
 211  0034 a601          	ld	a,#1
 212  0036 adc8          	call	_setDIO
 214                     ; 87     delay_us(2);
 216  0038 ae0002        	ldw	x,#2
 217  003b cd00e4        	call	_delay_us
 219                     ; 88     setDIO(0);
 221  003e 4f            	clr	a
 222  003f adbf          	call	_setDIO
 224                     ; 89     delay_us(2);
 226  0041 ae0002        	ldw	x,#2
 227  0044 cd00e4        	call	_delay_us
 229                     ; 90     setCLK(0);
 231  0047 4f            	clr	a
 232  0048 adce          	call	_setCLK
 234                     ; 91 }
 237  004a 81            	ret
 263                     ; 93 void tm_stop(void) {
 264                     	switch	.text
 265  004b               _tm_stop:
 269                     ; 94     setCLK(0);
 271  004b 4f            	clr	a
 272  004c adca          	call	_setCLK
 274                     ; 95     delay_us(2);
 276  004e ae0002        	ldw	x,#2
 277  0051 cd00e4        	call	_delay_us
 279                     ; 96     setDIO(0);
 281  0054 4f            	clr	a
 282  0055 ada9          	call	_setDIO
 284                     ; 97     delay_us(2);
 286  0057 ae0002        	ldw	x,#2
 287  005a cd00e4        	call	_delay_us
 289                     ; 98     setCLK(1);
 291  005d a601          	ld	a,#1
 292  005f adb7          	call	_setCLK
 294                     ; 99     delay_us(2);
 296  0061 ae0002        	ldw	x,#2
 297  0064 ad7e          	call	_delay_us
 299                     ; 100     setDIO(1);
 301  0066 a601          	ld	a,#1
 302  0068 ad96          	call	_setDIO
 304                     ; 101 }
 307  006a 81            	ret
 354                     ; 103 void tm_writeByte(uint8_t b) {
 355                     	switch	.text
 356  006b               _tm_writeByte:
 358  006b 88            	push	a
 359  006c 88            	push	a
 360       00000001      OFST:	set	1
 363                     ; 105     for (i = 0; i < 8; i++) {
 365  006d 0f01          	clr	(OFST+0,sp)
 367  006f               L711:
 368                     ; 106         setCLK(0);
 370  006f 4f            	clr	a
 371  0070 ada6          	call	_setCLK
 373                     ; 107         setDIO(b & 0x01);
 375  0072 7b02          	ld	a,(OFST+1,sp)
 376  0074 a401          	and	a,#1
 377  0076 ad88          	call	_setDIO
 379                     ; 108         delay_us(3);
 381  0078 ae0003        	ldw	x,#3
 382  007b ad67          	call	_delay_us
 384                     ; 109         setCLK(1);
 386  007d a601          	ld	a,#1
 387  007f ad97          	call	_setCLK
 389                     ; 110         delay_us(3);
 391  0081 ae0003        	ldw	x,#3
 392  0084 ad5e          	call	_delay_us
 394                     ; 111         b >>= 1;
 396  0086 0402          	srl	(OFST+1,sp)
 397                     ; 105     for (i = 0; i < 8; i++) {
 399  0088 0c01          	inc	(OFST+0,sp)
 403  008a 7b01          	ld	a,(OFST+0,sp)
 404  008c a108          	cp	a,#8
 405  008e 25df          	jrult	L711
 406                     ; 115     setCLK(0);
 408  0090 4f            	clr	a
 409  0091 ad85          	call	_setCLK
 411                     ; 116     GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_IN_FL_NO_IT); // input
 413  0093 4b00          	push	#0
 414  0095 4b10          	push	#16
 415  0097 ae5005        	ldw	x,#20485
 416  009a cd0000        	call	_GPIO_Init
 418  009d 85            	popw	x
 419                     ; 117     delay_us(5);
 421  009e ae0005        	ldw	x,#5
 422  00a1 ad41          	call	_delay_us
 424                     ; 118     setCLK(1);
 426  00a3 a601          	ld	a,#1
 427  00a5 cd0018        	call	_setCLK
 429                     ; 119     delay_us(5);
 431  00a8 ae0005        	ldw	x,#5
 432  00ab ad37          	call	_delay_us
 434                     ; 120     setCLK(0);
 436  00ad 4f            	clr	a
 437  00ae cd0018        	call	_setCLK
 439                     ; 121     GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_OUT_PP_LOW_FAST); // output
 441  00b1 4be0          	push	#224
 442  00b3 4b10          	push	#16
 443  00b5 ae5005        	ldw	x,#20485
 444  00b8 cd0000        	call	_GPIO_Init
 446  00bb 85            	popw	x
 447                     ; 122 }
 450  00bc 85            	popw	x
 451  00bd 81            	ret
 498                     ; 124 void tm_displayCharacter(uint8_t pos, uint8_t character) {
 499                     	switch	.text
 500  00be               _tm_displayCharacter:
 502  00be 89            	pushw	x
 503       00000000      OFST:	set	0
 506                     ; 125     tm_start();
 508  00bf cd0030        	call	_tm_start
 510                     ; 126     tm_writeByte(0x40); // auto-increment mode
 512  00c2 a640          	ld	a,#64
 513  00c4 ada5          	call	_tm_writeByte
 515                     ; 127     tm_stop();
 517  00c6 ad83          	call	_tm_stop
 519                     ; 129     tm_start();
 521  00c8 cd0030        	call	_tm_start
 523                     ; 130     tm_writeByte(0xC0 | pos); // start address + position
 525  00cb 7b01          	ld	a,(OFST+1,sp)
 526  00cd aac0          	or	a,#192
 527  00cf ad9a          	call	_tm_writeByte
 529                     ; 131     tm_writeByte(character);
 531  00d1 7b02          	ld	a,(OFST+2,sp)
 532  00d3 ad96          	call	_tm_writeByte
 534                     ; 132     tm_stop();
 536  00d5 cd004b        	call	_tm_stop
 538                     ; 134     tm_start();
 540  00d8 cd0030        	call	_tm_start
 542                     ; 135     tm_writeByte(0x88); // display ON, brightness medium
 544  00db a688          	ld	a,#136
 545  00dd ad8c          	call	_tm_writeByte
 547                     ; 136     tm_stop();
 549  00df cd004b        	call	_tm_stop
 551                     ; 137 }
 554  00e2 85            	popw	x
 555  00e3 81            	ret
 599                     ; 139 void delay_us(uint16_t us) {
 600                     	switch	.text
 601  00e4               _delay_us:
 603  00e4 89            	pushw	x
 604  00e5 89            	pushw	x
 605       00000002      OFST:	set	2
 608                     ; 141     for (i = 0; i < us; i++) {
 610  00e6 5f            	clrw	x
 611  00e7 1f01          	ldw	(OFST-1,sp),x
 614  00e9 200f          	jra	L571
 615  00eb               L171:
 616                     ; 142         _asm("nop"); _asm("nop"); _asm("nop"); _asm("nop");
 619  00eb 9d            nop
 624  00ec 9d            nop
 629  00ed 9d            nop
 634  00ee 9d            nop
 636                     ; 143         _asm("nop"); _asm("nop"); _asm("nop"); _asm("nop");
 639  00ef 9d            nop
 644  00f0 9d            nop
 649  00f1 9d            nop
 654  00f2 9d            nop
 656                     ; 141     for (i = 0; i < us; i++) {
 658  00f3 1e01          	ldw	x,(OFST-1,sp)
 659  00f5 1c0001        	addw	x,#1
 660  00f8 1f01          	ldw	(OFST-1,sp),x
 662  00fa               L571:
 665  00fa 1e01          	ldw	x,(OFST-1,sp)
 666  00fc 1303          	cpw	x,(OFST+1,sp)
 667  00fe 25eb          	jrult	L171
 668                     ; 145 }
 671  0100 5b04          	addw	sp,#4
 672  0102 81            	ret
 696                     ; 147 void initKeypad(void) {
 697                     	switch	.text
 698  0103               _initKeypad:
 702                     ; 149     GPIO_Init(GPIOD, ROW1_PIN | ROW2_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
 704  0103 4be0          	push	#224
 705  0105 4b60          	push	#96
 706  0107 ae500f        	ldw	x,#20495
 707  010a cd0000        	call	_GPIO_Init
 709  010d 85            	popw	x
 710                     ; 150     GPIO_Init(GPIOE, ROW3_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
 712  010e 4be0          	push	#224
 713  0110 4b01          	push	#1
 714  0112 ae5014        	ldw	x,#20500
 715  0115 cd0000        	call	_GPIO_Init
 717  0118 85            	popw	x
 718                     ; 151     GPIO_Init(GPIOC, ROW4_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
 720  0119 4be0          	push	#224
 721  011b 4b02          	push	#2
 722  011d ae500a        	ldw	x,#20490
 723  0120 cd0000        	call	_GPIO_Init
 725  0123 85            	popw	x
 726                     ; 154     GPIO_Init(GPIOG, COL1_PIN, GPIO_MODE_IN_PU_NO_IT);
 728  0124 4b40          	push	#64
 729  0126 4b01          	push	#1
 730  0128 ae501e        	ldw	x,#20510
 731  012b cd0000        	call	_GPIO_Init
 733  012e 85            	popw	x
 734                     ; 155     GPIO_Init(GPIOC, COL2_PIN | COL3_PIN, GPIO_MODE_IN_PU_NO_IT);
 736  012f 4b40          	push	#64
 737  0131 4b0c          	push	#12
 738  0133 ae500a        	ldw	x,#20490
 739  0136 cd0000        	call	_GPIO_Init
 741  0139 85            	popw	x
 742                     ; 156 }
 745  013a 81            	ret
 748                     	switch	.const
 749  000e               L112_keyMap:
 750  000e 31            	dc.b	49
 751  000f 32            	dc.b	50
 752  0010 33            	dc.b	51
 753  0011 34            	dc.b	52
 754  0012 35            	dc.b	53
 755  0013 36            	dc.b	54
 756  0014 37            	dc.b	55
 757  0015 38            	dc.b	56
 758  0016 39            	dc.b	57
 759  0017 2a            	dc.b	42
 760  0018 30            	dc.b	48
 761  0019 23            	dc.b	35
 849                     	switch	.const
 850  001a               L62:
 851  001a 000003e8      	dc.l	1000
 852  001e               L44:
 853  001e 00007530      	dc.l	30000
 854                     ; 158 char getKey(void) {
 855                     	switch	.text
 856  013b               _getKey:
 858  013b 5218          	subw	sp,#24
 859       00000018      OFST:	set	24
 862                     ; 159     const char keyMap[4][3] = {
 862                     ; 160         {'1', '2', '3'},
 862                     ; 161         {'4', '5', '6'},
 862                     ; 162         {'7', '8', '9'},
 862                     ; 163         {'*', '0', '#'}
 862                     ; 164     };
 864  013d 96            	ldw	x,sp
 865  013e 1c0004        	addw	x,#OFST-20
 866  0141 90ae000e      	ldw	y,#L112_keyMap
 867  0145 a60c          	ld	a,#12
 868  0147 cd0000        	call	c_xymov
 870                     ; 167     char key = 0;
 872                     ; 171     GPIOD->ODR |= ROW1_PIN | ROW2_PIN;
 874  014a c6500f        	ld	a,20495
 875  014d aa60          	or	a,#96
 876  014f c7500f        	ld	20495,a
 877                     ; 172     GPIOE->ODR |= ROW3_PIN;
 879  0152 72105014      	bset	20500,#0
 880                     ; 173     GPIOC->ODR |= ROW4_PIN;
 882  0156 7212500a      	bset	20490,#1
 883                     ; 175     for (row = 0; row < 4; row++) {
 885  015a 5f            	clrw	x
 886  015b 1f11          	ldw	(OFST-7,sp),x
 888  015d               L333:
 889                     ; 177         switch (row) {
 891  015d 1e11          	ldw	x,(OFST-7,sp)
 893                     ; 181             case 3: GPIOC->ODR &= ~ROW4_PIN; break;
 894  015f 5d            	tnzw	x
 895  0160 270b          	jreq	L312
 896  0162 5a            	decw	x
 897  0163 270e          	jreq	L512
 898  0165 5a            	decw	x
 899  0166 2711          	jreq	L712
 900  0168 5a            	decw	x
 901  0169 2714          	jreq	L122
 902  016b 2016          	jra	L343
 903  016d               L312:
 904                     ; 178             case 0: GPIOD->ODR &= ~ROW1_PIN; break;
 906  016d 721d500f      	bres	20495,#6
 909  0171 2010          	jra	L343
 910  0173               L512:
 911                     ; 179             case 1: GPIOD->ODR &= ~ROW2_PIN; break;
 913  0173 721b500f      	bres	20495,#5
 916  0177 200a          	jra	L343
 917  0179               L712:
 918                     ; 180             case 2: GPIOE->ODR &= ~ROW3_PIN; break;
 920  0179 72115014      	bres	20500,#0
 923  017d 2004          	jra	L343
 924  017f               L122:
 925                     ; 181             case 3: GPIOC->ODR &= ~ROW4_PIN; break;
 927  017f 7213500a      	bres	20490,#1
 930  0183               L343:
 931                     ; 184         for (i = 0; i < 1000; i++); // malé zpoždìní
 933  0183 ae0000        	ldw	x,#0
 934  0186 1f15          	ldw	(OFST-3,sp),x
 935  0188 ae0000        	ldw	x,#0
 936  018b 1f13          	ldw	(OFST-5,sp),x
 938  018d               L543:
 942  018d 96            	ldw	x,sp
 943  018e 1c0013        	addw	x,#OFST-5
 944  0191 a601          	ld	a,#1
 945  0193 cd0000        	call	c_lgadc
 950  0196 96            	ldw	x,sp
 951  0197 1c0013        	addw	x,#OFST-5
 952  019a cd0000        	call	c_ltor
 954  019d ae001a        	ldw	x,#L62
 955  01a0 cd0000        	call	c_lcmp
 957  01a3 25e8          	jrult	L543
 958                     ; 186         for (col = 0; col < 3; col++) {
 960  01a5 5f            	clrw	x
 961  01a6 1f17          	ldw	(OFST-1,sp),x
 963  01a8               L353:
 964                     ; 187             uint8_t colState = 1;
 966  01a8 a601          	ld	a,#1
 967  01aa 6b03          	ld	(OFST-21,sp),a
 969                     ; 189             switch (col) {
 971  01ac 1e17          	ldw	x,(OFST-1,sp)
 973                     ; 192                 case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
 974  01ae 5d            	tnzw	x
 975  01af 2708          	jreq	L322
 976  01b1 5a            	decw	x
 977  01b2 2715          	jreq	L522
 978  01b4 5a            	decw	x
 979  01b5 2722          	jreq	L722
 980  01b7 202e          	jra	L363
 981  01b9               L322:
 982                     ; 190                 case 0: colState = !(GPIOG->IDR & COL1_PIN); break;
 984  01b9 c6501f        	ld	a,20511
 985  01bc a501          	bcp	a,#1
 986  01be 2604          	jrne	L03
 987  01c0 a601          	ld	a,#1
 988  01c2 2001          	jra	L23
 989  01c4               L03:
 990  01c4 4f            	clr	a
 991  01c5               L23:
 992  01c5 6b03          	ld	(OFST-21,sp),a
 996  01c7 201e          	jra	L363
 997  01c9               L522:
 998                     ; 191                 case 1: colState = !(GPIOC->IDR & COL2_PIN); break;
1000  01c9 c6500b        	ld	a,20491
1001  01cc a504          	bcp	a,#4
1002  01ce 2604          	jrne	L43
1003  01d0 a601          	ld	a,#1
1004  01d2 2001          	jra	L63
1005  01d4               L43:
1006  01d4 4f            	clr	a
1007  01d5               L63:
1008  01d5 6b03          	ld	(OFST-21,sp),a
1012  01d7 200e          	jra	L363
1013  01d9               L722:
1014                     ; 192                 case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
1016  01d9 c6500b        	ld	a,20491
1017  01dc a508          	bcp	a,#8
1018  01de 2604          	jrne	L04
1019  01e0 a601          	ld	a,#1
1020  01e2 2001          	jra	L24
1021  01e4               L04:
1022  01e4 4f            	clr	a
1023  01e5               L24:
1024  01e5 6b03          	ld	(OFST-21,sp),a
1028  01e7               L363:
1029                     ; 195             if (colState) {
1031  01e7 0d03          	tnz	(OFST-21,sp)
1032  01e9 2603          	jrne	L001
1033  01eb cc02d3        	jp	L563
1034  01ee               L001:
1035                     ; 196                 for (i = 0; i < 30000; i++); // debounce
1037  01ee ae0000        	ldw	x,#0
1038  01f1 1f15          	ldw	(OFST-3,sp),x
1039  01f3 ae0000        	ldw	x,#0
1040  01f6 1f13          	ldw	(OFST-5,sp),x
1042  01f8               L763:
1046  01f8 96            	ldw	x,sp
1047  01f9 1c0013        	addw	x,#OFST-5
1048  01fc a601          	ld	a,#1
1049  01fe cd0000        	call	c_lgadc
1054  0201 96            	ldw	x,sp
1055  0202 1c0013        	addw	x,#OFST-5
1056  0205 cd0000        	call	c_ltor
1058  0208 ae001e        	ldw	x,#L44
1059  020b cd0000        	call	c_lcmp
1061  020e 25e8          	jrult	L763
1062                     ; 199                 switch (col) {
1064  0210 1e17          	ldw	x,(OFST-1,sp)
1066                     ; 202                     case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
1067  0212 5d            	tnzw	x
1068  0213 2708          	jreq	L132
1069  0215 5a            	decw	x
1070  0216 2715          	jreq	L332
1071  0218 5a            	decw	x
1072  0219 2722          	jreq	L532
1073  021b 202e          	jra	L773
1074  021d               L132:
1075                     ; 200                     case 0: colState = !(GPIOG->IDR & COL1_PIN); break;
1077  021d c6501f        	ld	a,20511
1078  0220 a501          	bcp	a,#1
1079  0222 2604          	jrne	L64
1080  0224 a601          	ld	a,#1
1081  0226 2001          	jra	L05
1082  0228               L64:
1083  0228 4f            	clr	a
1084  0229               L05:
1085  0229 6b03          	ld	(OFST-21,sp),a
1089  022b 201e          	jra	L773
1090  022d               L332:
1091                     ; 201                     case 1: colState = !(GPIOC->IDR & COL2_PIN); break;
1093  022d c6500b        	ld	a,20491
1094  0230 a504          	bcp	a,#4
1095  0232 2604          	jrne	L25
1096  0234 a601          	ld	a,#1
1097  0236 2001          	jra	L45
1098  0238               L25:
1099  0238 4f            	clr	a
1100  0239               L45:
1101  0239 6b03          	ld	(OFST-21,sp),a
1105  023b 200e          	jra	L773
1106  023d               L532:
1107                     ; 202                     case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
1109  023d c6500b        	ld	a,20491
1110  0240 a508          	bcp	a,#8
1111  0242 2604          	jrne	L65
1112  0244 a601          	ld	a,#1
1113  0246 2001          	jra	L06
1114  0248               L65:
1115  0248 4f            	clr	a
1116  0249               L06:
1117  0249 6b03          	ld	(OFST-21,sp),a
1121  024b               L773:
1122                     ; 205                 if (colState) {
1124  024b 0d03          	tnz	(OFST-21,sp)
1125  024d 2603          	jrne	L201
1126  024f cc02d3        	jp	L563
1127  0252               L201:
1128                     ; 206                     key = keyMap[row][col];
1130  0252 96            	ldw	x,sp
1131  0253 1c0004        	addw	x,#OFST-20
1132  0256 1f01          	ldw	(OFST-23,sp),x
1134  0258 1e11          	ldw	x,(OFST-7,sp)
1135  025a a603          	ld	a,#3
1136  025c cd0000        	call	c_bmulx
1138  025f 72fb01        	addw	x,(OFST-23,sp)
1139  0262 72fb17        	addw	x,(OFST-1,sp)
1140  0265 f6            	ld	a,(x)
1141  0266 6b10          	ld	(OFST-8,sp),a
1143  0268               L304:
1144                     ; 210                         uint8_t released = 0;
1146  0268 0f03          	clr	(OFST-21,sp)
1148                     ; 211                         switch (col) {
1150  026a 1e17          	ldw	x,(OFST-1,sp)
1152                     ; 214                             case 2: released = (GPIOC->IDR & COL3_PIN) != 0; break;
1153  026c 5d            	tnzw	x
1154  026d 2708          	jreq	L732
1155  026f 5a            	decw	x
1156  0270 2715          	jreq	L142
1157  0272 5a            	decw	x
1158  0273 2722          	jreq	L342
1159  0275 202e          	jra	L114
1160  0277               L732:
1161                     ; 212                             case 0: released = (GPIOG->IDR & COL1_PIN) != 0; break;
1163  0277 c6501f        	ld	a,20511
1164  027a a501          	bcp	a,#1
1165  027c 2704          	jreq	L26
1166  027e a601          	ld	a,#1
1167  0280 2001          	jra	L46
1168  0282               L26:
1169  0282 4f            	clr	a
1170  0283               L46:
1171  0283 6b03          	ld	(OFST-21,sp),a
1175  0285 201e          	jra	L114
1176  0287               L142:
1177                     ; 213                             case 1: released = (GPIOC->IDR & COL2_PIN) != 0; break;
1179  0287 c6500b        	ld	a,20491
1180  028a a504          	bcp	a,#4
1181  028c 2704          	jreq	L66
1182  028e a601          	ld	a,#1
1183  0290 2001          	jra	L07
1184  0292               L66:
1185  0292 4f            	clr	a
1186  0293               L07:
1187  0293 6b03          	ld	(OFST-21,sp),a
1191  0295 200e          	jra	L114
1192  0297               L342:
1193                     ; 214                             case 2: released = (GPIOC->IDR & COL3_PIN) != 0; break;
1195  0297 c6500b        	ld	a,20491
1196  029a a508          	bcp	a,#8
1197  029c 2704          	jreq	L27
1198  029e a601          	ld	a,#1
1199  02a0 2001          	jra	L47
1200  02a2               L27:
1201  02a2 4f            	clr	a
1202  02a3               L47:
1203  02a3 6b03          	ld	(OFST-21,sp),a
1207  02a5               L114:
1208                     ; 216                         if (released) break;
1210  02a5 0d03          	tnz	(OFST-21,sp)
1211  02a7 27bf          	jreq	L304
1213                     ; 220                     switch (row) {
1215  02a9 1e11          	ldw	x,(OFST-7,sp)
1217                     ; 224                         case 3: GPIOC->ODR |= ROW4_PIN; break;
1218  02ab 5d            	tnzw	x
1219  02ac 270b          	jreq	L542
1220  02ae 5a            	decw	x
1221  02af 270e          	jreq	L742
1222  02b1 5a            	decw	x
1223  02b2 2711          	jreq	L152
1224  02b4 5a            	decw	x
1225  02b5 2714          	jreq	L352
1226  02b7 2016          	jra	L714
1227  02b9               L542:
1228                     ; 221                         case 0: GPIOD->ODR |= ROW1_PIN; break;
1230  02b9 721c500f      	bset	20495,#6
1233  02bd 2010          	jra	L714
1234  02bf               L742:
1235                     ; 222                         case 1: GPIOD->ODR |= ROW2_PIN; break;
1237  02bf 721a500f      	bset	20495,#5
1240  02c3 200a          	jra	L714
1241  02c5               L152:
1242                     ; 223                         case 2: GPIOE->ODR |= ROW3_PIN; break;
1244  02c5 72105014      	bset	20500,#0
1247  02c9 2004          	jra	L714
1248  02cb               L352:
1249                     ; 224                         case 3: GPIOC->ODR |= ROW4_PIN; break;
1251  02cb 7212500a      	bset	20490,#1
1254  02cf               L714:
1255                     ; 227                     return key;
1257  02cf 7b10          	ld	a,(OFST-8,sp)
1259  02d1 204b          	jra	L67
1260  02d3               L563:
1261                     ; 186         for (col = 0; col < 3; col++) {
1263  02d3 1e17          	ldw	x,(OFST-1,sp)
1264  02d5 1c0001        	addw	x,#1
1265  02d8 1f17          	ldw	(OFST-1,sp),x
1269  02da 9c            	rvf
1270  02db 1e17          	ldw	x,(OFST-1,sp)
1271  02dd a30003        	cpw	x,#3
1272  02e0 2e03          	jrsge	L401
1273  02e2 cc01a8        	jp	L353
1274  02e5               L401:
1275                     ; 233         switch (row) {
1277  02e5 1e11          	ldw	x,(OFST-7,sp)
1279                     ; 237             case 3: GPIOC->ODR |= ROW4_PIN; break;
1280  02e7 5d            	tnzw	x
1281  02e8 270b          	jreq	L552
1282  02ea 5a            	decw	x
1283  02eb 270e          	jreq	L752
1284  02ed 5a            	decw	x
1285  02ee 2711          	jreq	L162
1286  02f0 5a            	decw	x
1287  02f1 2714          	jreq	L362
1288  02f3 2016          	jra	L324
1289  02f5               L552:
1290                     ; 234             case 0: GPIOD->ODR |= ROW1_PIN; break;
1292  02f5 721c500f      	bset	20495,#6
1295  02f9 2010          	jra	L324
1296  02fb               L752:
1297                     ; 235             case 1: GPIOD->ODR |= ROW2_PIN; break;
1299  02fb 721a500f      	bset	20495,#5
1302  02ff 200a          	jra	L324
1303  0301               L162:
1304                     ; 236             case 2: GPIOE->ODR |= ROW3_PIN; break;
1306  0301 72105014      	bset	20500,#0
1309  0305 2004          	jra	L324
1310  0307               L362:
1311                     ; 237             case 3: GPIOC->ODR |= ROW4_PIN; break;
1313  0307 7212500a      	bset	20490,#1
1316  030b               L324:
1317                     ; 175     for (row = 0; row < 4; row++) {
1319  030b 1e11          	ldw	x,(OFST-7,sp)
1320  030d 1c0001        	addw	x,#1
1321  0310 1f11          	ldw	(OFST-7,sp),x
1325  0312 9c            	rvf
1326  0313 1e11          	ldw	x,(OFST-7,sp)
1327  0315 a30004        	cpw	x,#4
1328  0318 2e03          	jrsge	L601
1329  031a cc015d        	jp	L333
1330  031d               L601:
1331                     ; 241     return 0; // žádná klávesa
1333  031d 4f            	clr	a
1335  031e               L67:
1337  031e 5b18          	addw	sp,#24
1338  0320 81            	ret
1363                     ; 246 void buzzerInit(void) {
1364                     	switch	.text
1365  0321               _buzzerInit:
1369                     ; 248     GPIO_Init(BUZZER_PORT, BUZZER_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
1371  0321 4be0          	push	#224
1372  0323 4b08          	push	#8
1373  0325 ae500f        	ldw	x,#20495
1374  0328 cd0000        	call	_GPIO_Init
1376  032b 85            	popw	x
1377                     ; 249     GPIO_WriteLow(BUZZER_PORT, BUZZER_PIN);
1379  032c 4b08          	push	#8
1380  032e ae500f        	ldw	x,#20495
1381  0331 cd0000        	call	_GPIO_WriteLow
1383  0334 84            	pop	a
1384                     ; 250 }
1387  0335 81            	ret
1460                     ; 252 void beepTone(uint16_t freq, uint16_t duration_ms) {
1461                     	switch	.text
1462  0336               _beepTone:
1464  0336 89            	pushw	x
1465  0337 5210          	subw	sp,#16
1466       00000010      OFST:	set	16
1469                     ; 256     uint32_t delay = 1000000 / (freq * 2); // poloviny periody v us
1471  0339 58            	sllw	x
1472  033a cd0000        	call	c_uitolx
1474  033d 96            	ldw	x,sp
1475  033e 1c0001        	addw	x,#OFST-15
1476  0341 cd0000        	call	c_rtol
1479  0344 ae4240        	ldw	x,#16960
1480  0347 bf02          	ldw	c_lreg+2,x
1481  0349 ae000f        	ldw	x,#15
1482  034c bf00          	ldw	c_lreg,x
1483  034e 96            	ldw	x,sp
1484  034f 1c0001        	addw	x,#OFST-15
1485  0352 cd0000        	call	c_ldiv
1487  0355 96            	ldw	x,sp
1488  0356 1c000d        	addw	x,#OFST-3
1489  0359 cd0000        	call	c_rtol
1492                     ; 257     uint32_t cycles = (uint32_t)freq * duration_ms / 1000;
1494  035c 1e11          	ldw	x,(OFST+1,sp)
1495  035e 1615          	ldw	y,(OFST+5,sp)
1496  0360 cd0000        	call	c_umul
1498  0363 ae001a        	ldw	x,#L62
1499  0366 cd0000        	call	c_ludv
1501  0369 96            	ldw	x,sp
1502  036a 1c0005        	addw	x,#OFST-11
1503  036d cd0000        	call	c_rtol
1506                     ; 259     for (i = 0; i < cycles; i++) {
1508  0370 ae0000        	ldw	x,#0
1509  0373 1f0b          	ldw	(OFST-5,sp),x
1510  0375 ae0000        	ldw	x,#0
1511  0378 1f09          	ldw	(OFST-7,sp),x
1514  037a 2025          	jra	L774
1515  037c               L374:
1516                     ; 260         GPIO_WriteHigh(BUZZER_PORT, BUZZER_PIN);
1518  037c 4b08          	push	#8
1519  037e ae500f        	ldw	x,#20495
1520  0381 cd0000        	call	_GPIO_WriteHigh
1522  0384 84            	pop	a
1523                     ; 261         delay_us(delay);
1525  0385 1e0f          	ldw	x,(OFST-1,sp)
1526  0387 cd00e4        	call	_delay_us
1528                     ; 262         GPIO_WriteLow(BUZZER_PORT, BUZZER_PIN);
1530  038a 4b08          	push	#8
1531  038c ae500f        	ldw	x,#20495
1532  038f cd0000        	call	_GPIO_WriteLow
1534  0392 84            	pop	a
1535                     ; 263         delay_us(delay);
1537  0393 1e0f          	ldw	x,(OFST-1,sp)
1538  0395 cd00e4        	call	_delay_us
1540                     ; 259     for (i = 0; i < cycles; i++) {
1542  0398 96            	ldw	x,sp
1543  0399 1c0009        	addw	x,#OFST-7
1544  039c a601          	ld	a,#1
1545  039e cd0000        	call	c_lgadc
1548  03a1               L774:
1551  03a1 96            	ldw	x,sp
1552  03a2 1c0009        	addw	x,#OFST-7
1553  03a5 cd0000        	call	c_ltor
1555  03a8 96            	ldw	x,sp
1556  03a9 1c0005        	addw	x,#OFST-11
1557  03ac cd0000        	call	c_lcmp
1559  03af 25cb          	jrult	L374
1560                     ; 265 }
1563  03b1 5b12          	addw	sp,#18
1564  03b3 81            	ret
1629                     ; 267 void beepAndBlink(uint16_t frequency, uint16_t duration_ms, GPIO_TypeDef* port, GPIO_Pin_TypeDef pin) {
1630                     	switch	.text
1631  03b4               _beepAndBlink:
1633  03b4 89            	pushw	x
1634  03b5 520a          	subw	sp,#10
1635       0000000a      OFST:	set	10
1638                     ; 268     uint16_t halfPeriod_us = 1000000UL / (2 * frequency);  // délka pùl periody v µs
1640  03b7 58            	sllw	x
1641  03b8 cd0000        	call	c_uitolx
1643  03bb 96            	ldw	x,sp
1644  03bc 1c0001        	addw	x,#OFST-9
1645  03bf cd0000        	call	c_rtol
1648  03c2 ae4240        	ldw	x,#16960
1649  03c5 bf02          	ldw	c_lreg+2,x
1650  03c7 ae000f        	ldw	x,#15
1651  03ca bf00          	ldw	c_lreg,x
1652  03cc 96            	ldw	x,sp
1653  03cd 1c0001        	addw	x,#OFST-9
1654  03d0 cd0000        	call	c_ludv
1656  03d3 be02          	ldw	x,c_lreg+2
1657  03d5 1f05          	ldw	(OFST-5,sp),x
1659                     ; 269     uint32_t startTime = milis();
1661  03d7 cd0000        	call	_milis
1663  03da cd0000        	call	c_uitolx
1665  03dd 96            	ldw	x,sp
1666  03de 1c0007        	addw	x,#OFST-3
1667  03e1 cd0000        	call	c_rtol
1671  03e4 2016          	jra	L145
1672  03e6               L535:
1673                     ; 272         beepTone(2000,400);
1675  03e6 ae0190        	ldw	x,#400
1676  03e9 89            	pushw	x
1677  03ea ae07d0        	ldw	x,#2000
1678  03ed cd0336        	call	_beepTone
1680  03f0 85            	popw	x
1681                     ; 273         blinkLED(1, '');            
1683  03f1 ae0100        	ldw	x,#256
1684  03f4 cd05b4        	call	_blinkLED
1686                     ; 274         delay_us(halfPeriod_us);
1688  03f7 1e05          	ldw	x,(OFST-5,sp)
1689  03f9 cd00e4        	call	_delay_us
1691  03fc               L145:
1692                     ; 271     while ((milis() - startTime) < duration_ms) {
1694  03fc cd0000        	call	_milis
1696  03ff cd0000        	call	c_uitolx
1698  0402 96            	ldw	x,sp
1699  0403 1c0007        	addw	x,#OFST-3
1700  0406 cd0000        	call	c_lsub
1702  0409 96            	ldw	x,sp
1703  040a 1c0001        	addw	x,#OFST-9
1704  040d cd0000        	call	c_rtol
1707  0410 1e0f          	ldw	x,(OFST+5,sp)
1708  0412 cd0000        	call	c_uitolx
1710  0415 96            	ldw	x,sp
1711  0416 1c0001        	addw	x,#OFST-9
1712  0419 cd0000        	call	c_lcmp
1714  041c 22c8          	jrugt	L535
1715                     ; 276 }
1718  041e 5b0c          	addw	sp,#12
1719  0420 81            	ret
1792                     ; 280 void beepSuccess(void) {
1793                     	switch	.text
1794  0421               _beepSuccess:
1796  0421 5209          	subw	sp,#9
1797       00000009      OFST:	set	9
1800                     ; 281     uint16_t freq = 3000;
1802  0423 ae0bb8        	ldw	x,#3000
1803  0426 1f01          	ldw	(OFST-8,sp),x
1805                     ; 282     uint16_t totalDuration = 300;  
1807  0428 ae012c        	ldw	x,#300
1808  042b 1f03          	ldw	(OFST-6,sp),x
1810                     ; 283     uint16_t chunkDuration = 50;   
1812  042d ae0032        	ldw	x,#50
1813  0430 1f05          	ldw	(OFST-4,sp),x
1815                     ; 284     uint16_t elapsed = 0;
1817  0432 5f            	clrw	x
1818  0433 1f07          	ldw	(OFST-2,sp),x
1820                     ; 285     uint8_t ledOn = 0;
1822  0435 0f09          	clr	(OFST+0,sp)
1825  0437 202e          	jra	L706
1826  0439               L306:
1827                     ; 288         if (ledOn) {
1829  0439 0d09          	tnz	(OFST+0,sp)
1830  043b 270d          	jreq	L316
1831                     ; 289             GPIO_WriteLow(GPIOE, GPIO_PIN_5);
1833  043d 4b20          	push	#32
1834  043f ae5014        	ldw	x,#20500
1835  0442 cd0000        	call	_GPIO_WriteLow
1837  0445 84            	pop	a
1838                     ; 290             ledOn = 0;
1840  0446 0f09          	clr	(OFST+0,sp)
1843  0448 200d          	jra	L516
1844  044a               L316:
1845                     ; 292             GPIO_WriteHigh(GPIOE, GPIO_PIN_5);
1847  044a 4b20          	push	#32
1848  044c ae5014        	ldw	x,#20500
1849  044f cd0000        	call	_GPIO_WriteHigh
1851  0452 84            	pop	a
1852                     ; 293             ledOn = 1;
1854  0453 a601          	ld	a,#1
1855  0455 6b09          	ld	(OFST+0,sp),a
1857  0457               L516:
1858                     ; 297         beepTone(freq, chunkDuration);
1860  0457 1e05          	ldw	x,(OFST-4,sp)
1861  0459 89            	pushw	x
1862  045a 1e03          	ldw	x,(OFST-6,sp)
1863  045c cd0336        	call	_beepTone
1865  045f 85            	popw	x
1866                     ; 299         elapsed += chunkDuration;
1868  0460 1e07          	ldw	x,(OFST-2,sp)
1869  0462 72fb05        	addw	x,(OFST-4,sp)
1870  0465 1f07          	ldw	(OFST-2,sp),x
1872  0467               L706:
1873                     ; 287     while (elapsed < totalDuration) {
1875  0467 1e07          	ldw	x,(OFST-2,sp)
1876  0469 1303          	cpw	x,(OFST-6,sp)
1877  046b 25cc          	jrult	L306
1878                     ; 303     GPIO_WriteLow(GPIOC, GPIO_PIN_4);
1880  046d 4b10          	push	#16
1881  046f ae500a        	ldw	x,#20490
1882  0472 cd0000        	call	_GPIO_WriteLow
1884  0475 84            	pop	a
1885                     ; 304 }
1888  0476 5b09          	addw	sp,#9
1889  0478 81            	ret
1913                     ; 306 void beepFail(void) {
1914                     	switch	.text
1915  0479               _beepFail:
1919                     ; 307     beepTone(500, 100);
1921  0479 ae0064        	ldw	x,#100
1922  047c 89            	pushw	x
1923  047d ae01f4        	ldw	x,#500
1924  0480 cd0336        	call	_beepTone
1926  0483 85            	popw	x
1927                     ; 308 }
1930  0484 81            	ret
1964                     ; 311 uint8_t EEPROM_ReadByte(uint16_t addr) {
1965                     	switch	.text
1966  0485               _EEPROM_ReadByte:
1970                     ; 313     return *((uint8_t*)addr);
1972  0485 f6            	ld	a,(x)
1975  0486 81            	ret
2021                     ; 317 void EEPROM_WriteByte(uint16_t addr, uint8_t data) {
2022                     	switch	.text
2023  0487               _EEPROM_WriteByte:
2025  0487 89            	pushw	x
2026       00000000      OFST:	set	0
2029                     ; 319     FLASH_Unlock(FLASH_MEMTYPE_DATA);
2031  0488 a6f7          	ld	a,#247
2032  048a cd0000        	call	_FLASH_Unlock
2034                     ; 320     FLASH_ProgramByte(addr, data);
2036  048d 7b05          	ld	a,(OFST+5,sp)
2037  048f 88            	push	a
2038  0490 1e02          	ldw	x,(OFST+2,sp)
2039  0492 cd0000        	call	c_uitolx
2041  0495 be02          	ldw	x,c_lreg+2
2042  0497 89            	pushw	x
2043  0498 be00          	ldw	x,c_lreg
2044  049a 89            	pushw	x
2045  049b cd0000        	call	_FLASH_ProgramByte
2047  049e 5b05          	addw	sp,#5
2048                     ; 321     FLASH_Lock(FLASH_MEMTYPE_DATA);
2050  04a0 a6f7          	ld	a,#247
2051  04a2 cd0000        	call	_FLASH_Lock
2053                     ; 322 }
2056  04a5 85            	popw	x
2057  04a6 81            	ret
2104                     ; 325 void loadPINfromEEPROM(void) {
2105                     	switch	.text
2106  04a7               _loadPINfromEEPROM:
2108  04a7 89            	pushw	x
2109       00000002      OFST:	set	2
2112                     ; 327     uint8_t valid = 1;
2114  04a8 a601          	ld	a,#1
2115  04aa 6b01          	ld	(OFST-1,sp),a
2117                     ; 328     for (i = 0; i < 4; i++) {
2119  04ac 0f02          	clr	(OFST+0,sp)
2121  04ae               L117:
2122                     ; 329         storedPIN[i] = EEPROM_ReadByte(EEPROM_PIN_ADDR + i);
2124  04ae 7b02          	ld	a,(OFST+0,sp)
2125  04b0 5f            	clrw	x
2126  04b1 97            	ld	xl,a
2127  04b2 89            	pushw	x
2128  04b3 7b04          	ld	a,(OFST+2,sp)
2129  04b5 5f            	clrw	x
2130  04b6 97            	ld	xl,a
2131  04b7 1c4000        	addw	x,#16384
2132  04ba adc9          	call	_EEPROM_ReadByte
2134  04bc 85            	popw	x
2135  04bd e700          	ld	(_storedPIN,x),a
2136                     ; 331         if (storedPIN[i] < '0' || storedPIN[i] > '9') {
2138  04bf 7b02          	ld	a,(OFST+0,sp)
2139  04c1 5f            	clrw	x
2140  04c2 97            	ld	xl,a
2141  04c3 e600          	ld	a,(_storedPIN,x)
2142  04c5 a130          	cp	a,#48
2143  04c7 250a          	jrult	L127
2145  04c9 7b02          	ld	a,(OFST+0,sp)
2146  04cb 5f            	clrw	x
2147  04cc 97            	ld	xl,a
2148  04cd e600          	ld	a,(_storedPIN,x)
2149  04cf a13a          	cp	a,#58
2150  04d1 2502          	jrult	L717
2151  04d3               L127:
2152                     ; 332             valid = 0;
2154  04d3 0f01          	clr	(OFST-1,sp)
2156  04d5               L717:
2157                     ; 328     for (i = 0; i < 4; i++) {
2159  04d5 0c02          	inc	(OFST+0,sp)
2163  04d7 7b02          	ld	a,(OFST+0,sp)
2164  04d9 a104          	cp	a,#4
2165  04db 25d1          	jrult	L117
2166                     ; 335     if (!valid) {
2168  04dd 0d01          	tnz	(OFST-1,sp)
2169  04df 2625          	jrne	L327
2170                     ; 337         for (i = 0; i < 4; i++) {
2172  04e1 0f02          	clr	(OFST+0,sp)
2174  04e3               L527:
2175                     ; 338             storedPIN[i] = defaultPIN[i];
2177  04e3 7b02          	ld	a,(OFST+0,sp)
2178  04e5 5f            	clrw	x
2179  04e6 97            	ld	xl,a
2180  04e7 d60000        	ld	a,(_defaultPIN,x)
2181  04ea e700          	ld	(_storedPIN,x),a
2182                     ; 339             EEPROM_WriteByte(EEPROM_PIN_ADDR + i, defaultPIN[i]);
2184  04ec 7b02          	ld	a,(OFST+0,sp)
2185  04ee 5f            	clrw	x
2186  04ef 97            	ld	xl,a
2187  04f0 d60000        	ld	a,(_defaultPIN,x)
2188  04f3 88            	push	a
2189  04f4 7b03          	ld	a,(OFST+1,sp)
2190  04f6 5f            	clrw	x
2191  04f7 97            	ld	xl,a
2192  04f8 1c4000        	addw	x,#16384
2193  04fb ad8a          	call	_EEPROM_WriteByte
2195  04fd 84            	pop	a
2196                     ; 337         for (i = 0; i < 4; i++) {
2198  04fe 0c02          	inc	(OFST+0,sp)
2202  0500 7b02          	ld	a,(OFST+0,sp)
2203  0502 a104          	cp	a,#4
2204  0504 25dd          	jrult	L527
2205  0506               L327:
2206                     ; 342 }
2209  0506 85            	popw	x
2210  0507 81            	ret
2256                     ; 345 void savePINtoEEPROM(const char* newPIN) {
2257                     	switch	.text
2258  0508               _savePINtoEEPROM:
2260  0508 89            	pushw	x
2261  0509 88            	push	a
2262       00000001      OFST:	set	1
2265                     ; 347     for (i = 0; i < 4; i++) {
2267  050a 0f01          	clr	(OFST+0,sp)
2269  050c               L557:
2270                     ; 348         storedPIN[i] = newPIN[i];
2272  050c 7b01          	ld	a,(OFST+0,sp)
2273  050e 5f            	clrw	x
2274  050f 97            	ld	xl,a
2275  0510 7b01          	ld	a,(OFST+0,sp)
2276  0512 905f          	clrw	y
2277  0514 9097          	ld	yl,a
2278  0516 72f902        	addw	y,(OFST+1,sp)
2279  0519 90f6          	ld	a,(y)
2280  051b e700          	ld	(_storedPIN,x),a
2281                     ; 349         EEPROM_WriteByte(EEPROM_PIN_ADDR + i, newPIN[i]);
2283  051d 7b01          	ld	a,(OFST+0,sp)
2284  051f 5f            	clrw	x
2285  0520 97            	ld	xl,a
2286  0521 72fb02        	addw	x,(OFST+1,sp)
2287  0524 f6            	ld	a,(x)
2288  0525 88            	push	a
2289  0526 7b02          	ld	a,(OFST+1,sp)
2290  0528 5f            	clrw	x
2291  0529 97            	ld	xl,a
2292  052a 1c4000        	addw	x,#16384
2293  052d cd0487        	call	_EEPROM_WriteByte
2295  0530 84            	pop	a
2296                     ; 347     for (i = 0; i < 4; i++) {
2298  0531 0c01          	inc	(OFST+0,sp)
2302  0533 7b01          	ld	a,(OFST+0,sp)
2303  0535 a104          	cp	a,#4
2304  0537 25d3          	jrult	L557
2305                     ; 351 }
2308  0539 5b03          	addw	sp,#3
2309  053b 81            	ret
2363                     ; 354 uint8_t comparePIN(const char* a, const char* b) {
2364                     	switch	.text
2365  053c               _comparePIN:
2367  053c 89            	pushw	x
2368  053d 88            	push	a
2369       00000001      OFST:	set	1
2372                     ; 356     for (i = 0; i < 4; i++) {
2374  053e 0f01          	clr	(OFST+0,sp)
2376  0540               L1101:
2377                     ; 357         if (a[i] != b[i]) return 0;
2379  0540 7b01          	ld	a,(OFST+0,sp)
2380  0542 5f            	clrw	x
2381  0543 97            	ld	xl,a
2382  0544 72fb06        	addw	x,(OFST+5,sp)
2383  0547 7b01          	ld	a,(OFST+0,sp)
2384  0549 905f          	clrw	y
2385  054b 9097          	ld	yl,a
2386  054d 72f902        	addw	y,(OFST+1,sp)
2387  0550 90f6          	ld	a,(y)
2388  0552 f1            	cp	a,(x)
2389  0553 2703          	jreq	L7101
2392  0555 4f            	clr	a
2394  0556 200a          	jra	L431
2395  0558               L7101:
2396                     ; 356     for (i = 0; i < 4; i++) {
2398  0558 0c01          	inc	(OFST+0,sp)
2402  055a 7b01          	ld	a,(OFST+0,sp)
2403  055c a104          	cp	a,#4
2404  055e 25e0          	jrult	L1101
2405                     ; 359     return 1;
2407  0560 a601          	ld	a,#1
2409  0562               L431:
2411  0562 5b03          	addw	sp,#3
2412  0564 81            	ret
2466                     ; 363 void blinkDisplay(uint8_t times) {
2467                     	switch	.text
2468  0565               _blinkDisplay:
2470  0565 88            	push	a
2471  0566 89            	pushw	x
2472       00000002      OFST:	set	2
2475                     ; 365     for (i = 0; i < times; i++) {
2477  0567 0f01          	clr	(OFST-1,sp)
2480  0569 2032          	jra	L3501
2481  056b               L7401:
2482                     ; 366         for (j = 0; j < 4; j++) {
2484  056b 0f02          	clr	(OFST+0,sp)
2486  056d               L7501:
2487                     ; 367             tm_displayCharacter(j, 0x7F); 
2489  056d 7b02          	ld	a,(OFST+0,sp)
2490  056f ae007f        	ldw	x,#127
2491  0572 95            	ld	xh,a
2492  0573 cd00be        	call	_tm_displayCharacter
2494                     ; 366         for (j = 0; j < 4; j++) {
2496  0576 0c02          	inc	(OFST+0,sp)
2500  0578 7b02          	ld	a,(OFST+0,sp)
2501  057a a104          	cp	a,#4
2502  057c 25ef          	jrult	L7501
2503                     ; 369         delay_us(300000); 
2505  057e ae93e0        	ldw	x,#37856
2506  0581 cd00e4        	call	_delay_us
2508                     ; 371         for (j = 0; j < 4; j++) {
2510  0584 0f02          	clr	(OFST+0,sp)
2512  0586               L5601:
2513                     ; 372             tm_displayCharacter(j, 0x00);
2515  0586 7b02          	ld	a,(OFST+0,sp)
2516  0588 5f            	clrw	x
2517  0589 95            	ld	xh,a
2518  058a cd00be        	call	_tm_displayCharacter
2520                     ; 371         for (j = 0; j < 4; j++) {
2522  058d 0c02          	inc	(OFST+0,sp)
2526  058f 7b02          	ld	a,(OFST+0,sp)
2527  0591 a104          	cp	a,#4
2528  0593 25f1          	jrult	L5601
2529                     ; 374         delay_us(300000);
2531  0595 ae93e0        	ldw	x,#37856
2532  0598 cd00e4        	call	_delay_us
2534                     ; 365     for (i = 0; i < times; i++) {
2536  059b 0c01          	inc	(OFST-1,sp)
2538  059d               L3501:
2541  059d 7b01          	ld	a,(OFST-1,sp)
2542  059f 1103          	cp	a,(OFST+1,sp)
2543  05a1 25c8          	jrult	L7401
2544                     ; 376 }
2547  05a3 5b03          	addw	sp,#3
2548  05a5 81            	ret
2575                     ; 380 void factoryResetPIN(void) {
2576                     	switch	.text
2577  05a6               _factoryResetPIN:
2581                     ; 381     savePINtoEEPROM(defaultPIN);
2583  05a6 ae0000        	ldw	x,#_defaultPIN
2584  05a9 cd0508        	call	_savePINtoEEPROM
2586                     ; 382     beepSuccess();
2588  05ac cd0421        	call	_beepSuccess
2590                     ; 383     blinkDisplay(2); 
2592  05af a602          	ld	a,#2
2593  05b1 adb2          	call	_blinkDisplay
2595                     ; 384 }
2598  05b3 81            	ret
2653                     ; 386 void blinkLED(uint8_t times, char color){
2654                     	switch	.text
2655  05b4               _blinkLED:
2657  05b4 89            	pushw	x
2658  05b5 88            	push	a
2659       00000001      OFST:	set	1
2662                     ; 388 			if (color == 'r'){
2664  05b6 9f            	ld	a,xl
2665  05b7 a172          	cp	a,#114
2666  05b9 2627          	jrne	L1311
2667                     ; 389 				for (i = 0; i < times; i++) {
2669  05bb 0f01          	clr	(OFST+0,sp)
2672  05bd 201a          	jra	L7311
2673  05bf               L3311:
2674                     ; 390 					GPIO_WriteHigh(GPIOC, GPIO_PIN_4); 
2676  05bf 4b10          	push	#16
2677  05c1 ae500a        	ldw	x,#20490
2678  05c4 cd0000        	call	_GPIO_WriteHigh
2680  05c7 84            	pop	a
2681                     ; 391 					delay_ms(250);
2683  05c8 ae00fa        	ldw	x,#250
2684  05cb cd0000        	call	_delay_ms
2686                     ; 392 					GPIO_WriteLow(GPIOC, GPIO_PIN_4);  
2688  05ce 4b10          	push	#16
2689  05d0 ae500a        	ldw	x,#20490
2690  05d3 cd0000        	call	_GPIO_WriteLow
2692  05d6 84            	pop	a
2693                     ; 389 				for (i = 0; i < times; i++) {
2695  05d7 0c01          	inc	(OFST+0,sp)
2697  05d9               L7311:
2700  05d9 7b01          	ld	a,(OFST+0,sp)
2701  05db 1102          	cp	a,(OFST+1,sp)
2702  05dd 25e0          	jrult	L3311
2704  05df               L3411:
2705                     ; 404 }
2708  05df 5b03          	addw	sp,#3
2709  05e1 81            	ret
2710  05e2               L1311:
2711                     ; 396 					for (i = 0; i < times; i++) {
2713  05e2 0f01          	clr	(OFST+0,sp)
2716  05e4 2020          	jra	L1511
2717  05e6               L5411:
2718                     ; 397 						GPIO_WriteHigh(GPIOE, GPIO_PIN_5);
2720  05e6 4b20          	push	#32
2721  05e8 ae5014        	ldw	x,#20500
2722  05eb cd0000        	call	_GPIO_WriteHigh
2724  05ee 84            	pop	a
2725                     ; 398 						delay_ms(500);
2727  05ef ae01f4        	ldw	x,#500
2728  05f2 cd0000        	call	_delay_ms
2730                     ; 399 						GPIO_WriteLow(GPIOE, GPIO_PIN_5);
2732  05f5 4b20          	push	#32
2733  05f7 ae5014        	ldw	x,#20500
2734  05fa cd0000        	call	_GPIO_WriteLow
2736  05fd 84            	pop	a
2737                     ; 400 						delay_ms(500);
2739  05fe ae01f4        	ldw	x,#500
2740  0601 cd0000        	call	_delay_ms
2742                     ; 396 					for (i = 0; i < times; i++) {
2744  0604 0c01          	inc	(OFST+0,sp)
2746  0606               L1511:
2749  0606 7b01          	ld	a,(OFST+0,sp)
2750  0608 1102          	cp	a,(OFST+1,sp)
2751  060a 25da          	jrult	L5411
2752  060c 20d1          	jra	L3411
2809                     ; 407 void logoutSignal(void) {
2810                     	switch	.text
2811  060e               _logoutSignal:
2813  060e 89            	pushw	x
2814       00000002      OFST:	set	2
2817                     ; 412     for (i = 0; i < 2; i++) {
2819  060f 0f02          	clr	(OFST+0,sp)
2821  0611               L3021:
2822                     ; 413         beepTone(1000, 100);
2824  0611 ae0064        	ldw	x,#100
2825  0614 89            	pushw	x
2826  0615 ae03e8        	ldw	x,#1000
2827  0618 cd0336        	call	_beepTone
2829  061b 85            	popw	x
2830                     ; 414         delay_ms(100);
2832  061c ae0064        	ldw	x,#100
2833  061f cd0000        	call	_delay_ms
2835                     ; 412     for (i = 0; i < 2; i++) {
2837  0622 0c02          	inc	(OFST+0,sp)
2841  0624 7b02          	ld	a,(OFST+0,sp)
2842  0626 a102          	cp	a,#2
2843  0628 25e7          	jrult	L3021
2844                     ; 417     for (i = 0; i < 2; i++) {
2846  062a 0f02          	clr	(OFST+0,sp)
2848  062c               L1121:
2849                     ; 418         GPIO_WriteHigh(GPIOC, GPIO_PIN_4);
2851  062c 4b10          	push	#16
2852  062e ae500a        	ldw	x,#20490
2853  0631 cd0000        	call	_GPIO_WriteHigh
2855  0634 84            	pop	a
2856                     ; 419         delay_ms(200);
2858  0635 ae00c8        	ldw	x,#200
2859  0638 cd0000        	call	_delay_ms
2861                     ; 420         GPIO_WriteLow(GPIOC, GPIO_PIN_4);
2863  063b 4b10          	push	#16
2864  063d ae500a        	ldw	x,#20490
2865  0640 cd0000        	call	_GPIO_WriteLow
2867  0643 84            	pop	a
2868                     ; 421         delay_ms(200);
2870  0644 ae00c8        	ldw	x,#200
2871  0647 cd0000        	call	_delay_ms
2873                     ; 417     for (i = 0; i < 2; i++) {
2875  064a 0c02          	inc	(OFST+0,sp)
2879  064c 7b02          	ld	a,(OFST+0,sp)
2880  064e a102          	cp	a,#2
2881  0650 25da          	jrult	L1121
2882                     ; 424     for (k = 0; k < 2; k++) {
2884  0652 0f01          	clr	(OFST-1,sp)
2886  0654               L7121:
2887                     ; 425         for (j = 0; j < 4; j++) tm_displayCharacter(j, 0xFF);
2889  0654 0f02          	clr	(OFST+0,sp)
2891  0656               L5221:
2894  0656 7b02          	ld	a,(OFST+0,sp)
2895  0658 ae00ff        	ldw	x,#255
2896  065b 95            	ld	xh,a
2897  065c cd00be        	call	_tm_displayCharacter
2901  065f 0c02          	inc	(OFST+0,sp)
2905  0661 7b02          	ld	a,(OFST+0,sp)
2906  0663 a104          	cp	a,#4
2907  0665 25ef          	jrult	L5221
2908                     ; 426         delay_ms(200);
2910  0667 ae00c8        	ldw	x,#200
2911  066a cd0000        	call	_delay_ms
2913                     ; 427         for (j = 0; j < 4; j++) tm_displayCharacter(j, 0x00);
2915  066d 0f02          	clr	(OFST+0,sp)
2917  066f               L3321:
2920  066f 7b02          	ld	a,(OFST+0,sp)
2921  0671 5f            	clrw	x
2922  0672 95            	ld	xh,a
2923  0673 cd00be        	call	_tm_displayCharacter
2927  0676 0c02          	inc	(OFST+0,sp)
2931  0678 7b02          	ld	a,(OFST+0,sp)
2932  067a a104          	cp	a,#4
2933  067c 25f1          	jrult	L3321
2934                     ; 428         delay_ms(200);
2936  067e ae00c8        	ldw	x,#200
2937  0681 cd0000        	call	_delay_ms
2939                     ; 424     for (k = 0; k < 2; k++) {
2941  0684 0c01          	inc	(OFST-1,sp)
2945  0686 7b01          	ld	a,(OFST-1,sp)
2946  0688 a102          	cp	a,#2
2947  068a 25c8          	jrult	L7121
2948                     ; 430 }
2951  068c 85            	popw	x
2952  068d 81            	ret
2955                     	switch	.const
2956  0022               L1421_userInput:
2957  0022 20            	dc.b	32
2958  0023 20            	dc.b	32
2959  0024 20            	dc.b	32
2960  0025 20            	dc.b	32
3085                     ; 433 void main(void) {
3086                     	switch	.text
3087  068e               _main:
3089  068e 5214          	subw	sp,#20
3090       00000014      OFST:	set	20
3093                     ; 434     char key = 0;
3095                     ; 435     char userInput[4] = {' ', ' ', ' ', ' '};
3097  0690 96            	ldw	x,sp
3098  0691 1c000f        	addw	x,#OFST-5
3099  0694 90ae0022      	ldw	y,#L1421_userInput
3100  0698 a604          	ld	a,#4
3101  069a cd0000        	call	c_xymov
3103                     ; 436     uint8_t index = 0;
3105  069d 0f13          	clr	(OFST-1,sp)
3107                     ; 438     uint8_t loggedIn = 0;
3109  069f 0f0d          	clr	(OFST-7,sp)
3111                     ; 439     uint32_t loginStartTime = 0;
3113  06a1 ae0000        	ldw	x,#0
3114  06a4 1f0b          	ldw	(OFST-9,sp),x
3115  06a6 ae0000        	ldw	x,#0
3116  06a9 1f09          	ldw	(OFST-11,sp),x
3118                     ; 440     const uint32_t LOGIN_TIMEOUT_MS = 5000;
3120  06ab ae1388        	ldw	x,#5000
3121  06ae 1f07          	ldw	(OFST-13,sp),x
3122  06b0 ae0000        	ldw	x,#0
3123  06b3 1f05          	ldw	(OFST-15,sp),x
3125                     ; 442     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
3127  06b5 4f            	clr	a
3128  06b6 cd0000        	call	_CLK_HSIPrescalerConfig
3130                     ; 444     GPIO_Init(TM_CLK_PORT, TM_CLK_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
3132  06b9 4be0          	push	#224
3133  06bb 4b20          	push	#32
3134  06bd ae5005        	ldw	x,#20485
3135  06c0 cd0000        	call	_GPIO_Init
3137  06c3 85            	popw	x
3138                     ; 445     GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
3140  06c4 4be0          	push	#224
3141  06c6 4b10          	push	#16
3142  06c8 ae5005        	ldw	x,#20485
3143  06cb cd0000        	call	_GPIO_Init
3145  06ce 85            	popw	x
3146                     ; 446     GPIO_Init(GPIOE, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT);
3148  06cf 4b00          	push	#0
3149  06d1 4b10          	push	#16
3150  06d3 ae5014        	ldw	x,#20500
3151  06d6 cd0000        	call	_GPIO_Init
3153  06d9 85            	popw	x
3154                     ; 449 		GPIO_Init(GPIOC, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_FAST); // èervená LED
3156  06da 4be0          	push	#224
3157  06dc 4b10          	push	#16
3158  06de ae500a        	ldw	x,#20490
3159  06e1 cd0000        	call	_GPIO_Init
3161  06e4 85            	popw	x
3162                     ; 450 		GPIO_Init(GPIOE, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST); // zelená LED
3164  06e5 4be0          	push	#224
3165  06e7 4b20          	push	#32
3166  06e9 ae5014        	ldw	x,#20500
3167  06ec cd0000        	call	_GPIO_Init
3169  06ef 85            	popw	x
3170                     ; 452     initKeypad();
3172  06f0 cd0103        	call	_initKeypad
3174                     ; 453     buzzerInit();
3176  06f3 cd0321        	call	_buzzerInit
3178                     ; 454     init_milis();
3180  06f6 cd0000        	call	_init_milis
3182                     ; 456     for (i = 0; i < 4; i++) {
3184  06f9 0f14          	clr	(OFST+0,sp)
3186  06fb               L1231:
3187                     ; 457         tm_displayCharacter(i, 0x00);
3189  06fb 7b14          	ld	a,(OFST+0,sp)
3190  06fd 5f            	clrw	x
3191  06fe 95            	ld	xh,a
3192  06ff cd00be        	call	_tm_displayCharacter
3194                     ; 456     for (i = 0; i < 4; i++) {
3196  0702 0c14          	inc	(OFST+0,sp)
3200  0704 7b14          	ld	a,(OFST+0,sp)
3201  0706 a104          	cp	a,#4
3202  0708 25f1          	jrult	L1231
3203                     ; 460     loadPINfromEEPROM();
3205  070a cd04a7        	call	_loadPINfromEEPROM
3207  070d               L7231:
3208                     ; 463         key = getKey();
3210  070d cd013b        	call	_getKey
3212  0710 6b0e          	ld	(OFST-6,sp),a
3214                     ; 467         if (GPIO_ReadInputPin(GPIOE, GPIO_PIN_4) == RESET) {
3216  0712 4b10          	push	#16
3217  0714 ae5014        	ldw	x,#20500
3218  0717 cd0000        	call	_GPIO_ReadInputPin
3220  071a 5b01          	addw	sp,#1
3221  071c 4d            	tnz	a
3222  071d 2634          	jrne	L3331
3223                     ; 468             factoryResetPIN();
3225  071f cd05a6        	call	_factoryResetPIN
3228  0722               L7331:
3229                     ; 469             while (GPIO_ReadInputPin(GPIOE, GPIO_PIN_4) == RESET);
3231  0722 4b10          	push	#16
3232  0724 ae5014        	ldw	x,#20500
3233  0727 cd0000        	call	_GPIO_ReadInputPin
3235  072a 5b01          	addw	sp,#1
3236  072c 4d            	tnz	a
3237  072d 27f3          	jreq	L7331
3238                     ; 470             index = 0;
3240  072f 0f13          	clr	(OFST-1,sp)
3242                     ; 471             for (i = 0; i < 4; i++) {
3244  0731 0f14          	clr	(OFST+0,sp)
3246  0733               L3431:
3247                     ; 472                 userInput[i] = ' ';
3249  0733 96            	ldw	x,sp
3250  0734 1c000f        	addw	x,#OFST-5
3251  0737 9f            	ld	a,xl
3252  0738 5e            	swapw	x
3253  0739 1b14          	add	a,(OFST+0,sp)
3254  073b 2401          	jrnc	L051
3255  073d 5c            	incw	x
3256  073e               L051:
3257  073e 02            	rlwa	x,a
3258  073f a620          	ld	a,#32
3259  0741 f7            	ld	(x),a
3260                     ; 473                 tm_displayCharacter(i, 0x00);
3262  0742 7b14          	ld	a,(OFST+0,sp)
3263  0744 5f            	clrw	x
3264  0745 95            	ld	xh,a
3265  0746 cd00be        	call	_tm_displayCharacter
3267                     ; 471             for (i = 0; i < 4; i++) {
3269  0749 0c14          	inc	(OFST+0,sp)
3273  074b 7b14          	ld	a,(OFST+0,sp)
3274  074d a104          	cp	a,#4
3275  074f 25e2          	jrult	L3431
3276                     ; 475             loggedIn = 0;
3278  0751 0f0d          	clr	(OFST-7,sp)
3280  0753               L3331:
3281                     ; 479 					if (loggedIn) {
3283  0753 0d0d          	tnz	(OFST-7,sp)
3284  0755 274b          	jreq	L1531
3285                     ; 480 							uint32_t now = milis();
3287  0757 cd0000        	call	_milis
3289  075a cd0000        	call	c_uitolx
3291  075d 96            	ldw	x,sp
3292  075e 1c0001        	addw	x,#OFST-19
3293  0761 cd0000        	call	c_rtol
3296                     ; 481 							if ((now - loginStartTime) >= LOGIN_TIMEOUT_MS) {
3298  0764 96            	ldw	x,sp
3299  0765 1c0001        	addw	x,#OFST-19
3300  0768 cd0000        	call	c_ltor
3302  076b 96            	ldw	x,sp
3303  076c 1c0009        	addw	x,#OFST-11
3304  076f cd0000        	call	c_lsub
3306  0772 96            	ldw	x,sp
3307  0773 1c0005        	addw	x,#OFST-15
3308  0776 cd0000        	call	c_lcmp
3310  0779 2527          	jrult	L1531
3311                     ; 482 									logoutSignal();
3313  077b cd060e        	call	_logoutSignal
3315                     ; 484 									loggedIn = 0;
3317  077e 0f0d          	clr	(OFST-7,sp)
3319                     ; 485 									index = 0;
3321  0780 0f13          	clr	(OFST-1,sp)
3323                     ; 486 									for ( i = 0; i < 4; i++) {
3325  0782 0f14          	clr	(OFST+0,sp)
3327  0784               L5531:
3328                     ; 487 											userInput[i] = ' ';
3330  0784 96            	ldw	x,sp
3331  0785 1c000f        	addw	x,#OFST-5
3332  0788 9f            	ld	a,xl
3333  0789 5e            	swapw	x
3334  078a 1b14          	add	a,(OFST+0,sp)
3335  078c 2401          	jrnc	L251
3336  078e 5c            	incw	x
3337  078f               L251:
3338  078f 02            	rlwa	x,a
3339  0790 a620          	ld	a,#32
3340  0792 f7            	ld	(x),a
3341                     ; 488 											tm_displayCharacter(i, 0x00);
3343  0793 7b14          	ld	a,(OFST+0,sp)
3344  0795 5f            	clrw	x
3345  0796 95            	ld	xh,a
3346  0797 cd00be        	call	_tm_displayCharacter
3348                     ; 486 									for ( i = 0; i < 4; i++) {
3350  079a 0c14          	inc	(OFST+0,sp)
3354  079c 7b14          	ld	a,(OFST+0,sp)
3355  079e a104          	cp	a,#4
3356  07a0 25e2          	jrult	L5531
3357  07a2               L1531:
3358                     ; 493         if (key != 0) {
3360  07a2 0d0e          	tnz	(OFST-6,sp)
3361  07a4 2603          	jrne	L661
3362  07a6 cc070d        	jp	L7231
3363  07a9               L661:
3364                     ; 494             if (key >= '0' && key <= '9') {
3366  07a9 7b0e          	ld	a,(OFST-6,sp)
3367  07ab a130          	cp	a,#48
3368  07ad 2403          	jruge	L071
3369  07af cc0853        	jp	L5631
3370  07b2               L071:
3372  07b2 7b0e          	ld	a,(OFST-6,sp)
3373  07b4 a13a          	cp	a,#58
3374  07b6 2503          	jrult	L271
3375  07b8 cc0853        	jp	L5631
3376  07bb               L271:
3377                     ; 495                 if (index < 4) {
3379  07bb 7b13          	ld	a,(OFST-1,sp)
3380  07bd a104          	cp	a,#4
3381  07bf 2503          	jrult	L471
3382  07c1 cc070d        	jp	L7231
3383  07c4               L471:
3384                     ; 496                     userInput[index] = key;
3386  07c4 96            	ldw	x,sp
3387  07c5 1c000f        	addw	x,#OFST-5
3388  07c8 9f            	ld	a,xl
3389  07c9 5e            	swapw	x
3390  07ca 1b13          	add	a,(OFST-1,sp)
3391  07cc 2401          	jrnc	L451
3392  07ce 5c            	incw	x
3393  07cf               L451:
3394  07cf 02            	rlwa	x,a
3395  07d0 7b0e          	ld	a,(OFST-6,sp)
3396  07d2 f7            	ld	(x),a
3397                     ; 497                     tm_displayCharacter(index, digitToSegment[key - '0']);
3399  07d3 7b0e          	ld	a,(OFST-6,sp)
3400  07d5 5f            	clrw	x
3401  07d6 97            	ld	xl,a
3402  07d7 1d0030        	subw	x,#48
3403  07da d60004        	ld	a,(_digitToSegment,x)
3404  07dd 97            	ld	xl,a
3405  07de 7b13          	ld	a,(OFST-1,sp)
3406  07e0 95            	ld	xh,a
3407  07e1 cd00be        	call	_tm_displayCharacter
3409                     ; 498                     index++;
3411  07e4 0c13          	inc	(OFST-1,sp)
3413                     ; 500                     if (index == 4) {
3415  07e6 7b13          	ld	a,(OFST-1,sp)
3416  07e8 a104          	cp	a,#4
3417  07ea 2703          	jreq	L671
3418  07ec cc070d        	jp	L7231
3419  07ef               L671:
3420                     ; 502                         if (!loggedIn) {
3422  07ef 0d0d          	tnz	(OFST-7,sp)
3423  07f1 2703          	jreq	L002
3424  07f3 cc070d        	jp	L7231
3425  07f6               L002:
3426                     ; 504                             if (comparePIN(userInput, storedPIN)) {
3428  07f6 ae0000        	ldw	x,#_storedPIN
3429  07f9 89            	pushw	x
3430  07fa 96            	ldw	x,sp
3431  07fb 1c0011        	addw	x,#OFST-3
3432  07fe cd053c        	call	_comparePIN
3434  0801 85            	popw	x
3435  0802 4d            	tnz	a
3436  0803 2716          	jreq	L5731
3437                     ; 505 																beepSuccess();
3439  0805 cd0421        	call	_beepSuccess
3441                     ; 506 																loggedIn = 1;
3443  0808 a601          	ld	a,#1
3444  080a 6b0d          	ld	(OFST-7,sp),a
3446                     ; 507                                 loginStartTime = milis();
3448  080c cd0000        	call	_milis
3450  080f cd0000        	call	c_uitolx
3452  0812 96            	ldw	x,sp
3453  0813 1c0009        	addw	x,#OFST-11
3454  0816 cd0000        	call	c_rtol
3458  0819 2012          	jra	L7731
3459  081b               L5731:
3460                     ; 509                                 beepFail();
3462  081b cd0479        	call	_beepFail
3464                     ; 510 																blinkLED(1, 'r');
3466  081e ae0172        	ldw	x,#370
3467  0821 cd05b4        	call	_blinkLED
3469                     ; 511 																beepFail();
3471  0824 cd0479        	call	_beepFail
3473                     ; 512 																blinkLED(1, 'r');
3475  0827 ae0172        	ldw	x,#370
3476  082a cd05b4        	call	_blinkLED
3478  082d               L7731:
3479                     ; 515                             index = 0;
3481  082d 0f13          	clr	(OFST-1,sp)
3483                     ; 516                             for (j = 0; j < 4; j++) {
3485  082f 0f14          	clr	(OFST+0,sp)
3487  0831               L1041:
3488                     ; 517                                 userInput[j] = ' ';
3490  0831 96            	ldw	x,sp
3491  0832 1c000f        	addw	x,#OFST-5
3492  0835 9f            	ld	a,xl
3493  0836 5e            	swapw	x
3494  0837 1b14          	add	a,(OFST+0,sp)
3495  0839 2401          	jrnc	L651
3496  083b 5c            	incw	x
3497  083c               L651:
3498  083c 02            	rlwa	x,a
3499  083d a620          	ld	a,#32
3500  083f f7            	ld	(x),a
3501                     ; 518                                 tm_displayCharacter(j, 0x00);
3503  0840 7b14          	ld	a,(OFST+0,sp)
3504  0842 5f            	clrw	x
3505  0843 95            	ld	xh,a
3506  0844 cd00be        	call	_tm_displayCharacter
3508                     ; 516                             for (j = 0; j < 4; j++) {
3510  0847 0c14          	inc	(OFST+0,sp)
3514  0849 7b14          	ld	a,(OFST+0,sp)
3515  084b a104          	cp	a,#4
3516  084d 25e2          	jrult	L1041
3517  084f ac0d070d      	jpf	L7231
3518  0853               L5631:
3519                     ; 523             } else if (key == '*') {
3521  0853 7b0e          	ld	a,(OFST-6,sp)
3522  0855 a12a          	cp	a,#42
3523  0857 2623          	jrne	L1141
3524                     ; 525                 if (index > 0) {
3526  0859 0d13          	tnz	(OFST-1,sp)
3527  085b 2603          	jrne	L202
3528  085d cc070d        	jp	L7231
3529  0860               L202:
3530                     ; 526                     index--;
3532  0860 0a13          	dec	(OFST-1,sp)
3534                     ; 527                     userInput[index] = ' ';
3536  0862 96            	ldw	x,sp
3537  0863 1c000f        	addw	x,#OFST-5
3538  0866 9f            	ld	a,xl
3539  0867 5e            	swapw	x
3540  0868 1b13          	add	a,(OFST-1,sp)
3541  086a 2401          	jrnc	L061
3542  086c 5c            	incw	x
3543  086d               L061:
3544  086d 02            	rlwa	x,a
3545  086e a620          	ld	a,#32
3546  0870 f7            	ld	(x),a
3547                     ; 528                     tm_displayCharacter(index, 0x00);
3549  0871 7b13          	ld	a,(OFST-1,sp)
3550  0873 5f            	clrw	x
3551  0874 95            	ld	xh,a
3552  0875 cd00be        	call	_tm_displayCharacter
3554  0878 ac0d070d      	jpf	L7231
3555  087c               L1141:
3556                     ; 530             } else if (key == '#') {
3558  087c 7b0e          	ld	a,(OFST-6,sp)
3559  087e a123          	cp	a,#35
3560  0880 2703          	jreq	L402
3561  0882 cc070d        	jp	L7231
3562  0885               L402:
3563                     ; 532                 if (loggedIn && index == 4) {
3565  0885 0d0d          	tnz	(OFST-7,sp)
3566  0887 2603          	jrne	L602
3567  0889 cc070d        	jp	L7231
3568  088c               L602:
3570  088c 7b13          	ld	a,(OFST-1,sp)
3571  088e a104          	cp	a,#4
3572  0890 2703          	jreq	L012
3573  0892 cc070d        	jp	L7231
3574  0895               L012:
3575                     ; 533                     savePINtoEEPROM(userInput);
3577  0895 96            	ldw	x,sp
3578  0896 1c000f        	addw	x,#OFST-5
3579  0899 cd0508        	call	_savePINtoEEPROM
3581                     ; 534                     blinkDisplay(2);  
3583  089c a602          	ld	a,#2
3584  089e cd0565        	call	_blinkDisplay
3586                     ; 537                     for (j = 0; j < 4; j++) {
3588  08a1 0f14          	clr	(OFST+0,sp)
3590  08a3               L3241:
3591                     ; 538                         storedPIN[j] = userInput[j];
3593  08a3 7b14          	ld	a,(OFST+0,sp)
3594  08a5 5f            	clrw	x
3595  08a6 97            	ld	xl,a
3596  08a7 89            	pushw	x
3597  08a8 96            	ldw	x,sp
3598  08a9 1c0011        	addw	x,#OFST-3
3599  08ac 9f            	ld	a,xl
3600  08ad 5e            	swapw	x
3601  08ae 1b16          	add	a,(OFST+2,sp)
3602  08b0 2401          	jrnc	L261
3603  08b2 5c            	incw	x
3604  08b3               L261:
3605  08b3 02            	rlwa	x,a
3606  08b4 f6            	ld	a,(x)
3607  08b5 85            	popw	x
3608  08b6 e700          	ld	(_storedPIN,x),a
3609                     ; 537                     for (j = 0; j < 4; j++) {
3611  08b8 0c14          	inc	(OFST+0,sp)
3615  08ba 7b14          	ld	a,(OFST+0,sp)
3616  08bc a104          	cp	a,#4
3617  08be 25e3          	jrult	L3241
3618                     ; 542                     loggedIn = 0;
3620  08c0 0f0d          	clr	(OFST-7,sp)
3622                     ; 543                     index = 0;
3624  08c2 0f13          	clr	(OFST-1,sp)
3626                     ; 544 										blinkLED(2, '');
3628  08c4 ae0200        	ldw	x,#512
3629  08c7 cd05b4        	call	_blinkLED
3631                     ; 545                     for (j = 0; j < 4; j++) {
3633  08ca 0f14          	clr	(OFST+0,sp)
3635  08cc               L1341:
3636                     ; 546                         userInput[j] = ' ';
3638  08cc 96            	ldw	x,sp
3639  08cd 1c000f        	addw	x,#OFST-5
3640  08d0 9f            	ld	a,xl
3641  08d1 5e            	swapw	x
3642  08d2 1b14          	add	a,(OFST+0,sp)
3643  08d4 2401          	jrnc	L461
3644  08d6 5c            	incw	x
3645  08d7               L461:
3646  08d7 02            	rlwa	x,a
3647  08d8 a620          	ld	a,#32
3648  08da f7            	ld	(x),a
3649                     ; 547                         tm_displayCharacter(j, 0x00);
3651  08db 7b14          	ld	a,(OFST+0,sp)
3652  08dd 5f            	clrw	x
3653  08de 95            	ld	xh,a
3654  08df cd00be        	call	_tm_displayCharacter
3656                     ; 545                     for (j = 0; j < 4; j++) {
3658  08e2 0c14          	inc	(OFST+0,sp)
3662  08e4 7b14          	ld	a,(OFST+0,sp)
3663  08e6 a104          	cp	a,#4
3664  08e8 25e2          	jrult	L1341
3665  08ea ac0d070d      	jpf	L7231
3700                     ; 560 void assert_failed(uint8_t* file, uint32_t line) {
3701                     	switch	.text
3702  08ee               _assert_failed:
3706  08ee               L5541:
3707                     ; 561     while (1);
3709  08ee 20fe          	jra	L5541
3754                     	xdef	_main
3755                     	xdef	_logoutSignal
3756                     	xdef	_factoryResetPIN
3757                     	xdef	_blinkDisplay
3758                     	xdef	_comparePIN
3759                     	xdef	_savePINtoEEPROM
3760                     	xdef	_loadPINfromEEPROM
3761                     	xdef	_EEPROM_WriteByte
3762                     	xdef	_EEPROM_ReadByte
3763                     	xdef	_digitToSegment
3764                     	xdef	_beepAndBlink
3765                     	xdef	_blinkLED
3766                     	xdef	_beepTone
3767                     	xdef	_beepFail
3768                     	xdef	_beepSuccess
3769                     	xdef	_buzzerInit
3770                     	xdef	_getKey
3771                     	xdef	_initKeypad
3772                     	xdef	_delay_us
3773                     	xdef	_tm_displayCharacter
3774                     	xdef	_tm_writeByte
3775                     	xdef	_tm_stop
3776                     	xdef	_tm_start
3777                     	xdef	_setCLK
3778                     	xdef	_setDIO
3779                     	switch	.ubsct
3780  0000               _storedPIN:
3781  0000 00000000      	ds.b	4
3782                     	xdef	_storedPIN
3783                     	xdef	_defaultPIN
3784                     	xref	_init_milis
3785                     	xref	_delay_ms
3786                     	xref	_milis
3787                     	xdef	_assert_failed
3788                     	xref	_GPIO_ReadInputPin
3789                     	xref	_GPIO_WriteLow
3790                     	xref	_GPIO_WriteHigh
3791                     	xref	_GPIO_Init
3792                     	xref	_FLASH_ProgramByte
3793                     	xref	_FLASH_Lock
3794                     	xref	_FLASH_Unlock
3795                     	xref	_CLK_HSIPrescalerConfig
3796                     	xref.b	c_lreg
3797                     	xref.b	c_x
3798                     	xref.b	c_y
3818                     	xref	c_lsub
3819                     	xref	c_ludv
3820                     	xref	c_umul
3821                     	xref	c_ldiv
3822                     	xref	c_rtol
3823                     	xref	c_uitolx
3824                     	xref	c_bmulx
3825                     	xref	c_lcmp
3826                     	xref	c_ltor
3827                     	xref	c_lgadc
3828                     	xref	c_xymov
3829                     	end
