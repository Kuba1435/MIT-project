   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
  15                     .const:	section	.text
  16  0000               _APR_Array:
  17  0000 00            	dc.b	0
  18  0001 1e            	dc.b	30
  19  0002 1e            	dc.b	30
  20  0003 1e            	dc.b	30
  21  0004 1e            	dc.b	30
  22  0005 1e            	dc.b	30
  23  0006 1e            	dc.b	30
  24  0007 1e            	dc.b	30
  25  0008 1e            	dc.b	30
  26  0009 1e            	dc.b	30
  27  000a 1e            	dc.b	30
  28  000b 1e            	dc.b	30
  29  000c 1e            	dc.b	30
  30  000d 3d            	dc.b	61
  31  000e 17            	dc.b	23
  32  000f 17            	dc.b	23
  33  0010 3e            	dc.b	62
  34  0011               _TBR_Array:
  35  0011 00            	dc.b	0
  36  0012 01            	dc.b	1
  37  0013 02            	dc.b	2
  38  0014 03            	dc.b	3
  39  0015 04            	dc.b	4
  40  0016 05            	dc.b	5
  41  0017 06            	dc.b	6
  42  0018 07            	dc.b	7
  43  0019 08            	dc.b	8
  44  001a 09            	dc.b	9
  45  001b 0a            	dc.b	10
  46  001c 0b            	dc.b	11
  47  001d 0c            	dc.b	12
  48  001e 0c            	dc.b	12
  49  001f 0e            	dc.b	14
  50  0020 0f            	dc.b	15
  51  0021 0f            	dc.b	15
  80                     ; 73 void AWU_DeInit(void)
  80                     ; 74 {
  82                     	switch	.text
  83  0000               _AWU_DeInit:
  87                     ; 75   AWU->CSR = AWU_CSR_RESET_VALUE;
  89  0000 725f50f0      	clr	20720
  90                     ; 76   AWU->APR = AWU_APR_RESET_VALUE;
  92  0004 353f50f1      	mov	20721,#63
  93                     ; 77   AWU->TBR = AWU_TBR_RESET_VALUE;
  95  0008 725f50f2      	clr	20722
  96                     ; 78 }
  99  000c 81            	ret
 262                     ; 88 void AWU_Init(AWU_Timebase_TypeDef AWU_TimeBase)
 262                     ; 89 {
 263                     	switch	.text
 264  000d               _AWU_Init:
 266  000d 88            	push	a
 267       00000000      OFST:	set	0
 270                     ; 91   assert_param(IS_AWU_TIMEBASE_OK(AWU_TimeBase));
 272  000e 4d            	tnz	a
 273  000f 2740          	jreq	L21
 274  0011 a101          	cp	a,#1
 275  0013 273c          	jreq	L21
 276  0015 a102          	cp	a,#2
 277  0017 2738          	jreq	L21
 278  0019 a103          	cp	a,#3
 279  001b 2734          	jreq	L21
 280  001d a104          	cp	a,#4
 281  001f 2730          	jreq	L21
 282  0021 a105          	cp	a,#5
 283  0023 272c          	jreq	L21
 284  0025 a106          	cp	a,#6
 285  0027 2728          	jreq	L21
 286  0029 a107          	cp	a,#7
 287  002b 2724          	jreq	L21
 288  002d a108          	cp	a,#8
 289  002f 2720          	jreq	L21
 290  0031 a109          	cp	a,#9
 291  0033 271c          	jreq	L21
 292  0035 a10a          	cp	a,#10
 293  0037 2718          	jreq	L21
 294  0039 a10b          	cp	a,#11
 295  003b 2714          	jreq	L21
 296  003d a10c          	cp	a,#12
 297  003f 2710          	jreq	L21
 298  0041 a10d          	cp	a,#13
 299  0043 270c          	jreq	L21
 300  0045 a10e          	cp	a,#14
 301  0047 2708          	jreq	L21
 302  0049 a10f          	cp	a,#15
 303  004b 2704          	jreq	L21
 304  004d a110          	cp	a,#16
 305  004f 2603          	jrne	L01
 306  0051               L21:
 307  0051 4f            	clr	a
 308  0052 2010          	jra	L41
 309  0054               L01:
 310  0054 ae005b        	ldw	x,#91
 311  0057 89            	pushw	x
 312  0058 ae0000        	ldw	x,#0
 313  005b 89            	pushw	x
 314  005c ae002e        	ldw	x,#L501
 315  005f cd0000        	call	_assert_failed
 317  0062 5b04          	addw	sp,#4
 318  0064               L41:
 319                     ; 94   AWU->CSR |= AWU_CSR_AWUEN;
 321  0064 721850f0      	bset	20720,#4
 322                     ; 97   AWU->TBR &= (uint8_t)(~AWU_TBR_AWUTB);
 324  0068 c650f2        	ld	a,20722
 325  006b a4f0          	and	a,#240
 326  006d c750f2        	ld	20722,a
 327                     ; 98   AWU->TBR |= TBR_Array[(uint8_t)AWU_TimeBase];
 329  0070 7b01          	ld	a,(OFST+1,sp)
 330  0072 5f            	clrw	x
 331  0073 97            	ld	xl,a
 332  0074 c650f2        	ld	a,20722
 333  0077 da0011        	or	a,(_TBR_Array,x)
 334  007a c750f2        	ld	20722,a
 335                     ; 101   AWU->APR &= (uint8_t)(~AWU_APR_APR);
 337  007d c650f1        	ld	a,20721
 338  0080 a4c0          	and	a,#192
 339  0082 c750f1        	ld	20721,a
 340                     ; 102   AWU->APR |= APR_Array[(uint8_t)AWU_TimeBase];
 342  0085 7b01          	ld	a,(OFST+1,sp)
 343  0087 5f            	clrw	x
 344  0088 97            	ld	xl,a
 345  0089 c650f1        	ld	a,20721
 346  008c da0000        	or	a,(_APR_Array,x)
 347  008f c750f1        	ld	20721,a
 348                     ; 103 }
 351  0092 84            	pop	a
 352  0093 81            	ret
 407                     ; 112 void AWU_Cmd(FunctionalState NewState)
 407                     ; 113 {
 408                     	switch	.text
 409  0094               _AWU_Cmd:
 413                     ; 114   if (NewState != DISABLE)
 415  0094 4d            	tnz	a
 416  0095 2706          	jreq	L531
 417                     ; 117     AWU->CSR |= AWU_CSR_AWUEN;
 419  0097 721850f0      	bset	20720,#4
 421  009b 2004          	jra	L731
 422  009d               L531:
 423                     ; 122     AWU->CSR &= (uint8_t)(~AWU_CSR_AWUEN);
 425  009d 721950f0      	bres	20720,#4
 426  00a1               L731:
 427                     ; 124 }
 430  00a1 81            	ret
 484                     	switch	.const
 485  0022               L42:
 486  0022 0001adb0      	dc.l	110000
 487  0026               L62:
 488  0026 000249f1      	dc.l	150001
 489  002a               L23:
 490  002a 000003e8      	dc.l	1000
 491                     ; 139 void AWU_LSICalibrationConfig(uint32_t LSIFreqHz)
 491                     ; 140 {
 492                     	switch	.text
 493  00a2               _AWU_LSICalibrationConfig:
 495  00a2 5206          	subw	sp,#6
 496       00000006      OFST:	set	6
 499                     ; 141   uint16_t lsifreqkhz = 0x0;
 501                     ; 142   uint16_t A = 0x0;
 503                     ; 145   assert_param(IS_LSI_FREQUENCY_OK(LSIFreqHz));
 505  00a4 96            	ldw	x,sp
 506  00a5 1c0009        	addw	x,#OFST+3
 507  00a8 cd0000        	call	c_ltor
 509  00ab ae0022        	ldw	x,#L42
 510  00ae cd0000        	call	c_lcmp
 512  00b1 2512          	jrult	L22
 513  00b3 96            	ldw	x,sp
 514  00b4 1c0009        	addw	x,#OFST+3
 515  00b7 cd0000        	call	c_ltor
 517  00ba ae0026        	ldw	x,#L62
 518  00bd cd0000        	call	c_lcmp
 520  00c0 2403          	jruge	L22
 521  00c2 4f            	clr	a
 522  00c3 2010          	jra	L03
 523  00c5               L22:
 524  00c5 ae0091        	ldw	x,#145
 525  00c8 89            	pushw	x
 526  00c9 ae0000        	ldw	x,#0
 527  00cc 89            	pushw	x
 528  00cd ae002e        	ldw	x,#L501
 529  00d0 cd0000        	call	_assert_failed
 531  00d3 5b04          	addw	sp,#4
 532  00d5               L03:
 533                     ; 147   lsifreqkhz = (uint16_t)(LSIFreqHz / 1000); /* Converts value in kHz */
 535  00d5 96            	ldw	x,sp
 536  00d6 1c0009        	addw	x,#OFST+3
 537  00d9 cd0000        	call	c_ltor
 539  00dc ae002a        	ldw	x,#L23
 540  00df cd0000        	call	c_ludv
 542  00e2 be02          	ldw	x,c_lreg+2
 543  00e4 1f03          	ldw	(OFST-3,sp),x
 545                     ; 151   A = (uint16_t)(lsifreqkhz >> 2U); /* Division by 4, keep integer part only */
 547  00e6 1e03          	ldw	x,(OFST-3,sp)
 548  00e8 54            	srlw	x
 549  00e9 54            	srlw	x
 550  00ea 1f05          	ldw	(OFST-1,sp),x
 552                     ; 153   if ((4U * A) >= ((lsifreqkhz - (4U * A)) * (1U + (2U * A))))
 554  00ec 1e05          	ldw	x,(OFST-1,sp)
 555  00ee 58            	sllw	x
 556  00ef 58            	sllw	x
 557  00f0 1f01          	ldw	(OFST-5,sp),x
 559  00f2 1e03          	ldw	x,(OFST-3,sp)
 560  00f4 72f001        	subw	x,(OFST-5,sp)
 561  00f7 1605          	ldw	y,(OFST-1,sp)
 562  00f9 9058          	sllw	y
 563  00fb 905c          	incw	y
 564  00fd cd0000        	call	c_imul
 566  0100 1605          	ldw	y,(OFST-1,sp)
 567  0102 9058          	sllw	y
 568  0104 9058          	sllw	y
 569  0106 bf00          	ldw	c_x,x
 570  0108 90b300        	cpw	y,c_x
 571  010b 2509          	jrult	L761
 572                     ; 155     AWU->APR = (uint8_t)(A - 2U);
 574  010d 7b06          	ld	a,(OFST+0,sp)
 575  010f a002          	sub	a,#2
 576  0111 c750f1        	ld	20721,a
 578  0114 2006          	jra	L171
 579  0116               L761:
 580                     ; 159     AWU->APR = (uint8_t)(A - 1U);
 582  0116 7b06          	ld	a,(OFST+0,sp)
 583  0118 4a            	dec	a
 584  0119 c750f1        	ld	20721,a
 585  011c               L171:
 586                     ; 161 }
 589  011c 5b06          	addw	sp,#6
 590  011e 81            	ret
 613                     ; 168 void AWU_IdleModeEnable(void)
 613                     ; 169 {
 614                     	switch	.text
 615  011f               _AWU_IdleModeEnable:
 619                     ; 171   AWU->CSR &= (uint8_t)(~AWU_CSR_AWUEN);
 621  011f 721950f0      	bres	20720,#4
 622                     ; 174   AWU->TBR = (uint8_t)(~AWU_TBR_AWUTB);
 624  0123 35f050f2      	mov	20722,#240
 625                     ; 175 }
 628  0127 81            	ret
 672                     ; 183 FlagStatus AWU_GetFlagStatus(void)
 672                     ; 184 {
 673                     	switch	.text
 674  0128               _AWU_GetFlagStatus:
 678                     ; 185   return((FlagStatus)(((uint8_t)(AWU->CSR & AWU_CSR_AWUF) == (uint8_t)0x00) ? RESET : SET));
 680  0128 c650f0        	ld	a,20720
 681  012b a520          	bcp	a,#32
 682  012d 2603          	jrne	L04
 683  012f 4f            	clr	a
 684  0130 2002          	jra	L24
 685  0132               L04:
 686  0132 a601          	ld	a,#1
 687  0134               L24:
 690  0134 81            	ret
 725                     	xdef	_TBR_Array
 726                     	xdef	_APR_Array
 727                     	xdef	_AWU_GetFlagStatus
 728                     	xdef	_AWU_IdleModeEnable
 729                     	xdef	_AWU_LSICalibrationConfig
 730                     	xdef	_AWU_Cmd
 731                     	xdef	_AWU_Init
 732                     	xdef	_AWU_DeInit
 733                     	xref	_assert_failed
 734                     	switch	.const
 735  002e               L501:
 736  002e 2e2e5c733230  	dc.b	"..\s208_vzor\src\s"
 737  0040 746d38735f61  	dc.b	"tm8s_awu.c",0
 738                     	xref.b	c_lreg
 739                     	xref.b	c_x
 759                     	xref	c_imul
 760                     	xref	c_ludv
 761                     	xref	c_lcmp
 762                     	xref	c_ltor
 763                     	end
