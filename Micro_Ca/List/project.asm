
;CodeVisionAVR C Compiler V2.05.0 Advanced
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _mode=R4
	.DEF _rx_wr_index=R7
	.DEF _rx_rd_index=R6
	.DEF _rx_counter=R9

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x83:
	.DB  0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  0x04
	.DW  _0x83*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Advanced
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 1/25/2018
;Author  : www.Eca.ir *** www.Webkade.ir
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;void turn_horiz_motor(void);
;void turn_vert_motor(void);
;int mode = 0;
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0050 {

	.CSEG
_usart_rx_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0051 char status,data;
; 0000 0052 status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0053 data=UDR;
	IN   R16,12
; 0000 0054 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0055    {
; 0000 0056    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R7
	INC  R7
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0057 #if RX_BUFFER_SIZE == 256
; 0000 0058    // special case for receiver buffer size=256
; 0000 0059    if (++rx_counter == 0)
; 0000 005A       {
; 0000 005B #else
; 0000 005C    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x4
	CLR  R7
; 0000 005D    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R9
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0x5
; 0000 005E       {
; 0000 005F       rx_counter=0;
	CLR  R9
; 0000 0060 #endif
; 0000 0061       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0062       }
; 0000 0063    }
_0x5:
; 0000 0064    if(data == 'a')
_0x3:
	CPI  R16,97
	BRNE _0x6
; 0000 0065    {
; 0000 0066     mode = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x82
; 0000 0067 
; 0000 0068     }
; 0000 0069    else if(data == 'b')
_0x6:
	CPI  R16,98
	BRNE _0x8
; 0000 006A     mode = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0x82:
	MOVW R4,R30
; 0000 006B 
; 0000 006C    if(mode==1)
_0x8:
	CALL SUBOPT_0x0
	BRNE _0x9
; 0000 006D        PORTB.0=~PORTB.0;
	SBIS 0x18,0
	RJMP _0xA
	CBI  0x18,0
	RJMP _0xB
_0xA:
	SBI  0x18,0
_0xB:
; 0000 006E 
; 0000 006F    if(data=='h')
_0x9:
	CPI  R16,104
	BRNE _0xC
; 0000 0070    {
; 0000 0071      PORTB.0=~PORTB.0;
	SBIS 0x18,0
	RJMP _0xD
	CBI  0x18,0
	RJMP _0xE
_0xD:
	SBI  0x18,0
_0xE:
; 0000 0072     if(mode==1)
	CALL SUBOPT_0x0
	BRNE _0xF
; 0000 0073      turn_horiz_motor();
	RCALL _turn_horiz_motor
; 0000 0074      }
_0xF:
; 0000 0075 
; 0000 0076    if(data=='v')
_0xC:
	CPI  R16,118
	BRNE _0x10
; 0000 0077     if(mode == 1)
	CALL SUBOPT_0x0
	BRNE _0x11
; 0000 0078      turn_vert_motor();
	RCALL _turn_vert_motor
; 0000 0079 
; 0000 007A }
_0x11:
_0x10:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0081 {
; 0000 0082 char data;
; 0000 0083 while (rx_counter==0);
;	data -> R17
; 0000 0084 data=rx_buffer[rx_rd_index++];
; 0000 0085 #if RX_BUFFER_SIZE != 256
; 0000 0086 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 0087 #endif
; 0000 0088 #asm("cli")
; 0000 0089 --rx_counter;
; 0000 008A #asm("sei")
; 0000 008B return data;
; 0000 008C }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;#include <delay.h>
;
;
;
;// Declare your global variables here
;void turn_vert_motor(void)
; 0000 0098 {
_turn_vert_motor:
; 0000 0099 
; 0000 009A       if(((PORTA & 0x0F)==0x00) || ((PORTA & 0x01) ==0x01)  ){
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	BREQ _0x17
	IN   R30,0x1B
	ANDI R30,LOW(0x1)
	CPI  R30,LOW(0x1)
	BRNE _0x16
_0x17:
; 0000 009B 
; 0000 009C 
; 0000 009D             delay_ms(1000);
	CALL SUBOPT_0x1
; 0000 009E             PORTA.0=0;
; 0000 009F             PORTA.1=1;
	SBI  0x1B,1
; 0000 00A0             PORTA.2=0;
	CBI  0x1B,2
; 0000 00A1             PORTA.3=0;
	CBI  0x1B,3
; 0000 00A2 
; 0000 00A3            }
; 0000 00A4     if((PORTA & 0x0F)==0x02){
_0x16:
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0x2)
	BRNE _0x21
; 0000 00A5 
; 0000 00A6       delay_ms(1000);
	RJMP _0x2060001
; 0000 00A7             PORTA.0=0;
; 0000 00A8             PORTA.1=0;
; 0000 00A9             PORTA.2=1;
; 0000 00AA             PORTA.3=0;
; 0000 00AB 
; 0000 00AC             return;
; 0000 00AD 
; 0000 00AE       }
; 0000 00AF 
; 0000 00B0     if((PORTA & 0x0F) == 0x04){
_0x21:
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0x4)
	BRNE _0x2A
; 0000 00B1 
; 0000 00B2         delay_ms(1000);
	CALL SUBOPT_0x1
; 0000 00B3 
; 0000 00B4             PORTA.0=0;
; 0000 00B5             PORTA.1=0;
	CBI  0x1B,1
; 0000 00B6             PORTA.2=0;
	CBI  0x1B,2
; 0000 00B7             PORTA.3=1;
	SBI  0x1B,3
; 0000 00B8 
; 0000 00B9     }
; 0000 00BA 
; 0000 00BB      if((PORTA & 0x0F) == 0x08){
_0x2A:
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0x8)
	BRNE _0x33
