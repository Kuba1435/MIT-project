   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
  15                     	bsct
  16  0000               _savedCode:
  17  0000 31            	dc.b	49
  18  0001 32            	dc.b	50
  19  0002 33            	dc.b	51
  20  0003 34            	dc.b	52
  21  0004 00            	dc.b	0
  22  0005               _isLoggedIn:
  23  0005 00            	dc.b	0
  24  0006               _changingCode:
  25  0006 00            	dc.b	0
  26                     .const:	section	.text
  27  0000               _digitToSegment:
  28  0000 3f            	dc.b	63
  29  0001 06            	dc.b	6
  30  0002 5b            	dc.b	91
  31  0003 4f            	dc.b	79
  32  0004 66            	dc.b	102
  33  0005 6d            	dc.b	109
  34  0006 7d            	dc.b	125
  35  0007 07            	dc.b	7
  36  0008 7f            	dc.b	127
  37  0009 6f            	dc.b	111
  79                     ; 67 void setDIO(uint8_t state) {
  81                     	switch	.text
  82  0000               _setDIO:
  86                     ; 68     if (state) GPIO_WriteHigh(TM_DIO_PORT, TM_DIO_PIN);
  88  0000 4d            	tnz	a
  89  0001 270b          	jreq	L72
  92  0003 4b10          	push	#16
  93  0005 ae5005        	ldw	x,#20485
  94  0008 cd0000        	call	_GPIO_WriteHigh
  96  000b 84            	pop	a
  98  000c 2009          	jra	L13
  99  000e               L72:
 100                     ; 69     else GPIO_WriteLow(TM_DIO_PORT, TM_DIO_PIN);
 102  000e 4b10          	push	#16
 103  0010 ae5005        	ldw	x,#20485
 104  0013 cd0000        	call	_GPIO_WriteLow
 106  0016 84            	pop	a
 107  0017               L13:
 108                     ; 70 }
 111  0017 81            	ret
 147                     ; 72 void setCLK(uint8_t state) {
 148                     	switch	.text
 149  0018               _setCLK:
 153                     ; 73     if (state) GPIO_WriteHigh(TM_CLK_PORT, TM_CLK_PIN);
 155  0018 4d            	tnz	a
 156  0019 270b          	jreq	L15
 159  001b 4b20          	push	#32
 160  001d ae5005        	ldw	x,#20485
 161  0020 cd0000        	call	_GPIO_WriteHigh
 163  0023 84            	pop	a
 165  0024 2009          	jra	L35
 166  0026               L15:
 167                     ; 74     else GPIO_WriteLow(TM_CLK_PORT, TM_CLK_PIN);
 169  0026 4b20          	push	#32
 170  0028 ae5005        	ldw	x,#20485
 171  002b cd0000        	call	_GPIO_WriteLow
 173  002e 84            	pop	a
 174  002f               L35:
 175                     ; 75 }
 178  002f 81            	ret
 204                     ; 77 void tm_start(void) {
 205                     	switch	.text
 206  0030               _tm_start:
 210                     ; 78     setCLK(1);
 212  0030 a601          	ld	a,#1
 213  0032 ade4          	call	_setCLK
 215                     ; 79     setDIO(1);
 217  0034 a601          	ld	a,#1
 218  0036 adc8          	call	_setDIO
 220                     ; 80     delay_us(2);
 222  0038 ae0002        	ldw	x,#2
 223  003b cd00e4        	call	_delay_us
 225                     ; 81     setDIO(0);
 227  003e 4f            	clr	a
 228  003f adbf          	call	_setDIO
 230                     ; 82     delay_us(2);
 232  0041 ae0002        	ldw	x,#2
 233  0044 cd00e4        	call	_delay_us
 235                     ; 83     setCLK(0);
 237  0047 4f            	clr	a
 238  0048 adce          	call	_setCLK
 240                     ; 84 }
 243  004a 81            	ret
 269                     ; 86 void tm_stop(void) {
 270                     	switch	.text
 271  004b               _tm_stop:
 275                     ; 87     setCLK(0);
 277  004b 4f            	clr	a
 278  004c adca          	call	_setCLK
 280                     ; 88     delay_us(2);
 282  004e ae0002        	ldw	x,#2
 283  0051 cd00e4        	call	_delay_us
 285                     ; 89     setDIO(0);
 287  0054 4f            	clr	a
 288  0055 ada9          	call	_setDIO
 290                     ; 90     delay_us(2);
 292  0057 ae0002        	ldw	x,#2
 293  005a cd00e4        	call	_delay_us
 295                     ; 91     setCLK(1);
 297  005d a601          	ld	a,#1
 298  005f adb7          	call	_setCLK
 300                     ; 92     delay_us(2);
 302  0061 ae0002        	ldw	x,#2
 303  0064 ad7e          	call	_delay_us
 305                     ; 93     setDIO(1);
 307  0066 a601          	ld	a,#1
 308  0068 ad96          	call	_setDIO
 310                     ; 94 }
 313  006a 81            	ret
 360                     ; 96 void tm_writeByte(uint8_t b) {
 361                     	switch	.text
 362  006b               _tm_writeByte:
 364  006b 88            	push	a
 365  006c 88            	push	a
 366       00000001      OFST:	set	1
 369                     ; 98     for (i = 0; i < 8; i++) {
 371  006d 0f01          	clr	(OFST+0,sp)
 373  006f               L711:
 374                     ; 99         setCLK(0);
 376  006f 4f            	clr	a
 377  0070 ada6          	call	_setCLK
 379                     ; 100         setDIO(b & 0x01);
 381  0072 7b02          	ld	a,(OFST+1,sp)
 382  0074 a401          	and	a,#1
 383  0076 ad88          	call	_setDIO
 385                     ; 101         delay_us(3);
 387  0078 ae0003        	ldw	x,#3
 388  007b ad67          	call	_delay_us
 390                     ; 102         setCLK(1);
 392  007d a601          	ld	a,#1
 393  007f ad97          	call	_setCLK
 395                     ; 103         delay_us(3);
 397  0081 ae0003        	ldw	x,#3
 398  0084 ad5e          	call	_delay_us
 400                     ; 104         b >>= 1;
 402  0086 0402          	srl	(OFST+1,sp)
 403                     ; 98     for (i = 0; i < 8; i++) {
 405  0088 0c01          	inc	(OFST+0,sp)
 409  008a 7b01          	ld	a,(OFST+0,sp)
 410  008c a108          	cp	a,#8
 411  008e 25df          	jrult	L711
 412                     ; 108     setCLK(0);
 414  0090 4f            	clr	a
 415  0091 ad85          	call	_setCLK
 417                     ; 109     GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_IN_FL_NO_IT); // input
 419  0093 4b00          	push	#0
 420  0095 4b10          	push	#16
 421  0097 ae5005        	ldw	x,#20485
 422  009a cd0000        	call	_GPIO_Init
 424  009d 85            	popw	x
 425                     ; 110     delay_us(5);
 427  009e ae0005        	ldw	x,#5
 428  00a1 ad41          	call	_delay_us
 430                     ; 111     setCLK(1);
 432  00a3 a601          	ld	a,#1
 433  00a5 cd0018        	call	_setCLK
 435                     ; 112     delay_us(5);
 437  00a8 ae0005        	ldw	x,#5
 438  00ab ad37          	call	_delay_us
 440                     ; 113     setCLK(0);
 442  00ad 4f            	clr	a
 443  00ae cd0018        	call	_setCLK
 445                     ; 114     GPIO_Init(TM_DIO_PORT, TM_DIO_PIN, GPIO_MODE_OUT_PP_LOW_FAST); // back to output
 447  00b1 4be0          	push	#224
 448  00b3 4b10          	push	#16
 449  00b5 ae5005        	ldw	x,#20485
 450  00b8 cd0000        	call	_GPIO_Init
 452  00bb 85            	popw	x
 453                     ; 115 }
 456  00bc 85            	popw	x
 457  00bd 81            	ret
 504                     ; 117 void tm_displayCharacter(uint8_t pos, uint8_t character) {
 505                     	switch	.text
 506  00be               _tm_displayCharacter:
 508  00be 89            	pushw	x
 509       00000000      OFST:	set	0
 512                     ; 118     tm_start();
 514  00bf cd0030        	call	_tm_start
 516                     ; 119     tm_writeByte(0x40); // auto-increment mode
 518  00c2 a640          	ld	a,#64
 519  00c4 ada5          	call	_tm_writeByte
 521                     ; 120     tm_stop();
 523  00c6 ad83          	call	_tm_stop
 525                     ; 122     tm_start();
 527  00c8 cd0030        	call	_tm_start
 529                     ; 123     tm_writeByte(0xC0 | pos); // start address + position
 531  00cb 7b01          	ld	a,(OFST+1,sp)
 532  00cd aac0          	or	a,#192
 533  00cf ad9a          	call	_tm_writeByte
 535                     ; 124     tm_writeByte(character);
 537  00d1 7b02          	ld	a,(OFST+2,sp)
 538  00d3 ad96          	call	_tm_writeByte
 540                     ; 125     tm_stop();
 542  00d5 cd004b        	call	_tm_stop
 544                     ; 127     tm_start();
 546  00d8 cd0030        	call	_tm_start
 548                     ; 128     tm_writeByte(0x88); // display ON, brightness = medium
 550  00db a688          	ld	a,#136
 551  00dd ad8c          	call	_tm_writeByte
 553                     ; 129     tm_stop();
 555  00df cd004b        	call	_tm_stop
 557                     ; 130 }
 560  00e2 85            	popw	x
 561  00e3 81            	ret
 605                     ; 132 void delay_us(uint16_t us) {
 606                     	switch	.text
 607  00e4               _delay_us:
 609  00e4 89            	pushw	x
 610  00e5 89            	pushw	x
 611       00000002      OFST:	set	2
 614                     ; 134     for (i = 0; i < us; i++) {
 616  00e6 5f            	clrw	x
 617  00e7 1f01          	ldw	(OFST-1,sp),x
 620  00e9 200f          	jra	L571
 621  00eb               L171:
 622                     ; 135         _asm("nop"); _asm("nop"); _asm("nop"); _asm("nop");
 625  00eb 9d            nop
 630  00ec 9d            nop
 635  00ed 9d            nop
 640  00ee 9d            nop
 642                     ; 136         _asm("nop"); _asm("nop"); _asm("nop"); _asm("nop");
 645  00ef 9d            nop
 650  00f0 9d            nop
 655  00f1 9d            nop
 660  00f2 9d            nop
 662                     ; 134     for (i = 0; i < us; i++) {
 664  00f3 1e01          	ldw	x,(OFST-1,sp)
 665  00f5 1c0001        	addw	x,#1
 666  00f8 1f01          	ldw	(OFST-1,sp),x
 668  00fa               L571:
 671  00fa 1e01          	ldw	x,(OFST-1,sp)
 672  00fc 1303          	cpw	x,(OFST+1,sp)
 673  00fe 25eb          	jrult	L171
 674                     ; 138 }
 677  0100 5b04          	addw	sp,#4
 678  0102 81            	ret
 702                     ; 140 void initKeypad(void) {
 703                     	switch	.text
 704  0103               _initKeypad:
 708                     ; 142     GPIO_Init(GPIOD, ROW1_PIN | ROW2_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
 710  0103 4be0          	push	#224
 711  0105 4b60          	push	#96
 712  0107 ae500f        	ldw	x,#20495
 713  010a cd0000        	call	_GPIO_Init
 715  010d 85            	popw	x
 716                     ; 143     GPIO_Init(GPIOE, ROW3_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
 718  010e 4be0          	push	#224
 719  0110 4b01          	push	#1
 720  0112 ae5014        	ldw	x,#20500
 721  0115 cd0000        	call	_GPIO_Init
 723  0118 85            	popw	x
 724                     ; 144     GPIO_Init(GPIOC, ROW4_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
 726  0119 4be0          	push	#224
 727  011b 4b02          	push	#2
 728  011d ae500a        	ldw	x,#20490
 729  0120 cd0000        	call	_GPIO_Init
 731  0123 85            	popw	x
 732                     ; 147     GPIO_Init(GPIOG, COL1_PIN, GPIO_MODE_IN_PU_NO_IT);
 734  0124 4b40          	push	#64
 735  0126 4b01          	push	#1
 736  0128 ae501e        	ldw	x,#20510
 737  012b cd0000        	call	_GPIO_Init
 739  012e 85            	popw	x
 740                     ; 148     GPIO_Init(GPIOC, COL2_PIN | COL3_PIN, GPIO_MODE_IN_PU_NO_IT);
 742  012f 4b40          	push	#64
 743  0131 4b0c          	push	#12
 744  0133 ae500a        	ldw	x,#20490
 745  0136 cd0000        	call	_GPIO_Init
 747  0139 85            	popw	x
 748                     ; 149 }
 751  013a 81            	ret
 754                     	switch	.const
 755  000a               L112_keyMap:
 756  000a 31            	dc.b	49
 757  000b 32            	dc.b	50
 758  000c 33            	dc.b	51
 759  000d 34            	dc.b	52
 760  000e 35            	dc.b	53
 761  000f 36            	dc.b	54
 762  0010 37            	dc.b	55
 763  0011 38            	dc.b	56
 764  0012 39            	dc.b	57
 765  0013 2a            	dc.b	42
 766  0014 30            	dc.b	48
 767  0015 23            	dc.b	35
 846                     	switch	.const
 847  0016               L62:
 848  0016 000003e8      	dc.l	1000
 849  001a               L44:
 850  001a 00007530      	dc.l	30000
 851                     ; 151 char getKey(void) {
 852                     	switch	.text
 853  013b               _getKey:
 855  013b 5217          	subw	sp,#23
 856       00000017      OFST:	set	23
 859                     ; 152     const char keyMap[4][3] = {
 859                     ; 153         {'1', '2', '3'},
 859                     ; 154         {'4', '5', '6'},
 859                     ; 155         {'7', '8', '9'},
 859                     ; 156         {'*', '0', '#'}
 859                     ; 157     };
 861  013d 96            	ldw	x,sp
 862  013e 1c0003        	addw	x,#OFST-20
 863  0141 90ae000a      	ldw	y,#L112_keyMap
 864  0145 a60c          	ld	a,#12
 865  0147 cd0000        	call	c_xymov
 867                     ; 160     char key = 0;
 869                     ; 164     GPIOD->ODR |= ROW1_PIN | ROW2_PIN;
 871  014a c6500f        	ld	a,20495
 872  014d aa60          	or	a,#96
 873  014f c7500f        	ld	20495,a
 874                     ; 165     GPIOE->ODR |= ROW3_PIN;
 876  0152 72105014      	bset	20500,#0
 877                     ; 166     GPIOC->ODR |= ROW4_PIN;
 879  0156 7212500a      	bset	20490,#1
 880                     ; 168     for (row = 0; row < 4; row++) {
 882  015a 5f            	clrw	x
 883  015b 1f0f          	ldw	(OFST-8,sp),x
 885  015d               L723:
 886                     ; 170         switch (row) {
 888  015d 1e0f          	ldw	x,(OFST-8,sp)
 890                     ; 174             case 3: GPIOC->ODR &= ~ROW4_PIN; break;
 891  015f 5d            	tnzw	x
 892  0160 270b          	jreq	L312
 893  0162 5a            	decw	x
 894  0163 270e          	jreq	L512
 895  0165 5a            	decw	x
 896  0166 2711          	jreq	L712
 897  0168 5a            	decw	x
 898  0169 2714          	jreq	L122
 899  016b 2016          	jra	L733
 900  016d               L312:
 901                     ; 171             case 0: GPIOD->ODR &= ~ROW1_PIN; break;
 903  016d 721d500f      	bres	20495,#6
 906  0171 2010          	jra	L733
 907  0173               L512:
 908                     ; 172             case 1: GPIOD->ODR &= ~ROW2_PIN; break;
 910  0173 721b500f      	bres	20495,#5
 913  0177 200a          	jra	L733
 914  0179               L712:
 915                     ; 173             case 2: GPIOE->ODR &= ~ROW3_PIN; break;
 917  0179 72115014      	bres	20500,#0
 920  017d 2004          	jra	L733
 921  017f               L122:
 922                     ; 174             case 3: GPIOC->ODR &= ~ROW4_PIN; break;
 924  017f 7213500a      	bres	20490,#1
 927  0183               L733:
 928                     ; 178         for (i = 0; i < 1000; i++);
 930  0183 ae0000        	ldw	x,#0
 931  0186 1f13          	ldw	(OFST-4,sp),x
 932  0188 ae0000        	ldw	x,#0
 933  018b 1f11          	ldw	(OFST-6,sp),x
 935  018d               L143:
 939  018d 96            	ldw	x,sp
 940  018e 1c0011        	addw	x,#OFST-6
 941  0191 a601          	ld	a,#1
 942  0193 cd0000        	call	c_lgadc
 947  0196 96            	ldw	x,sp
 948  0197 1c0011        	addw	x,#OFST-6
 949  019a cd0000        	call	c_ltor
 951  019d ae0016        	ldw	x,#L62
 952  01a0 cd0000        	call	c_lcmp
 954  01a3 25e8          	jrult	L143
 955                     ; 181         for (col = 0; col < 3; col++) {
 957  01a5 5f            	clrw	x
 958  01a6 1f15          	ldw	(OFST-2,sp),x
 960  01a8               L743:
 961                     ; 182             uint8_t colState = 1;
 963  01a8 a601          	ld	a,#1
 964  01aa 6b17          	ld	(OFST+0,sp),a
 966                     ; 184             switch (col) {
 968  01ac 1e15          	ldw	x,(OFST-2,sp)
 970                     ; 187                 case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
 971  01ae 5d            	tnzw	x
 972  01af 2708          	jreq	L322
 973  01b1 5a            	decw	x
 974  01b2 2715          	jreq	L522
 975  01b4 5a            	decw	x
 976  01b5 2722          	jreq	L722
 977  01b7 202e          	jra	L753
 978  01b9               L322:
 979                     ; 185                 case 0: colState = !(GPIOG->IDR & COL1_PIN); break;
 981  01b9 c6501f        	ld	a,20511
 982  01bc a501          	bcp	a,#1
 983  01be 2604          	jrne	L03
 984  01c0 a601          	ld	a,#1
 985  01c2 2001          	jra	L23
 986  01c4               L03:
 987  01c4 4f            	clr	a
 988  01c5               L23:
 989  01c5 6b17          	ld	(OFST+0,sp),a
 993  01c7 201e          	jra	L753
 994  01c9               L522:
 995                     ; 186                 case 1: colState = !(GPIOC->IDR & COL2_PIN); break;
 997  01c9 c6500b        	ld	a,20491
 998  01cc a504          	bcp	a,#4
 999  01ce 2604          	jrne	L43
1000  01d0 a601          	ld	a,#1
1001  01d2 2001          	jra	L63
1002  01d4               L43:
1003  01d4 4f            	clr	a
1004  01d5               L63:
1005  01d5 6b17          	ld	(OFST+0,sp),a
1009  01d7 200e          	jra	L753
1010  01d9               L722:
1011                     ; 187                 case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
1013  01d9 c6500b        	ld	a,20491
1014  01dc a508          	bcp	a,#8
1015  01de 2604          	jrne	L04
1016  01e0 a601          	ld	a,#1
1017  01e2 2001          	jra	L24
1018  01e4               L04:
1019  01e4 4f            	clr	a
1020  01e5               L24:
1021  01e5 6b17          	ld	(OFST+0,sp),a
1025  01e7               L753:
1026                     ; 190             if (colState) {
1028  01e7 0d17          	tnz	(OFST+0,sp)
1029  01e9 2603          	jrne	L66
1030  01eb cc02b1        	jp	L163
1031  01ee               L66:
1032                     ; 192                 for (i = 0; i < 30000; i++);
1034  01ee ae0000        	ldw	x,#0
1035  01f1 1f13          	ldw	(OFST-4,sp),x
1036  01f3 ae0000        	ldw	x,#0
1037  01f6 1f11          	ldw	(OFST-6,sp),x
1039  01f8               L363:
1043  01f8 96            	ldw	x,sp
1044  01f9 1c0011        	addw	x,#OFST-6
1045  01fc a601          	ld	a,#1
1046  01fe cd0000        	call	c_lgadc
1051  0201 96            	ldw	x,sp
1052  0202 1c0011        	addw	x,#OFST-6
1053  0205 cd0000        	call	c_ltor
1055  0208 ae001a        	ldw	x,#L44
1056  020b cd0000        	call	c_lcmp
1058  020e 25e8          	jrult	L363
1059                     ; 195                 switch (col) {
1061  0210 1e15          	ldw	x,(OFST-2,sp)
1063                     ; 198                     case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
1064  0212 5d            	tnzw	x
1065  0213 2708          	jreq	L132
1066  0215 5a            	decw	x
1067  0216 2715          	jreq	L332
1068  0218 5a            	decw	x
1069  0219 2722          	jreq	L532
1070  021b 202e          	jra	L373
1071  021d               L132:
1072                     ; 196                     case 0: colState = !(GPIOG->IDR & COL1_PIN); break;
1074  021d c6501f        	ld	a,20511
1075  0220 a501          	bcp	a,#1
1076  0222 2604          	jrne	L64
1077  0224 a601          	ld	a,#1
1078  0226 2001          	jra	L05
1079  0228               L64:
1080  0228 4f            	clr	a
1081  0229               L05:
1082  0229 6b17          	ld	(OFST+0,sp),a
1086  022b 201e          	jra	L373
1087  022d               L332:
1088                     ; 197                     case 1: colState = !(GPIOC->IDR & COL2_PIN); break;
1090  022d c6500b        	ld	a,20491
1091  0230 a504          	bcp	a,#4
1092  0232 2604          	jrne	L25
1093  0234 a601          	ld	a,#1
1094  0236 2001          	jra	L45
1095  0238               L25:
1096  0238 4f            	clr	a
1097  0239               L45:
1098  0239 6b17          	ld	(OFST+0,sp),a
1102  023b 200e          	jra	L373
1103  023d               L532:
1104                     ; 198                     case 2: colState = !(GPIOC->IDR & COL3_PIN); break;
1106  023d c6500b        	ld	a,20491
1107  0240 a508          	bcp	a,#8
1108  0242 2604          	jrne	L65
1109  0244 a601          	ld	a,#1
1110  0246 2001          	jra	L06
1111  0248               L65:
1112  0248 4f            	clr	a
1113  0249               L06:
1114  0249 6b17          	ld	(OFST+0,sp),a
1118  024b               L373:
1119                     ; 201                 if (colState) {
1121  024b 0d17          	tnz	(OFST+0,sp)
1122  024d 2762          	jreq	L163
1123                     ; 202                     key = keyMap[row][col];
1125  024f 96            	ldw	x,sp
1126  0250 1c0003        	addw	x,#OFST-20
1127  0253 1f01          	ldw	(OFST-22,sp),x
1129  0255 1e0f          	ldw	x,(OFST-8,sp)
1130  0257 a603          	ld	a,#3
1131  0259 cd0000        	call	c_bmulx
1133  025c 72fb01        	addw	x,(OFST-22,sp)
1134  025f 72fb15        	addw	x,(OFST-2,sp)
1135  0262 f6            	ld	a,(x)
1136  0263 6b17          	ld	(OFST+0,sp),a
1138                     ; 206                         switch (col) {
1140  0265 1e15          	ldw	x,(OFST-2,sp)
1142                     ; 209                             case 2: if (GPIOC->IDR & COL3_PIN) break;
1143  0267 5d            	tnzw	x
1144  0268 2708          	jreq	L732
1145  026a 5a            	decw	x
1146  026b 270c          	jreq	L142
1147  026d 5a            	decw	x
1148  026e 2710          	jreq	L342
1149  0270 2015          	jra	L104
1150  0272               L732:
1151                     ; 207                             case 0: if (GPIOG->IDR & COL1_PIN) break;
1153  0272 c6501f        	ld	a,20511
1154  0275 a501          	bcp	a,#1
1155  0277 260e          	jrne	L104
1158  0279               L142:
1159                     ; 208                             case 1: if (GPIOC->IDR & COL2_PIN) break;
1161  0279 c6500b        	ld	a,20491
1162  027c a504          	bcp	a,#4
1163  027e 2607          	jrne	L104
1166  0280               L342:
1167                     ; 209                             case 2: if (GPIOC->IDR & COL3_PIN) break;
1169  0280 c6500b        	ld	a,20491
1170  0283 a508          	bcp	a,#8
1171  0285 2600          	jrne	L104
1174  0287               L504:
1175                     ; 211                         break;
1177  0287               L104:
1178                     ; 215                     switch (row) {
1180  0287 1e0f          	ldw	x,(OFST-8,sp)
1182                     ; 219                         case 3: GPIOC->ODR |= ROW4_PIN; break;
1183  0289 5d            	tnzw	x
1184  028a 270b          	jreq	L542
1185  028c 5a            	decw	x
1186  028d 270e          	jreq	L742
1187  028f 5a            	decw	x
1188  0290 2711          	jreq	L152
1189  0292 5a            	decw	x
1190  0293 2714          	jreq	L352
1191  0295 2016          	jra	L714
1192  0297               L542:
1193                     ; 216                         case 0: GPIOD->ODR |= ROW1_PIN; break;
1195  0297 721c500f      	bset	20495,#6
1198  029b 2010          	jra	L714
1199  029d               L742:
1200                     ; 217                         case 1: GPIOD->ODR |= ROW2_PIN; break;
1202  029d 721a500f      	bset	20495,#5
1205  02a1 200a          	jra	L714
1206  02a3               L152:
1207                     ; 218                         case 2: GPIOE->ODR |= ROW3_PIN; break;
1209  02a3 72105014      	bset	20500,#0
1212  02a7 2004          	jra	L714
1213  02a9               L352:
1214                     ; 219                         case 3: GPIOC->ODR |= ROW4_PIN; break;
1216  02a9 7212500a      	bset	20490,#1
1219  02ad               L714:
1220                     ; 222                     return key;
1222  02ad 7b17          	ld	a,(OFST+0,sp)
1224  02af 204b          	jra	L46
1225  02b1               L163:
1226                     ; 181         for (col = 0; col < 3; col++) {
1228  02b1 1e15          	ldw	x,(OFST-2,sp)
1229  02b3 1c0001        	addw	x,#1
1230  02b6 1f15          	ldw	(OFST-2,sp),x
1234  02b8 9c            	rvf
1235  02b9 1e15          	ldw	x,(OFST-2,sp)
1236  02bb a30003        	cpw	x,#3
1237  02be 2e03          	jrsge	L07
1238  02c0 cc01a8        	jp	L743
1239  02c3               L07:
1240                     ; 228         switch (row) {
1242  02c3 1e0f          	ldw	x,(OFST-8,sp)
1244                     ; 232             case 3: GPIOC->ODR |= ROW4_PIN; break;
1245  02c5 5d            	tnzw	x
1246  02c6 270b          	jreq	L552
1247  02c8 5a            	decw	x
1248  02c9 270e          	jreq	L752
1249  02cb 5a            	decw	x
1250  02cc 2711          	jreq	L162
1251  02ce 5a            	decw	x
1252  02cf 2714          	jreq	L362
1253  02d1 2016          	jra	L324
1254  02d3               L552:
1255                     ; 229             case 0: GPIOD->ODR |= ROW1_PIN; break;
1257  02d3 721c500f      	bset	20495,#6
1260  02d7 2010          	jra	L324
1261  02d9               L752:
1262                     ; 230             case 1: GPIOD->ODR |= ROW2_PIN; break;
1264  02d9 721a500f      	bset	20495,#5
1267  02dd 200a          	jra	L324
1268  02df               L162:
1269                     ; 231             case 2: GPIOE->ODR |= ROW3_PIN; break;
1271  02df 72105014      	bset	20500,#0
1274  02e3 2004          	jra	L324
1275  02e5               L362:
1276                     ; 232             case 3: GPIOC->ODR |= ROW4_PIN; break;
1278  02e5 7212500a      	bset	20490,#1
1281  02e9               L324:
1282                     ; 168     for (row = 0; row < 4; row++) {
1284  02e9 1e0f          	ldw	x,(OFST-8,sp)
1285  02eb 1c0001        	addw	x,#1
1286  02ee 1f0f          	ldw	(OFST-8,sp),x
1290  02f0 9c            	rvf
1291  02f1 1e0f          	ldw	x,(OFST-8,sp)
1292  02f3 a30004        	cpw	x,#4
1293  02f6 2e03          	jrsge	L27
1294  02f8 cc015d        	jp	L723
1295  02fb               L27:
1296                     ; 236     return 0; // Žádná klávesa
1298  02fb 4f            	clr	a
1300  02fc               L46:
1302  02fc 5b17          	addw	sp,#23
1303  02fe 81            	ret
1376                     ; 239 void playTone(uint16_t frequency, uint16_t duration_ms) {
1377                     	switch	.text
1378  02ff               _playTone:
1380  02ff 89            	pushw	x
1381  0300 5210          	subw	sp,#16
1382       00000010      OFST:	set	16
1385                     ; 240     uint32_t delay = 1000000UL / (frequency * 2); // poloèas periody (us)
1387  0302 58            	sllw	x
1388  0303 cd0000        	call	c_uitolx
1390  0306 96            	ldw	x,sp
1391  0307 1c0001        	addw	x,#OFST-15
1392  030a cd0000        	call	c_rtol
1395  030d ae4240        	ldw	x,#16960
1396  0310 bf02          	ldw	c_lreg+2,x
1397  0312 ae000f        	ldw	x,#15
1398  0315 bf00          	ldw	c_lreg,x
1399  0317 96            	ldw	x,sp
1400  0318 1c0001        	addw	x,#OFST-15
1401  031b cd0000        	call	c_ludv
1403  031e 96            	ldw	x,sp
1404  031f 1c0009        	addw	x,#OFST-7
1405  0322 cd0000        	call	c_rtol
1408                     ; 241     uint32_t cycles = (uint32_t)frequency * duration_ms / 1000;
1410  0325 1e11          	ldw	x,(OFST+1,sp)
1411  0327 1615          	ldw	y,(OFST+5,sp)
1412  0329 cd0000        	call	c_umul
1414  032c ae0016        	ldw	x,#L62
1415  032f cd0000        	call	c_ludv
1417  0332 96            	ldw	x,sp
1418  0333 1c0005        	addw	x,#OFST-11
1419  0336 cd0000        	call	c_rtol
1422                     ; 244     for (i = 0; i < cycles; i++) {
1424  0339 ae0000        	ldw	x,#0
1425  033c 1f0f          	ldw	(OFST-1,sp),x
1426  033e ae0000        	ldw	x,#0
1427  0341 1f0d          	ldw	(OFST-3,sp),x
1430  0343 2025          	jra	L764
1431  0345               L364:
1432                     ; 245         GPIO_WriteHigh(GPIOD, GPIO_PIN_3); // napø. PD3
1434  0345 4b08          	push	#8
1435  0347 ae500f        	ldw	x,#20495
1436  034a cd0000        	call	_GPIO_WriteHigh
1438  034d 84            	pop	a
1439                     ; 246         delay_us(delay);
1441  034e 1e0b          	ldw	x,(OFST-5,sp)
1442  0350 cd00e4        	call	_delay_us
1444                     ; 247         GPIO_WriteLow(GPIOD, GPIO_PIN_3);
1446  0353 4b08          	push	#8
1447  0355 ae500f        	ldw	x,#20495
1448  0358 cd0000        	call	_GPIO_WriteLow
1450  035b 84            	pop	a
1451                     ; 248         delay_us(delay);
1453  035c 1e0b          	ldw	x,(OFST-5,sp)
1454  035e cd00e4        	call	_delay_us
1456                     ; 244     for (i = 0; i < cycles; i++) {
1458  0361 96            	ldw	x,sp
1459  0362 1c000d        	addw	x,#OFST-3
1460  0365 a601          	ld	a,#1
1461  0367 cd0000        	call	c_lgadc
1464  036a               L764:
1467  036a 96            	ldw	x,sp
1468  036b 1c000d        	addw	x,#OFST-3
1469  036e cd0000        	call	c_ltor
1471  0371 96            	ldw	x,sp
1472  0372 1c0005        	addw	x,#OFST-11
1473  0375 cd0000        	call	c_lcmp
1475  0378 25cb          	jrult	L364
1476                     ; 250 }
1479  037a 5b12          	addw	sp,#18
1480  037c 81            	ret
1523                     ; 253 void EEPROM_WriteByte(uint8_t address, uint8_t data) {
1524                     	switch	.text
1525  037d               _EEPROM_WriteByte:
1527  037d 89            	pushw	x
1528       00000000      OFST:	set	0
1531  037e               L715:
1532                     ; 254     while ((FLASH->IAPSR & FLASH_IAPSR_DUL) == 0); // Èekej na odemèení
1534  037e c6505f        	ld	a,20575
1535  0381 a508          	bcp	a,#8
1536  0383 27f9          	jreq	L715
1537                     ; 255     *(PointerAttr uint8_t *)(uint16_t)(FLASH_DATA_START_PHYSICAL_ADDRESS + address) = data;
1539  0385 7b01          	ld	a,(OFST+1,sp)
1540  0387 5f            	clrw	x
1541  0388 97            	ld	xl,a
1542  0389 1c4000        	addw	x,#16384
1543  038c 3f00          	clr	c_x
1544  038e 7b02          	ld	a,(OFST+2,sp)
1545  0390 bf01          	ldw	c_x+1,x
1546  0392 92bd0000      	ldf	[c_x.e],a
1547                     ; 256     FLASH->IAPSR &= (uint8_t)(~FLASH_IAPSR_EOP); // Potvrï zápis
1549  0396 7215505f      	bres	20575,#2
1550                     ; 257 }
1553  039a 85            	popw	x
1554  039b 81            	ret
1588                     ; 259 uint8_t EEPROM_ReadByte(uint8_t address) {
1589                     	switch	.text
1590  039c               _EEPROM_ReadByte:
1594                     ; 260     return *(PointerAttr uint8_t *)(uint16_t)(FLASH_DATA_START_PHYSICAL_ADDRESS + address);
1596  039c 5f            	clrw	x
1597  039d 97            	ld	xl,a
1598  039e 1c4000        	addw	x,#16384
1599  03a1 3f00          	clr	c_x
1600  03a3 bf01          	ldw	c_x+1,x
1601  03a5 92bc0000      	ldf	a,[c_x.e]
1604  03a9 81            	ret
1650                     ; 263 void saveCodeToEEPROM(char *code) {
1651                     	switch	.text
1652  03aa               _saveCodeToEEPROM:
1654  03aa 89            	pushw	x
1655  03ab 88            	push	a
1656       00000001      OFST:	set	1
1659                     ; 265     for ( i = 0; i < 4; i++) {
1661  03ac 0f01          	clr	(OFST+0,sp)
1663  03ae               L365:
1664                     ; 266         EEPROM_WriteByte(0xA0 + i, code[i]);
1666  03ae 7b01          	ld	a,(OFST+0,sp)
1667  03b0 5f            	clrw	x
1668  03b1 97            	ld	xl,a
1669  03b2 72fb02        	addw	x,(OFST+1,sp)
1670  03b5 f6            	ld	a,(x)
1671  03b6 97            	ld	xl,a
1672  03b7 7b01          	ld	a,(OFST+0,sp)
1673  03b9 aba0          	add	a,#160
1674  03bb 95            	ld	xh,a
1675  03bc adbf          	call	_EEPROM_WriteByte
1677                     ; 267         playTone(1000 + (code[i] - '0') * 100, 100); // Indikace zápisu
1679  03be ae0064        	ldw	x,#100
1680  03c1 89            	pushw	x
1681  03c2 7b03          	ld	a,(OFST+2,sp)
1682  03c4 5f            	clrw	x
1683  03c5 97            	ld	xl,a
1684  03c6 72fb04        	addw	x,(OFST+3,sp)
1685  03c9 f6            	ld	a,(x)
1686  03ca 97            	ld	xl,a
1687  03cb a664          	ld	a,#100
1688  03cd 42            	mul	x,a
1689  03ce 1d0ed8        	subw	x,#3800
1690  03d1 cd02ff        	call	_playTone
1692  03d4 85            	popw	x
1693                     ; 265     for ( i = 0; i < 4; i++) {
1695  03d5 0c01          	inc	(OFST+0,sp)
1699  03d7 7b01          	ld	a,(OFST+0,sp)
1700  03d9 a104          	cp	a,#4
1701  03db 25d1          	jrult	L365
1702                     ; 269 }
1705  03dd 5b03          	addw	sp,#3
1706  03df 81            	ret
1751                     ; 271 void loadCodeFromEEPROM(char *code) {
1752                     	switch	.text
1753  03e0               _loadCodeFromEEPROM:
1755  03e0 89            	pushw	x
1756  03e1 88            	push	a
1757       00000001      OFST:	set	1
1760                     ; 273     for ( i = 0; i < 4; i++) {
1762  03e2 0f01          	clr	(OFST+0,sp)
1764  03e4               L316:
1765                     ; 274         code[i] = EEPROM_ReadByte(0xA0 + i); // Naèti hodnotu z EEPROM
1767  03e4 7b01          	ld	a,(OFST+0,sp)
1768  03e6 5f            	clrw	x
1769  03e7 97            	ld	xl,a
1770  03e8 72fb02        	addw	x,(OFST+1,sp)
1771  03eb 89            	pushw	x
1772  03ec 7b03          	ld	a,(OFST+2,sp)
1773  03ee aba0          	add	a,#160
1774  03f0 adaa          	call	_EEPROM_ReadByte
1776  03f2 85            	popw	x
1777  03f3 f7            	ld	(x),a
1778                     ; 273     for ( i = 0; i < 4; i++) {
1780  03f4 0c01          	inc	(OFST+0,sp)
1784  03f6 7b01          	ld	a,(OFST+0,sp)
1785  03f8 a104          	cp	a,#4
1786  03fa 25e8          	jrult	L316
1787                     ; 276     code[4] = '\0'; // Ukonèi øetìzec
1789  03fc 1e02          	ldw	x,(OFST+1,sp)
1790  03fe 6f04          	clr	(4,x)
1791                     ; 277 }
1794  0400 5b03          	addw	sp,#3
1795  0402 81            	ret
1852                     ; 279 void debugEEPROM(void) {
1853                     	switch	.text
1854  0403               _debugEEPROM:
1856  0403 5207          	subw	sp,#7
1857       00000007      OFST:	set	7
1860                     ; 284     loadCodeFromEEPROM(debugCode);
1862  0405 96            	ldw	x,sp
1863  0406 1c0002        	addw	x,#OFST-5
1864  0409 add5          	call	_loadCodeFromEEPROM
1866                     ; 286 		for ( i = 0; i < 4; i++) {
1868  040b 0f07          	clr	(OFST+0,sp)
1870  040d               L746:
1871                     ; 287 				playTone(500 + ((debugCode[i] - '0') * 200), 100);
1873  040d ae0064        	ldw	x,#100
1874  0410 89            	pushw	x
1875  0411 96            	ldw	x,sp
1876  0412 1c0004        	addw	x,#OFST-3
1877  0415 9f            	ld	a,xl
1878  0416 5e            	swapw	x
1879  0417 1b09          	add	a,(OFST+2,sp)
1880  0419 2401          	jrnc	L011
1881  041b 5c            	incw	x
1882  041c               L011:
1883  041c 02            	rlwa	x,a
1884  041d f6            	ld	a,(x)
1885  041e 97            	ld	xl,a
1886  041f a6c8          	ld	a,#200
1887  0421 42            	mul	x,a
1888  0422 1d238c        	subw	x,#9100
1889  0425 cd02ff        	call	_playTone
1891  0428 85            	popw	x
1892                     ; 288 				delay_us(200000); // Pauza mezi tóny
1894  0429 ae0d40        	ldw	x,#3392
1895  042c cd00e4        	call	_delay_us
1897                     ; 286 		for ( i = 0; i < 4; i++) {
1899  042f 0c07          	inc	(OFST+0,sp)
1903  0431 7b07          	ld	a,(OFST+0,sp)
1904  0433 a104          	cp	a,#4
1905  0435 25d6          	jrult	L746
1906                     ; 291     if (strlen(debugCode) == 4 && debugCode[0] >= '0' && debugCode[0] <= '9') {
1908  0437 96            	ldw	x,sp
1909  0438 1c0002        	addw	x,#OFST-5
1910  043b cd0000        	call	_strlen
1912  043e a30004        	cpw	x,#4
1913  0441 261a          	jrne	L556
1915  0443 7b02          	ld	a,(OFST-5,sp)
1916  0445 a130          	cp	a,#48
1917  0447 2514          	jrult	L556
1919  0449 7b02          	ld	a,(OFST-5,sp)
1920  044b a13a          	cp	a,#58
1921  044d 240e          	jruge	L556
1922                     ; 293         playTone(2000, 300); // Jeden dlouhý tón
1924  044f ae012c        	ldw	x,#300
1925  0452 89            	pushw	x
1926  0453 ae07d0        	ldw	x,#2000
1927  0456 cd02ff        	call	_playTone
1929  0459 85            	popw	x
1931  045a               L756:
1932                     ; 301 }
1935  045a 5b07          	addw	sp,#7
1936  045c 81            	ret
1937  045d               L556:
1938                     ; 296         for (k = 0; i < 3; i++) {
1941  045d 2013          	jra	L566
1942  045f               L166:
1943                     ; 297             playTone(1000, 150); // Tøi krátké tóny
1945  045f ae0096        	ldw	x,#150
1946  0462 89            	pushw	x
1947  0463 ae03e8        	ldw	x,#1000
1948  0466 cd02ff        	call	_playTone
1950  0469 85            	popw	x
1951                     ; 298             delay_us(150000);   // Pauza mezi tóny
1953  046a ae49f0        	ldw	x,#18928
1954  046d cd00e4        	call	_delay_us
1956                     ; 296         for (k = 0; i < 3; i++) {
1958  0470 0c07          	inc	(OFST+0,sp)
1960  0472               L566:
1963  0472 7b07          	ld	a,(OFST+0,sp)
1964  0474 a103          	cp	a,#3
1965  0476 25e7          	jrult	L166
1966  0478 20e0          	jra	L756
1969                     	switch	.const
1970  001e               L176_userInput:
1971  001e 20            	dc.b	32
1972  001f 20            	dc.b	32
1973  0020 20            	dc.b	32
1974  0021 20            	dc.b	32
1975  0022 00            	dc.b	0
2051                     ; 305 void main(void) {
2052                     	switch	.text
2053  047a               _main:
2055  047a 5209          	subw	sp,#9
2056       00000009      OFST:	set	9
2059                     ; 306     char key = 0;
2061                     ; 307     char userInput[5] = {' ', ' ', ' ', ' ', '\0'};
2063  047c 96            	ldw	x,sp
2064  047d 1c0004        	addw	x,#OFST-5
2065  0480 90ae001e      	ldw	y,#L176_userInput
2066  0484 a605          	ld	a,#5
2067  0486 cd0000        	call	c_xymov
2069                     ; 308     uint8_t index = 0;
2071  0489 0f03          	clr	(OFST-6,sp)
2073                     ; 313     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
2075  048b 4f            	clr	a
2076  048c cd0000        	call	_CLK_HSIPrescalerConfig
2078                     ; 316     GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST);
2080  048f 4be0          	push	#224
2081  0491 4b20          	push	#32
2082  0493 ae5005        	ldw	x,#20485
2083  0496 cd0000        	call	_GPIO_Init
2085  0499 85            	popw	x
2086                     ; 317     GPIO_Init(GPIOB, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_FAST);
2088  049a 4be0          	push	#224
2089  049c 4b10          	push	#16
2090  049e ae5005        	ldw	x,#20485
2091  04a1 cd0000        	call	_GPIO_Init
2093  04a4 85            	popw	x
2094                     ; 318     GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); // Výstup pro zvuk
2096  04a5 4be0          	push	#224
2097  04a7 4b08          	push	#8
2098  04a9 ae500f        	ldw	x,#20495
2099  04ac cd0000        	call	_GPIO_Init
2101  04af 85            	popw	x
2102                     ; 319     initKeypad();
2104  04b0 cd0103        	call	_initKeypad
2106                     ; 322 		loadCodeFromEEPROM(savedCode);
2108  04b3 ae0000        	ldw	x,#_savedCode
2109  04b6 cd03e0        	call	_loadCodeFromEEPROM
2111                     ; 325 		for (i = 0; i < 4; i++) {
2113  04b9 0f09          	clr	(OFST+0,sp)
2115  04bb               L527:
2116                     ; 326 				if (savedCode[i] >= '0' && savedCode[i] <= '9') {
2118  04bb 7b09          	ld	a,(OFST+0,sp)
2119  04bd 5f            	clrw	x
2120  04be 97            	ld	xl,a
2121  04bf e600          	ld	a,(_savedCode,x)
2122  04c1 a130          	cp	a,#48
2123  04c3 2521          	jrult	L337
2125  04c5 7b09          	ld	a,(OFST+0,sp)
2126  04c7 5f            	clrw	x
2127  04c8 97            	ld	xl,a
2128  04c9 e600          	ld	a,(_savedCode,x)
2129  04cb a13a          	cp	a,#58
2130  04cd 2417          	jruge	L337
2131                     ; 327 						playTone(1000 + (savedCode[i] - '0') * 100, 100); // Pøehraj hodnoty
2133  04cf ae0064        	ldw	x,#100
2134  04d2 89            	pushw	x
2135  04d3 7b0b          	ld	a,(OFST+2,sp)
2136  04d5 5f            	clrw	x
2137  04d6 97            	ld	xl,a
2138  04d7 e600          	ld	a,(_savedCode,x)
2139  04d9 97            	ld	xl,a
2140  04da a664          	ld	a,#100
2141  04dc 42            	mul	x,a
2142  04dd 1d0ed8        	subw	x,#3800
2143  04e0 cd02ff        	call	_playTone
2145  04e3 85            	popw	x
2147  04e4 200b          	jra	L537
2148  04e6               L337:
2149                     ; 329 						playTone(500, 300); // Tón pro chybnou hodnotu
2151  04e6 ae012c        	ldw	x,#300
2152  04e9 89            	pushw	x
2153  04ea ae01f4        	ldw	x,#500
2154  04ed cd02ff        	call	_playTone
2156  04f0 85            	popw	x
2157  04f1               L537:
2158                     ; 331 				delay_us(200000);
2160  04f1 ae0d40        	ldw	x,#3392
2161  04f4 cd00e4        	call	_delay_us
2163                     ; 325 		for (i = 0; i < 4; i++) {
2165  04f7 0c09          	inc	(OFST+0,sp)
2169  04f9 7b09          	ld	a,(OFST+0,sp)
2170  04fb a104          	cp	a,#4
2171  04fd 25bc          	jrult	L527
2172                     ; 335 		if (strlen(savedCode) != 4) {
2174  04ff ae0000        	ldw	x,#_savedCode
2175  0502 cd0000        	call	_strlen
2177  0505 a30004        	cpw	x,#4
2178  0508 270d          	jreq	L737
2179                     ; 336 				playTone(500, 300); // Tón pro neplatnou délku
2181  050a ae012c        	ldw	x,#300
2182  050d 89            	pushw	x
2183  050e ae01f4        	ldw	x,#500
2184  0511 cd02ff        	call	_playTone
2186  0514 85            	popw	x
2188  0515 2017          	jra	L147
2189  0517               L737:
2190                     ; 337 		} else if (savedCode[0] < '0' || savedCode[0] > '9') {
2192  0517 b600          	ld	a,_savedCode
2193  0519 a130          	cp	a,#48
2194  051b 2506          	jrult	L547
2196  051d b600          	ld	a,_savedCode
2197  051f a13a          	cp	a,#58
2198  0521 250b          	jrult	L147
2199  0523               L547:
2200                     ; 338 				playTone(700, 300); // Tón pro neplatný první znak
2202  0523 ae012c        	ldw	x,#300
2203  0526 89            	pushw	x
2204  0527 ae02bc        	ldw	x,#700
2205  052a cd02ff        	call	_playTone
2207  052d 85            	popw	x
2208  052e               L147:
2209                     ; 341 		if (strlen(savedCode) != 4 || savedCode[0] < '0' || savedCode[0] > '9') {
2211  052e ae0000        	ldw	x,#_savedCode
2212  0531 cd0000        	call	_strlen
2214  0534 a30004        	cpw	x,#4
2215  0537 260c          	jrne	L157
2217  0539 b600          	ld	a,_savedCode
2218  053b a130          	cp	a,#48
2219  053d 2506          	jrult	L157
2221  053f b600          	ld	a,_savedCode
2222  0541 a13a          	cp	a,#58
2223  0543 255e          	jrult	L747
2224  0545               L157:
2225                     ; 342 				playTone(500, 300); // Tón pro neplatnou délku
2227  0545 ae012c        	ldw	x,#300
2228  0548 89            	pushw	x
2229  0549 ae01f4        	ldw	x,#500
2230  054c cd02ff        	call	_playTone
2232  054f 85            	popw	x
2233                     ; 343 				strcpy(savedCode, "1234"); // Nastav výchozí kód
2235  0550 ae0000        	ldw	x,#_savedCode
2236  0553 90ae0023      	ldw	y,#L557
2237  0557 cd0000        	call	c_strcpx
2239                     ; 344 				saveCodeToEEPROM(savedCode); // Ulož výchozí kód do EEPROM
2241  055a ae0000        	ldw	x,#_savedCode
2242  055d cd03aa        	call	_saveCodeToEEPROM
2244                     ; 345 				playTone(1500, 300); // Indikace inicializace
2246  0560 ae012c        	ldw	x,#300
2247  0563 89            	pushw	x
2248  0564 ae05dc        	ldw	x,#1500
2249  0567 cd02ff        	call	_playTone
2251  056a 85            	popw	x
2253  056b               L167:
2254                     ; 352         key = getKey();
2256  056b cd013b        	call	_getKey
2258  056e 6b09          	ld	(OFST+0,sp),a
2260                     ; 355         if (key >= '0' && key <= '9' && index < 4) {
2262  0570 7b09          	ld	a,(OFST+0,sp)
2263  0572 a130          	cp	a,#48
2264  0574 253a          	jrult	L567
2266  0576 7b09          	ld	a,(OFST+0,sp)
2267  0578 a13a          	cp	a,#58
2268  057a 2434          	jruge	L567
2270  057c 7b03          	ld	a,(OFST-6,sp)
2271  057e a104          	cp	a,#4
2272  0580 242e          	jruge	L567
2273                     ; 356             userInput[index++] = key;
2275  0582 96            	ldw	x,sp
2276  0583 1c0004        	addw	x,#OFST-5
2277  0586 1f01          	ldw	(OFST-8,sp),x
2279  0588 7b03          	ld	a,(OFST-6,sp)
2280  058a 97            	ld	xl,a
2281  058b 0c03          	inc	(OFST-6,sp)
2283  058d 9f            	ld	a,xl
2284  058e 5f            	clrw	x
2285  058f 97            	ld	xl,a
2286  0590 72fb01        	addw	x,(OFST-8,sp)
2287  0593 7b09          	ld	a,(OFST+0,sp)
2288  0595 f7            	ld	(x),a
2289                     ; 357             playTone(2000, 100);
2291  0596 ae0064        	ldw	x,#100
2292  0599 89            	pushw	x
2293  059a ae07d0        	ldw	x,#2000
2294  059d cd02ff        	call	_playTone
2296  05a0 85            	popw	x
2298  05a1 2028          	jra	L767
2299  05a3               L747:
2300                     ; 347 				playTone(2000, 300); // Tón pro správná data
2302  05a3 ae012c        	ldw	x,#300
2303  05a6 89            	pushw	x
2304  05a7 ae07d0        	ldw	x,#2000
2305  05aa cd02ff        	call	_playTone
2307  05ad 85            	popw	x
2308  05ae 20bb          	jra	L167
2309  05b0               L567:
2310                     ; 360         else if (key == '#' && isLoggedIn) {
2312  05b0 7b09          	ld	a,(OFST+0,sp)
2313  05b2 a123          	cp	a,#35
2314  05b4 2615          	jrne	L767
2316  05b6 3d05          	tnz	_isLoggedIn
2317  05b8 2711          	jreq	L767
2318                     ; 361             changingCode = 1;
2320  05ba 35010006      	mov	_changingCode,#1
2321                     ; 362             index = 0; // Resetuj index
2323  05be 0f03          	clr	(OFST-6,sp)
2325                     ; 363             playTone(1500, 200);
2327  05c0 ae00c8        	ldw	x,#200
2328  05c3 89            	pushw	x
2329  05c4 ae05dc        	ldw	x,#1500
2330  05c7 cd02ff        	call	_playTone
2332  05ca 85            	popw	x
2333  05cb               L767:
2334                     ; 367         for (i = 0; i < 4; i++) {
2336  05cb 0f09          	clr	(OFST+0,sp)
2338  05cd               L377:
2339                     ; 368             if (userInput[i] >= '0' && userInput[i] <= '9') {
2341  05cd 96            	ldw	x,sp
2342  05ce 1c0004        	addw	x,#OFST-5
2343  05d1 9f            	ld	a,xl
2344  05d2 5e            	swapw	x
2345  05d3 1b09          	add	a,(OFST+0,sp)
2346  05d5 2401          	jrnc	L411
2347  05d7 5c            	incw	x
2348  05d8               L411:
2349  05d8 02            	rlwa	x,a
2350  05d9 f6            	ld	a,(x)
2351  05da a130          	cp	a,#48
2352  05dc 252f          	jrult	L1001
2354  05de 96            	ldw	x,sp
2355  05df 1c0004        	addw	x,#OFST-5
2356  05e2 9f            	ld	a,xl
2357  05e3 5e            	swapw	x
2358  05e4 1b09          	add	a,(OFST+0,sp)
2359  05e6 2401          	jrnc	L611
2360  05e8 5c            	incw	x
2361  05e9               L611:
2362  05e9 02            	rlwa	x,a
2363  05ea f6            	ld	a,(x)
2364  05eb a13a          	cp	a,#58
2365  05ed 241e          	jruge	L1001
2366                     ; 369                 tm_displayCharacter(i, digitToSegment[userInput[i] - '0']);
2368  05ef 96            	ldw	x,sp
2369  05f0 1c0004        	addw	x,#OFST-5
2370  05f3 9f            	ld	a,xl
2371  05f4 5e            	swapw	x
2372  05f5 1b09          	add	a,(OFST+0,sp)
2373  05f7 2401          	jrnc	L021
2374  05f9 5c            	incw	x
2375  05fa               L021:
2376  05fa 02            	rlwa	x,a
2377  05fb f6            	ld	a,(x)
2378  05fc 5f            	clrw	x
2379  05fd 97            	ld	xl,a
2380  05fe 1d0030        	subw	x,#48
2381  0601 d60000        	ld	a,(_digitToSegment,x)
2382  0604 97            	ld	xl,a
2383  0605 7b09          	ld	a,(OFST+0,sp)
2384  0607 95            	ld	xh,a
2385  0608 cd00be        	call	_tm_displayCharacter
2388  060b 2007          	jra	L3001
2389  060d               L1001:
2390                     ; 371                 tm_displayCharacter(i, 0x00); // Vypni segment, pokud není zadáno èíslo
2392  060d 7b09          	ld	a,(OFST+0,sp)
2393  060f 5f            	clrw	x
2394  0610 95            	ld	xh,a
2395  0611 cd00be        	call	_tm_displayCharacter
2397  0614               L3001:
2398                     ; 367         for (i = 0; i < 4; i++) {
2400  0614 0c09          	inc	(OFST+0,sp)
2404  0616 7b09          	ld	a,(OFST+0,sp)
2405  0618 a104          	cp	a,#4
2406  061a 25b1          	jrult	L377
2407                     ; 376         if (index == 4) {
2409  061c 7b03          	ld	a,(OFST-6,sp)
2410  061e a104          	cp	a,#4
2411  0620 2703          	jreq	L421
2412  0622 cc056b        	jp	L167
2413  0625               L421:
2414                     ; 377             userInput[4] = '\0'; // Ukonèi vstup jako øetìzec
2416  0625 0f08          	clr	(OFST-1,sp)
2418                     ; 379             if (changingCode) {
2420  0627 3d06          	tnz	_changingCode
2421  0629 2721          	jreq	L7001
2422                     ; 381                 strcpy(savedCode, userInput);
2424  062b ae0000        	ldw	x,#_savedCode
2425  062e 9096          	ldw	y,sp
2426  0630 72a90004      	addw	y,#OFST-5
2427  0634 cd0000        	call	c_strcpx
2429                     ; 382                 saveCodeToEEPROM(savedCode);
2431  0637 ae0000        	ldw	x,#_savedCode
2432  063a cd03aa        	call	_saveCodeToEEPROM
2434                     ; 383                 changingCode = 0;
2436  063d 3f06          	clr	_changingCode
2437                     ; 384                 playTone(1800, 300);
2439  063f ae012c        	ldw	x,#300
2440  0642 89            	pushw	x
2441  0643 ae0708        	ldw	x,#1800
2442  0646 cd02ff        	call	_playTone
2444  0649 85            	popw	x
2446  064a 202e          	jra	L1101
2447  064c               L7001:
2448                     ; 385             } else if (strcmp(savedCode, userInput) == 0) {
2450  064c 96            	ldw	x,sp
2451  064d 1c0004        	addw	x,#OFST-5
2452  0650 89            	pushw	x
2453  0651 ae0000        	ldw	x,#_savedCode
2454  0654 cd0000        	call	_strcmp
2456  0657 5b02          	addw	sp,#2
2457  0659 a30000        	cpw	x,#0
2458  065c 2611          	jrne	L3101
2459                     ; 387                 isLoggedIn = 1;
2461  065e 35010005      	mov	_isLoggedIn,#1
2462                     ; 388                 playTone(1500, 400);
2464  0662 ae0190        	ldw	x,#400
2465  0665 89            	pushw	x
2466  0666 ae05dc        	ldw	x,#1500
2467  0669 cd02ff        	call	_playTone
2469  066c 85            	popw	x
2471  066d 200b          	jra	L1101
2472  066f               L3101:
2473                     ; 391                 playTone(300, 700);
2475  066f ae02bc        	ldw	x,#700
2476  0672 89            	pushw	x
2477  0673 ae012c        	ldw	x,#300
2478  0676 cd02ff        	call	_playTone
2480  0679 85            	popw	x
2481  067a               L1101:
2482                     ; 395             index = 0;
2484  067a 0f03          	clr	(OFST-6,sp)
2486                     ; 396             for (i = 0; i < 4; i++) {
2488  067c 0f09          	clr	(OFST+0,sp)
2490  067e               L7101:
2491                     ; 397                 userInput[i] = ' ';
2493  067e 96            	ldw	x,sp
2494  067f 1c0004        	addw	x,#OFST-5
2495  0682 9f            	ld	a,xl
2496  0683 5e            	swapw	x
2497  0684 1b09          	add	a,(OFST+0,sp)
2498  0686 2401          	jrnc	L221
2499  0688 5c            	incw	x
2500  0689               L221:
2501  0689 02            	rlwa	x,a
2502  068a a620          	ld	a,#32
2503  068c f7            	ld	(x),a
2504                     ; 396             for (i = 0; i < 4; i++) {
2506  068d 0c09          	inc	(OFST+0,sp)
2510  068f 7b09          	ld	a,(OFST+0,sp)
2511  0691 a104          	cp	a,#4
2512  0693 25e9          	jrult	L7101
2513  0695 ac6b056b      	jpf	L167
2548                     ; 406 void assert_failed(uint8_t* file, uint32_t line) {
2549                     	switch	.text
2550  0699               _assert_failed:
2554  0699               L3401:
2555                     ; 407     while (1);
2557  0699 20fe          	jra	L3401
2610                     	xdef	_main
2611                     	xdef	_digitToSegment
2612                     	xdef	_loadCodeFromEEPROM
2613                     	xdef	_saveCodeToEEPROM
2614                     	xdef	_EEPROM_ReadByte
2615                     	xdef	_EEPROM_WriteByte
2616                     	xdef	_changingCode
2617                     	xdef	_isLoggedIn
2618                     	xdef	_savedCode
2619                     	xdef	_getKey
2620                     	xdef	_initKeypad
2621                     	xdef	_debugEEPROM
2622                     	xdef	_playTone
2623                     	xdef	_delay_us
2624                     	xdef	_tm_displayCharacter
2625                     	xdef	_tm_writeByte
2626                     	xdef	_tm_stop
2627                     	xdef	_tm_start
2628                     	xdef	_setCLK
2629                     	xdef	_setDIO
2630                     	xref	_strlen
2631                     	xref	_strcmp
2632                     	xdef	_assert_failed
2633                     	xref	_GPIO_WriteLow
2634                     	xref	_GPIO_WriteHigh
2635                     	xref	_GPIO_Init
2636                     	xref	_CLK_HSIPrescalerConfig
2637                     	switch	.const
2638  0023               L557:
2639  0023 3132333400    	dc.b	"1234",0
2640                     	xref.b	c_lreg
2641                     	xref.b	c_x
2642                     	xref.b	c_y
2662                     	xref	c_strcpx
2663                     	xref	c_umul
2664                     	xref	c_ludv
2665                     	xref	c_rtol
2666                     	xref	c_uitolx
2667                     	xref	c_bmulx
2668                     	xref	c_lcmp
2669                     	xref	c_ltor
2670                     	xref	c_lgadc
2671                     	xref	c_xymov
2672                     	end
