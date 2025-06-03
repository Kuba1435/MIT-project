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
1637                     ; 270 void beepSuccess(void) {
1638                     	switch	.text
1639  03b4               _beepSuccess:
1641  03b4 5209          	subw	sp,#9
1642       00000009      OFST:	set	9
1645                     ; 271     uint16_t freq = 3000;
1647  03b6 ae0bb8        	ldw	x,#3000
1648  03b9 1f01          	ldw	(OFST-8,sp),x
1650                     ; 272     uint16_t totalDuration = 300;  
1652  03bb ae012c        	ldw	x,#300
1653  03be 1f03          	ldw	(OFST-6,sp),x
1655                     ; 273     uint16_t chunkDuration = 50;   
1657  03c0 ae0032        	ldw	x,#50
1658  03c3 1f05          	ldw	(OFST-4,sp),x
1660                     ; 274     uint16_t elapsed = 0;
1662  03c5 5f            	clrw	x
1663  03c6 1f07          	ldw	(OFST-2,sp),x
1665                     ; 275     uint8_t ledOn = 0;
1667  03c8 0f09          	clr	(OFST+0,sp)
1670  03ca 202e          	jra	L545
1671  03cc               L145:
1672                     ; 278         if (ledOn) {
1674  03cc 0d09          	tnz	(OFST+0,sp)
1675  03ce 270d          	jreq	L155
1676                     ; 279             GPIO_WriteLow(GPIOE, GPIO_PIN_5);
1678  03d0 4b20          	push	#32
1679  03d2 ae5014        	ldw	x,#20500
1680  03d5 cd0000        	call	_GPIO_WriteLow
1682  03d8 84            	pop	a
1683                     ; 280             ledOn = 0;
1685  03d9 0f09          	clr	(OFST+0,sp)
1688  03db 200d          	jra	L355
1689  03dd               L155:
1690                     ; 282             GPIO_WriteHigh(GPIOE, GPIO_PIN_5);
1692  03dd 4b20          	push	#32
1693  03df ae5014        	ldw	x,#20500
1694  03e2 cd0000        	call	_GPIO_WriteHigh
1696  03e5 84            	pop	a
1697                     ; 283             ledOn = 1;
1699  03e6 a601          	ld	a,#1
1700  03e8 6b09          	ld	(OFST+0,sp),a
1702  03ea               L355:
1703                     ; 287         beepTone(freq, chunkDuration);
1705  03ea 1e05          	ldw	x,(OFST-4,sp)
1706  03ec 89            	pushw	x
1707  03ed 1e03          	ldw	x,(OFST-6,sp)
1708  03ef cd0336        	call	_beepTone
1710  03f2 85            	popw	x
1711                     ; 289         elapsed += chunkDuration;
1713  03f3 1e07          	ldw	x,(OFST-2,sp)
1714  03f5 72fb05        	addw	x,(OFST-4,sp)
1715  03f8 1f07          	ldw	(OFST-2,sp),x
1717  03fa               L545:
1718                     ; 277     while (elapsed < totalDuration) {
1720  03fa 1e07          	ldw	x,(OFST-2,sp)
1721  03fc 1303          	cpw	x,(OFST-6,sp)
1722  03fe 25cc          	jrult	L145
1723                     ; 293     GPIO_WriteLow(GPIOC, GPIO_PIN_4);
1725  0400 4b10          	push	#16
1726  0402 ae500a        	ldw	x,#20490
1727  0405 cd0000        	call	_GPIO_WriteLow
1729  0408 84            	pop	a
1730                     ; 294 }
1733  0409 5b09          	addw	sp,#9
1734  040b 81            	ret
1758                     ; 296 void beepFail(void) {
1759                     	switch	.text
1760  040c               _beepFail:
1764                     ; 297     beepTone(500, 100);
1766  040c ae0064        	ldw	x,#100
1767  040f 89            	pushw	x
1768  0410 ae01f4        	ldw	x,#500
1769  0413 cd0336        	call	_beepTone
1771  0416 85            	popw	x
1772                     ; 298 }
1775  0417 81            	ret
1809                     ; 301 uint8_t EEPROM_ReadByte(uint16_t addr) {
1810                     	switch	.text
1811  0418               _EEPROM_ReadByte:
1815                     ; 303     return *((uint8_t*)addr);
1817  0418 f6            	ld	a,(x)
1820  0419 81            	ret
1866                     ; 307 void EEPROM_WriteByte(uint16_t addr, uint8_t data) {
1867                     	switch	.text
1868  041a               _EEPROM_WriteByte:
1870  041a 89            	pushw	x
1871       00000000      OFST:	set	0
1874                     ; 309     FLASH_Unlock(FLASH_MEMTYPE_DATA);
1876  041b a6f7          	ld	a,#247
1877  041d cd0000        	call	_FLASH_Unlock
1879                     ; 310     FLASH_ProgramByte(addr, data);
1881  0420 7b05          	ld	a,(OFST+5,sp)
1882  0422 88            	push	a
1883  0423 1e02          	ldw	x,(OFST+2,sp)
1884  0425 cd0000        	call	c_uitolx
1886  0428 be02          	ldw	x,c_lreg+2
1887  042a 89            	pushw	x
1888  042b be00          	ldw	x,c_lreg
1889  042d 89            	pushw	x
1890  042e cd0000        	call	_FLASH_ProgramByte
1892  0431 5b05          	addw	sp,#5
1893                     ; 311     FLASH_Lock(FLASH_MEMTYPE_DATA);
1895  0433 a6f7          	ld	a,#247
1896  0435 cd0000        	call	_FLASH_Lock
1898                     ; 312 }
1901  0438 85            	popw	x
1902  0439 81            	ret
1949                     ; 315 void loadPINfromEEPROM(void) {
1950                     	switch	.text
1951  043a               _loadPINfromEEPROM:
1953  043a 89            	pushw	x
1954       00000002      OFST:	set	2
1957                     ; 317     uint8_t valid = 1;
1959  043b a601          	ld	a,#1
1960  043d 6b01          	ld	(OFST-1,sp),a
1962                     ; 318     for (i = 0; i < 4; i++) {
1964  043f 0f02          	clr	(OFST+0,sp)
1966  0441               L746:
1967                     ; 319         storedPIN[i] = EEPROM_ReadByte(EEPROM_PIN_ADDR + i);
1969  0441 7b02          	ld	a,(OFST+0,sp)
1970  0443 5f            	clrw	x
1971  0444 97            	ld	xl,a
1972  0445 89            	pushw	x
1973  0446 7b04          	ld	a,(OFST+2,sp)
1974  0448 5f            	clrw	x
1975  0449 97            	ld	xl,a
1976  044a 1c4000        	addw	x,#16384
1977  044d adc9          	call	_EEPROM_ReadByte
1979  044f 85            	popw	x
1980  0450 e700          	ld	(_storedPIN,x),a
1981                     ; 321         if (storedPIN[i] < '0' || storedPIN[i] > '9') {
1983  0452 7b02          	ld	a,(OFST+0,sp)
1984  0454 5f            	clrw	x
1985  0455 97            	ld	xl,a
1986  0456 e600          	ld	a,(_storedPIN,x)
1987  0458 a130          	cp	a,#48
1988  045a 250a          	jrult	L756
1990  045c 7b02          	ld	a,(OFST+0,sp)
1991  045e 5f            	clrw	x
1992  045f 97            	ld	xl,a
1993  0460 e600          	ld	a,(_storedPIN,x)
1994  0462 a13a          	cp	a,#58
1995  0464 2502          	jrult	L556
1996  0466               L756:
1997                     ; 322             valid = 0;
1999  0466 0f01          	clr	(OFST-1,sp)
2001  0468               L556:
2002                     ; 318     for (i = 0; i < 4; i++) {
2004  0468 0c02          	inc	(OFST+0,sp)
2008  046a 7b02          	ld	a,(OFST+0,sp)
2009  046c a104          	cp	a,#4
2010  046e 25d1          	jrult	L746
2011                     ; 325     if (!valid) {
2013  0470 0d01          	tnz	(OFST-1,sp)
2014  0472 2625          	jrne	L166
2015                     ; 327         for (i = 0; i < 4; i++) {
2017  0474 0f02          	clr	(OFST+0,sp)
2019  0476               L366:
2020                     ; 328             storedPIN[i] = defaultPIN[i];
2022  0476 7b02          	ld	a,(OFST+0,sp)
2023  0478 5f            	clrw	x
2024  0479 97            	ld	xl,a
2025  047a d60000        	ld	a,(_defaultPIN,x)
2026  047d e700          	ld	(_storedPIN,x),a
2027                     ; 329             EEPROM_WriteByte(EEPROM_PIN_ADDR + i, defaultPIN[i]);
2029  047f 7b02          	ld	a,(OFST+0,sp)
2030  0481 5f            	clrw	x
2031  0482 97            	ld	xl,a
2032  0483 d60000        	ld	a,(_defaultPIN,x)
2033  0486 88            	push	a
2034  0487 7b03          	ld	a,(OFST+1,sp)
2035  0489 5f            	clrw	x
2036  048a 97            	ld	xl,a
2037  048b 1c4000        	addw	x,#16384
2038  048e ad8a          	call	_EEPROM_WriteByte
2040  0490 84            	pop	a
2041                     ; 327         for (i = 0; i < 4; i++) {
2043  0491 0c02          	inc	(OFST+0,sp)
2047  0493 7b02          	ld	a,(OFST+0,sp)
2048  0495 a104          	cp	a,#4
2049  0497 25dd          	jrult	L366
2050  0499               L166:
2051                     ; 332 }
2054  0499 85            	popw	x
2055  049a 81            	ret
2101                     ; 335 void savePINtoEEPROM(const char* newPIN) {
2102                     	switch	.text
2103  049b               _savePINtoEEPROM:
2105  049b 89            	pushw	x
2106  049c 88            	push	a
2107       00000001      OFST:	set	1
2110                     ; 337     for (i = 0; i < 4; i++) {
2112  049d 0f01          	clr	(OFST+0,sp)
2114  049f               L317:
2115                     ; 338         storedPIN[i] = newPIN[i];
2117  049f 7b01          	ld	a,(OFST+0,sp)
2118  04a1 5f            	clrw	x
2119  04a2 97            	ld	xl,a
2120  04a3 7b01          	ld	a,(OFST+0,sp)
2121  04a5 905f          	clrw	y
2122  04a7 9097          	ld	yl,a
2123  04a9 72f902        	addw	y,(OFST+1,sp)
2124  04ac 90f6          	ld	a,(y)
2125  04ae e700          	ld	(_storedPIN,x),a
2126                     ; 339         EEPROM_WriteByte(EEPROM_PIN_ADDR + i, newPIN[i]);
2128  04b0 7b01          	ld	a,(OFST+0,sp)
2129  04b2 5f            	clrw	x
2130  04b3 97            	ld	xl,a
2131  04b4 72fb02        	addw	x,(OFST+1,sp)
2132  04b7 f6            	ld	a,(x)
2133  04b8 88            	push	a
2134  04b9 7b02          	ld	a,(OFST+1,sp)
2135  04bb 5f            	clrw	x
2136  04bc 97            	ld	xl,a
2137  04bd 1c4000        	addw	x,#16384
2138  04c0 cd041a        	call	_EEPROM_WriteByte
2140  04c3 84            	pop	a
2141                     ; 337     for (i = 0; i < 4; i++) {
2143  04c4 0c01          	inc	(OFST+0,sp)
2147  04c6 7b01          	ld	a,(OFST+0,sp)
2148  04c8 a104          	cp	a,#4
2149  04ca 25d3          	jrult	L317
2150                     ; 341 }
2153  04cc 5b03          	addw	sp,#3
2154  04ce 81            	ret
2208                     ; 344 uint8_t comparePIN(const char* a, const char* b) {
2209                     	switch	.text
2210  04cf               _comparePIN:
2212  04cf 89            	pushw	x
2213  04d0 88            	push	a
2214       00000001      OFST:	set	1
2217                     ; 346     for (i = 0; i < 4; i++) {
2219  04d1 0f01          	clr	(OFST+0,sp)
2221  04d3               L747:
2222                     ; 347         if (a[i] != b[i]) return 0;
2224  04d3 7b01          	ld	a,(OFST+0,sp)
2225  04d5 5f            	clrw	x
2226  04d6 97            	ld	xl,a
2227  04d7 72fb06        	addw	x,(OFST+5,sp)
2228  04da 7b01          	ld	a,(OFST+0,sp)
2229  04dc 905f          	clrw	y
2230  04de 9097          	ld	yl,a
2231  04e0 72f902        	addw	y,(OFST+1,sp)
2232  04e3 90f6          	ld	a,(y)
2233  04e5 f1            	cp	a,(x)
2234  04e6 2703          	jreq	L557
2237  04e8 4f            	clr	a
2239  04e9 200a          	jra	L231
2240  04eb               L557:
2241                     ; 346     for (i = 0; i < 4; i++) {
2243  04eb 0c01          	inc	(OFST+0,sp)
2247  04ed 7b01          	ld	a,(OFST+0,sp)
2248  04ef a104          	cp	a,#4
2249  04f1 25e0          	jrult	L747
2250                     ; 349     return 1;
2252  04f3 a601          	ld	a,#1
2254  04f5               L231:
2256  04f5 5b03          	addw	sp,#3
2257  04f7 81            	ret
2311                     ; 353 void blinkDisplay(uint8_t times) {
2312                     	switch	.text
2313  04f8               _blinkDisplay:
2315  04f8 88            	push	a
2316  04f9 89            	pushw	x
2317       00000002      OFST:	set	2
2320                     ; 355     for (i = 0; i < times; i++) {
2322  04fa 0f01          	clr	(OFST-1,sp)
2325  04fc 2032          	jra	L1101
2326  04fe               L5001:
2327                     ; 356         for (j = 0; j < 4; j++) {
2329  04fe 0f02          	clr	(OFST+0,sp)
2331  0500               L5101:
2332                     ; 357             tm_displayCharacter(j, 0x7F); 
2334  0500 7b02          	ld	a,(OFST+0,sp)
2335  0502 ae007f        	ldw	x,#127
2336  0505 95            	ld	xh,a
2337  0506 cd00be        	call	_tm_displayCharacter
2339                     ; 356         for (j = 0; j < 4; j++) {
2341  0509 0c02          	inc	(OFST+0,sp)
2345  050b 7b02          	ld	a,(OFST+0,sp)
2346  050d a104          	cp	a,#4
2347  050f 25ef          	jrult	L5101
2348                     ; 359         delay_us(300000); 
2350  0511 ae93e0        	ldw	x,#37856
2351  0514 cd00e4        	call	_delay_us
2353                     ; 361         for (j = 0; j < 4; j++) {
2355  0517 0f02          	clr	(OFST+0,sp)
2357  0519               L3201:
2358                     ; 362             tm_displayCharacter(j, 0x00);
2360  0519 7b02          	ld	a,(OFST+0,sp)
2361  051b 5f            	clrw	x
2362  051c 95            	ld	xh,a
2363  051d cd00be        	call	_tm_displayCharacter
2365                     ; 361         for (j = 0; j < 4; j++) {
2367  0520 0c02          	inc	(OFST+0,sp)
2371  0522 7b02          	ld	a,(OFST+0,sp)
2372  0524 a104          	cp	a,#4
2373  0526 25f1          	jrult	L3201
2374                     ; 364         delay_us(300000);
2376  0528 ae93e0        	ldw	x,#37856
2377  052b cd00e4        	call	_delay_us
2379                     ; 355     for (i = 0; i < times; i++) {
2381  052e 0c01          	inc	(OFST-1,sp)
2383  0530               L1101:
2386  0530 7b01          	ld	a,(OFST-1,sp)
2387  0532 1103          	cp	a,(OFST+1,sp)
2388  0534 25c8          	jrult	L5001
2389                     ; 366 }
2392  0536 5b03          	addw	sp,#3
2393  0538 81            	ret
2420                     ; 370 void factoryResetPIN(void) {
2421                     	switch	.text
2422  0539               _factoryResetPIN:
2426                     ; 371     savePINtoEEPROM(defaultPIN);
2428  0539 ae0000        	ldw	x,#_defaultPIN
2429  053c cd049b        	call	_savePINtoEEPROM
2431                     ; 372     beepSuccess();
2433  053f cd03b4        	call	_beepSuccess
2435                     ; 373     blinkDisplay(2); 
2437  0542 a602          	ld	a,#2
2438  0544 adb2          	call	_blinkDisplay
2440                     ; 374 }
2443  0546 81            	ret
2498                     ; 376 void blinkLED(uint8_t times, char color){
2499                     	switch	.text
2500  0547               _blinkLED:
2502  0547 89            	pushw	x
2503  0548 88            	push	a
2504       00000001      OFST:	set	1
2507                     ; 378 			if (color == 'r'){
2509  0549 9f            	ld	a,xl
2510  054a a172          	cp	a,#114
2511  054c 2627          	jrne	L7601
2512                     ; 379 				for (i = 0; i < times; i++) {
2514  054e 0f01          	clr	(OFST+0,sp)
2517  0550 201a          	jra	L5701
2518  0552               L1701:
2519                     ; 380 					GPIO_WriteHigh(GPIOC, GPIO_PIN_4); 
2521  0552 4b10          	push	#16
2522  0554 ae500a        	ldw	x,#20490
2523  0557 cd0000        	call	_GPIO_WriteHigh
2525  055a 84            	pop	a
2526                     ; 381 					delay_ms(250);
2528  055b ae00fa        	ldw	x,#250
2529  055e cd0000        	call	_delay_ms
2531                     ; 382 					GPIO_WriteLow(GPIOC, GPIO_PIN_4);  
2533  0561 4b10          	push	#16
2534  0563 ae500a        	ldw	x,#20490
2535  0566 cd0000        	call	_GPIO_WriteLow
2537  0569 84            	pop	a
2538                     ; 379 				for (i = 0; i < times; i++) {
2540  056a 0c01          	inc	(OFST+0,sp)
2542  056c               L5701:
2545  056c 7b01          	ld	a,(OFST+0,sp)
2546  056e 1102          	cp	a,(OFST+1,sp)
2547  0570 25e0          	jrult	L1701
2549  0572               L1011:
2550                     ; 394 }
2553  0572 5b03          	addw	sp,#3
2554  0574 81            	ret
2555  0575               L7601:
2556                     ; 386 					for (i = 0; i < times; i++) {
2558  0575 0f01          	clr	(OFST+0,sp)
2561  0577 2020          	jra	L7011
2562  0579               L3011:
2563                     ; 387 						GPIO_WriteHigh(GPIOE, GPIO_PIN_5);
2565  0579 4b20          	push	#32
2566  057b ae5014        	ldw	x,#20500
2567  057e cd0000        	call	_GPIO_WriteHigh
2569  0581 84            	pop	a
2570                     ; 388 						delay_ms(500);
2572  0582 ae01f4        	ldw	x,#500
2573  0585 cd0000        	call	_delay_ms
2575                     ; 389 						GPIO_WriteLow(GPIOE, GPIO_PIN_5);
2577  0588 4b20          	push	#32
2578  058a ae5014        	ldw	x,#20500
2579  058d cd0000        	call	_GPIO_WriteLow
2581  0590 84            	pop	a
2582                     ; 390 						delay_ms(500);
2584  0591 ae01f4        	ldw	x,#500
2585  0594 cd0000        	call	_delay_ms
2587                     ; 386 					for (i = 0; i < times; i++) {
2589  0597 0c01          	inc	(OFST+0,sp)
2591  0599               L7011:
2594  0599 7b01          	ld	a,(OFST+0,sp)
2595  059b 1102          	cp	a,(OFST+1,sp)
2596  059d 25da          	jrult	L3011
2597  059f 20d1          	jra	L1011
2654                     ; 397 void logoutSignal(void) {
2655                     	switch	.text
2656  05a1               _logoutSignal:
2658  05a1 89            	pushw	x
2659       00000002      OFST:	set	2
2662                     ; 402     for (i = 0; i < 2; i++) {
2664  05a2 0f02          	clr	(OFST+0,sp)
2666  05a4               L1411:
2667                     ; 403         beepTone(1000, 100);
2669  05a4 ae0064        	ldw	x,#100
2670  05a7 89            	pushw	x
2671  05a8 ae03e8        	ldw	x,#1000
2672  05ab cd0336        	call	_beepTone
2674  05ae 85            	popw	x
2675                     ; 404         delay_ms(100);
2677  05af ae0064        	ldw	x,#100
2678  05b2 cd0000        	call	_delay_ms
2680                     ; 402     for (i = 0; i < 2; i++) {
2682  05b5 0c02          	inc	(OFST+0,sp)
2686  05b7 7b02          	ld	a,(OFST+0,sp)
2687  05b9 a102          	cp	a,#2
2688  05bb 25e7          	jrult	L1411
2689                     ; 407     for (i = 0; i < 2; i++) {
2691  05bd 0f02          	clr	(OFST+0,sp)
2693  05bf               L7411:
2694                     ; 408         GPIO_WriteHigh(GPIOC, GPIO_PIN_4);
2696  05bf 4b10          	push	#16
2697  05c1 ae500a        	ldw	x,#20490
2698  05c4 cd0000        	call	_GPIO_WriteHigh
2700  05c7 84            	pop	a
2701                     ; 409         delay_ms(200);
2703  05c8 ae00c8        	ldw	x,#200
2704  05cb cd0000        	call	_delay_ms
2706                     ; 410         GPIO_WriteLow(GPIOC, GPIO_PIN_4);
2708  05ce 4b10          	push	#16
2709  05d0 ae500a        	ldw	x,#20490
2710  05d3 cd0000        	call	_GPIO_WriteLow
2712  05d6 84            	pop	a
2713                     ; 411         delay_ms(200);
2715  05d7 ae00c8        	ldw	x,#200
2716  05da cd0000        	call	_delay_ms
2718                     ; 407     for (i = 0; i < 2; i++) {
2720  05dd 0c02          	inc	(OFST+0,sp)
2724  05df 7b02          	ld	a,(OFST+0,sp)
2725  05e1 a102          	cp	a,#2
2726  05e3 25da          	jrult	L7411
2727                     ; 414     for (k = 0; k < 2; k++) {
2729  05e5 0f01          	clr	(OFST-1,sp)
2731  05e7               L5511:
2732                     ; 415         for (j = 0; j < 4; j++) tm_displayCharacter(j, 0xFF);
2734  05e7 0f02          	clr	(OFST+0,sp)
2736  05e9               L3611:
2739  05e9 7b02          	ld	a,(OFST+0,sp)
2740  05eb ae00ff        	ldw	x,#255
2741  05ee 95            	ld	xh,a
2742  05ef cd00be        	call	_tm_displayCharacter
2746  05f2 0c02          	inc	(OFST+0,sp)
2750  05f4 7b02          	ld	a,(OFST+0,sp)
2751  05f6 a104          	cp	a,#4
2752  05f8 25ef          	jrult	L3611
2753                     ; 416         delay_ms(200);
2755  05fa ae00c8        	ldw	x,#200
2756  05fd cd0000        	call	_delay_ms
2758                     ; 417         for (j = 0; j < 4; j++) tm_displayCharacter(j, 0x00);
2760  0600 0f02          	clr	(OFST+0,sp)
2762  0602               L1711:
2765  0602 7b02          	ld	a,(OFST+0,sp)
2766  0604 5f            	clrw	x
2767  0605 95            	ld	xh,a
2768  0606 cd00be        	call	_tm_displayCharacter
2772  0609 0c02          	inc	(OFST+0,sp)
2776  060b 7b02          	ld	a,(OFST+0,sp)
2777  060d a104          	cp	a,#4
2778  060f 25f1          	jrult	L1711
2779                     ; 418         delay_ms(200);
2781  0611 ae00c8        	ldw	x,#200
2782  0614 cd0000        	call	_delay_ms
2784                     ; 414     for (k = 0; k < 2; k++) {
2786  0617 0c01          	inc	(OFST-1,sp)
2790  0619 7b01          	ld	a,(OFST-1,sp)
2791  061b a102          	cp	a,#2
2792  061d 25c8          	jrult	L5511
2793                     ; 420 }
2796  061f 85            	popw	x
2797  0620 81            	ret
2800                     	switch	.const
2801  0022               L7711_userInput:
2802  0022 20            	dc.b	32
2803  0023 20            	dc.b	32
2804  0024 20            	dc.b	32
2805  0025 20            	dc.b	32
2930                     ; 423 void main(void) {
2931                     	switch	.text
2932  0621               _main:
2934  0621 5214          	subw	sp,#20
2935       00000014      OFST:	set	20
2938                     ; 424     char key = 0;
2940                     ; 425     char userInput[4] = {' ', ' ', ' ', ' '};
2942  0623 96            	ldw	x,sp
2943  0624 1c000f        	addw	x,#OFST-5
2944  0627 90ae0022      	ldw	y,#L7711_userInput
2945  062b a604          	ld	a,#4
2946  062d cd0000        	call	c_xymov
2948                     ; 426     uint8_t index = 0;
2950  0630 0f13          	clr	(OFST-1,sp)
2952                     ; 428     uint8_t loggedIn = 0;
2954  0632 0f0d          	clr	(OFST-7,sp)
2956                     ; 429     uint32_t loginStartTime = 0;
2958  0634 ae0000        	ldw	x,#0
2959  0637 1f0b          	ldw	(OFST-9,sp),x
2960  0639 ae0000        	ldw	x,#0
2961  063c 1f09          	ldw	(OFST-11,sp),x
2963                     ; 430     const uint32_t LOGIN_TIMEOUT_MS = 5000;
2965  063e ae1388        	ldw	x,#5000
2966  0641 1f07          	ldw	(OFST-13,sp),x
2967  0643 ae0000        	ldw	x,#0
2968  0646 1f05          	ldw	(OFST-15,sp),x
2970                     ; 432     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
2972  0648 4f            	clr	a
2973  0649 cd0000        	call	_CLK_HSIPrescalerConfig
2975                     ; 434     GPIO_Init(TM_CLK_PORT, TM_CLK_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
2977  064c 4be0          	push	#224
2978  064e 4b20          	push	#32
2979  0650 ae5005        	ldw	x,#20485
2980  0653 cd0000        	call	_GPIO_Init
2982  0656 85            	popw	x
2983                     ; 435     GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
2985  0657 4be0          	push	#224
2986  0659 4b10          	push	#16
2987  065b ae5005        	ldw	x,#20485
2988  065e cd0000        	call	_GPIO_Init
2990  0661 85            	popw	x
2991                     ; 436     GPIO_Init(GPIOE, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT);
2993  0662 4b00          	push	#0
2994  0664 4b10          	push	#16
2995  0666 ae5014        	ldw	x,#20500
2996  0669 cd0000        	call	_GPIO_Init
2998  066c 85            	popw	x
2999                     ; 439 		GPIO_Init(GPIOC, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_FAST); // èervená LED
3001  066d 4be0          	push	#224
3002  066f 4b10          	push	#16
3003  0671 ae500a        	ldw	x,#20490
3004  0674 cd0000        	call	_GPIO_Init
3006  0677 85            	popw	x
3007                     ; 440 		GPIO_Init(GPIOE, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST); // zelená LED
3009  0678 4be0          	push	#224
3010  067a 4b20          	push	#32
3011  067c ae5014        	ldw	x,#20500
3012  067f cd0000        	call	_GPIO_Init
3014  0682 85            	popw	x
3015                     ; 442     initKeypad();
3017  0683 cd0103        	call	_initKeypad
3019                     ; 443     buzzerInit();
3021  0686 cd0321        	call	_buzzerInit
3023                     ; 444     init_milis();
3025  0689 cd0000        	call	_init_milis
3027                     ; 446     for (i = 0; i < 4; i++) {
3029  068c 0f14          	clr	(OFST+0,sp)
3031  068e               L7521:
3032                     ; 447         tm_displayCharacter(i, 0x00);
3034  068e 7b14          	ld	a,(OFST+0,sp)
3035  0690 5f            	clrw	x
3036  0691 95            	ld	xh,a
3037  0692 cd00be        	call	_tm_displayCharacter
3039                     ; 446     for (i = 0; i < 4; i++) {
3041  0695 0c14          	inc	(OFST+0,sp)
3045  0697 7b14          	ld	a,(OFST+0,sp)
3046  0699 a104          	cp	a,#4
3047  069b 25f1          	jrult	L7521
3048                     ; 450     loadPINfromEEPROM();
3050  069d cd043a        	call	_loadPINfromEEPROM
3052  06a0               L5621:
3053                     ; 453         key = getKey();
3055  06a0 cd013b        	call	_getKey
3057  06a3 6b0e          	ld	(OFST-6,sp),a
3059                     ; 457         if (GPIO_ReadInputPin(GPIOE, GPIO_PIN_4) == RESET) {
3061  06a5 4b10          	push	#16
3062  06a7 ae5014        	ldw	x,#20500
3063  06aa cd0000        	call	_GPIO_ReadInputPin
3065  06ad 5b01          	addw	sp,#1
3066  06af 4d            	tnz	a
3067  06b0 2634          	jrne	L1721
3068                     ; 458             factoryResetPIN();
3070  06b2 cd0539        	call	_factoryResetPIN
3073  06b5               L5721:
3074                     ; 459             while (GPIO_ReadInputPin(GPIOE, GPIO_PIN_4) == RESET);
3076  06b5 4b10          	push	#16
3077  06b7 ae5014        	ldw	x,#20500
3078  06ba cd0000        	call	_GPIO_ReadInputPin
3080  06bd 5b01          	addw	sp,#1
3081  06bf 4d            	tnz	a
3082  06c0 27f3          	jreq	L5721
3083                     ; 460             index = 0;
3085  06c2 0f13          	clr	(OFST-1,sp)
3087                     ; 461             for (i = 0; i < 4; i++) {
3089  06c4 0f14          	clr	(OFST+0,sp)
3091  06c6               L1031:
3092                     ; 462                 userInput[i] = ' ';
3094  06c6 96            	ldw	x,sp
3095  06c7 1c000f        	addw	x,#OFST-5
3096  06ca 9f            	ld	a,xl
3097  06cb 5e            	swapw	x
3098  06cc 1b14          	add	a,(OFST+0,sp)
3099  06ce 2401          	jrnc	L641
3100  06d0 5c            	incw	x
3101  06d1               L641:
3102  06d1 02            	rlwa	x,a
3103  06d2 a620          	ld	a,#32
3104  06d4 f7            	ld	(x),a
3105                     ; 463                 tm_displayCharacter(i, 0x00);
3107  06d5 7b14          	ld	a,(OFST+0,sp)
3108  06d7 5f            	clrw	x
3109  06d8 95            	ld	xh,a
3110  06d9 cd00be        	call	_tm_displayCharacter
3112                     ; 461             for (i = 0; i < 4; i++) {
3114  06dc 0c14          	inc	(OFST+0,sp)
3118  06de 7b14          	ld	a,(OFST+0,sp)
3119  06e0 a104          	cp	a,#4
3120  06e2 25e2          	jrult	L1031
3121                     ; 465             loggedIn = 0;
3123  06e4 0f0d          	clr	(OFST-7,sp)
3125  06e6               L1721:
3126                     ; 469 					if (loggedIn) {
3128  06e6 0d0d          	tnz	(OFST-7,sp)
3129  06e8 274b          	jreq	L7031
3130                     ; 470 							uint32_t now = milis();
3132  06ea cd0000        	call	_milis
3134  06ed cd0000        	call	c_uitolx
3136  06f0 96            	ldw	x,sp
3137  06f1 1c0001        	addw	x,#OFST-19
3138  06f4 cd0000        	call	c_rtol
3141                     ; 471 							if ((now - loginStartTime) >= LOGIN_TIMEOUT_MS) {
3143  06f7 96            	ldw	x,sp
3144  06f8 1c0001        	addw	x,#OFST-19
3145  06fb cd0000        	call	c_ltor
3147  06fe 96            	ldw	x,sp
3148  06ff 1c0009        	addw	x,#OFST-11
3149  0702 cd0000        	call	c_lsub
3151  0705 96            	ldw	x,sp
3152  0706 1c0005        	addw	x,#OFST-15
3153  0709 cd0000        	call	c_lcmp
3155  070c 2527          	jrult	L7031
3156                     ; 472 									logoutSignal();
3158  070e cd05a1        	call	_logoutSignal
3160                     ; 474 									loggedIn = 0;
3162  0711 0f0d          	clr	(OFST-7,sp)
3164                     ; 475 									index = 0;
3166  0713 0f13          	clr	(OFST-1,sp)
3168                     ; 476 									for ( i = 0; i < 4; i++) {
3170  0715 0f14          	clr	(OFST+0,sp)
3172  0717               L3131:
3173                     ; 477 											userInput[i] = ' ';
3175  0717 96            	ldw	x,sp
3176  0718 1c000f        	addw	x,#OFST-5
3177  071b 9f            	ld	a,xl
3178  071c 5e            	swapw	x
3179  071d 1b14          	add	a,(OFST+0,sp)
3180  071f 2401          	jrnc	L051
3181  0721 5c            	incw	x
3182  0722               L051:
3183  0722 02            	rlwa	x,a
3184  0723 a620          	ld	a,#32
3185  0725 f7            	ld	(x),a
3186                     ; 478 											tm_displayCharacter(i, 0x00);
3188  0726 7b14          	ld	a,(OFST+0,sp)
3189  0728 5f            	clrw	x
3190  0729 95            	ld	xh,a
3191  072a cd00be        	call	_tm_displayCharacter
3193                     ; 476 									for ( i = 0; i < 4; i++) {
3195  072d 0c14          	inc	(OFST+0,sp)
3199  072f 7b14          	ld	a,(OFST+0,sp)
3200  0731 a104          	cp	a,#4
3201  0733 25e2          	jrult	L3131
3202  0735               L7031:
3203                     ; 483         if (key != 0) {
3205  0735 0d0e          	tnz	(OFST-6,sp)
3206  0737 2603          	jrne	L461
3207  0739 cc06a0        	jp	L5621
3208  073c               L461:
3209                     ; 484             if (key >= '0' && key <= '9') {
3211  073c 7b0e          	ld	a,(OFST-6,sp)
3212  073e a130          	cp	a,#48
3213  0740 2403          	jruge	L661
3214  0742 cc07e6        	jp	L3231
3215  0745               L661:
3217  0745 7b0e          	ld	a,(OFST-6,sp)
3218  0747 a13a          	cp	a,#58
3219  0749 2503          	jrult	L071
3220  074b cc07e6        	jp	L3231
3221  074e               L071:
3222                     ; 485                 if (index < 4) {
3224  074e 7b13          	ld	a,(OFST-1,sp)
3225  0750 a104          	cp	a,#4
3226  0752 2503          	jrult	L271
3227  0754 cc06a0        	jp	L5621
3228  0757               L271:
3229                     ; 486                     userInput[index] = key;
3231  0757 96            	ldw	x,sp
3232  0758 1c000f        	addw	x,#OFST-5
3233  075b 9f            	ld	a,xl
3234  075c 5e            	swapw	x
3235  075d 1b13          	add	a,(OFST-1,sp)
3236  075f 2401          	jrnc	L251
3237  0761 5c            	incw	x
3238  0762               L251:
3239  0762 02            	rlwa	x,a
3240  0763 7b0e          	ld	a,(OFST-6,sp)
3241  0765 f7            	ld	(x),a
3242                     ; 487                     tm_displayCharacter(index, digitToSegment[key - '0']);
3244  0766 7b0e          	ld	a,(OFST-6,sp)
3245  0768 5f            	clrw	x
3246  0769 97            	ld	xl,a
3247  076a 1d0030        	subw	x,#48
3248  076d d60004        	ld	a,(_digitToSegment,x)
3249  0770 97            	ld	xl,a
3250  0771 7b13          	ld	a,(OFST-1,sp)
3251  0773 95            	ld	xh,a
3252  0774 cd00be        	call	_tm_displayCharacter
3254                     ; 488                     index++;
3256  0777 0c13          	inc	(OFST-1,sp)
3258                     ; 490                     if (index == 4) {
3260  0779 7b13          	ld	a,(OFST-1,sp)
3261  077b a104          	cp	a,#4
3262  077d 2703          	jreq	L471
3263  077f cc06a0        	jp	L5621
3264  0782               L471:
3265                     ; 492                         if (!loggedIn) {
3267  0782 0d0d          	tnz	(OFST-7,sp)
3268  0784 2703          	jreq	L671
3269  0786 cc06a0        	jp	L5621
3270  0789               L671:
3271                     ; 494                             if (comparePIN(userInput, storedPIN)) {
3273  0789 ae0000        	ldw	x,#_storedPIN
3274  078c 89            	pushw	x
3275  078d 96            	ldw	x,sp
3276  078e 1c0011        	addw	x,#OFST-3
3277  0791 cd04cf        	call	_comparePIN
3279  0794 85            	popw	x
3280  0795 4d            	tnz	a
3281  0796 2716          	jreq	L3331
3282                     ; 495 																beepSuccess();
3284  0798 cd03b4        	call	_beepSuccess
3286                     ; 496 																loggedIn = 1;
3288  079b a601          	ld	a,#1
3289  079d 6b0d          	ld	(OFST-7,sp),a
3291                     ; 497                                 loginStartTime = milis();
3293  079f cd0000        	call	_milis
3295  07a2 cd0000        	call	c_uitolx
3297  07a5 96            	ldw	x,sp
3298  07a6 1c0009        	addw	x,#OFST-11
3299  07a9 cd0000        	call	c_rtol
3303  07ac 2012          	jra	L5331
3304  07ae               L3331:
3305                     ; 499                                 beepFail();
3307  07ae cd040c        	call	_beepFail
3309                     ; 500 																blinkLED(1, 'r');
3311  07b1 ae0172        	ldw	x,#370
3312  07b4 cd0547        	call	_blinkLED
3314                     ; 501 																beepFail();
3316  07b7 cd040c        	call	_beepFail
3318                     ; 502 																blinkLED(1, 'r');
3320  07ba ae0172        	ldw	x,#370
3321  07bd cd0547        	call	_blinkLED
3323  07c0               L5331:
3324                     ; 505                             index = 0;
3326  07c0 0f13          	clr	(OFST-1,sp)
3328                     ; 506                             for (j = 0; j < 4; j++) {
3330  07c2 0f14          	clr	(OFST+0,sp)
3332  07c4               L7331:
3333                     ; 507                                 userInput[j] = ' ';
3335  07c4 96            	ldw	x,sp
3336  07c5 1c000f        	addw	x,#OFST-5
3337  07c8 9f            	ld	a,xl
3338  07c9 5e            	swapw	x
3339  07ca 1b14          	add	a,(OFST+0,sp)
3340  07cc 2401          	jrnc	L451
3341  07ce 5c            	incw	x
3342  07cf               L451:
3343  07cf 02            	rlwa	x,a
3344  07d0 a620          	ld	a,#32
3345  07d2 f7            	ld	(x),a
3346                     ; 508                                 tm_displayCharacter(j, 0x00);
3348  07d3 7b14          	ld	a,(OFST+0,sp)
3349  07d5 5f            	clrw	x
3350  07d6 95            	ld	xh,a
3351  07d7 cd00be        	call	_tm_displayCharacter
3353                     ; 506                             for (j = 0; j < 4; j++) {
3355  07da 0c14          	inc	(OFST+0,sp)
3359  07dc 7b14          	ld	a,(OFST+0,sp)
3360  07de a104          	cp	a,#4
3361  07e0 25e2          	jrult	L7331
3362  07e2 aca006a0      	jpf	L5621
3363  07e6               L3231:
3364                     ; 513             } else if (key == '*') {
3366  07e6 7b0e          	ld	a,(OFST-6,sp)
3367  07e8 a12a          	cp	a,#42
3368  07ea 2623          	jrne	L7431
3369                     ; 515                 if (index > 0) {
3371  07ec 0d13          	tnz	(OFST-1,sp)
3372  07ee 2603          	jrne	L002
3373  07f0 cc06a0        	jp	L5621
3374  07f3               L002:
3375                     ; 516                     index--;
3377  07f3 0a13          	dec	(OFST-1,sp)
3379                     ; 517                     userInput[index] = ' ';
3381  07f5 96            	ldw	x,sp
3382  07f6 1c000f        	addw	x,#OFST-5
3383  07f9 9f            	ld	a,xl
3384  07fa 5e            	swapw	x
3385  07fb 1b13          	add	a,(OFST-1,sp)
3386  07fd 2401          	jrnc	L651
3387  07ff 5c            	incw	x
3388  0800               L651:
3389  0800 02            	rlwa	x,a
3390  0801 a620          	ld	a,#32
3391  0803 f7            	ld	(x),a
3392                     ; 518                     tm_displayCharacter(index, 0x00);
3394  0804 7b13          	ld	a,(OFST-1,sp)
3395  0806 5f            	clrw	x
3396  0807 95            	ld	xh,a
3397  0808 cd00be        	call	_tm_displayCharacter
3399  080b aca006a0      	jpf	L5621
3400  080f               L7431:
3401                     ; 520             } else if (key == '#') {
3403  080f 7b0e          	ld	a,(OFST-6,sp)
3404  0811 a123          	cp	a,#35
3405  0813 2703          	jreq	L202
3406  0815 cc06a0        	jp	L5621
3407  0818               L202:
3408                     ; 522                 if (loggedIn && index == 4) {
3410  0818 0d0d          	tnz	(OFST-7,sp)
3411  081a 2603          	jrne	L402
3412  081c cc06a0        	jp	L5621
3413  081f               L402:
3415  081f 7b13          	ld	a,(OFST-1,sp)
3416  0821 a104          	cp	a,#4
3417  0823 2703          	jreq	L602
3418  0825 cc06a0        	jp	L5621
3419  0828               L602:
3420                     ; 523                     savePINtoEEPROM(userInput);
3422  0828 96            	ldw	x,sp
3423  0829 1c000f        	addw	x,#OFST-5
3424  082c cd049b        	call	_savePINtoEEPROM
3426                     ; 524                     blinkDisplay(2);  
3428  082f a602          	ld	a,#2
3429  0831 cd04f8        	call	_blinkDisplay
3431                     ; 527                     for (j = 0; j < 4; j++) {
3433  0834 0f14          	clr	(OFST+0,sp)
3435  0836               L1631:
3436                     ; 528                         storedPIN[j] = userInput[j];
3438  0836 7b14          	ld	a,(OFST+0,sp)
3439  0838 5f            	clrw	x
3440  0839 97            	ld	xl,a
3441  083a 89            	pushw	x
3442  083b 96            	ldw	x,sp
3443  083c 1c0011        	addw	x,#OFST-3
3444  083f 9f            	ld	a,xl
3445  0840 5e            	swapw	x
3446  0841 1b16          	add	a,(OFST+2,sp)
3447  0843 2401          	jrnc	L061
3448  0845 5c            	incw	x
3449  0846               L061:
3450  0846 02            	rlwa	x,a
3451  0847 f6            	ld	a,(x)
3452  0848 85            	popw	x
3453  0849 e700          	ld	(_storedPIN,x),a
3454                     ; 527                     for (j = 0; j < 4; j++) {
3456  084b 0c14          	inc	(OFST+0,sp)
3460  084d 7b14          	ld	a,(OFST+0,sp)
3461  084f a104          	cp	a,#4
3462  0851 25e3          	jrult	L1631
3463                     ; 532                     loggedIn = 0;
3465  0853 0f0d          	clr	(OFST-7,sp)
3467                     ; 533                     index = 0;
3469  0855 0f13          	clr	(OFST-1,sp)
3471                     ; 534 										blinkLED(1, '');
3473  0857 ae0100        	ldw	x,#256
3474  085a cd0547        	call	_blinkLED
3476                     ; 535                     for (j = 0; j < 4; j++) {
3478  085d 0f14          	clr	(OFST+0,sp)
3480  085f               L7631:
3481                     ; 536                         userInput[j] = ' ';
3483  085f 96            	ldw	x,sp
3484  0860 1c000f        	addw	x,#OFST-5
3485  0863 9f            	ld	a,xl
3486  0864 5e            	swapw	x
3487  0865 1b14          	add	a,(OFST+0,sp)
3488  0867 2401          	jrnc	L261
3489  0869 5c            	incw	x
3490  086a               L261:
3491  086a 02            	rlwa	x,a
3492  086b a620          	ld	a,#32
3493  086d f7            	ld	(x),a
3494                     ; 537                         tm_displayCharacter(j, 0x00);
3496  086e 7b14          	ld	a,(OFST+0,sp)
3497  0870 5f            	clrw	x
3498  0871 95            	ld	xh,a
3499  0872 cd00be        	call	_tm_displayCharacter
3501                     ; 535                     for (j = 0; j < 4; j++) {
3503  0875 0c14          	inc	(OFST+0,sp)
3507  0877 7b14          	ld	a,(OFST+0,sp)
3508  0879 a104          	cp	a,#4
3509  087b 25e2          	jrult	L7631
3510  087d aca006a0      	jpf	L5621
3545                     ; 550 void assert_failed(uint8_t* file, uint32_t line) {
3546                     	switch	.text
3547  0881               _assert_failed:
3551  0881               L3141:
3552                     ; 551     while (1);
3554  0881 20fe          	jra	L3141
3599                     	xdef	_main
3600                     	xdef	_logoutSignal
3601                     	xdef	_factoryResetPIN
3602                     	xdef	_blinkDisplay
3603                     	xdef	_comparePIN
3604                     	xdef	_savePINtoEEPROM
3605                     	xdef	_loadPINfromEEPROM
3606                     	xdef	_EEPROM_WriteByte
3607                     	xdef	_EEPROM_ReadByte
3608                     	xdef	_digitToSegment
3609                     	xdef	_blinkLED
3610                     	xdef	_beepTone
3611                     	xdef	_beepFail
3612                     	xdef	_beepSuccess
3613                     	xdef	_buzzerInit
3614                     	xdef	_getKey
3615                     	xdef	_initKeypad
3616                     	xdef	_delay_us
3617                     	xdef	_tm_displayCharacter
3618                     	xdef	_tm_writeByte
3619                     	xdef	_tm_stop
3620                     	xdef	_tm_start
3621                     	xdef	_setCLK
3622                     	xdef	_setDIO
3623                     	switch	.ubsct
3624  0000               _storedPIN:
3625  0000 00000000      	ds.b	4
3626                     	xdef	_storedPIN
3627                     	xdef	_defaultPIN
3628                     	xref	_init_milis
3629                     	xref	_delay_ms
3630                     	xref	_milis
3631                     	xdef	_assert_failed
3632                     	xref	_GPIO_ReadInputPin
3633                     	xref	_GPIO_WriteLow
3634                     	xref	_GPIO_WriteHigh
3635                     	xref	_GPIO_Init
3636                     	xref	_FLASH_ProgramByte
3637                     	xref	_FLASH_Lock
3638                     	xref	_FLASH_Unlock
3639                     	xref	_CLK_HSIPrescalerConfig
3640                     	xref.b	c_lreg
3641                     	xref.b	c_x
3642                     	xref.b	c_y
3662                     	xref	c_lsub
3663                     	xref	c_ludv
3664                     	xref	c_umul
3665                     	xref	c_ldiv
3666                     	xref	c_rtol
3667                     	xref	c_uitolx
3668                     	xref	c_bmulx
3669                     	xref	c_lcmp
3670                     	xref	c_ltor
3671                     	xref	c_lgadc
3672                     	xref	c_xymov
3673                     	end