; 0000 00BC 
; 0000 00BD         delay_ms(1000);
	CALL SUBOPT_0x2
; 0000 00BE 
; 0000 00BF             PORTA.0=1;
	SBI  0x1B,0
; 0000 00C0             PORTA.1=0;
	CBI  0x1B,1
; 0000 00C1             PORTA.2=0;
	CBI  0x1B,2
; 0000 00C2             PORTA.3=0;
	CBI  0x1B,3
; 0000 00C3 
; 0000 00C4     }
; 0000 00C5 
; 0000 00C6 }
_0x33:
	RET
;void turn_horiz_motor(void)
; 0000 00C8 {
_turn_horiz_motor:
; 0000 00C9 
; 0000 00CA     if(((PORTA & 0xF0)==0x00)  ){
	IN   R30,0x1B
	ANDI R30,LOW(0xF0)
	BRNE _0x3C
; 0000 00CB             delay_ms(1000);
	CALL SUBOPT_0x2
; 0000 00CC             PORTA.4=0;
	CBI  0x1B,4
; 0000 00CD             PORTA.5=0;
	CBI  0x1B,5
; 0000 00CE             PORTA.6=0;
	CBI  0x1B,6
; 0000 00CF             PORTA.7=1;
	SBI  0x1B,7
; 0000 00D0             return;
	RET
; 0000 00D1 
; 0000 00D2            }
; 0000 00D3 
; 0000 00D4     if((PORTA & 0xF0)==0x80){
_0x3C:
	IN   R30,0x1B
	ANDI R30,LOW(0xF0)
	CPI  R30,LOW(0x80)
	BRNE _0x45
; 0000 00D5             delay_ms(1000);
	CALL SUBOPT_0x2
; 0000 00D6             PORTA.4=0;
	CBI  0x1B,4
; 0000 00D7             PORTA.5=1;
	SBI  0x1B,5
; 0000 00D8             PORTA.6=0;
	CBI  0x1B,6
; 0000 00D9             PORTA.7=0;
	CBI  0x1B,7
; 0000 00DA             return;
	RET
; 0000 00DB             }
; 0000 00DC       if((PORTA & 0xF0)==0x20){
_0x45:
	IN   R30,0x1B
	ANDI R30,LOW(0xF0)
	CPI  R30,LOW(0x20)
	BRNE _0x4E
; 0000 00DD             delay_ms(1000);
	CALL SUBOPT_0x2
; 0000 00DE             PORTA.4=0;
	CBI  0x1B,4
; 0000 00DF             PORTA.5=0;
	CBI  0x1B,5
; 0000 00E0             PORTA.6=0;
	CBI  0x1B,6
; 0000 00E1             PORTA.7=1;
	SBI  0x1B,7
; 0000 00E2             }
; 0000 00E3 
; 0000 00E4 }
_0x4E:
	RET
