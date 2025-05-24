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
  73                     ; 70 void setDIO(uint8_t state) {
  75                     	switch	.text
  76  0000               _setDIO:
  80                     ; 71     if (state) GPIO_WriteHigh(TM_DIO_PORT, TM_DIO_PIN);
  82  0000 4d            	tnz	a
  83  0001 270b          	jreq	L72
  86  0003 4b10          	push	#16
  87  0005 ae5005        	ldw	x,#20485
  88  0008 cd0000        	call	_GPIO_WriteHigh
  90  000b 84            	pop	a
  92  000c 2009          	jra	L13
  93  000e               L72:
  94                     ; 72     else GPIO_WriteLow(TM_DIO_PORT, TM_DIO_PIN);
  96  000e 4b10          	push	#16
  97  0010 ae5005        	ldw	x,#20485
  98  0013 cd0000        	call	_GPIO_WriteLow
 100  0016 84            	pop	a
 101  0017               L13:
 102                     ; 73 }
 105  0017 81            	ret
 141                     ; 75 void setCLK(uint8_t state) {
 142                     	switch	.text
 143  0018               _setCLK:
 147                     ; 76     if (state) GPIO_WriteHigh(TM_CLK_PORT, TM_CLK_PIN);
 149  0018 4d            	tnz	a
 150  0019 270b          	jreq	L15
 153  001b 4b20          	push	#32
 154  001d ae5005        	ldw	x,#20485
 155  0020 cd0000        	call	_GPIO_WriteHigh
 157  0023 84            	pop	a
 159  0024 2009          	jra	L35
 160  0026               L15:
 161                     ; 77     else GPIO_WriteLow(TM_CLK_PORT, TM_CLK_PIN);
 163  0026 4b20          	push	#32
 164  0028 ae5005        	ldw	x,#20485
 165  002b cd0000        	call	_GPIO_WriteLow
 167  002e 84            	pop	a
 168  002f               L35:
 169                     ; 78 }
 172  002f 81            	ret
 198                     ; 80 void tm_start(void) {
 199                     	switch	.text
 200  0030               _tm_start:
 204                     ; 81     setCLK(1);
 206  0030 a601          	ld	a,#1
 207  0032 ade4          	call	_setCLK
 209                     ; 82     setDIO(1);
 211  0034 a601          	ld	a,#1
 212  0036 adc8          	call	_setDIO
 214                     ; 83     delay_us(2);
 216  0038 ae0002        	ldw	x,#2
 217  003b cd00e4        	call	_delay_us
 219                     ; 84     setDIO(0);
 221  003e 4f            	clr	a
 222  003f adbf          	call	_setDIO
 224                     ; 85     delay_us(2);
 226  0041 ae0002        	ldw	x,#2
 227  0044 cd00e4        	call	_delay_us
 229                     ; 86     setCLK(0);
 231  0047 4f            	clr	a
 232  0048 adce          	call	_setCLK
 234                     ; 87 }
 237  004a 81            	ret
 263                     ; 89 void tm_stop(void) {
 264                     	switch	.text
 265  004b               _tm_stop:
 269                     ; 90     setCLK(0);
 271  004b 4f            	clr	a
 272  004c adca          	call	_setCLK
 274                     ; 91     delay_us(2);
 276  004e ae0002        	ldw	x,#2
 277  0051 cd00e4        	call	_delay_us
 279                     ; 92     setDIO(0);
 281  0054 4f            	clr	a
 282  0055 ada9          	call	_setDIO
 284                     ; 93     delay_us(2);
 286  0057 ae0002        	ldw	x,#2
 287  005a cd00e4        	call	_delay_us
 289                     ; 94     setCLK(1);
 291  005d a601          	ld	a,#1
 292  005f adb7          	call	_setCLK
 294                     ; 95     delay_us(2);
 296  0061 ae0002        	ldw	x,#2
 297  0064 ad7e          	call	_delay_us
 299                     ; 96     setDIO(1);
 301  0066 a601          	ld	a,#1
 302  0068 ad96          	call	_setDIO
 304                     ; 97 }
 307  006a 81            	ret
 354                     ; 99 void tm_writeByte(uint8_t b) {
 355                     	switch	.text
 356  006b               _tm_writeByte:
 358  006b 88            	push	a
 359  006c 88            	push	a
 360       00000001      OFST:	set	1
 363                     ; 101     for (i = 0; i < 8; i++) {
 365  006d 0f01          	clr	(OFST+0,sp)
 367  006f               L711:
 368                     ; 102         setCLK(0);
 370  006f 4f            	clr	a
 371  0070 ada6          	call	_setCLK
 373                     ; 103         setDIO(b & 0x01);
 375  0072 7b02          	ld	a,(OFST+1,sp)
 376  0074 a401          	and	a,#1
 377  0076 ad88          	call	_setDIO
 379                     ; 104         delay_us(3);
 381  0078 ae0003        	ldw	x,#3
 382  007b ad67          	call	_delay_us
 384                     ; 105         setCLK(1);
 386  007d a601          	ld	a,#1
 387  007f ad97          	call	_setCLK
 389                     ; 106         delay_us(3);
 391  0081 ae0003        	ldw	x,#3
 392  0084 ad5e          	call	_delay_us
 394                     ; 107         b >>= 1;
 396  0086 0402          	srl	(OFST+1,sp)
 397                     ; 101     for (i = 0; i < 8; i++) {
 399  0088 0c01          	inc	(OFST+0,sp)
 403  008a 7b01          	ld	a,(OFST+0,sp)
 404  008c a108          	cp	a,#8
 405  008e 25df          	jrult	L711
 406                     ; 111     setCLK(0);
 408  0090 4f            	clr	a
 409  0091 ad85          	call	_setCLK
 411                     ; 112     GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_IN_FL_NO_IT); // input
 413  0093 4b00          	push	#0
 414  0095 4b10          	push	#16
 415  0097 ae5005        	ldw	x,#20485
 416  009a cd0000        	call	_GPIO_Init
 418  009d 85            	popw	x
 419                     ; 113     delay_us(5);
 421  009e ae0005        	ldw	x,#5
 422  00a1 ad41          	call	_delay_us
 424                     ; 114     setCLK(1);
 426  00a3 a601          	ld	a,#1
 427  00a5 cd0018        	call	_setCLK
 429                     ; 115     delay_us(5);
 431  00a8 ae0005        	ldw	x,#5
 432  00ab ad37          	call	_delay_us
 434                     ; 116     setCLK(0);
 436  00ad 4f            	clr	a
 437  00ae cd0018        	call	_setCLK
 439                     ; 117     GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_OUT_PP_LOW_FAST); // output
 441  00b1 4be0          	push	#224
 442  00b3 4b10          	push	#16
 443  00b5 ae5005        	ldw	x,#20485
 444  00b8 cd0000        	call	_GPIO_Init
 446  00bb 85            	popw	x
 447                     ; 118 }
 450  00bc 85            	popw	x
 451  00bd 81            	ret
 498                     ; 120 void tm_displayCharacter(uint8_t pos, uint8_t character) {
 499                     	switch	.text
 500  00be               _tm_displayCharacter:
 502  00be 89            	pushw	x
 503       00000000      OFST:	set	0
 506                     ; 121     tm_start();
 508  00bf cd0030        	call	_tm_start
 510                     ; 122     tm_writeByte(0x40); // auto-increment mode
 512  00c2 a640          	ld	a,#64
 513  00c4 ada5          	call	_tm_writeByte
 515                     ; 123     tm_stop();
 517  00c6 ad83          	call	_tm_stop
 519                     ; 125     tm_start();
 521  00c8 cd0030        	call	_tm_start
 523                     ; 126     tm_writeByte(0xC0 | pos); // start address + position
 525  00cb 7b01          	ld	a,(OFST+1,sp)
 526  00cd aac0          	or	a,#192
 527  00cf ad9a          	call	_tm_writeByte
 529                     ; 127     tm_writeByte(character);
 531  00d1 7b02          	ld	a,(OFST+2,sp)
 532  00d3 ad96          	call	_tm_writeByte
 534                     ; 128     tm_stop();
 536  00d5 cd004b        	call	_tm_stop
 538                     ; 130     tm_start();
 540  00d8 cd0030        	call	_tm_start
 542                     ; 131     tm_writeByte(0x88); // display ON, brightness medium
 544  00db a688          	ld	a,#136
 545  00dd ad8c          	call	_tm_writeByte
 547                     ; 132     tm_stop();
 549  00df cd004b        	call	_tm_stop
 551                     ; 133 }
 554  00e2 85            	popw	x
 555  00e3 81            	ret
 599                     ; 135 void delay_us(uint16_t us) {
 600                     	switch	.text
 601  00e4               _delay_us:
 603  00e4 89            	pushw	x
 604  00e5 89            	pushw	x
 605       00000002      OFST:	set	2
 608                     ; 137     for (i = 0; i < us; i++) {
 610  00e6 5f            	clrw	x
 611  00e7 1f01          	ldw	(OFST-1,sp),x
 614  00e9 200f          	jra	L571
 615  00eb               L171:
 616                     ; 138         _asm("nop"); _asm("nop"); _asm("nop"); _asm("nop");
 619  00eb 9d            nop
 624  00ec 9d            nop
 629  00ed 9d            nop
 634  00ee 9d            nop
 636                     ; 139         _asm("nop"); _asm("nop"); _asm("nop"); _asm("nop");
 639  00ef 9d            nop
 644  00f0 9d            nop
 649  00f1 9d            nop
 654  00f2 9d            nop
 656                     ; 137     for (i = 0; i < us; i++) {
 658  00f3 1e01          	ldw	x,(OFST-1,sp)
 659  00f5 1c0001        	addw	x,#1
 660  00f8 1f01          	ldw	(OFST-1,sp),x
 662  00fa               L571:
 665  00fa 1e01          	ldw	x,(OFST-1,sp)
 666  00fc 1303          	cpw	x,(OFST+1,sp)
 667  00fe 25eb          	jrult	L171
 668                     ; 141 }
 671  0100 5b04          	addw	sp,#4
 672  0102 81            	ret
 696                     ; 143 void initKeypad(void) {
 697                     	switch	.text
 698  0103               _initKeypad:
 702                     ; 145     GPIO_Init(GPIOD, ROW1_PIN | ROW2_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
 704  0103 4be0          	push	#224
 705  0105 4b60          	push	#96
 706  0107 ae500f        	ldw	x,#20495
 707  010a cd0000        	call	_GPIO_Init
 709  010d 85            	popw	x
 710                     ; 146     GPIO_Init(GPIOE, ROW3_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
 712  010e 4be0          	push	#224
 713  0110 4b01          	push	#1
 714  0112 ae5014        	ldw	x,#20500
 715  0115 cd0000        	call	_GPIO_Init
 717  0118 85            	popw	x
 718                     ; 147     GPIO_Init(GPIOC, ROW4_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
 720  0119 4be0          	push	#224
 721  011b 4b02          	push	#2
 722  011d ae500a        	ldw	x,#20490
 723  0120 cd0000        	call	_GPIO_Init
 725  0123 85            	popw	x
 726                     ; 150     GPIO_Init(GPIOG, COL1_PIN, GPIO_MODE_IN_PU_NO_IT);
 728  0124 4b40          	push	#64
 729  0126 4b01          	push	#1
 730  0128 ae501e        	ldw	x,#20510
 731  012b cd0000        	call	_GPIO_Init
 733  012e 85            	popw	x
 734                     ; 151     GPIO_Init(GPIOC, COL2_PIN | COL3_PIN, GPIO_MODE_IN_PU_NO_IT);
 736  012f 4b40          	push	#64
 737  0131 4b0c          	push	#12
 738  0133 ae500a        	ldw	x,#20490
 739  0136 cd0000        	call	_GPIO_Init
 741  0139 85            	popw	x
 742                     ; 152 }
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
 854                     ; 154 char getKey(void) {
 855                     	switch	.text
 856  013b               _getKey:
 858  013b 5218          	subw	sp,#24
 859       00000018      OFST:	set	24
 862                     ; 155     const char keyMap[4][3] = {
 862                     ; 156         {'1', '2', '3'},
 862                     ; 157         {'4', '5', '6'},
 862                     ; 158         {'7', '8', '9'},
 862                     ; 159         {'*', '0', '#'}
 862                     ; 160     };
 864  013d 96            	ldw	x,sp
 865  013e 1c0004        	addw	x,#OFST-20
 866  0141 90ae000e      	ldw	y,#L112_keyMap
 867  0145 a60c          	ld	a,#12
 868  0147 cd0000        	call	c_xymov
 870                     ; 163     char key = 0;
 872                     ; 167     GPIOD->ODR |= ROW1_PIN | ROW2_PIN;
 874  014a c6500f        	ld	a,20495
 875  014d aa60          	or	a,#96
 876  014f c7500f        	ld	20495,a
 877                     ; 168     GPIOE->ODR |= ROW3_PIN;
 879  0152 72105014      	bset	20500,#0
 880                     ; 169     GPIOC->ODR |= ROW4_PIN;
 882  0156 7212500a      	bset	20490,#1
 883                     ; 171     for (row = 0; row < 4; row++) {
 885  015a 5f            	clrw	x
 886  015b 1f11          	ldw	(OFST-7,sp),x
 888  015d               L333:
 889                     ; 173         switch (row) {
 891  015d 1e11          	ldw	x,(OFST-7,sp)
 893                     ; 177             case 3: GPIOC->ODR &= ~ROW4_PIN; break;
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
 904                     ; 174             case 0: GPIOD->ODR &= ~ROW1_PIN; break;
 906  016d 721d500f      	bres	20495,#6
 909  0171 2010          	jra	L343
 910  0173               L512:
 911                     ; 175             case 1: GPIOD->ODR &= ~ROW2_PIN; break;
 913  0173 721b500f      	bres	20495,#5
 916  0177 200a          	jra	L343
 917  0179               L712:
 918                     ; 176             case 2: GPIOE->ODR &= ~ROW3_PIN; break;
 920  0179 72115014      	bres	20500,#0
 923  017d 2004          	jra	L343
 924  017f               L122:
 925                     ; 177             case 3: GPIOC->ODR &= ~ROW4_PIN; break;
 927  017f 7213500a      	bres	20490,#1
 930  0183               L343:
 931                     ; 180         for (i = 0; i < 1000; i++); // malé zpoždìní
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
 958                     ; 182         for (col = 0; col < 3; col++) {
 960  01a5 5f            	clrw	x
 961  01a6 1f17          	ldw	(OFST-1,sp),x
 963  01a8               L353:
 964                     ; 183             uint8_t colState = 1;
 966  01a8 a601          	ld	a,#1
 967  01aa 6b03          	ld	(OFST-21,sp),a
 969                     ; 185             switch (col) {
 971  01ac 1e17          	ldw	x,(OFST-1,sp)
 973                     ; 188                 case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
 974  01ae 5d            	tnzw	x
 975  01af 2708          	jreq	L322
 976  01b1 5a            	decw	x
 977  01b2 2715          	jreq	L522
 978  01b4 5a            	decw	x
 979  01b5 2722          	jreq	L722
 980  01b7 202e          	jra	L363
 981  01b9               L322:
 982                     ; 186                 case 0: colState = !(GPIOG->IDR & COL1_PIN); break;
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
 998                     ; 187                 case 1: colState = !(GPIOC->IDR & COL2_PIN); break;
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
1014                     ; 188                 case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
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
1029                     ; 191             if (colState) {
1031  01e7 0d03          	tnz	(OFST-21,sp)
1032  01e9 2603          	jrne	L001
1033  01eb cc02d3        	jp	L563
1034  01ee               L001:
1035                     ; 192                 for (i = 0; i < 30000; i++); // debounce
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
1062                     ; 195                 switch (col) {
1064  0210 1e17          	ldw	x,(OFST-1,sp)
1066                     ; 198                     case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
1067  0212 5d            	tnzw	x
1068  0213 2708          	jreq	L132
1069  0215 5a            	decw	x
1070  0216 2715          	jreq	L332
1071  0218 5a            	decw	x
1072  0219 2722          	jreq	L532
1073  021b 202e          	jra	L773
1074  021d               L132:
1075                     ; 196                     case 0: colState = !(GPIOG->IDR & COL1_PIN); break;
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
1091                     ; 197                     case 1: colState = !(GPIOC->IDR & COL2_PIN); break;
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
1107                     ; 198                     case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
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
1122                     ; 201                 if (colState) {
1124  024b 0d03          	tnz	(OFST-21,sp)
1125  024d 2603          	jrne	L201
1126  024f cc02d3        	jp	L563
1127  0252               L201:
1128                     ; 202                     key = keyMap[row][col];
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
1144                     ; 206                         uint8_t released = 0;
1146  0268 0f03          	clr	(OFST-21,sp)
1148                     ; 207                         switch (col) {
1150  026a 1e17          	ldw	x,(OFST-1,sp)
1152                     ; 210                             case 2: released = (GPIOC->IDR & COL3_PIN) != 0; break;
1153  026c 5d            	tnzw	x
1154  026d 2708          	jreq	L732
1155  026f 5a            	decw	x
1156  0270 2715          	jreq	L142
1157  0272 5a            	decw	x
1158  0273 2722          	jreq	L342
1159  0275 202e          	jra	L114
1160  0277               L732:
1161                     ; 208                             case 0: released = (GPIOG->IDR & COL1_PIN) != 0; break;
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
1177                     ; 209                             case 1: released = (GPIOC->IDR & COL2_PIN) != 0; break;
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
1193                     ; 210                             case 2: released = (GPIOC->IDR & COL3_PIN) != 0; break;
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
1208                     ; 212                         if (released) break;
1210  02a5 0d03          	tnz	(OFST-21,sp)
1211  02a7 27bf          	jreq	L304
1213                     ; 216                     switch (row) {
1215  02a9 1e11          	ldw	x,(OFST-7,sp)
1217                     ; 220                         case 3: GPIOC->ODR |= ROW4_PIN; break;
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
1228                     ; 217                         case 0: GPIOD->ODR |= ROW1_PIN; break;
1230  02b9 721c500f      	bset	20495,#6
1233  02bd 2010          	jra	L714
1234  02bf               L742:
1235                     ; 218                         case 1: GPIOD->ODR |= ROW2_PIN; break;
1237  02bf 721a500f      	bset	20495,#5
1240  02c3 200a          	jra	L714
1241  02c5               L152:
1242                     ; 219                         case 2: GPIOE->ODR |= ROW3_PIN; break;
1244  02c5 72105014      	bset	20500,#0
1247  02c9 2004          	jra	L714
1248  02cb               L352:
1249                     ; 220                         case 3: GPIOC->ODR |= ROW4_PIN; break;
1251  02cb 7212500a      	bset	20490,#1
1254  02cf               L714:
1255                     ; 223                     return key;
1257  02cf 7b10          	ld	a,(OFST-8,sp)
1259  02d1 204b          	jra	L67
1260  02d3               L563:
1261                     ; 182         for (col = 0; col < 3; col++) {
1263  02d3 1e17          	ldw	x,(OFST-1,sp)
1264  02d5 1c0001        	addw	x,#1
1265  02d8 1f17          	ldw	(OFST-1,sp),x
1269  02da 9c            	rvf
1270  02db 1e17          	ldw	x,(OFST-1,sp)
1271  02dd a30003        	cpw	x,#3
1272  02e0 2e03          	jrsge	L401
1273  02e2 cc01a8        	jp	L353
1274  02e5               L401:
1275                     ; 229         switch (row) {
1277  02e5 1e11          	ldw	x,(OFST-7,sp)
1279                     ; 233             case 3: GPIOC->ODR |= ROW4_PIN; break;
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
1290                     ; 230             case 0: GPIOD->ODR |= ROW1_PIN; break;
1292  02f5 721c500f      	bset	20495,#6
1295  02f9 2010          	jra	L324
1296  02fb               L752:
1297                     ; 231             case 1: GPIOD->ODR |= ROW2_PIN; break;
1299  02fb 721a500f      	bset	20495,#5
1302  02ff 200a          	jra	L324
1303  0301               L162:
1304                     ; 232             case 2: GPIOE->ODR |= ROW3_PIN; break;
1306  0301 72105014      	bset	20500,#0
1309  0305 2004          	jra	L324
1310  0307               L362:
1311                     ; 233             case 3: GPIOC->ODR |= ROW4_PIN; break;
1313  0307 7212500a      	bset	20490,#1
1316  030b               L324:
1317                     ; 171     for (row = 0; row < 4; row++) {
1319  030b 1e11          	ldw	x,(OFST-7,sp)
1320  030d 1c0001        	addw	x,#1
1321  0310 1f11          	ldw	(OFST-7,sp),x
1325  0312 9c            	rvf
1326  0313 1e11          	ldw	x,(OFST-7,sp)
1327  0315 a30004        	cpw	x,#4
1328  0318 2e03          	jrsge	L601
1329  031a cc015d        	jp	L333
1330  031d               L601:
1331                     ; 237     return 0; // žádná klávesa
1333  031d 4f            	clr	a
1335  031e               L67:
1337  031e 5b18          	addw	sp,#24
1338  0320 81            	ret
1363                     ; 242 void buzzerInit(void) {
1364                     	switch	.text
1365  0321               _buzzerInit:
1369                     ; 244     GPIO_Init(BUZZER_PORT, BUZZER_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
1371  0321 4be0          	push	#224
1372  0323 4b08          	push	#8
1373  0325 ae500f        	ldw	x,#20495
1374  0328 cd0000        	call	_GPIO_Init
1376  032b 85            	popw	x
1377                     ; 245     GPIO_WriteLow(BUZZER_PORT, BUZZER_PIN);
1379  032c 4b08          	push	#8
1380  032e ae500f        	ldw	x,#20495
1381  0331 cd0000        	call	_GPIO_WriteLow
1383  0334 84            	pop	a
1384                     ; 246 }
1387  0335 81            	ret
1460                     ; 248 void beepTone(uint16_t freq, uint16_t duration_ms) {
1461                     	switch	.text
1462  0336               _beepTone:
1464  0336 89            	pushw	x
1465  0337 5210          	subw	sp,#16
1466       00000010      OFST:	set	16
1469                     ; 252     uint32_t delay = 1000000 / (freq * 2); // poloviny periody v us
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
1492                     ; 253     uint32_t cycles = (uint32_t)freq * duration_ms / 1000;
1494  035c 1e11          	ldw	x,(OFST+1,sp)
1495  035e 1615          	ldw	y,(OFST+5,sp)
1496  0360 cd0000        	call	c_umul
1498  0363 ae001a        	ldw	x,#L62
1499  0366 cd0000        	call	c_ludv
1501  0369 96            	ldw	x,sp
1502  036a 1c0005        	addw	x,#OFST-11
1503  036d cd0000        	call	c_rtol
1506                     ; 255     for (i = 0; i < cycles; i++) {
1508  0370 ae0000        	ldw	x,#0
1509  0373 1f0b          	ldw	(OFST-5,sp),x
1510  0375 ae0000        	ldw	x,#0
1511  0378 1f09          	ldw	(OFST-7,sp),x
1514  037a 2025          	jra	L774
1515  037c               L374:
1516                     ; 256         GPIO_WriteHigh(BUZZER_PORT, BUZZER_PIN);
1518  037c 4b08          	push	#8
1519  037e ae500f        	ldw	x,#20495
1520  0381 cd0000        	call	_GPIO_WriteHigh
1522  0384 84            	pop	a
1523                     ; 257         delay_us(delay);
1525  0385 1e0f          	ldw	x,(OFST-1,sp)
1526  0387 cd00e4        	call	_delay_us
1528                     ; 258         GPIO_WriteLow(BUZZER_PORT, BUZZER_PIN);
1530  038a 4b08          	push	#8
1531  038c ae500f        	ldw	x,#20495
1532  038f cd0000        	call	_GPIO_WriteLow
1534  0392 84            	pop	a
1535                     ; 259         delay_us(delay);
1537  0393 1e0f          	ldw	x,(OFST-1,sp)
1538  0395 cd00e4        	call	_delay_us
1540                     ; 255     for (i = 0; i < cycles; i++) {
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
1560                     ; 261 }
1563  03b1 5b12          	addw	sp,#18
1564  03b3 81            	ret
1588                     ; 263 void beepSuccess(void) {
1589                     	switch	.text
1590  03b4               _beepSuccess:
1594                     ; 264     beepTone(1000, 100);
1596  03b4 ae0064        	ldw	x,#100
1597  03b7 89            	pushw	x
1598  03b8 ae03e8        	ldw	x,#1000
1599  03bb cd0336        	call	_beepTone
1601  03be 85            	popw	x
1602                     ; 265 }
1605  03bf 81            	ret
1630                     ; 267 void beepFail(void) {
1631                     	switch	.text
1632  03c0               _beepFail:
1636                     ; 268     beepTone(500, 100);
1638  03c0 ae0064        	ldw	x,#100
1639  03c3 89            	pushw	x
1640  03c4 ae01f4        	ldw	x,#500
1641  03c7 cd0336        	call	_beepTone
1643  03ca 85            	popw	x
1644                     ; 269     delay_us(100000);
1646  03cb ae86a0        	ldw	x,#34464
1647  03ce cd00e4        	call	_delay_us
1649                     ; 270     beepTone(500, 100);
1651  03d1 ae0064        	ldw	x,#100
1652  03d4 89            	pushw	x
1653  03d5 ae01f4        	ldw	x,#500
1654  03d8 cd0336        	call	_beepTone
1656  03db 85            	popw	x
1657                     ; 271 }
1660  03dc 81            	ret
1694                     ; 274 uint8_t EEPROM_ReadByte(uint16_t addr) {
1695                     	switch	.text
1696  03dd               _EEPROM_ReadByte:
1700                     ; 276     return *((uint8_t*)addr);
1702  03dd f6            	ld	a,(x)
1705  03de 81            	ret
1751                     ; 280 void EEPROM_WriteByte(uint16_t addr, uint8_t data) {
1752                     	switch	.text
1753  03df               _EEPROM_WriteByte:
1755  03df 89            	pushw	x
1756       00000000      OFST:	set	0
1759                     ; 282     FLASH_Unlock(FLASH_MEMTYPE_DATA);
1761  03e0 a6f7          	ld	a,#247
1762  03e2 cd0000        	call	_FLASH_Unlock
1764                     ; 283     FLASH_ProgramByte(addr, data);
1766  03e5 7b05          	ld	a,(OFST+5,sp)
1767  03e7 88            	push	a
1768  03e8 1e02          	ldw	x,(OFST+2,sp)
1769  03ea cd0000        	call	c_uitolx
1771  03ed be02          	ldw	x,c_lreg+2
1772  03ef 89            	pushw	x
1773  03f0 be00          	ldw	x,c_lreg
1774  03f2 89            	pushw	x
1775  03f3 cd0000        	call	_FLASH_ProgramByte
1777  03f6 5b05          	addw	sp,#5
1778                     ; 284     FLASH_Lock(FLASH_MEMTYPE_DATA);
1780  03f8 a6f7          	ld	a,#247
1781  03fa cd0000        	call	_FLASH_Lock
1783                     ; 285 }
1786  03fd 85            	popw	x
1787  03fe 81            	ret
1834                     ; 288 void loadPINfromEEPROM(void) {
1835                     	switch	.text
1836  03ff               _loadPINfromEEPROM:
1838  03ff 89            	pushw	x
1839       00000002      OFST:	set	2
1842                     ; 290     uint8_t valid = 1;
1844  0400 a601          	ld	a,#1
1845  0402 6b01          	ld	(OFST-1,sp),a
1847                     ; 291     for (i = 0; i < 4; i++) {
1849  0404 0f02          	clr	(OFST+0,sp)
1851  0406               L506:
1852                     ; 292         storedPIN[i] = EEPROM_ReadByte(EEPROM_PIN_ADDR + i);
1854  0406 7b02          	ld	a,(OFST+0,sp)
1855  0408 5f            	clrw	x
1856  0409 97            	ld	xl,a
1857  040a 89            	pushw	x
1858  040b 7b04          	ld	a,(OFST+2,sp)
1859  040d 5f            	clrw	x
1860  040e 97            	ld	xl,a
1861  040f 1c4000        	addw	x,#16384
1862  0412 adc9          	call	_EEPROM_ReadByte
1864  0414 85            	popw	x
1865  0415 e700          	ld	(_storedPIN,x),a
1866                     ; 294         if (storedPIN[i] < '0' || storedPIN[i] > '9') {
1868  0417 7b02          	ld	a,(OFST+0,sp)
1869  0419 5f            	clrw	x
1870  041a 97            	ld	xl,a
1871  041b e600          	ld	a,(_storedPIN,x)
1872  041d a130          	cp	a,#48
1873  041f 250a          	jrult	L516
1875  0421 7b02          	ld	a,(OFST+0,sp)
1876  0423 5f            	clrw	x
1877  0424 97            	ld	xl,a
1878  0425 e600          	ld	a,(_storedPIN,x)
1879  0427 a13a          	cp	a,#58
1880  0429 2502          	jrult	L316
1881  042b               L516:
1882                     ; 295             valid = 0;
1884  042b 0f01          	clr	(OFST-1,sp)
1886  042d               L316:
1887                     ; 291     for (i = 0; i < 4; i++) {
1889  042d 0c02          	inc	(OFST+0,sp)
1893  042f 7b02          	ld	a,(OFST+0,sp)
1894  0431 a104          	cp	a,#4
1895  0433 25d1          	jrult	L506
1896                     ; 298     if (!valid) {
1898  0435 0d01          	tnz	(OFST-1,sp)
1899  0437 2625          	jrne	L716
1900                     ; 300         for (i = 0; i < 4; i++) {
1902  0439 0f02          	clr	(OFST+0,sp)
1904  043b               L126:
1905                     ; 301             storedPIN[i] = defaultPIN[i];
1907  043b 7b02          	ld	a,(OFST+0,sp)
1908  043d 5f            	clrw	x
1909  043e 97            	ld	xl,a
1910  043f d60000        	ld	a,(_defaultPIN,x)
1911  0442 e700          	ld	(_storedPIN,x),a
1912                     ; 302             EEPROM_WriteByte(EEPROM_PIN_ADDR + i, defaultPIN[i]);
1914  0444 7b02          	ld	a,(OFST+0,sp)
1915  0446 5f            	clrw	x
1916  0447 97            	ld	xl,a
1917  0448 d60000        	ld	a,(_defaultPIN,x)
1918  044b 88            	push	a
1919  044c 7b03          	ld	a,(OFST+1,sp)
1920  044e 5f            	clrw	x
1921  044f 97            	ld	xl,a
1922  0450 1c4000        	addw	x,#16384
1923  0453 ad8a          	call	_EEPROM_WriteByte
1925  0455 84            	pop	a
1926                     ; 300         for (i = 0; i < 4; i++) {
1928  0456 0c02          	inc	(OFST+0,sp)
1932  0458 7b02          	ld	a,(OFST+0,sp)
1933  045a a104          	cp	a,#4
1934  045c 25dd          	jrult	L126
1935  045e               L716:
1936                     ; 305 }
1939  045e 85            	popw	x
1940  045f 81            	ret
1986                     ; 308 void savePINtoEEPROM(const char* newPIN) {
1987                     	switch	.text
1988  0460               _savePINtoEEPROM:
1990  0460 89            	pushw	x
1991  0461 88            	push	a
1992       00000001      OFST:	set	1
1995                     ; 310     for (i = 0; i < 4; i++) {
1997  0462 0f01          	clr	(OFST+0,sp)
1999  0464               L156:
2000                     ; 311         storedPIN[i] = newPIN[i];
2002  0464 7b01          	ld	a,(OFST+0,sp)
2003  0466 5f            	clrw	x
2004  0467 97            	ld	xl,a
2005  0468 7b01          	ld	a,(OFST+0,sp)
2006  046a 905f          	clrw	y
2007  046c 9097          	ld	yl,a
2008  046e 72f902        	addw	y,(OFST+1,sp)
2009  0471 90f6          	ld	a,(y)
2010  0473 e700          	ld	(_storedPIN,x),a
2011                     ; 312         EEPROM_WriteByte(EEPROM_PIN_ADDR + i, newPIN[i]);
2013  0475 7b01          	ld	a,(OFST+0,sp)
2014  0477 5f            	clrw	x
2015  0478 97            	ld	xl,a
2016  0479 72fb02        	addw	x,(OFST+1,sp)
2017  047c f6            	ld	a,(x)
2018  047d 88            	push	a
2019  047e 7b02          	ld	a,(OFST+1,sp)
2020  0480 5f            	clrw	x
2021  0481 97            	ld	xl,a
2022  0482 1c4000        	addw	x,#16384
2023  0485 cd03df        	call	_EEPROM_WriteByte
2025  0488 84            	pop	a
2026                     ; 310     for (i = 0; i < 4; i++) {
2028  0489 0c01          	inc	(OFST+0,sp)
2032  048b 7b01          	ld	a,(OFST+0,sp)
2033  048d a104          	cp	a,#4
2034  048f 25d3          	jrult	L156
2035                     ; 314 }
2038  0491 5b03          	addw	sp,#3
2039  0493 81            	ret
2093                     ; 317 uint8_t comparePIN(const char* a, const char* b) {
2094                     	switch	.text
2095  0494               _comparePIN:
2097  0494 89            	pushw	x
2098  0495 88            	push	a
2099       00000001      OFST:	set	1
2102                     ; 319     for (i = 0; i < 4; i++) {
2104  0496 0f01          	clr	(OFST+0,sp)
2106  0498               L507:
2107                     ; 320         if (a[i] != b[i]) return 0;
2109  0498 7b01          	ld	a,(OFST+0,sp)
2110  049a 5f            	clrw	x
2111  049b 97            	ld	xl,a
2112  049c 72fb06        	addw	x,(OFST+5,sp)
2113  049f 7b01          	ld	a,(OFST+0,sp)
2114  04a1 905f          	clrw	y
2115  04a3 9097          	ld	yl,a
2116  04a5 72f902        	addw	y,(OFST+1,sp)
2117  04a8 90f6          	ld	a,(y)
2118  04aa f1            	cp	a,(x)
2119  04ab 2703          	jreq	L317
2122  04ad 4f            	clr	a
2124  04ae 200a          	jra	L231
2125  04b0               L317:
2126                     ; 319     for (i = 0; i < 4; i++) {
2128  04b0 0c01          	inc	(OFST+0,sp)
2132  04b2 7b01          	ld	a,(OFST+0,sp)
2133  04b4 a104          	cp	a,#4
2134  04b6 25e0          	jrult	L507
2135                     ; 322     return 1;
2137  04b8 a601          	ld	a,#1
2139  04ba               L231:
2141  04ba 5b03          	addw	sp,#3
2142  04bc 81            	ret
2196                     ; 326 void blinkDisplay(uint8_t times) {
2197                     	switch	.text
2198  04bd               _blinkDisplay:
2200  04bd 88            	push	a
2201  04be 89            	pushw	x
2202       00000002      OFST:	set	2
2205                     ; 328     for (i = 0; i < times; i++) {
2207  04bf 0f01          	clr	(OFST-1,sp)
2210  04c1 2032          	jra	L747
2211  04c3               L347:
2212                     ; 330         for (j = 0; j < 4; j++) {
2214  04c3 0f02          	clr	(OFST+0,sp)
2216  04c5               L357:
2217                     ; 331             tm_displayCharacter(j, 0x7F); // 0x7F = všechny segmenty ON
2219  04c5 7b02          	ld	a,(OFST+0,sp)
2220  04c7 ae007f        	ldw	x,#127
2221  04ca 95            	ld	xh,a
2222  04cb cd00be        	call	_tm_displayCharacter
2224                     ; 330         for (j = 0; j < 4; j++) {
2226  04ce 0c02          	inc	(OFST+0,sp)
2230  04d0 7b02          	ld	a,(OFST+0,sp)
2231  04d2 a104          	cp	a,#4
2232  04d4 25ef          	jrult	L357
2233                     ; 333         delay_us(300000);  // ~300 ms (potøebuješ delší delay, mùžeš upravit)
2235  04d6 ae93e0        	ldw	x,#37856
2236  04d9 cd00e4        	call	_delay_us
2238                     ; 336         for (j = 0; j < 4; j++) {
2240  04dc 0f02          	clr	(OFST+0,sp)
2242  04de               L167:
2243                     ; 337             tm_displayCharacter(j, 0x00);
2245  04de 7b02          	ld	a,(OFST+0,sp)
2246  04e0 5f            	clrw	x
2247  04e1 95            	ld	xh,a
2248  04e2 cd00be        	call	_tm_displayCharacter
2250                     ; 336         for (j = 0; j < 4; j++) {
2252  04e5 0c02          	inc	(OFST+0,sp)
2256  04e7 7b02          	ld	a,(OFST+0,sp)
2257  04e9 a104          	cp	a,#4
2258  04eb 25f1          	jrult	L167
2259                     ; 339         delay_us(300000);
2261  04ed ae93e0        	ldw	x,#37856
2262  04f0 cd00e4        	call	_delay_us
2264                     ; 328     for (i = 0; i < times; i++) {
2266  04f3 0c01          	inc	(OFST-1,sp)
2268  04f5               L747:
2271  04f5 7b01          	ld	a,(OFST-1,sp)
2272  04f7 1103          	cp	a,(OFST+1,sp)
2273  04f9 25c8          	jrult	L347
2274                     ; 341 }
2277  04fb 5b03          	addw	sp,#3
2278  04fd 81            	ret
2305                     ; 345 void factoryResetPIN(void) {
2306                     	switch	.text
2307  04fe               _factoryResetPIN:
2311                     ; 346     savePINtoEEPROM(defaultPIN);
2313  04fe ae0000        	ldw	x,#_defaultPIN
2314  0501 cd0460        	call	_savePINtoEEPROM
2316                     ; 347     beepSuccess();
2318  0504 cd03b4        	call	_beepSuccess
2320                     ; 348     blinkDisplay(2); // blikni 2x po resetu
2322  0507 a602          	ld	a,#2
2323  0509 adb2          	call	_blinkDisplay
2325                     ; 349 }
2328  050b 81            	ret
2331                     	switch	.const
2332  0022               L777_userInput:
2333  0022 20            	dc.b	32
2334  0023 20            	dc.b	32
2335  0024 20            	dc.b	32
2336  0025 20            	dc.b	32
2470                     ; 352 void main(void) {
2471                     	switch	.text
2472  050c               _main:
2474  050c 5214          	subw	sp,#20
2475       00000014      OFST:	set	20
2478                     ; 353     char key = 0;
2480                     ; 354     char userInput[4] = {' ', ' ', ' ', ' '};
2482  050e 96            	ldw	x,sp
2483  050f 1c000f        	addw	x,#OFST-5
2484  0512 90ae0022      	ldw	y,#L777_userInput
2485  0516 a604          	ld	a,#4
2486  0518 cd0000        	call	c_xymov
2488                     ; 355     uint8_t index = 0;
2490  051b 0f13          	clr	(OFST-1,sp)
2492                     ; 357     uint8_t loggedIn = 0;
2494  051d 0f0d          	clr	(OFST-7,sp)
2496                     ; 358     uint32_t loginStartTime = 0;
2498  051f ae0000        	ldw	x,#0
2499  0522 1f0b          	ldw	(OFST-9,sp),x
2500  0524 ae0000        	ldw	x,#0
2501  0527 1f09          	ldw	(OFST-11,sp),x
2503                     ; 359     const uint32_t LOGIN_TIMEOUT_MS = 5000;
2505  0529 ae1388        	ldw	x,#5000
2506  052c 1f07          	ldw	(OFST-13,sp),x
2507  052e ae0000        	ldw	x,#0
2508  0531 1f05          	ldw	(OFST-15,sp),x
2510                     ; 361     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
2512  0533 4f            	clr	a
2513  0534 cd0000        	call	_CLK_HSIPrescalerConfig
2515                     ; 363     GPIO_Init(TM_CLK_PORT, TM_CLK_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
2517  0537 4be0          	push	#224
2518  0539 4b20          	push	#32
2519  053b ae5005        	ldw	x,#20485
2520  053e cd0000        	call	_GPIO_Init
2522  0541 85            	popw	x
2523                     ; 364     GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
2525  0542 4be0          	push	#224
2526  0544 4b10          	push	#16
2527  0546 ae5005        	ldw	x,#20485
2528  0549 cd0000        	call	_GPIO_Init
2530  054c 85            	popw	x
2531                     ; 365     GPIO_Init(GPIOE, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT);
2533  054d 4b00          	push	#0
2534  054f 4b10          	push	#16
2535  0551 ae5014        	ldw	x,#20500
2536  0554 cd0000        	call	_GPIO_Init
2538  0557 85            	popw	x
2539                     ; 367     initKeypad();
2541  0558 cd0103        	call	_initKeypad
2543                     ; 368     buzzerInit();
2545  055b cd0321        	call	_buzzerInit
2547                     ; 369     init_milis();
2549  055e cd0000        	call	_init_milis
2551                     ; 371     for (i = 0; i < 4; i++) {
2553  0561 0f14          	clr	(OFST+0,sp)
2555  0563               L3601:
2556                     ; 372         tm_displayCharacter(i, 0x00);
2558  0563 7b14          	ld	a,(OFST+0,sp)
2559  0565 5f            	clrw	x
2560  0566 95            	ld	xh,a
2561  0567 cd00be        	call	_tm_displayCharacter
2563                     ; 371     for (i = 0; i < 4; i++) {
2565  056a 0c14          	inc	(OFST+0,sp)
2569  056c 7b14          	ld	a,(OFST+0,sp)
2570  056e a104          	cp	a,#4
2571  0570 25f1          	jrult	L3601
2572                     ; 375     loadPINfromEEPROM();
2574  0572 cd03ff        	call	_loadPINfromEEPROM
2576  0575               L1701:
2577                     ; 378         key = getKey();
2579  0575 cd013b        	call	_getKey
2581  0578 6b0e          	ld	(OFST-6,sp),a
2583                     ; 381         if (GPIO_ReadInputPin(GPIOE, GPIO_PIN_4) == RESET) {
2585  057a 4b10          	push	#16
2586  057c ae5014        	ldw	x,#20500
2587  057f cd0000        	call	_GPIO_ReadInputPin
2589  0582 5b01          	addw	sp,#1
2590  0584 4d            	tnz	a
2591  0585 2634          	jrne	L5701
2592                     ; 382             factoryResetPIN();
2594  0587 cd04fe        	call	_factoryResetPIN
2597  058a               L1011:
2598                     ; 383             while (GPIO_ReadInputPin(GPIOE, GPIO_PIN_4) == RESET);
2600  058a 4b10          	push	#16
2601  058c ae5014        	ldw	x,#20500
2602  058f cd0000        	call	_GPIO_ReadInputPin
2604  0592 5b01          	addw	sp,#1
2605  0594 4d            	tnz	a
2606  0595 27f3          	jreq	L1011
2607                     ; 384             index = 0;
2609  0597 0f13          	clr	(OFST-1,sp)
2611                     ; 385             for (i = 0; i < 4; i++) {
2613  0599 0f14          	clr	(OFST+0,sp)
2615  059b               L5011:
2616                     ; 386                 userInput[i] = ' ';
2618  059b 96            	ldw	x,sp
2619  059c 1c000f        	addw	x,#OFST-5
2620  059f 9f            	ld	a,xl
2621  05a0 5e            	swapw	x
2622  05a1 1b14          	add	a,(OFST+0,sp)
2623  05a3 2401          	jrnc	L241
2624  05a5 5c            	incw	x
2625  05a6               L241:
2626  05a6 02            	rlwa	x,a
2627  05a7 a620          	ld	a,#32
2628  05a9 f7            	ld	(x),a
2629                     ; 387                 tm_displayCharacter(i, 0x00);
2631  05aa 7b14          	ld	a,(OFST+0,sp)
2632  05ac 5f            	clrw	x
2633  05ad 95            	ld	xh,a
2634  05ae cd00be        	call	_tm_displayCharacter
2636                     ; 385             for (i = 0; i < 4; i++) {
2638  05b1 0c14          	inc	(OFST+0,sp)
2642  05b3 7b14          	ld	a,(OFST+0,sp)
2643  05b5 a104          	cp	a,#4
2644  05b7 25e2          	jrult	L5011
2645                     ; 389             loggedIn = 0;
2647  05b9 0f0d          	clr	(OFST-7,sp)
2649  05bb               L5701:
2650                     ; 393         if (loggedIn) {
2652  05bb 0d0d          	tnz	(OFST-7,sp)
2653  05bd 2603          	jrne	L061
2654  05bf cc064f        	jp	L3111
2655  05c2               L061:
2656                     ; 394             uint32_t now = milis();
2658  05c2 cd0000        	call	_milis
2660  05c5 cd0000        	call	c_uitolx
2662  05c8 96            	ldw	x,sp
2663  05c9 1c0001        	addw	x,#OFST-19
2664  05cc cd0000        	call	c_rtol
2667                     ; 395             if ((now - loginStartTime) >= LOGIN_TIMEOUT_MS) {
2669  05cf 96            	ldw	x,sp
2670  05d0 1c0001        	addw	x,#OFST-19
2671  05d3 cd0000        	call	c_ltor
2673  05d6 96            	ldw	x,sp
2674  05d7 1c0009        	addw	x,#OFST-11
2675  05da cd0000        	call	c_lsub
2677  05dd 96            	ldw	x,sp
2678  05de 1c0005        	addw	x,#OFST-15
2679  05e1 cd0000        	call	c_lcmp
2681  05e4 2569          	jrult	L3111
2682                     ; 397                 beepTone(1000, 500);  // dlouhý tón 500ms
2684  05e6 ae01f4        	ldw	x,#500
2685  05e9 89            	pushw	x
2686  05ea ae03e8        	ldw	x,#1000
2687  05ed cd0336        	call	_beepTone
2689  05f0 85            	popw	x
2690                     ; 398                 for (k = 0; k < 2; k++) {
2692  05f1 0f13          	clr	(OFST-1,sp)
2694  05f3               L7111:
2695                     ; 399                     for (j = 0; j < 4; j++) tm_displayCharacter(j, 0xFF);
2697  05f3 0f14          	clr	(OFST+0,sp)
2699  05f5               L5211:
2702  05f5 7b14          	ld	a,(OFST+0,sp)
2703  05f7 ae00ff        	ldw	x,#255
2704  05fa 95            	ld	xh,a
2705  05fb cd00be        	call	_tm_displayCharacter
2709  05fe 0c14          	inc	(OFST+0,sp)
2713  0600 7b14          	ld	a,(OFST+0,sp)
2714  0602 a104          	cp	a,#4
2715  0604 25ef          	jrult	L5211
2716                     ; 400                     delay_ms(200);
2718  0606 ae00c8        	ldw	x,#200
2719  0609 cd0000        	call	_delay_ms
2721                     ; 401                     for (j = 0; j < 4; j++) tm_displayCharacter(j, 0x00);
2723  060c 0f14          	clr	(OFST+0,sp)
2725  060e               L3311:
2728  060e 7b14          	ld	a,(OFST+0,sp)
2729  0610 5f            	clrw	x
2730  0611 95            	ld	xh,a
2731  0612 cd00be        	call	_tm_displayCharacter
2735  0615 0c14          	inc	(OFST+0,sp)
2739  0617 7b14          	ld	a,(OFST+0,sp)
2740  0619 a104          	cp	a,#4
2741  061b 25f1          	jrult	L3311
2742                     ; 402                     delay_ms(200);
2744  061d ae00c8        	ldw	x,#200
2745  0620 cd0000        	call	_delay_ms
2747                     ; 398                 for (k = 0; k < 2; k++) {
2749  0623 0c13          	inc	(OFST-1,sp)
2753  0625 7b13          	ld	a,(OFST-1,sp)
2754  0627 a102          	cp	a,#2
2755  0629 25c8          	jrult	L7111
2756                     ; 404                 loggedIn = 0;
2758  062b 0f0d          	clr	(OFST-7,sp)
2760                     ; 405                 index = 0;
2762  062d 0f13          	clr	(OFST-1,sp)
2764                     ; 406                 for (i = 0; i < 4; i++) {
2766  062f 0f14          	clr	(OFST+0,sp)
2768  0631               L1411:
2769                     ; 407                     userInput[i] = ' ';
2771  0631 96            	ldw	x,sp
2772  0632 1c000f        	addw	x,#OFST-5
2773  0635 9f            	ld	a,xl
2774  0636 5e            	swapw	x
2775  0637 1b14          	add	a,(OFST+0,sp)
2776  0639 2401          	jrnc	L441
2777  063b 5c            	incw	x
2778  063c               L441:
2779  063c 02            	rlwa	x,a
2780  063d a620          	ld	a,#32
2781  063f f7            	ld	(x),a
2782                     ; 408                     tm_displayCharacter(i, 0x00);
2784  0640 7b14          	ld	a,(OFST+0,sp)
2785  0642 5f            	clrw	x
2786  0643 95            	ld	xh,a
2787  0644 cd00be        	call	_tm_displayCharacter
2789                     ; 406                 for (i = 0; i < 4; i++) {
2791  0647 0c14          	inc	(OFST+0,sp)
2795  0649 7b14          	ld	a,(OFST+0,sp)
2796  064b a104          	cp	a,#4
2797  064d 25e2          	jrult	L1411
2798  064f               L3111:
2799                     ; 413         if (key != 0) {
2801  064f 0d0e          	tnz	(OFST-6,sp)
2802  0651 2603          	jrne	L261
2803  0653 cc0575        	jp	L1701
2804  0656               L261:
2805                     ; 414             if (key >= '0' && key <= '9') {
2807  0656 7b0e          	ld	a,(OFST-6,sp)
2808  0658 a130          	cp	a,#48
2809  065a 2403          	jruge	L461
2810  065c cc072b        	jp	L1511
2811  065f               L461:
2813  065f 7b0e          	ld	a,(OFST-6,sp)
2814  0661 a13a          	cp	a,#58
2815  0663 2503          	jrult	L661
2816  0665 cc072b        	jp	L1511
2817  0668               L661:
2818                     ; 415                 if (index < 4) {
2820  0668 7b13          	ld	a,(OFST-1,sp)
2821  066a a104          	cp	a,#4
2822  066c 2503          	jrult	L071
2823  066e cc0575        	jp	L1701
2824  0671               L071:
2825                     ; 416                     userInput[index] = key;
2827  0671 96            	ldw	x,sp
2828  0672 1c000f        	addw	x,#OFST-5
2829  0675 9f            	ld	a,xl
2830  0676 5e            	swapw	x
2831  0677 1b13          	add	a,(OFST-1,sp)
2832  0679 2401          	jrnc	L641
2833  067b 5c            	incw	x
2834  067c               L641:
2835  067c 02            	rlwa	x,a
2836  067d 7b0e          	ld	a,(OFST-6,sp)
2837  067f f7            	ld	(x),a
2838                     ; 417                     tm_displayCharacter(index, digitToSegment[key - '0']);
2840  0680 7b0e          	ld	a,(OFST-6,sp)
2841  0682 5f            	clrw	x
2842  0683 97            	ld	xl,a
2843  0684 1d0030        	subw	x,#48
2844  0687 d60004        	ld	a,(_digitToSegment,x)
2845  068a 97            	ld	xl,a
2846  068b 7b13          	ld	a,(OFST-1,sp)
2847  068d 95            	ld	xh,a
2848  068e cd00be        	call	_tm_displayCharacter
2850                     ; 418                     index++;
2852  0691 0c13          	inc	(OFST-1,sp)
2854                     ; 420                     if (index == 4) {
2856  0693 7b13          	ld	a,(OFST-1,sp)
2857  0695 a104          	cp	a,#4
2858  0697 2703          	jreq	L271
2859  0699 cc0575        	jp	L1701
2860  069c               L271:
2861                     ; 422                         if (!loggedIn) {
2863  069c 0d0d          	tnz	(OFST-7,sp)
2864  069e 2703          	jreq	L471
2865  06a0 cc0575        	jp	L1701
2866  06a3               L471:
2867                     ; 423                             if (comparePIN(userInput, storedPIN)) {
2869  06a3 ae0000        	ldw	x,#_storedPIN
2870  06a6 89            	pushw	x
2871  06a7 96            	ldw	x,sp
2872  06a8 1c0011        	addw	x,#OFST-3
2873  06ab cd0494        	call	_comparePIN
2875  06ae 85            	popw	x
2876  06af 4d            	tnz	a
2877  06b0 2750          	jreq	L1611
2878                     ; 424                                 beepSuccess();
2880  06b2 cd03b4        	call	_beepSuccess
2882                     ; 425                                 for (k = 0; k < 2; k++) {
2884  06b5 0f13          	clr	(OFST-1,sp)
2886  06b7               L3611:
2887                     ; 426                                     for (j = 0; j < 4; j++) tm_displayCharacter(j, 0x7F);
2889  06b7 0f14          	clr	(OFST+0,sp)
2891  06b9               L1711:
2894  06b9 7b14          	ld	a,(OFST+0,sp)
2895  06bb ae007f        	ldw	x,#127
2896  06be 95            	ld	xh,a
2897  06bf cd00be        	call	_tm_displayCharacter
2901  06c2 0c14          	inc	(OFST+0,sp)
2905  06c4 7b14          	ld	a,(OFST+0,sp)
2906  06c6 a104          	cp	a,#4
2907  06c8 25ef          	jrult	L1711
2908                     ; 427                                     delay_ms(200);
2910  06ca ae00c8        	ldw	x,#200
2911  06cd cd0000        	call	_delay_ms
2913                     ; 428                                     for (j = 0; j < 4; j++) tm_displayCharacter(j, 0x00);
2915  06d0 0f14          	clr	(OFST+0,sp)
2917  06d2               L7711:
2920  06d2 7b14          	ld	a,(OFST+0,sp)
2921  06d4 5f            	clrw	x
2922  06d5 95            	ld	xh,a
2923  06d6 cd00be        	call	_tm_displayCharacter
2927  06d9 0c14          	inc	(OFST+0,sp)
2931  06db 7b14          	ld	a,(OFST+0,sp)
2932  06dd a104          	cp	a,#4
2933  06df 25f1          	jrult	L7711
2934                     ; 429                                     delay_ms(200);
2936  06e1 ae00c8        	ldw	x,#200
2937  06e4 cd0000        	call	_delay_ms
2939                     ; 425                                 for (k = 0; k < 2; k++) {
2941  06e7 0c13          	inc	(OFST-1,sp)
2945  06e9 7b13          	ld	a,(OFST-1,sp)
2946  06eb a102          	cp	a,#2
2947  06ed 25c8          	jrult	L3611
2948                     ; 431                                 loggedIn = 1;
2950  06ef a601          	ld	a,#1
2951  06f1 6b0d          	ld	(OFST-7,sp),a
2953                     ; 432                                 loginStartTime = milis();
2955  06f3 cd0000        	call	_milis
2957  06f6 cd0000        	call	c_uitolx
2959  06f9 96            	ldw	x,sp
2960  06fa 1c0009        	addw	x,#OFST-11
2961  06fd cd0000        	call	c_rtol
2965  0700 2003          	jra	L5021
2966  0702               L1611:
2967                     ; 434                                 beepFail();
2969  0702 cd03c0        	call	_beepFail
2971  0705               L5021:
2972                     ; 437                             index = 0;
2974  0705 0f13          	clr	(OFST-1,sp)
2976                     ; 438                             for (j = 0; j < 4; j++) {
2978  0707 0f14          	clr	(OFST+0,sp)
2980  0709               L7021:
2981                     ; 439                                 userInput[j] = ' ';
2983  0709 96            	ldw	x,sp
2984  070a 1c000f        	addw	x,#OFST-5
2985  070d 9f            	ld	a,xl
2986  070e 5e            	swapw	x
2987  070f 1b14          	add	a,(OFST+0,sp)
2988  0711 2401          	jrnc	L051
2989  0713 5c            	incw	x
2990  0714               L051:
2991  0714 02            	rlwa	x,a
2992  0715 a620          	ld	a,#32
2993  0717 f7            	ld	(x),a
2994                     ; 440                                 tm_displayCharacter(j, 0x00);
2996  0718 7b14          	ld	a,(OFST+0,sp)
2997  071a 5f            	clrw	x
2998  071b 95            	ld	xh,a
2999  071c cd00be        	call	_tm_displayCharacter
3001                     ; 438                             for (j = 0; j < 4; j++) {
3003  071f 0c14          	inc	(OFST+0,sp)
3007  0721 7b14          	ld	a,(OFST+0,sp)
3008  0723 a104          	cp	a,#4
3009  0725 25e2          	jrult	L7021
3010  0727 ac750575      	jpf	L1701
3011  072b               L1511:
3012                     ; 445             } else if (key == '*') {
3014  072b 7b0e          	ld	a,(OFST-6,sp)
3015  072d a12a          	cp	a,#42
3016  072f 2623          	jrne	L7121
3017                     ; 447                 if (index > 0) {
3019  0731 0d13          	tnz	(OFST-1,sp)
3020  0733 2603          	jrne	L671
3021  0735 cc0575        	jp	L1701
3022  0738               L671:
3023                     ; 448                     index--;
3025  0738 0a13          	dec	(OFST-1,sp)
3027                     ; 449                     userInput[index] = ' ';
3029  073a 96            	ldw	x,sp
3030  073b 1c000f        	addw	x,#OFST-5
3031  073e 9f            	ld	a,xl
3032  073f 5e            	swapw	x
3033  0740 1b13          	add	a,(OFST-1,sp)
3034  0742 2401          	jrnc	L251
3035  0744 5c            	incw	x
3036  0745               L251:
3037  0745 02            	rlwa	x,a
3038  0746 a620          	ld	a,#32
3039  0748 f7            	ld	(x),a
3040                     ; 450                     tm_displayCharacter(index, 0x00);
3042  0749 7b13          	ld	a,(OFST-1,sp)
3043  074b 5f            	clrw	x
3044  074c 95            	ld	xh,a
3045  074d cd00be        	call	_tm_displayCharacter
3047  0750 ac750575      	jpf	L1701
3048  0754               L7121:
3049                     ; 452             } else if (key == '#') {
3051  0754 7b0e          	ld	a,(OFST-6,sp)
3052  0756 a123          	cp	a,#35
3053  0758 2703          	jreq	L002
3054  075a cc0575        	jp	L1701
3055  075d               L002:
3056                     ; 454                 if (loggedIn && index == 4) {
3058  075d 0d0d          	tnz	(OFST-7,sp)
3059  075f 2603          	jrne	L202
3060  0761 cc0575        	jp	L1701
3061  0764               L202:
3063  0764 7b13          	ld	a,(OFST-1,sp)
3064  0766 a104          	cp	a,#4
3065  0768 2703          	jreq	L402
3066  076a cc0575        	jp	L1701
3067  076d               L402:
3068                     ; 455                     savePINtoEEPROM(userInput);
3070  076d 96            	ldw	x,sp
3071  076e 1c000f        	addw	x,#OFST-5
3072  0771 cd0460        	call	_savePINtoEEPROM
3074                     ; 456                     beepSuccess();
3076  0774 cd03b4        	call	_beepSuccess
3078                     ; 457                     blinkDisplay(2);  // blikni displej 2x
3080  0777 a602          	ld	a,#2
3081  0779 cd04bd        	call	_blinkDisplay
3083                     ; 460                     for (j = 0; j < 4; j++) {
3085  077c 0f14          	clr	(OFST+0,sp)
3087  077e               L1321:
3088                     ; 461                         storedPIN[j] = userInput[j];
3090  077e 7b14          	ld	a,(OFST+0,sp)
3091  0780 5f            	clrw	x
3092  0781 97            	ld	xl,a
3093  0782 89            	pushw	x
3094  0783 96            	ldw	x,sp
3095  0784 1c0011        	addw	x,#OFST-3
3096  0787 9f            	ld	a,xl
3097  0788 5e            	swapw	x
3098  0789 1b16          	add	a,(OFST+2,sp)
3099  078b 2401          	jrnc	L451
3100  078d 5c            	incw	x
3101  078e               L451:
3102  078e 02            	rlwa	x,a
3103  078f f6            	ld	a,(x)
3104  0790 85            	popw	x
3105  0791 e700          	ld	(_storedPIN,x),a
3106                     ; 460                     for (j = 0; j < 4; j++) {
3108  0793 0c14          	inc	(OFST+0,sp)
3112  0795 7b14          	ld	a,(OFST+0,sp)
3113  0797 a104          	cp	a,#4
3114  0799 25e3          	jrult	L1321
3115                     ; 465                     loggedIn = 0;
3117  079b 0f0d          	clr	(OFST-7,sp)
3119                     ; 466                     index = 0;
3121  079d 0f13          	clr	(OFST-1,sp)
3123                     ; 467                     for (j = 0; j < 4; j++) {
3125  079f 0f14          	clr	(OFST+0,sp)
3127  07a1               L7321:
3128                     ; 468                         userInput[j] = ' ';
3130  07a1 96            	ldw	x,sp
3131  07a2 1c000f        	addw	x,#OFST-5
3132  07a5 9f            	ld	a,xl
3133  07a6 5e            	swapw	x
3134  07a7 1b14          	add	a,(OFST+0,sp)
3135  07a9 2401          	jrnc	L651
3136  07ab 5c            	incw	x
3137  07ac               L651:
3138  07ac 02            	rlwa	x,a
3139  07ad a620          	ld	a,#32
3140  07af f7            	ld	(x),a
3141                     ; 469                         tm_displayCharacter(j, 0x00);
3143  07b0 7b14          	ld	a,(OFST+0,sp)
3144  07b2 5f            	clrw	x
3145  07b3 95            	ld	xh,a
3146  07b4 cd00be        	call	_tm_displayCharacter
3148                     ; 467                     for (j = 0; j < 4; j++) {
3150  07b7 0c14          	inc	(OFST+0,sp)
3154  07b9 7b14          	ld	a,(OFST+0,sp)
3155  07bb a104          	cp	a,#4
3156  07bd 25e2          	jrult	L7321
3157  07bf ac750575      	jpf	L1701
3192                     ; 482 void assert_failed(uint8_t* file, uint32_t line) {
3193                     	switch	.text
3194  07c3               _assert_failed:
3198  07c3               L3621:
3199                     ; 483     while (1);
3201  07c3 20fe          	jra	L3621
3246                     	xdef	_main
3247                     	xdef	_factoryResetPIN
3248                     	xdef	_blinkDisplay
3249                     	xdef	_comparePIN
3250                     	xdef	_savePINtoEEPROM
3251                     	xdef	_loadPINfromEEPROM
3252                     	xdef	_EEPROM_WriteByte
3253                     	xdef	_EEPROM_ReadByte
3254                     	xdef	_digitToSegment
3255                     	xdef	_beepTone
3256                     	xdef	_beepFail
3257                     	xdef	_beepSuccess
3258                     	xdef	_buzzerInit
3259                     	xdef	_getKey
3260                     	xdef	_initKeypad
3261                     	xdef	_delay_us
3262                     	xdef	_tm_displayCharacter
3263                     	xdef	_tm_writeByte
3264                     	xdef	_tm_stop
3265                     	xdef	_tm_start
3266                     	xdef	_setCLK
3267                     	xdef	_setDIO
3268                     	switch	.ubsct
3269  0000               _storedPIN:
3270  0000 00000000      	ds.b	4
3271                     	xdef	_storedPIN
3272                     	xdef	_defaultPIN
3273                     	xref	_init_milis
3274                     	xref	_delay_ms
3275                     	xref	_milis
3276                     	xdef	_assert_failed
3277                     	xref	_GPIO_ReadInputPin
3278                     	xref	_GPIO_WriteLow
3279                     	xref	_GPIO_WriteHigh
3280                     	xref	_GPIO_Init
3281                     	xref	_FLASH_ProgramByte
3282                     	xref	_FLASH_Lock
3283                     	xref	_FLASH_Unlock
3284                     	xref	_CLK_HSIPrescalerConfig
3285                     	xref.b	c_lreg
3286                     	xref.b	c_x
3287                     	xref.b	c_y
3307                     	xref	c_lsub
3308                     	xref	c_ludv
3309                     	xref	c_umul
3310                     	xref	c_ldiv
3311                     	xref	c_rtol
3312                     	xref	c_uitolx
3313                     	xref	c_bmulx
3314                     	xref	c_lcmp
3315                     	xref	c_ltor
3316                     	xref	c_lgadc
3317                     	xref	c_xymov
3318                     	end
