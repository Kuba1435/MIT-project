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
  73                     ; 81 void setDIO(uint8_t state) {
  75                     	switch	.text
  76  0000               _setDIO:
  80                     ; 82     if (state) GPIO_WriteHigh(TM_DIO_PORT, TM_DIO_PIN);
  82  0000 4d            	tnz	a
  83  0001 270b          	jreq	L72
  86  0003 4b10          	push	#16
  87  0005 ae5005        	ldw	x,#20485
  88  0008 cd0000        	call	_GPIO_WriteHigh
  90  000b 84            	pop	a
  92  000c 2009          	jra	L13
  93  000e               L72:
  94                     ; 83     else GPIO_WriteLow(TM_DIO_PORT, TM_DIO_PIN);
  96  000e 4b10          	push	#16
  97  0010 ae5005        	ldw	x,#20485
  98  0013 cd0000        	call	_GPIO_WriteLow
 100  0016 84            	pop	a
 101  0017               L13:
 102                     ; 84 }
 105  0017 81            	ret
 141                     ; 86 void setCLK(uint8_t state) {
 142                     	switch	.text
 143  0018               _setCLK:
 147                     ; 87     if (state) GPIO_WriteHigh(TM_CLK_PORT, TM_CLK_PIN);
 149  0018 4d            	tnz	a
 150  0019 270b          	jreq	L15
 153  001b 4b20          	push	#32
 154  001d ae5005        	ldw	x,#20485
 155  0020 cd0000        	call	_GPIO_WriteHigh
 157  0023 84            	pop	a
 159  0024 2009          	jra	L35
 160  0026               L15:
 161                     ; 88     else GPIO_WriteLow(TM_CLK_PORT, TM_CLK_PIN);
 163  0026 4b20          	push	#32
 164  0028 ae5005        	ldw	x,#20485
 165  002b cd0000        	call	_GPIO_WriteLow
 167  002e 84            	pop	a
 168  002f               L35:
 169                     ; 89 }
 172  002f 81            	ret
 198                     ; 92 void tm_start(void) {
 199                     	switch	.text
 200  0030               _tm_start:
 204                     ; 93     setCLK(1);
 206  0030 a601          	ld	a,#1
 207  0032 ade4          	call	_setCLK
 209                     ; 94     setDIO(1);
 211  0034 a601          	ld	a,#1
 212  0036 adc8          	call	_setDIO
 214                     ; 95     delay_us(2);
 216  0038 ae0002        	ldw	x,#2
 217  003b cd00e4        	call	_delay_us
 219                     ; 96     setDIO(0);
 221  003e 4f            	clr	a
 222  003f adbf          	call	_setDIO
 224                     ; 97     delay_us(2);
 226  0041 ae0002        	ldw	x,#2
 227  0044 cd00e4        	call	_delay_us
 229                     ; 98     setCLK(0);
 231  0047 4f            	clr	a
 232  0048 adce          	call	_setCLK
 234                     ; 99 }
 237  004a 81            	ret
 263                     ; 101 void tm_stop(void) {
 264                     	switch	.text
 265  004b               _tm_stop:
 269                     ; 102     setCLK(0);
 271  004b 4f            	clr	a
 272  004c adca          	call	_setCLK
 274                     ; 103     delay_us(2);
 276  004e ae0002        	ldw	x,#2
 277  0051 cd00e4        	call	_delay_us
 279                     ; 104     setDIO(0);
 281  0054 4f            	clr	a
 282  0055 ada9          	call	_setDIO
 284                     ; 105     delay_us(2);
 286  0057 ae0002        	ldw	x,#2
 287  005a cd00e4        	call	_delay_us
 289                     ; 106     setCLK(1);
 291  005d a601          	ld	a,#1
 292  005f adb7          	call	_setCLK
 294                     ; 107     delay_us(2);
 296  0061 ae0002        	ldw	x,#2
 297  0064 ad7e          	call	_delay_us
 299                     ; 108     setDIO(1);
 301  0066 a601          	ld	a,#1
 302  0068 ad96          	call	_setDIO
 304                     ; 109 }
 307  006a 81            	ret
 354                     ; 111 void tm_writeByte(uint8_t b) {
 355                     	switch	.text
 356  006b               _tm_writeByte:
 358  006b 88            	push	a
 359  006c 88            	push	a
 360       00000001      OFST:	set	1
 363                     ; 113     for (i = 0; i < 8; i++) {
 365  006d 0f01          	clr	(OFST+0,sp)
 367  006f               L711:
 368                     ; 114         setCLK(0);
 370  006f 4f            	clr	a
 371  0070 ada6          	call	_setCLK
 373                     ; 115         setDIO(b & 0x01);
 375  0072 7b02          	ld	a,(OFST+1,sp)
 376  0074 a401          	and	a,#1
 377  0076 ad88          	call	_setDIO
 379                     ; 116         delay_us(3);
 381  0078 ae0003        	ldw	x,#3
 382  007b ad67          	call	_delay_us
 384                     ; 117         setCLK(1);
 386  007d a601          	ld	a,#1
 387  007f ad97          	call	_setCLK
 389                     ; 118         delay_us(3);
 391  0081 ae0003        	ldw	x,#3
 392  0084 ad5e          	call	_delay_us
 394                     ; 119         b >>= 1;
 396  0086 0402          	srl	(OFST+1,sp)
 397                     ; 113     for (i = 0; i < 8; i++) {
 399  0088 0c01          	inc	(OFST+0,sp)
 403  008a 7b01          	ld	a,(OFST+0,sp)
 404  008c a108          	cp	a,#8
 405  008e 25df          	jrult	L711
 406                     ; 123     setCLK(0);
 408  0090 4f            	clr	a
 409  0091 ad85          	call	_setCLK
 411                     ; 124     GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_IN_FL_NO_IT); // input
 413  0093 4b00          	push	#0
 414  0095 4b10          	push	#16
 415  0097 ae5005        	ldw	x,#20485
 416  009a cd0000        	call	_GPIO_Init
 418  009d 85            	popw	x
 419                     ; 125     delay_us(5);
 421  009e ae0005        	ldw	x,#5
 422  00a1 ad41          	call	_delay_us
 424                     ; 126     setCLK(1);
 426  00a3 a601          	ld	a,#1
 427  00a5 cd0018        	call	_setCLK
 429                     ; 127     delay_us(5);
 431  00a8 ae0005        	ldw	x,#5
 432  00ab ad37          	call	_delay_us
 434                     ; 128     setCLK(0);
 436  00ad 4f            	clr	a
 437  00ae cd0018        	call	_setCLK
 439                     ; 129     GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_OUT_PP_LOW_FAST); // output
 441  00b1 4be0          	push	#224
 442  00b3 4b10          	push	#16
 443  00b5 ae5005        	ldw	x,#20485
 444  00b8 cd0000        	call	_GPIO_Init
 446  00bb 85            	popw	x
 447                     ; 130 }
 450  00bc 85            	popw	x
 451  00bd 81            	ret
 498                     ; 132 void tm_displayCharacter(uint8_t pos, uint8_t character) {
 499                     	switch	.text
 500  00be               _tm_displayCharacter:
 502  00be 89            	pushw	x
 503       00000000      OFST:	set	0
 506                     ; 133     tm_start();
 508  00bf cd0030        	call	_tm_start
 510                     ; 134     tm_writeByte(0x40); 
 512  00c2 a640          	ld	a,#64
 513  00c4 ada5          	call	_tm_writeByte
 515                     ; 135     tm_stop();
 517  00c6 ad83          	call	_tm_stop
 519                     ; 137     tm_start();
 521  00c8 cd0030        	call	_tm_start
 523                     ; 138     tm_writeByte(0xC0 | pos); 
 525  00cb 7b01          	ld	a,(OFST+1,sp)
 526  00cd aac0          	or	a,#192
 527  00cf ad9a          	call	_tm_writeByte
 529                     ; 139     tm_writeByte(character);
 531  00d1 7b02          	ld	a,(OFST+2,sp)
 532  00d3 ad96          	call	_tm_writeByte
 534                     ; 140     tm_stop();
 536  00d5 cd004b        	call	_tm_stop
 538                     ; 142     tm_start();
 540  00d8 cd0030        	call	_tm_start
 542                     ; 143     tm_writeByte(0x88); // display ON, brightness medium
 544  00db a688          	ld	a,#136
 545  00dd ad8c          	call	_tm_writeByte
 547                     ; 144     tm_stop();
 549  00df cd004b        	call	_tm_stop
 551                     ; 145 }
 554  00e2 85            	popw	x
 555  00e3 81            	ret
 599                     ; 147 void delay_us(uint16_t us) {
 600                     	switch	.text
 601  00e4               _delay_us:
 603  00e4 89            	pushw	x
 604  00e5 89            	pushw	x
 605       00000002      OFST:	set	2
 608                     ; 149     for (i = 0; i < us; i++) {
 610  00e6 5f            	clrw	x
 611  00e7 1f01          	ldw	(OFST-1,sp),x
 614  00e9 200f          	jra	L571
 615  00eb               L171:
 616                     ; 150         _asm("nop"); _asm("nop"); _asm("nop"); _asm("nop");
 619  00eb 9d            nop
 624  00ec 9d            nop
 629  00ed 9d            nop
 634  00ee 9d            nop
 636                     ; 151         _asm("nop"); _asm("nop"); _asm("nop"); _asm("nop");
 639  00ef 9d            nop
 644  00f0 9d            nop
 649  00f1 9d            nop
 654  00f2 9d            nop
 656                     ; 149     for (i = 0; i < us; i++) {
 658  00f3 1e01          	ldw	x,(OFST-1,sp)
 659  00f5 1c0001        	addw	x,#1
 660  00f8 1f01          	ldw	(OFST-1,sp),x
 662  00fa               L571:
 665  00fa 1e01          	ldw	x,(OFST-1,sp)
 666  00fc 1303          	cpw	x,(OFST+1,sp)
 667  00fe 25eb          	jrult	L171
 668                     ; 153 }
 671  0100 5b04          	addw	sp,#4
 672  0102 81            	ret
 696                     ; 155 void initKeypad(void) {
 697                     	switch	.text
 698  0103               _initKeypad:
 702                     ; 157     GPIO_Init(GPIOD, ROW1_PIN | ROW2_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
 704  0103 4be0          	push	#224
 705  0105 4b60          	push	#96
 706  0107 ae500f        	ldw	x,#20495
 707  010a cd0000        	call	_GPIO_Init
 709  010d 85            	popw	x
 710                     ; 158     GPIO_Init(GPIOE, ROW3_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
 712  010e 4be0          	push	#224
 713  0110 4b01          	push	#1
 714  0112 ae5014        	ldw	x,#20500
 715  0115 cd0000        	call	_GPIO_Init
 717  0118 85            	popw	x
 718                     ; 159     GPIO_Init(GPIOC, ROW4_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
 720  0119 4be0          	push	#224
 721  011b 4b02          	push	#2
 722  011d ae500a        	ldw	x,#20490
 723  0120 cd0000        	call	_GPIO_Init
 725  0123 85            	popw	x
 726                     ; 162     GPIO_Init(GPIOG, COL1_PIN, GPIO_MODE_IN_PU_NO_IT);
 728  0124 4b40          	push	#64
 729  0126 4b01          	push	#1
 730  0128 ae501e        	ldw	x,#20510
 731  012b cd0000        	call	_GPIO_Init
 733  012e 85            	popw	x
 734                     ; 163     GPIO_Init(GPIOC, COL2_PIN | COL3_PIN, GPIO_MODE_IN_PU_NO_IT);
 736  012f 4b40          	push	#64
 737  0131 4b0c          	push	#12
 738  0133 ae500a        	ldw	x,#20490
 739  0136 cd0000        	call	_GPIO_Init
 741  0139 85            	popw	x
 742                     ; 164 }
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
 854                     ; 166 char getKey(void) {
 855                     	switch	.text
 856  013b               _getKey:
 858  013b 5218          	subw	sp,#24
 859       00000018      OFST:	set	24
 862                     ; 167     const char keyMap[4][3] = {
 862                     ; 168         {'1', '2', '3'},
 862                     ; 169         {'4', '5', '6'},
 862                     ; 170         {'7', '8', '9'},
 862                     ; 171         {'*', '0', '#'}
 862                     ; 172     };
 864  013d 96            	ldw	x,sp
 865  013e 1c0004        	addw	x,#OFST-20
 866  0141 90ae000e      	ldw	y,#L112_keyMap
 867  0145 a60c          	ld	a,#12
 868  0147 cd0000        	call	c_xymov
 870                     ; 175     char key = 0;
 872                     ; 179     GPIOD->ODR |= ROW1_PIN | ROW2_PIN;
 874  014a c6500f        	ld	a,20495
 875  014d aa60          	or	a,#96
 876  014f c7500f        	ld	20495,a
 877                     ; 180     GPIOE->ODR |= ROW3_PIN;
 879  0152 72105014      	bset	20500,#0
 880                     ; 181     GPIOC->ODR |= ROW4_PIN;
 882  0156 7212500a      	bset	20490,#1
 883                     ; 183     for (row = 0; row < 4; row++) {
 885  015a 5f            	clrw	x
 886  015b 1f11          	ldw	(OFST-7,sp),x
 888  015d               L333:
 889                     ; 185         switch (row) {
 891  015d 1e11          	ldw	x,(OFST-7,sp)
 893                     ; 189             case 3: GPIOC->ODR &= ~ROW4_PIN; break;
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
 904                     ; 186             case 0: GPIOD->ODR &= ~ROW1_PIN; break;
 906  016d 721d500f      	bres	20495,#6
 909  0171 2010          	jra	L343
 910  0173               L512:
 911                     ; 187             case 1: GPIOD->ODR &= ~ROW2_PIN; break;
 913  0173 721b500f      	bres	20495,#5
 916  0177 200a          	jra	L343
 917  0179               L712:
 918                     ; 188             case 2: GPIOE->ODR &= ~ROW3_PIN; break;
 920  0179 72115014      	bres	20500,#0
 923  017d 2004          	jra	L343
 924  017f               L122:
 925                     ; 189             case 3: GPIOC->ODR &= ~ROW4_PIN; break;
 927  017f 7213500a      	bres	20490,#1
 930  0183               L343:
 931                     ; 192         for (i = 0; i < 1000; i++); // malé zpoždìní
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
 958                     ; 194         for (col = 0; col < 3; col++) {
 960  01a5 5f            	clrw	x
 961  01a6 1f17          	ldw	(OFST-1,sp),x
 963  01a8               L353:
 964                     ; 195             uint8_t colState = 1;
 966  01a8 a601          	ld	a,#1
 967  01aa 6b03          	ld	(OFST-21,sp),a
 969                     ; 197             switch (col) {
 971  01ac 1e17          	ldw	x,(OFST-1,sp)
 973                     ; 200                 case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
 974  01ae 5d            	tnzw	x
 975  01af 2708          	jreq	L322
 976  01b1 5a            	decw	x
 977  01b2 2715          	jreq	L522
 978  01b4 5a            	decw	x
 979  01b5 2722          	jreq	L722
 980  01b7 202e          	jra	L363
 981  01b9               L322:
 982                     ; 198                 case 0: colState = !(GPIOG->IDR & COL1_PIN); break;
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
 998                     ; 199                 case 1: colState = !(GPIOC->IDR & COL2_PIN); break;
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
1014                     ; 200                 case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
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
1029                     ; 203             if (colState) {
1031  01e7 0d03          	tnz	(OFST-21,sp)
1032  01e9 2603          	jrne	L001
1033  01eb cc02d3        	jp	L563
1034  01ee               L001:
1035                     ; 204                 for (i = 0; i < 30000; i++); // debounce
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
1062                     ; 207                 switch (col) {
1064  0210 1e17          	ldw	x,(OFST-1,sp)
1066                     ; 210                     case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
1067  0212 5d            	tnzw	x
1068  0213 2708          	jreq	L132
1069  0215 5a            	decw	x
1070  0216 2715          	jreq	L332
1071  0218 5a            	decw	x
1072  0219 2722          	jreq	L532
1073  021b 202e          	jra	L773
1074  021d               L132:
1075                     ; 208                     case 0: colState = !(GPIOG->IDR & COL1_PIN); break;
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
1091                     ; 209                     case 1: colState = !(GPIOC->IDR & COL2_PIN); break;
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
1107                     ; 210                     case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
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
1122                     ; 213                 if (colState) {
1124  024b 0d03          	tnz	(OFST-21,sp)
1125  024d 2603          	jrne	L201
1126  024f cc02d3        	jp	L563
1127  0252               L201:
1128                     ; 214                     key = keyMap[row][col];
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
1144                     ; 218                         uint8_t released = 0;
1146  0268 0f03          	clr	(OFST-21,sp)
1148                     ; 219                         switch (col) {
1150  026a 1e17          	ldw	x,(OFST-1,sp)
1152                     ; 222                             case 2: released = (GPIOC->IDR & COL3_PIN) != 0; break;
1153  026c 5d            	tnzw	x
1154  026d 2708          	jreq	L732
1155  026f 5a            	decw	x
1156  0270 2715          	jreq	L142
1157  0272 5a            	decw	x
1158  0273 2722          	jreq	L342
1159  0275 202e          	jra	L114
1160  0277               L732:
1161                     ; 220                             case 0: released = (GPIOG->IDR & COL1_PIN) != 0; break;
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
1177                     ; 221                             case 1: released = (GPIOC->IDR & COL2_PIN) != 0; break;
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
1193                     ; 222                             case 2: released = (GPIOC->IDR & COL3_PIN) != 0; break;
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
1208                     ; 224                         if (released) break;
1210  02a5 0d03          	tnz	(OFST-21,sp)
1211  02a7 27bf          	jreq	L304
1213                     ; 228                     switch (row) {
1215  02a9 1e11          	ldw	x,(OFST-7,sp)
1217                     ; 232                         case 3: GPIOC->ODR |= ROW4_PIN; break;
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
1228                     ; 229                         case 0: GPIOD->ODR |= ROW1_PIN; break;
1230  02b9 721c500f      	bset	20495,#6
1233  02bd 2010          	jra	L714
1234  02bf               L742:
1235                     ; 230                         case 1: GPIOD->ODR |= ROW2_PIN; break;
1237  02bf 721a500f      	bset	20495,#5
1240  02c3 200a          	jra	L714
1241  02c5               L152:
1242                     ; 231                         case 2: GPIOE->ODR |= ROW3_PIN; break;
1244  02c5 72105014      	bset	20500,#0
1247  02c9 2004          	jra	L714
1248  02cb               L352:
1249                     ; 232                         case 3: GPIOC->ODR |= ROW4_PIN; break;
1251  02cb 7212500a      	bset	20490,#1
1254  02cf               L714:
1255                     ; 235                     return key;
1257  02cf 7b10          	ld	a,(OFST-8,sp)
1259  02d1 204b          	jra	L67
1260  02d3               L563:
1261                     ; 194         for (col = 0; col < 3; col++) {
1263  02d3 1e17          	ldw	x,(OFST-1,sp)
1264  02d5 1c0001        	addw	x,#1
1265  02d8 1f17          	ldw	(OFST-1,sp),x
1269  02da 9c            	rvf
1270  02db 1e17          	ldw	x,(OFST-1,sp)
1271  02dd a30003        	cpw	x,#3
1272  02e0 2e03          	jrsge	L401
1273  02e2 cc01a8        	jp	L353
1274  02e5               L401:
1275                     ; 241         switch (row) {
1277  02e5 1e11          	ldw	x,(OFST-7,sp)
1279                     ; 245             case 3: GPIOC->ODR |= ROW4_PIN; break;
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
1290                     ; 242             case 0: GPIOD->ODR |= ROW1_PIN; break;
1292  02f5 721c500f      	bset	20495,#6
1295  02f9 2010          	jra	L324
1296  02fb               L752:
1297                     ; 243             case 1: GPIOD->ODR |= ROW2_PIN; break;
1299  02fb 721a500f      	bset	20495,#5
1302  02ff 200a          	jra	L324
1303  0301               L162:
1304                     ; 244             case 2: GPIOE->ODR |= ROW3_PIN; break;
1306  0301 72105014      	bset	20500,#0
1309  0305 2004          	jra	L324
1310  0307               L362:
1311                     ; 245             case 3: GPIOC->ODR |= ROW4_PIN; break;
1313  0307 7212500a      	bset	20490,#1
1316  030b               L324:
1317                     ; 183     for (row = 0; row < 4; row++) {
1319  030b 1e11          	ldw	x,(OFST-7,sp)
1320  030d 1c0001        	addw	x,#1
1321  0310 1f11          	ldw	(OFST-7,sp),x
1325  0312 9c            	rvf
1326  0313 1e11          	ldw	x,(OFST-7,sp)
1327  0315 a30004        	cpw	x,#4
1328  0318 2e03          	jrsge	L601
1329  031a cc015d        	jp	L333
1330  031d               L601:
1331                     ; 249     return 0; // žádná klávesa
1333  031d 4f            	clr	a
1335  031e               L67:
1337  031e 5b18          	addw	sp,#24
1338  0320 81            	ret
1363                     ; 254 void buzzerInit(void) {
1364                     	switch	.text
1365  0321               _buzzerInit:
1369                     ; 256     GPIO_Init(BUZZER_PORT, BUZZER_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
1371  0321 4be0          	push	#224
1372  0323 4b08          	push	#8
1373  0325 ae500f        	ldw	x,#20495
1374  0328 cd0000        	call	_GPIO_Init
1376  032b 85            	popw	x
1377                     ; 257     GPIO_WriteLow(BUZZER_PORT, BUZZER_PIN);
1379  032c 4b08          	push	#8
1380  032e ae500f        	ldw	x,#20495
1381  0331 cd0000        	call	_GPIO_WriteLow
1383  0334 84            	pop	a
1384                     ; 258 }
1387  0335 81            	ret
1460                     ; 260 void beepTone(uint16_t freq, uint16_t duration_ms) {
1461                     	switch	.text
1462  0336               _beepTone:
1464  0336 89            	pushw	x
1465  0337 5210          	subw	sp,#16
1466       00000010      OFST:	set	16
1469                     ; 264     uint32_t delay = 1000000 / (freq * 2); // poloviny periody v us
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
1492                     ; 265     uint32_t cycles = (uint32_t)freq * duration_ms / 1000;
1494  035c 1e11          	ldw	x,(OFST+1,sp)
1495  035e 1615          	ldw	y,(OFST+5,sp)
1496  0360 cd0000        	call	c_umul
1498  0363 ae001a        	ldw	x,#L62
1499  0366 cd0000        	call	c_ludv
1501  0369 96            	ldw	x,sp
1502  036a 1c0005        	addw	x,#OFST-11
1503  036d cd0000        	call	c_rtol
1506                     ; 267     for (i = 0; i < cycles; i++) {
1508  0370 ae0000        	ldw	x,#0
1509  0373 1f0b          	ldw	(OFST-5,sp),x
1510  0375 ae0000        	ldw	x,#0
1511  0378 1f09          	ldw	(OFST-7,sp),x
1514  037a 2025          	jra	L774
1515  037c               L374:
1516                     ; 268         GPIO_WriteHigh(BUZZER_PORT, BUZZER_PIN);
1518  037c 4b08          	push	#8
1519  037e ae500f        	ldw	x,#20495
1520  0381 cd0000        	call	_GPIO_WriteHigh
1522  0384 84            	pop	a
1523                     ; 269         delay_us(delay);
1525  0385 1e0f          	ldw	x,(OFST-1,sp)
1526  0387 cd00e4        	call	_delay_us
1528                     ; 270         GPIO_WriteLow(BUZZER_PORT, BUZZER_PIN);
1530  038a 4b08          	push	#8
1531  038c ae500f        	ldw	x,#20495
1532  038f cd0000        	call	_GPIO_WriteLow
1534  0392 84            	pop	a
1535                     ; 271         delay_us(delay);
1537  0393 1e0f          	ldw	x,(OFST-1,sp)
1538  0395 cd00e4        	call	_delay_us
1540                     ; 267     for (i = 0; i < cycles; i++) {
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
1560                     ; 273 }
1563  03b1 5b12          	addw	sp,#18
1564  03b3 81            	ret
1637                     ; 278 void beepSuccess(void) {
1638                     	switch	.text
1639  03b4               _beepSuccess:
1641  03b4 5209          	subw	sp,#9
1642       00000009      OFST:	set	9
1645                     ; 279     uint16_t freq = 3000;
1647  03b6 ae0bb8        	ldw	x,#3000
1648  03b9 1f01          	ldw	(OFST-8,sp),x
1650                     ; 280     uint16_t totalDuration = 300;  
1652  03bb ae012c        	ldw	x,#300
1653  03be 1f03          	ldw	(OFST-6,sp),x
1655                     ; 281     uint16_t chunkDuration = 50;   
1657  03c0 ae0032        	ldw	x,#50
1658  03c3 1f05          	ldw	(OFST-4,sp),x
1660                     ; 282     uint16_t elapsed = 0;
1662  03c5 5f            	clrw	x
1663  03c6 1f07          	ldw	(OFST-2,sp),x
1665                     ; 283     uint8_t ledOn = 0;
1667  03c8 0f09          	clr	(OFST+0,sp)
1670  03ca 202e          	jra	L545
1671  03cc               L145:
1672                     ; 286         if (ledOn) {
1674  03cc 0d09          	tnz	(OFST+0,sp)
1675  03ce 270d          	jreq	L155
1676                     ; 287             GPIO_WriteLow(GPIOE, GPIO_PIN_5);
1678  03d0 4b20          	push	#32
1679  03d2 ae5014        	ldw	x,#20500
1680  03d5 cd0000        	call	_GPIO_WriteLow
1682  03d8 84            	pop	a
1683                     ; 288             ledOn = 0;
1685  03d9 0f09          	clr	(OFST+0,sp)
1688  03db 200d          	jra	L355
1689  03dd               L155:
1690                     ; 290             GPIO_WriteHigh(GPIOE, GPIO_PIN_5);
1692  03dd 4b20          	push	#32
1693  03df ae5014        	ldw	x,#20500
1694  03e2 cd0000        	call	_GPIO_WriteHigh
1696  03e5 84            	pop	a
1697                     ; 291             ledOn = 1;
1699  03e6 a601          	ld	a,#1
1700  03e8 6b09          	ld	(OFST+0,sp),a
1702  03ea               L355:
1703                     ; 294         beepTone(freq, chunkDuration);
1705  03ea 1e05          	ldw	x,(OFST-4,sp)
1706  03ec 89            	pushw	x
1707  03ed 1e03          	ldw	x,(OFST-6,sp)
1708  03ef cd0336        	call	_beepTone
1710  03f2 85            	popw	x
1711                     ; 296         elapsed += chunkDuration;
1713  03f3 1e07          	ldw	x,(OFST-2,sp)
1714  03f5 72fb05        	addw	x,(OFST-4,sp)
1715  03f8 1f07          	ldw	(OFST-2,sp),x
1717  03fa               L545:
1718                     ; 285     while (elapsed < totalDuration) {
1720  03fa 1e07          	ldw	x,(OFST-2,sp)
1721  03fc 1303          	cpw	x,(OFST-6,sp)
1722  03fe 25cc          	jrult	L145
1723                     ; 299     GPIO_WriteLow(GPIOC, GPIO_PIN_4);
1725  0400 4b10          	push	#16
1726  0402 ae500a        	ldw	x,#20490
1727  0405 cd0000        	call	_GPIO_WriteLow
1729  0408 84            	pop	a
1730                     ; 300 }
1733  0409 5b09          	addw	sp,#9
1734  040b 81            	ret
1759                     ; 303 void beepFail(void) {
1760                     	switch	.text
1761  040c               _beepFail:
1765                     ; 304     beepTone(600, 100);  
1767  040c ae0064        	ldw	x,#100
1768  040f 89            	pushw	x
1769  0410 ae0258        	ldw	x,#600
1770  0413 cd0336        	call	_beepTone
1772  0416 85            	popw	x
1773                     ; 305     delay_ms(50);
1775  0417 ae0032        	ldw	x,#50
1776  041a cd0000        	call	_delay_ms
1778                     ; 306     beepTone(600, 100);  
1780  041d ae0064        	ldw	x,#100
1781  0420 89            	pushw	x
1782  0421 ae0258        	ldw	x,#600
1783  0424 cd0336        	call	_beepTone
1785  0427 85            	popw	x
1786                     ; 307 }
1789  0428 81            	ret
1823                     ; 310 uint8_t EEPROM_ReadByte(uint16_t addr) {
1824                     	switch	.text
1825  0429               _EEPROM_ReadByte:
1829                     ; 312     return *((uint8_t*)addr);
1831  0429 f6            	ld	a,(x)
1834  042a 81            	ret
1880                     ; 316 void EEPROM_WriteByte(uint16_t addr, uint8_t data) {
1881                     	switch	.text
1882  042b               _EEPROM_WriteByte:
1884  042b 89            	pushw	x
1885       00000000      OFST:	set	0
1888                     ; 318     FLASH_Unlock(FLASH_MEMTYPE_DATA);
1890  042c a6f7          	ld	a,#247
1891  042e cd0000        	call	_FLASH_Unlock
1893                     ; 319     FLASH_ProgramByte(addr, data);
1895  0431 7b05          	ld	a,(OFST+5,sp)
1896  0433 88            	push	a
1897  0434 1e02          	ldw	x,(OFST+2,sp)
1898  0436 cd0000        	call	c_uitolx
1900  0439 be02          	ldw	x,c_lreg+2
1901  043b 89            	pushw	x
1902  043c be00          	ldw	x,c_lreg
1903  043e 89            	pushw	x
1904  043f cd0000        	call	_FLASH_ProgramByte
1906  0442 5b05          	addw	sp,#5
1907                     ; 320     FLASH_Lock(FLASH_MEMTYPE_DATA);
1909  0444 a6f7          	ld	a,#247
1910  0446 cd0000        	call	_FLASH_Lock
1912                     ; 321 }
1915  0449 85            	popw	x
1916  044a 81            	ret
1963                     ; 324 void loadPINfromEEPROM(void) {
1964                     	switch	.text
1965  044b               _loadPINfromEEPROM:
1967  044b 89            	pushw	x
1968       00000002      OFST:	set	2
1971                     ; 326     uint8_t valid = 1;
1973  044c a601          	ld	a,#1
1974  044e 6b01          	ld	(OFST-1,sp),a
1976                     ; 327     for (i = 0; i < 4; i++) {
1978  0450 0f02          	clr	(OFST+0,sp)
1980  0452               L746:
1981                     ; 328         storedPIN[i] = EEPROM_ReadByte(EEPROM_PIN_ADDR + i);
1983  0452 7b02          	ld	a,(OFST+0,sp)
1984  0454 5f            	clrw	x
1985  0455 97            	ld	xl,a
1986  0456 89            	pushw	x
1987  0457 7b04          	ld	a,(OFST+2,sp)
1988  0459 5f            	clrw	x
1989  045a 97            	ld	xl,a
1990  045b 1c4000        	addw	x,#16384
1991  045e adc9          	call	_EEPROM_ReadByte
1993  0460 85            	popw	x
1994  0461 e700          	ld	(_storedPIN,x),a
1995                     ; 330         if (storedPIN[i] < '0' || storedPIN[i] > '9') {
1997  0463 7b02          	ld	a,(OFST+0,sp)
1998  0465 5f            	clrw	x
1999  0466 97            	ld	xl,a
2000  0467 e600          	ld	a,(_storedPIN,x)
2001  0469 a130          	cp	a,#48
2002  046b 250a          	jrult	L756
2004  046d 7b02          	ld	a,(OFST+0,sp)
2005  046f 5f            	clrw	x
2006  0470 97            	ld	xl,a
2007  0471 e600          	ld	a,(_storedPIN,x)
2008  0473 a13a          	cp	a,#58
2009  0475 2502          	jrult	L556
2010  0477               L756:
2011                     ; 331             valid = 0;
2013  0477 0f01          	clr	(OFST-1,sp)
2015  0479               L556:
2016                     ; 327     for (i = 0; i < 4; i++) {
2018  0479 0c02          	inc	(OFST+0,sp)
2022  047b 7b02          	ld	a,(OFST+0,sp)
2023  047d a104          	cp	a,#4
2024  047f 25d1          	jrult	L746
2025                     ; 334     if (!valid) {
2027  0481 0d01          	tnz	(OFST-1,sp)
2028  0483 2625          	jrne	L166
2029                     ; 336         for (i = 0; i < 4; i++) {
2031  0485 0f02          	clr	(OFST+0,sp)
2033  0487               L366:
2034                     ; 337             storedPIN[i] = defaultPIN[i];
2036  0487 7b02          	ld	a,(OFST+0,sp)
2037  0489 5f            	clrw	x
2038  048a 97            	ld	xl,a
2039  048b d60000        	ld	a,(_defaultPIN,x)
2040  048e e700          	ld	(_storedPIN,x),a
2041                     ; 338             EEPROM_WriteByte(EEPROM_PIN_ADDR + i, defaultPIN[i]);
2043  0490 7b02          	ld	a,(OFST+0,sp)
2044  0492 5f            	clrw	x
2045  0493 97            	ld	xl,a
2046  0494 d60000        	ld	a,(_defaultPIN,x)
2047  0497 88            	push	a
2048  0498 7b03          	ld	a,(OFST+1,sp)
2049  049a 5f            	clrw	x
2050  049b 97            	ld	xl,a
2051  049c 1c4000        	addw	x,#16384
2052  049f ad8a          	call	_EEPROM_WriteByte
2054  04a1 84            	pop	a
2055                     ; 336         for (i = 0; i < 4; i++) {
2057  04a2 0c02          	inc	(OFST+0,sp)
2061  04a4 7b02          	ld	a,(OFST+0,sp)
2062  04a6 a104          	cp	a,#4
2063  04a8 25dd          	jrult	L366
2064  04aa               L166:
2065                     ; 341 }
2068  04aa 85            	popw	x
2069  04ab 81            	ret
2115                     ; 344 void savePINtoEEPROM(const char* newPIN) {
2116                     	switch	.text
2117  04ac               _savePINtoEEPROM:
2119  04ac 89            	pushw	x
2120  04ad 88            	push	a
2121       00000001      OFST:	set	1
2124                     ; 346     for (i = 0; i < 4; i++) {
2126  04ae 0f01          	clr	(OFST+0,sp)
2128  04b0               L317:
2129                     ; 347         storedPIN[i] = newPIN[i];
2131  04b0 7b01          	ld	a,(OFST+0,sp)
2132  04b2 5f            	clrw	x
2133  04b3 97            	ld	xl,a
2134  04b4 7b01          	ld	a,(OFST+0,sp)
2135  04b6 905f          	clrw	y
2136  04b8 9097          	ld	yl,a
2137  04ba 72f902        	addw	y,(OFST+1,sp)
2138  04bd 90f6          	ld	a,(y)
2139  04bf e700          	ld	(_storedPIN,x),a
2140                     ; 348         EEPROM_WriteByte(EEPROM_PIN_ADDR + i, newPIN[i]);
2142  04c1 7b01          	ld	a,(OFST+0,sp)
2143  04c3 5f            	clrw	x
2144  04c4 97            	ld	xl,a
2145  04c5 72fb02        	addw	x,(OFST+1,sp)
2146  04c8 f6            	ld	a,(x)
2147  04c9 88            	push	a
2148  04ca 7b02          	ld	a,(OFST+1,sp)
2149  04cc 5f            	clrw	x
2150  04cd 97            	ld	xl,a
2151  04ce 1c4000        	addw	x,#16384
2152  04d1 cd042b        	call	_EEPROM_WriteByte
2154  04d4 84            	pop	a
2155                     ; 346     for (i = 0; i < 4; i++) {
2157  04d5 0c01          	inc	(OFST+0,sp)
2161  04d7 7b01          	ld	a,(OFST+0,sp)
2162  04d9 a104          	cp	a,#4
2163  04db 25d3          	jrult	L317
2164                     ; 350 }
2167  04dd 5b03          	addw	sp,#3
2168  04df 81            	ret
2222                     ; 353 uint8_t comparePIN(const char* a, const char* b) {
2223                     	switch	.text
2224  04e0               _comparePIN:
2226  04e0 89            	pushw	x
2227  04e1 88            	push	a
2228       00000001      OFST:	set	1
2231                     ; 355     for (i = 0; i < 4; i++) {
2233  04e2 0f01          	clr	(OFST+0,sp)
2235  04e4               L747:
2236                     ; 356         if (a[i] != b[i]) return 0;
2238  04e4 7b01          	ld	a,(OFST+0,sp)
2239  04e6 5f            	clrw	x
2240  04e7 97            	ld	xl,a
2241  04e8 72fb06        	addw	x,(OFST+5,sp)
2242  04eb 7b01          	ld	a,(OFST+0,sp)
2243  04ed 905f          	clrw	y
2244  04ef 9097          	ld	yl,a
2245  04f1 72f902        	addw	y,(OFST+1,sp)
2246  04f4 90f6          	ld	a,(y)
2247  04f6 f1            	cp	a,(x)
2248  04f7 2703          	jreq	L557
2251  04f9 4f            	clr	a
2253  04fa 200a          	jra	L231
2254  04fc               L557:
2255                     ; 355     for (i = 0; i < 4; i++) {
2257  04fc 0c01          	inc	(OFST+0,sp)
2261  04fe 7b01          	ld	a,(OFST+0,sp)
2262  0500 a104          	cp	a,#4
2263  0502 25e0          	jrult	L747
2264                     ; 358     return 1;
2266  0504 a601          	ld	a,#1
2268  0506               L231:
2270  0506 5b03          	addw	sp,#3
2271  0508 81            	ret
2325                     ; 362 void blinkDisplay(uint8_t times) {
2326                     	switch	.text
2327  0509               _blinkDisplay:
2329  0509 88            	push	a
2330  050a 89            	pushw	x
2331       00000002      OFST:	set	2
2334                     ; 364     for (i = 0; i < times; i++) {
2336  050b 0f01          	clr	(OFST-1,sp)
2339  050d 2032          	jra	L1101
2340  050f               L5001:
2341                     ; 365         for (j = 0; j < 4; j++) {
2343  050f 0f02          	clr	(OFST+0,sp)
2345  0511               L5101:
2346                     ; 366             tm_displayCharacter(j, 0x7F); 
2348  0511 7b02          	ld	a,(OFST+0,sp)
2349  0513 ae007f        	ldw	x,#127
2350  0516 95            	ld	xh,a
2351  0517 cd00be        	call	_tm_displayCharacter
2353                     ; 365         for (j = 0; j < 4; j++) {
2355  051a 0c02          	inc	(OFST+0,sp)
2359  051c 7b02          	ld	a,(OFST+0,sp)
2360  051e a104          	cp	a,#4
2361  0520 25ef          	jrult	L5101
2362                     ; 368         delay_us(300000); 
2364  0522 ae93e0        	ldw	x,#37856
2365  0525 cd00e4        	call	_delay_us
2367                     ; 370         for (j = 0; j < 4; j++) {
2369  0528 0f02          	clr	(OFST+0,sp)
2371  052a               L3201:
2372                     ; 371             tm_displayCharacter(j, 0x00);
2374  052a 7b02          	ld	a,(OFST+0,sp)
2375  052c 5f            	clrw	x
2376  052d 95            	ld	xh,a
2377  052e cd00be        	call	_tm_displayCharacter
2379                     ; 370         for (j = 0; j < 4; j++) {
2381  0531 0c02          	inc	(OFST+0,sp)
2385  0533 7b02          	ld	a,(OFST+0,sp)
2386  0535 a104          	cp	a,#4
2387  0537 25f1          	jrult	L3201
2388                     ; 373         delay_us(300000);
2390  0539 ae93e0        	ldw	x,#37856
2391  053c cd00e4        	call	_delay_us
2393                     ; 364     for (i = 0; i < times; i++) {
2395  053f 0c01          	inc	(OFST-1,sp)
2397  0541               L1101:
2400  0541 7b01          	ld	a,(OFST-1,sp)
2401  0543 1103          	cp	a,(OFST+1,sp)
2402  0545 25c8          	jrult	L5001
2403                     ; 375 }
2406  0547 5b03          	addw	sp,#3
2407  0549 81            	ret
2434                     ; 379 void factoryResetPIN(void) {
2435                     	switch	.text
2436  054a               _factoryResetPIN:
2440                     ; 380     savePINtoEEPROM(defaultPIN);
2442  054a ae0000        	ldw	x,#_defaultPIN
2443  054d cd04ac        	call	_savePINtoEEPROM
2445                     ; 381     beepSuccess();
2447  0550 cd03b4        	call	_beepSuccess
2449                     ; 382     blinkDisplay(2); 
2451  0553 a602          	ld	a,#2
2452  0555 adb2          	call	_blinkDisplay
2454                     ; 383 }
2457  0557 81            	ret
2512                     ; 385 void blinkLED(uint8_t times, char color){
2513                     	switch	.text
2514  0558               _blinkLED:
2516  0558 89            	pushw	x
2517  0559 88            	push	a
2518       00000001      OFST:	set	1
2521                     ; 387 			if (color == 'r'){
2523  055a 9f            	ld	a,xl
2524  055b a172          	cp	a,#114
2525  055d 2627          	jrne	L7601
2526                     ; 388 				for (i = 0; i < times; i++) {
2528  055f 0f01          	clr	(OFST+0,sp)
2531  0561 201a          	jra	L5701
2532  0563               L1701:
2533                     ; 389 					GPIO_WriteHigh(GPIOC, GPIO_PIN_4); 
2535  0563 4b10          	push	#16
2536  0565 ae500a        	ldw	x,#20490
2537  0568 cd0000        	call	_GPIO_WriteHigh
2539  056b 84            	pop	a
2540                     ; 390 					delay_ms(250);
2542  056c ae00fa        	ldw	x,#250
2543  056f cd0000        	call	_delay_ms
2545                     ; 391 					GPIO_WriteLow(GPIOC, GPIO_PIN_4);  
2547  0572 4b10          	push	#16
2548  0574 ae500a        	ldw	x,#20490
2549  0577 cd0000        	call	_GPIO_WriteLow
2551  057a 84            	pop	a
2552                     ; 388 				for (i = 0; i < times; i++) {
2554  057b 0c01          	inc	(OFST+0,sp)
2556  057d               L5701:
2559  057d 7b01          	ld	a,(OFST+0,sp)
2560  057f 1102          	cp	a,(OFST+1,sp)
2561  0581 25e0          	jrult	L1701
2563  0583               L1011:
2564                     ; 403 }
2567  0583 5b03          	addw	sp,#3
2568  0585 81            	ret
2569  0586               L7601:
2570                     ; 395 					for (i = 0; i < times; i++) {
2572  0586 0f01          	clr	(OFST+0,sp)
2575  0588 2020          	jra	L7011
2576  058a               L3011:
2577                     ; 396 						GPIO_WriteHigh(GPIOE, GPIO_PIN_5);
2579  058a 4b20          	push	#32
2580  058c ae5014        	ldw	x,#20500
2581  058f cd0000        	call	_GPIO_WriteHigh
2583  0592 84            	pop	a
2584                     ; 397 						delay_ms(500);
2586  0593 ae01f4        	ldw	x,#500
2587  0596 cd0000        	call	_delay_ms
2589                     ; 398 						GPIO_WriteLow(GPIOE, GPIO_PIN_5);
2591  0599 4b20          	push	#32
2592  059b ae5014        	ldw	x,#20500
2593  059e cd0000        	call	_GPIO_WriteLow
2595  05a1 84            	pop	a
2596                     ; 399 						delay_ms(500);
2598  05a2 ae01f4        	ldw	x,#500
2599  05a5 cd0000        	call	_delay_ms
2601                     ; 395 					for (i = 0; i < times; i++) {
2603  05a8 0c01          	inc	(OFST+0,sp)
2605  05aa               L7011:
2608  05aa 7b01          	ld	a,(OFST+0,sp)
2609  05ac 1102          	cp	a,(OFST+1,sp)
2610  05ae 25da          	jrult	L3011
2611  05b0 20d1          	jra	L1011
2668                     ; 406 void logoutSignal(void) {
2669                     	switch	.text
2670  05b2               _logoutSignal:
2672  05b2 89            	pushw	x
2673       00000002      OFST:	set	2
2676                     ; 411     for (i = 0; i < 2; i++) {
2678  05b3 0f02          	clr	(OFST+0,sp)
2680  05b5               L1411:
2681                     ; 412         beepTone(1000, 100);
2683  05b5 ae0064        	ldw	x,#100
2684  05b8 89            	pushw	x
2685  05b9 ae03e8        	ldw	x,#1000
2686  05bc cd0336        	call	_beepTone
2688  05bf 85            	popw	x
2689                     ; 413         delay_ms(100);
2691  05c0 ae0064        	ldw	x,#100
2692  05c3 cd0000        	call	_delay_ms
2694                     ; 411     for (i = 0; i < 2; i++) {
2696  05c6 0c02          	inc	(OFST+0,sp)
2700  05c8 7b02          	ld	a,(OFST+0,sp)
2701  05ca a102          	cp	a,#2
2702  05cc 25e7          	jrult	L1411
2703                     ; 416     for (i = 0; i < 2; i++) {
2705  05ce 0f02          	clr	(OFST+0,sp)
2707  05d0               L7411:
2708                     ; 417         GPIO_WriteHigh(GPIOC, GPIO_PIN_4);
2710  05d0 4b10          	push	#16
2711  05d2 ae500a        	ldw	x,#20490
2712  05d5 cd0000        	call	_GPIO_WriteHigh
2714  05d8 84            	pop	a
2715                     ; 418         delay_ms(200);
2717  05d9 ae00c8        	ldw	x,#200
2718  05dc cd0000        	call	_delay_ms
2720                     ; 419         GPIO_WriteLow(GPIOC, GPIO_PIN_4);
2722  05df 4b10          	push	#16
2723  05e1 ae500a        	ldw	x,#20490
2724  05e4 cd0000        	call	_GPIO_WriteLow
2726  05e7 84            	pop	a
2727                     ; 420         delay_ms(200);
2729  05e8 ae00c8        	ldw	x,#200
2730  05eb cd0000        	call	_delay_ms
2732                     ; 416     for (i = 0; i < 2; i++) {
2734  05ee 0c02          	inc	(OFST+0,sp)
2738  05f0 7b02          	ld	a,(OFST+0,sp)
2739  05f2 a102          	cp	a,#2
2740  05f4 25da          	jrult	L7411
2741                     ; 423     for (k = 0; k < 2; k++) {
2743  05f6 0f01          	clr	(OFST-1,sp)
2745  05f8               L5511:
2746                     ; 424         for (j = 0; j < 4; j++) tm_displayCharacter(j, 0xFF);
2748  05f8 0f02          	clr	(OFST+0,sp)
2750  05fa               L3611:
2753  05fa 7b02          	ld	a,(OFST+0,sp)
2754  05fc ae00ff        	ldw	x,#255
2755  05ff 95            	ld	xh,a
2756  0600 cd00be        	call	_tm_displayCharacter
2760  0603 0c02          	inc	(OFST+0,sp)
2764  0605 7b02          	ld	a,(OFST+0,sp)
2765  0607 a104          	cp	a,#4
2766  0609 25ef          	jrult	L3611
2767                     ; 425         delay_ms(200);
2769  060b ae00c8        	ldw	x,#200
2770  060e cd0000        	call	_delay_ms
2772                     ; 426         for (j = 0; j < 4; j++) tm_displayCharacter(j, 0x00);
2774  0611 0f02          	clr	(OFST+0,sp)
2776  0613               L1711:
2779  0613 7b02          	ld	a,(OFST+0,sp)
2780  0615 5f            	clrw	x
2781  0616 95            	ld	xh,a
2782  0617 cd00be        	call	_tm_displayCharacter
2786  061a 0c02          	inc	(OFST+0,sp)
2790  061c 7b02          	ld	a,(OFST+0,sp)
2791  061e a104          	cp	a,#4
2792  0620 25f1          	jrult	L1711
2793                     ; 427         delay_ms(200);
2795  0622 ae00c8        	ldw	x,#200
2796  0625 cd0000        	call	_delay_ms
2798                     ; 423     for (k = 0; k < 2; k++) {
2800  0628 0c01          	inc	(OFST-1,sp)
2804  062a 7b01          	ld	a,(OFST-1,sp)
2805  062c a102          	cp	a,#2
2806  062e 25c8          	jrult	L5511
2807                     ; 429 }
2810  0630 85            	popw	x
2811  0631 81            	ret
2814                     	switch	.const
2815  0022               L7711_userInput:
2816  0022 20            	dc.b	32
2817  0023 20            	dc.b	32
2818  0024 20            	dc.b	32
2819  0025 20            	dc.b	32
2944                     ; 432 void main(void) {
2945                     	switch	.text
2946  0632               _main:
2948  0632 5214          	subw	sp,#20
2949       00000014      OFST:	set	20
2952                     ; 433     char key = 0;
2954                     ; 434     char userInput[4] = {' ', ' ', ' ', ' '};
2956  0634 96            	ldw	x,sp
2957  0635 1c000f        	addw	x,#OFST-5
2958  0638 90ae0022      	ldw	y,#L7711_userInput
2959  063c a604          	ld	a,#4
2960  063e cd0000        	call	c_xymov
2962                     ; 435     uint8_t index = 0;
2964  0641 0f13          	clr	(OFST-1,sp)
2966                     ; 437     uint8_t loggedIn = 0;
2968  0643 0f0d          	clr	(OFST-7,sp)
2970                     ; 438     uint32_t loginStartTime = 0;
2972  0645 ae0000        	ldw	x,#0
2973  0648 1f0b          	ldw	(OFST-9,sp),x
2974  064a ae0000        	ldw	x,#0
2975  064d 1f09          	ldw	(OFST-11,sp),x
2977                     ; 439     const uint32_t LOGIN_TIMEOUT_MS = 5000;
2979  064f ae1388        	ldw	x,#5000
2980  0652 1f07          	ldw	(OFST-13,sp),x
2981  0654 ae0000        	ldw	x,#0
2982  0657 1f05          	ldw	(OFST-15,sp),x
2984                     ; 441     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
2986  0659 4f            	clr	a
2987  065a cd0000        	call	_CLK_HSIPrescalerConfig
2989                     ; 443     GPIO_Init(TM_CLK_PORT, TM_CLK_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
2991  065d 4be0          	push	#224
2992  065f 4b20          	push	#32
2993  0661 ae5005        	ldw	x,#20485
2994  0664 cd0000        	call	_GPIO_Init
2996  0667 85            	popw	x
2997                     ; 444     GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
2999  0668 4be0          	push	#224
3000  066a 4b10          	push	#16
3001  066c ae5005        	ldw	x,#20485
3002  066f cd0000        	call	_GPIO_Init
3004  0672 85            	popw	x
3005                     ; 445     GPIO_Init(GPIOE, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT);
3007  0673 4b00          	push	#0
3008  0675 4b10          	push	#16
3009  0677 ae5014        	ldw	x,#20500
3010  067a cd0000        	call	_GPIO_Init
3012  067d 85            	popw	x
3013                     ; 448 		GPIO_Init(GPIOC, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_FAST); // èervená LED
3015  067e 4be0          	push	#224
3016  0680 4b10          	push	#16
3017  0682 ae500a        	ldw	x,#20490
3018  0685 cd0000        	call	_GPIO_Init
3020  0688 85            	popw	x
3021                     ; 449 		GPIO_Init(GPIOE, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST); // zelená LED
3023  0689 4be0          	push	#224
3024  068b 4b20          	push	#32
3025  068d ae5014        	ldw	x,#20500
3026  0690 cd0000        	call	_GPIO_Init
3028  0693 85            	popw	x
3029                     ; 451     initKeypad();
3031  0694 cd0103        	call	_initKeypad
3033                     ; 452     buzzerInit();
3035  0697 cd0321        	call	_buzzerInit
3037                     ; 453     init_milis();
3039  069a cd0000        	call	_init_milis
3041                     ; 455     for (i = 0; i < 4; i++) {
3043  069d 0f14          	clr	(OFST+0,sp)
3045  069f               L7521:
3046                     ; 456         tm_displayCharacter(i, 0x00);
3048  069f 7b14          	ld	a,(OFST+0,sp)
3049  06a1 5f            	clrw	x
3050  06a2 95            	ld	xh,a
3051  06a3 cd00be        	call	_tm_displayCharacter
3053                     ; 455     for (i = 0; i < 4; i++) {
3055  06a6 0c14          	inc	(OFST+0,sp)
3059  06a8 7b14          	ld	a,(OFST+0,sp)
3060  06aa a104          	cp	a,#4
3061  06ac 25f1          	jrult	L7521
3062                     ; 459     loadPINfromEEPROM();
3064  06ae cd044b        	call	_loadPINfromEEPROM
3066  06b1               L5621:
3067                     ; 462         key = getKey();
3069  06b1 cd013b        	call	_getKey
3071  06b4 6b0e          	ld	(OFST-6,sp),a
3073                     ; 466         if (GPIO_ReadInputPin(GPIOE, GPIO_PIN_4) == RESET) {
3075  06b6 4b10          	push	#16
3076  06b8 ae5014        	ldw	x,#20500
3077  06bb cd0000        	call	_GPIO_ReadInputPin
3079  06be 5b01          	addw	sp,#1
3080  06c0 4d            	tnz	a
3081  06c1 2634          	jrne	L1721
3082                     ; 467             factoryResetPIN();
3084  06c3 cd054a        	call	_factoryResetPIN
3087  06c6               L5721:
3088                     ; 468             while (GPIO_ReadInputPin(GPIOE, GPIO_PIN_4) == RESET);
3090  06c6 4b10          	push	#16
3091  06c8 ae5014        	ldw	x,#20500
3092  06cb cd0000        	call	_GPIO_ReadInputPin
3094  06ce 5b01          	addw	sp,#1
3095  06d0 4d            	tnz	a
3096  06d1 27f3          	jreq	L5721
3097                     ; 469             index = 0;
3099  06d3 0f13          	clr	(OFST-1,sp)
3101                     ; 470             for (i = 0; i < 4; i++) {
3103  06d5 0f14          	clr	(OFST+0,sp)
3105  06d7               L1031:
3106                     ; 471                 userInput[i] = ' ';
3108  06d7 96            	ldw	x,sp
3109  06d8 1c000f        	addw	x,#OFST-5
3110  06db 9f            	ld	a,xl
3111  06dc 5e            	swapw	x
3112  06dd 1b14          	add	a,(OFST+0,sp)
3113  06df 2401          	jrnc	L641
3114  06e1 5c            	incw	x
3115  06e2               L641:
3116  06e2 02            	rlwa	x,a
3117  06e3 a620          	ld	a,#32
3118  06e5 f7            	ld	(x),a
3119                     ; 472                 tm_displayCharacter(i, 0x00);
3121  06e6 7b14          	ld	a,(OFST+0,sp)
3122  06e8 5f            	clrw	x
3123  06e9 95            	ld	xh,a
3124  06ea cd00be        	call	_tm_displayCharacter
3126                     ; 470             for (i = 0; i < 4; i++) {
3128  06ed 0c14          	inc	(OFST+0,sp)
3132  06ef 7b14          	ld	a,(OFST+0,sp)
3133  06f1 a104          	cp	a,#4
3134  06f3 25e2          	jrult	L1031
3135                     ; 474             loggedIn = 0;
3137  06f5 0f0d          	clr	(OFST-7,sp)
3139  06f7               L1721:
3140                     ; 478 					if (loggedIn) {
3142  06f7 0d0d          	tnz	(OFST-7,sp)
3143  06f9 274b          	jreq	L7031
3144                     ; 479 							uint32_t now = milis();
3146  06fb cd0000        	call	_milis
3148  06fe cd0000        	call	c_uitolx
3150  0701 96            	ldw	x,sp
3151  0702 1c0001        	addw	x,#OFST-19
3152  0705 cd0000        	call	c_rtol
3155                     ; 480 							if ((now - loginStartTime) >= LOGIN_TIMEOUT_MS) {
3157  0708 96            	ldw	x,sp
3158  0709 1c0001        	addw	x,#OFST-19
3159  070c cd0000        	call	c_ltor
3161  070f 96            	ldw	x,sp
3162  0710 1c0009        	addw	x,#OFST-11
3163  0713 cd0000        	call	c_lsub
3165  0716 96            	ldw	x,sp
3166  0717 1c0005        	addw	x,#OFST-15
3167  071a cd0000        	call	c_lcmp
3169  071d 2527          	jrult	L7031
3170                     ; 481 									logoutSignal();
3172  071f cd05b2        	call	_logoutSignal
3174                     ; 483 									loggedIn = 0;
3176  0722 0f0d          	clr	(OFST-7,sp)
3178                     ; 484 									index = 0;
3180  0724 0f13          	clr	(OFST-1,sp)
3182                     ; 485 									for ( i = 0; i < 4; i++) {
3184  0726 0f14          	clr	(OFST+0,sp)
3186  0728               L3131:
3187                     ; 486 											userInput[i] = ' ';
3189  0728 96            	ldw	x,sp
3190  0729 1c000f        	addw	x,#OFST-5
3191  072c 9f            	ld	a,xl
3192  072d 5e            	swapw	x
3193  072e 1b14          	add	a,(OFST+0,sp)
3194  0730 2401          	jrnc	L051
3195  0732 5c            	incw	x
3196  0733               L051:
3197  0733 02            	rlwa	x,a
3198  0734 a620          	ld	a,#32
3199  0736 f7            	ld	(x),a
3200                     ; 487 											tm_displayCharacter(i, 0x00);
3202  0737 7b14          	ld	a,(OFST+0,sp)
3203  0739 5f            	clrw	x
3204  073a 95            	ld	xh,a
3205  073b cd00be        	call	_tm_displayCharacter
3207                     ; 485 									for ( i = 0; i < 4; i++) {
3209  073e 0c14          	inc	(OFST+0,sp)
3213  0740 7b14          	ld	a,(OFST+0,sp)
3214  0742 a104          	cp	a,#4
3215  0744 25e2          	jrult	L3131
3216  0746               L7031:
3217                     ; 493         if (key != 0) {
3219  0746 0d0e          	tnz	(OFST-6,sp)
3220  0748 2603          	jrne	L461
3221  074a cc06b1        	jp	L5621
3222  074d               L461:
3223                     ; 494             if (key >= '0' && key <= '9') {
3225  074d 7b0e          	ld	a,(OFST-6,sp)
3226  074f a130          	cp	a,#48
3227  0751 2403          	jruge	L661
3228  0753 cc07ee        	jp	L3231
3229  0756               L661:
3231  0756 7b0e          	ld	a,(OFST-6,sp)
3232  0758 a13a          	cp	a,#58
3233  075a 2503          	jrult	L071
3234  075c cc07ee        	jp	L3231
3235  075f               L071:
3236                     ; 495                 if (index < 4) {
3238  075f 7b13          	ld	a,(OFST-1,sp)
3239  0761 a104          	cp	a,#4
3240  0763 2503          	jrult	L271
3241  0765 cc06b1        	jp	L5621
3242  0768               L271:
3243                     ; 496                     userInput[index] = key;
3245  0768 96            	ldw	x,sp
3246  0769 1c000f        	addw	x,#OFST-5
3247  076c 9f            	ld	a,xl
3248  076d 5e            	swapw	x
3249  076e 1b13          	add	a,(OFST-1,sp)
3250  0770 2401          	jrnc	L251
3251  0772 5c            	incw	x
3252  0773               L251:
3253  0773 02            	rlwa	x,a
3254  0774 7b0e          	ld	a,(OFST-6,sp)
3255  0776 f7            	ld	(x),a
3256                     ; 497                     tm_displayCharacter(index, digitToSegment[key - '0']);
3258  0777 7b0e          	ld	a,(OFST-6,sp)
3259  0779 5f            	clrw	x
3260  077a 97            	ld	xl,a
3261  077b 1d0030        	subw	x,#48
3262  077e d60004        	ld	a,(_digitToSegment,x)
3263  0781 97            	ld	xl,a
3264  0782 7b13          	ld	a,(OFST-1,sp)
3265  0784 95            	ld	xh,a
3266  0785 cd00be        	call	_tm_displayCharacter
3268                     ; 498                     index++;
3270  0788 0c13          	inc	(OFST-1,sp)
3272                     ; 501                     if (index == 4) {
3274  078a 7b13          	ld	a,(OFST-1,sp)
3275  078c a104          	cp	a,#4
3276  078e 2703          	jreq	L471
3277  0790 cc06b1        	jp	L5621
3278  0793               L471:
3279                     ; 504                         if (!loggedIn) {
3281  0793 0d0d          	tnz	(OFST-7,sp)
3282  0795 2703          	jreq	L671
3283  0797 cc06b1        	jp	L5621
3284  079a               L671:
3285                     ; 506                             if (comparePIN(userInput, storedPIN)) {
3287  079a ae0000        	ldw	x,#_storedPIN
3288  079d 89            	pushw	x
3289  079e 96            	ldw	x,sp
3290  079f 1c0011        	addw	x,#OFST-3
3291  07a2 cd04e0        	call	_comparePIN
3293  07a5 85            	popw	x
3294  07a6 4d            	tnz	a
3295  07a7 2716          	jreq	L3331
3296                     ; 507 																beepSuccess();
3298  07a9 cd03b4        	call	_beepSuccess
3300                     ; 508 																loggedIn = 1;
3302  07ac a601          	ld	a,#1
3303  07ae 6b0d          	ld	(OFST-7,sp),a
3305                     ; 509                                 loginStartTime = milis();
3307  07b0 cd0000        	call	_milis
3309  07b3 cd0000        	call	c_uitolx
3311  07b6 96            	ldw	x,sp
3312  07b7 1c0009        	addw	x,#OFST-11
3313  07ba cd0000        	call	c_rtol
3317  07bd 2009          	jra	L5331
3318  07bf               L3331:
3319                     ; 511                                 beepFail();
3321  07bf cd040c        	call	_beepFail
3323                     ; 512 																blinkLED(1, 'r');
3325  07c2 ae0172        	ldw	x,#370
3326  07c5 cd0558        	call	_blinkLED
3328  07c8               L5331:
3329                     ; 516                             index = 0;
3331  07c8 0f13          	clr	(OFST-1,sp)
3333                     ; 517                             for (j = 0; j < 4; j++) {
3335  07ca 0f14          	clr	(OFST+0,sp)
3337  07cc               L7331:
3338                     ; 518                                 userInput[j] = ' ';
3340  07cc 96            	ldw	x,sp
3341  07cd 1c000f        	addw	x,#OFST-5
3342  07d0 9f            	ld	a,xl
3343  07d1 5e            	swapw	x
3344  07d2 1b14          	add	a,(OFST+0,sp)
3345  07d4 2401          	jrnc	L451
3346  07d6 5c            	incw	x
3347  07d7               L451:
3348  07d7 02            	rlwa	x,a
3349  07d8 a620          	ld	a,#32
3350  07da f7            	ld	(x),a
3351                     ; 519                                 tm_displayCharacter(j, 0x00);
3353  07db 7b14          	ld	a,(OFST+0,sp)
3354  07dd 5f            	clrw	x
3355  07de 95            	ld	xh,a
3356  07df cd00be        	call	_tm_displayCharacter
3358                     ; 517                             for (j = 0; j < 4; j++) {
3360  07e2 0c14          	inc	(OFST+0,sp)
3364  07e4 7b14          	ld	a,(OFST+0,sp)
3365  07e6 a104          	cp	a,#4
3366  07e8 25e2          	jrult	L7331
3367  07ea acb106b1      	jpf	L5621
3368  07ee               L3231:
3369                     ; 524             } else if (key == '*') {
3371  07ee 7b0e          	ld	a,(OFST-6,sp)
3372  07f0 a12a          	cp	a,#42
3373  07f2 2623          	jrne	L7431
3374                     ; 526                 if (index > 0) {
3376  07f4 0d13          	tnz	(OFST-1,sp)
3377  07f6 2603          	jrne	L002
3378  07f8 cc06b1        	jp	L5621
3379  07fb               L002:
3380                     ; 527                     index--;
3382  07fb 0a13          	dec	(OFST-1,sp)
3384                     ; 528                     userInput[index] = ' ';
3386  07fd 96            	ldw	x,sp
3387  07fe 1c000f        	addw	x,#OFST-5
3388  0801 9f            	ld	a,xl
3389  0802 5e            	swapw	x
3390  0803 1b13          	add	a,(OFST-1,sp)
3391  0805 2401          	jrnc	L651
3392  0807 5c            	incw	x
3393  0808               L651:
3394  0808 02            	rlwa	x,a
3395  0809 a620          	ld	a,#32
3396  080b f7            	ld	(x),a
3397                     ; 529                     tm_displayCharacter(index, 0x00);
3399  080c 7b13          	ld	a,(OFST-1,sp)
3400  080e 5f            	clrw	x
3401  080f 95            	ld	xh,a
3402  0810 cd00be        	call	_tm_displayCharacter
3404  0813 acb106b1      	jpf	L5621
3405  0817               L7431:
3406                     ; 531             } else if (key == '#') {
3408  0817 7b0e          	ld	a,(OFST-6,sp)
3409  0819 a123          	cp	a,#35
3410  081b 2703          	jreq	L202
3411  081d cc06b1        	jp	L5621
3412  0820               L202:
3413                     ; 533                 if (loggedIn && index == 4) {
3415  0820 0d0d          	tnz	(OFST-7,sp)
3416  0822 2603          	jrne	L402
3417  0824 cc06b1        	jp	L5621
3418  0827               L402:
3420  0827 7b13          	ld	a,(OFST-1,sp)
3421  0829 a104          	cp	a,#4
3422  082b 2703          	jreq	L602
3423  082d cc06b1        	jp	L5621
3424  0830               L602:
3425                     ; 534                     savePINtoEEPROM(userInput);
3427  0830 96            	ldw	x,sp
3428  0831 1c000f        	addw	x,#OFST-5
3429  0834 cd04ac        	call	_savePINtoEEPROM
3431                     ; 535                     blinkDisplay(2);  
3433  0837 a602          	ld	a,#2
3434  0839 cd0509        	call	_blinkDisplay
3436                     ; 538                     for (j = 0; j < 4; j++) {
3438  083c 0f14          	clr	(OFST+0,sp)
3440  083e               L1631:
3441                     ; 539                         storedPIN[j] = userInput[j];
3443  083e 7b14          	ld	a,(OFST+0,sp)
3444  0840 5f            	clrw	x
3445  0841 97            	ld	xl,a
3446  0842 89            	pushw	x
3447  0843 96            	ldw	x,sp
3448  0844 1c0011        	addw	x,#OFST-3
3449  0847 9f            	ld	a,xl
3450  0848 5e            	swapw	x
3451  0849 1b16          	add	a,(OFST+2,sp)
3452  084b 2401          	jrnc	L061
3453  084d 5c            	incw	x
3454  084e               L061:
3455  084e 02            	rlwa	x,a
3456  084f f6            	ld	a,(x)
3457  0850 85            	popw	x
3458  0851 e700          	ld	(_storedPIN,x),a
3459                     ; 538                     for (j = 0; j < 4; j++) {
3461  0853 0c14          	inc	(OFST+0,sp)
3465  0855 7b14          	ld	a,(OFST+0,sp)
3466  0857 a104          	cp	a,#4
3467  0859 25e3          	jrult	L1631
3468                     ; 543                     loggedIn = 0;
3470  085b 0f0d          	clr	(OFST-7,sp)
3472                     ; 544                     index = 0;
3474  085d 0f13          	clr	(OFST-1,sp)
3476                     ; 545 										blinkLED(1, '');
3478  085f ae0100        	ldw	x,#256
3479  0862 cd0558        	call	_blinkLED
3481                     ; 546                     for (j = 0; j < 4; j++) {
3483  0865 0f14          	clr	(OFST+0,sp)
3485  0867               L7631:
3486                     ; 547                         userInput[j] = ' ';
3488  0867 96            	ldw	x,sp
3489  0868 1c000f        	addw	x,#OFST-5
3490  086b 9f            	ld	a,xl
3491  086c 5e            	swapw	x
3492  086d 1b14          	add	a,(OFST+0,sp)
3493  086f 2401          	jrnc	L261
3494  0871 5c            	incw	x
3495  0872               L261:
3496  0872 02            	rlwa	x,a
3497  0873 a620          	ld	a,#32
3498  0875 f7            	ld	(x),a
3499                     ; 548                         tm_displayCharacter(j, 0x00);
3501  0876 7b14          	ld	a,(OFST+0,sp)
3502  0878 5f            	clrw	x
3503  0879 95            	ld	xh,a
3504  087a cd00be        	call	_tm_displayCharacter
3506                     ; 546                     for (j = 0; j < 4; j++) {
3508  087d 0c14          	inc	(OFST+0,sp)
3512  087f 7b14          	ld	a,(OFST+0,sp)
3513  0881 a104          	cp	a,#4
3514  0883 25e2          	jrult	L7631
3515  0885 acb106b1      	jpf	L5621
3550                     ; 561 void assert_failed(uint8_t* file, uint32_t line) {
3551                     	switch	.text
3552  0889               _assert_failed:
3556  0889               L3141:
3557                     ; 562     while (1);
3559  0889 20fe          	jra	L3141
3604                     	xdef	_main
3605                     	xdef	_logoutSignal
3606                     	xdef	_factoryResetPIN
3607                     	xdef	_blinkDisplay
3608                     	xdef	_comparePIN
3609                     	xdef	_savePINtoEEPROM
3610                     	xdef	_loadPINfromEEPROM
3611                     	xdef	_EEPROM_WriteByte
3612                     	xdef	_EEPROM_ReadByte
3613                     	xdef	_digitToSegment
3614                     	xdef	_blinkLED
3615                     	xdef	_beepTone
3616                     	xdef	_beepFail
3617                     	xdef	_beepSuccess
3618                     	xdef	_buzzerInit
3619                     	xdef	_getKey
3620                     	xdef	_initKeypad
3621                     	xdef	_delay_us
3622                     	xdef	_tm_displayCharacter
3623                     	xdef	_tm_writeByte
3624                     	xdef	_tm_stop
3625                     	xdef	_tm_start
3626                     	xdef	_setCLK
3627                     	xdef	_setDIO
3628                     	switch	.ubsct
3629  0000               _storedPIN:
3630  0000 00000000      	ds.b	4
3631                     	xdef	_storedPIN
3632                     	xdef	_defaultPIN
3633                     	xref	_init_milis
3634                     	xref	_delay_ms
3635                     	xref	_milis
3636                     	xdef	_assert_failed
3637                     	xref	_GPIO_ReadInputPin
3638                     	xref	_GPIO_WriteLow
3639                     	xref	_GPIO_WriteHigh
3640                     	xref	_GPIO_Init
3641                     	xref	_FLASH_ProgramByte
3642                     	xref	_FLASH_Lock
3643                     	xref	_FLASH_Unlock
3644                     	xref	_CLK_HSIPrescalerConfig
3645                     	xref.b	c_lreg
3646                     	xref.b	c_x
3647                     	xref.b	c_y
3667                     	xref	c_lsub
3668                     	xref	c_ludv
3669                     	xref	c_umul
3670                     	xref	c_ldiv
3671                     	xref	c_rtol
3672                     	xref	c_uitolx
3673                     	xref	c_bmulx
3674                     	xref	c_lcmp
3675                     	xref	c_ltor
3676                     	xref	c_lgadc
3677                     	xref	c_xymov
3678                     	end