;
;
;void auto_turn_motor(void)
; 0000 00E8 {
_auto_turn_motor:
; 0000 00E9 
; 0000 00EA         if(((PORTA & 0x0F)==0x00) || ((PORTA & 0x01) ==0x01)  ){
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	BREQ _0x58
	IN   R30,0x1B
	ANDI R30,LOW(0x1)
	CPI  R30,LOW(0x1)
	BRNE _0x57
_0x58:
; 0000 00EB 
; 0000 00EC 
; 0000 00ED             delay_ms(1000);
	CALL SUBOPT_0x1
; 0000 00EE             PORTA.0=0;
; 0000 00EF             PORTA.1=1;
	SBI  0x1B,1
; 0000 00F0             PORTA.2=0;
	CBI  0x1B,2
; 0000 00F1             PORTA.3=0;
	CBI  0x1B,3
; 0000 00F2 
; 0000 00F3            }
; 0000 00F4     if((PORTA & 0x0F)==0x02){
_0x57:
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0x2)
	BRNE _0x62
; 0000 00F5 
; 0000 00F6       delay_ms(1000);
_0x2060001:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00F7             PORTA.0=0;
	CBI  0x1B,0
; 0000 00F8             PORTA.1=0;
	CBI  0x1B,1
; 0000 00F9             PORTA.2=1;
	SBI  0x1B,2
; 0000 00FA             PORTA.3=0;
	CBI  0x1B,3
; 0000 00FB 
; 0000 00FC             return;
	RET
; 0000 00FD 
; 0000 00FE       }
; 0000 00FF 
; 0000 0100     if((PORTA & 0x0F) == 0x04){
_0x62:
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0x4)
	BRNE _0x6B
; 0000 0101 
; 0000 0102         delay_ms(1000);
	CALL SUBOPT_0x1
; 0000 0103 
; 0000 0104             PORTA.0=0;
; 0000 0105             PORTA.1=0;
	CBI  0x1B,1
; 0000 0106             PORTA.2=0;
	CBI  0x1B,2
; 0000 0107             PORTA.3=1;
	SBI  0x1B,3
; 0000 0108 
; 0000 0109     }
; 0000 010A 
; 0000 010B      if((PORTA & 0x0F) == 0x08){
_0x6B:
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0x8)
	BRNE _0x74
; 0000 010C 
; 0000 010D         delay_ms(1000);
	CALL SUBOPT_0x2
; 0000 010E 
; 0000 010F             PORTA.0=1;
	SBI  0x1B,0
; 0000 0110             PORTA.1=0;
	CBI  0x1B,1
; 0000 0111             PORTA.2=0;
	CBI  0x1B,2
; 0000 0112             PORTA.3=0;
	CBI  0x1B,3
; 0000 0113 
; 0000 0114     }
; 0000 0115 
; 0000 0116 
; 0000 0117 }
_0x74:
	RET
;
;void main(void)
; 0000 011A {
_main:
; 0000 011B // Declare your local variables here
; 0000 011C 
; 0000 011D // Input/Output Ports initialization
; 0000 011E // Port A initialization
; 0000 011F // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0120 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0121 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0122 DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0123 
; 0000 0124 // Port B initialization
; 0000 0125 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0126 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0127 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0128 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0129 
; 0000 012A // Port C initialization
; 0000 012B // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 012C // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 012D PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 012E DDRC=0x00;
	OUT  0x14,R30
; 0000 012F 
; 0000 0130 // Port D initialization
; 0000 0131 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0132 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0133 PORTD=0x00;
	OUT  0x12,R30
; 0000 0134 DDRD=0x00;
	OUT  0x11,R30
; 0000 0135 
; 0000 0136 // Timer/Counter 0 initialization
; 0000 0137 // Clock source: System Clock
; 0000 0138 // Clock value: Timer 0 Stopped
; 0000 0139 // Mode: Normal top=0xFF
; 0000 013A // OC0 output: Disconnected
; 0000 013B TCCR0=0x00;
	OUT  0x33,R30
; 0000 013C TCNT0=0x00;
	OUT  0x32,R30
; 0000 013D OCR0=0x00;
	OUT  0x3C,R30
; 0000 013E 
; 0000 013F // Timer/Counter 1 initialization
; 0000 0140 // Clock source: System Clock
; 0000 0141 // Clock value: Timer1 Stopped
; 0000 0142 // Mode: Normal top=0xFFFF
; 0000 0143 // OC1A output: Discon.
; 0000 0144 // OC1B output: Discon.
; 0000 0145 // Noise Canceler: Off
; 0000 0146 // Input Capture on Falling Edge
; 0000 0147 // Timer1 Overflow Interrupt: Off
; 0000 0148 // Input Capture Interrupt: Off
; 0000 0149 // Compare A Match Interrupt: Off
; 0000 014A // Compare B Match Interrupt: Off
; 0000 014B TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 014C TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 014D TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 014E TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 014F ICR1H=0x00;
	OUT  0x27,R30
; 0000 0150 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0151 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0152 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0153 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0154 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0155 
; 0000 0156 // Timer/Counter 2 initialization
; 0000 0157 // Clock source: System Clock
; 0000 0158 // Clock value: Timer2 Stopped
; 0000 0159 // Mode: Normal top=0xFF
; 0000 015A // OC2 output: Disconnected
; 0000 015B ASSR=0x00;
	OUT  0x22,R30
; 0000 015C TCCR2=0x00;
	OUT  0x25,R30
; 0000 015D TCNT2=0x00;
	OUT  0x24,R30
; 0000 015E OCR2=0x00;
	OUT  0x23,R30
; 0000 015F 
; 0000 0160 // External Interrupt(s) initialization
; 0000 0161 // INT0: Off
; 0000 0162 // INT1: Off
; 0000 0163 // INT2: Off
; 0000 0164 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0165 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0166 
; 0000 0167 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0168 TIMSK=0x00;
	OUT  0x39,R30
; 0000 0169 
; 0000 016A // USART initialization
; 0000 016B // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 016C // USART Receiver: On
; 0000 016D // USART Transmitter: Off
; 0000 016E // USART Mode: Asynchronous
; 0000 016F // USART Baud Rate: 9600
; 0000 0170 UCSRA=0x00;
	OUT  0xB,R30
; 0000 0171 UCSRB=0x90;
	LDI  R30,LOW(144)
	OUT  0xA,R30
; 0000 0172 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0173 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0174 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0175 
; 0000 0176 // Analog Comparator initialization
; 0000 0177 // Analog Comparator: Off
; 0000 0178 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0179 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 017A SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 017B 
; 0000 017C // ADC initialization
; 0000 017D // ADC disabled
; 0000 017E ADCSRA=0x00;
	OUT  0x6,R30
; 0000 017F 
; 0000 0180 // SPI initialization
; 0000 0181 // SPI disabled
; 0000 0182 SPCR=0x00;
	OUT  0xD,R30
; 0000 0183 
; 0000 0184 // TWI initialization
; 0000 0185 // TWI disabled
; 0000 0186 TWCR=0x00;
	OUT  0x36,R30
; 0000 0187 
; 0000 0188 // Global enable interrupts
; 0000 0189 #asm("sei")
	sei
; 0000 018A 
; 0000 018B while (1)
_0x7D:
; 0000 018C       {
; 0000 018D       if(mode == 2)
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x80
; 0000 018E         auto_turn_motor();
	RCALL _auto_turn_motor
; 0000 018F 
; 0000 0190       }
_0x80:
	RJMP _0x7D
; 0000 0191 }
_0x81:
	RJMP _0x81
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CBI  0x1B,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
