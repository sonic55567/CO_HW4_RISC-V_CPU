# CO_HW4_RISC-V_CPU
Computer Organization 2019 HOMEWORK 4 RISC-V CPU

# Computer Organization 2019

## HOMEWORK 4 RISC-V CPU

## Due date:

## Overview

The goal of this homework is to help you understand how a single-cycle RISC-V
work and how to use Verilog hardware description language (Verilog HDL) to model
electronic systems. In this homework, you need to implement ALU and decoder
module and make your codes be able to execute all RISC-V instructions. You need to
follow the instruction table in this homework and satisfy all the homework
requirements. In addition, you need to verify your CPU by using Modelsim.

## General rules for deliverables

```
 You need to complete this homework INDIVIDUALLY. You can discuss the
homework with other students, but you need to do the homework by yourself.
You should not copy anything from someone else, and you should not
distribute your homework to someone else. If you violate any of these rules,
you will get NEGATIVE scores, or even fail this course directly
```
##  When submitting your homework, compress all files into a single zip file,

```
and upload the compressed file to Moodle.
 Please follow the file hierarchy shown in Figure 1.
F740XXXXX ( your id ) (folder)
src ( folder ) * Store your source code
report.docx ( project report. The report template is already
included. Follow the template to complete the report. )
```

```
F740XXXXX/
```
```
src/
```
```
report.docx
```
```
Your source code
```
```
Your source code
```
```
Figure 1. File hierarchy for homework submission
```
 Important! DO NOT submit your homework in the last minute. Late
submission is not accepted.
 You should finish all the requirements (shown below) in this homework and
Project report.
 If your code can not be recompiled by TA successfully using modelsim, you
will receive NO credit.
 Verilog and SystemVerilog generators aren’t allowed in this course.


## Instruction format:

```
 R-type
31 25 24 20 19 15 14 12 11 7 6 0
funct7 rs2 rs1 funct3 rd opcode Mnemonic Description
0000000 rs2 rs1 000 rd 0110011 ADD rd = rs1 + rs
0100000 rs2 rs1 000 rd 0110011 SUB rd = rs1 - rs
0000000 rs2 rs1 001 rd 0110011 SLL rd = rs1u << rs2[4:0]
0000000 rs2 rs1 010 rd 0110011 SLT rd = rs1s < rs2s? 1 : 0
0000000 rs2 rs1 011 rd 0110011 SLTU rd = rs1u < rs2u? 1 : 0
0000000 rs2 rs1 100 rd 0110011 XOR rd = rs1 ^ rs
0000000 rs2 rs1 101 rd 0110011 SRL rd = rs1u >> rs2[4:0]
0100000 rs2 rs1 101 rd 0110011 SRA rd = rs1s >> rs2[4:0]
0000000 rs2 rs1 110 rd 0110011 OR rd = rs1 | rs
0000000 rs2 rs1 111 rd 0110011 AND rd = rs1 & rs
```
```
 I-type
31 20 19 15 14 12 11 7 6 0
imm[11:0] rs1 funct3 rd opcode Mnemonic Description
imm[11:0] rs1 010 rd 0000011 LW rd = M[rs1 + imm]
imm[11:0] rs1 000 rd 0010011 ADDI rd = rs1 + imm
imm[11:0] rs1 010 rd 0010011 SLTI rd = rs1s < imms? 1:
imm[11:0] rs1 011 rd 0010011 SLTIU rd = rs1u < immu? 1:
imm[11:0] rs1 100 rd 0010011 XORI rd = rs1 ^ imm
imm[11:0] rs1 110 rd 0010011 ORI rd = rs1 | imm
imm[11:0] rs1 111 rd 0010011 ANDI rd = rs1 & imm
0000000 shamt rs1 001 rd 0010011 SLLI rd = rs1u << shamt
0000000 shamt rs1 101 rd 0010011 SRLI rd = rs1u >> shamt
0100000 shamt rs1 101 rd 0010011 SRAI rd = rs1s >> shamt
```
```
imm[11:0] rs1 000 rd 1100111 JALR
```
```
rd = PC + 4
PC = imm + rs
(Set LSB of PC to 0)
```
```
 S-type
31 25 24 20 19 15 14 12 11 7 6 0
imm[11:5] rs2 rs1 funct3 imm[4:0] opcode Mnemonic Description
imm[11:5] rs2 rs1 010 imm[4:0] 0100011 SW M[rs1 + imm] = rs
```

```
 B-type
31 25 24 20 19 15 14 12 11 7 6 0
imm[12|10:5] rs2 rs1 funct3 imm[4:1|11] opcode Mnemonic Description
imm[12|10:5] rs2 rs1 000 imm[4:1|11] 1100011 BEQ
PC = (rs1 == rs2)?
PC + imm : PC + 4
```
```
imm[12|10:5] rs2 rs1 001 imm[4:1|11] 1100011 BNE
PC = (rs1 != rs2)?
PC + imm : PC + 4
imm[12|10:5] rs2 rs1 100 imm[4:1|11] 1100011 BLT
PC = (rs1s < rs2 s)?
PC + imm : PC + 4
```
```
imm[12|10:5] rs2 rs1 101 imm[4:1|11] 1100011 BGE
```
```
PC = (rs1s ≧ rs2 s)?
PC + imm : PC + 4
imm[12|10:5] rs2 rs1 110 imm[4:1|11] 1100011 BLTU
PC = (rs1u < rs2 u)?
PC + imm : PC + 4
```
```
imm[12|10:5] rs2 rs1 111 imm[4:1|11] 1100011 BGEU
```
```
PC = (rs1u ≧ rs2 u)?
PC + imm : PC + 4
```
```
 U-type
31 12 11 7 6 0
imm[31:12] rd opcode Mnemonic Description
imm[31:12] rd 0010111 AUIPC rd = PC + imm
imm[31:12] rd 0110111 LUI rd = imm
```
```
 J-type
31 12 11 7 6 0
imm[20|10:1|11|19:12] rd opcode Mnemonic Description
imm[20|10:1|11|19:12] rd 1101111 JAL
rd = PC + 4
PC = PC + imm
```
## Homework Description

```
 Module
a. top_tb module
b. “top_tb” is not a part of CPU, it is a file that controls all the program
and verify the correctness of our CPU. The main features are as follows:
send periodical signal CLK to CPU, set the initial value of IM, print the
value of DM, end the program.
※You do not need to modify this module.
```

c. top module
“top” is the outmost module. It is responsible for connecting wires
between CPU, IM and DM.
Here are the wires:
 instr_read represents the signal whether the instruction should be
read in IM.
 instr_addr represents the instruction address in IM.
 instr_out represents the instruction send from IM.
 data_read represents the signal whether the data should be read in
DM.
 data_write represents the signal whether the data should be wrote
in DM.
 data_addr represents the data address in DM.
 data_in represents the data which will be wrote into DM.
 data_out represents the data send from DM.
※You do not need to modify this module.
d. SRAM module
“SRAM” is the abbreviation of “Instruction Memory” (or “Data
Memory”). This module saves all the instructions (or data) and send
instruction (or data) to CPU according to request.

```
A0 A
```
```
Mem[A1]
```
```
Data
```
```
clk
```
```
addr
```
```
read
```
```
write
```
```
DI
```
```
DO
```
```
Write & Read Read Idle
```
```
Mem[A0] Data
```
```
※You do not need to modify this module
```

e. CPU module
“CPU” is responsible for connecting wires between modules,
please design a single-cycle RISC-V CPU by yourself. You can write
other modules in other files if you need, but remember to include those
files in CPU.v.
※You should modify this module.


 Reference Block Diagram


 Register File
Register ABI Name Description Saver
x
x
x
x
x
x
x6 – 7
x
x
x10 - 11
x12 - 17
x18 - 27
x28 - 31

```
zero
ra
sp
gp
tp
t
t1 - 2
s0/fp
s
a0 - 1
a2 - 7
s2 - 11
t3 - 6
```
```
Hard-wired zero
Return address
Stack pointer
Global pointer
Thread pointer
Temporary / alternate link register
Temporaries
Saved register / frame pointer
Saved register
Function arguments / return values
Function arguments
Saved registers
Temporaties
```
### ---

```
Caller
Callee
---
---
Caller
Caller
Callee
Callee
Caller
Caller
Callee
Caller
```
 Test Instruction
a. Memory layout

```
.text
```
```
.rodata
.fini
.init
```
```
Unmapped
```
```
_test
```
```
.bss
.data
.sdata
.sbss
```
```
.stack
```
```
setup.S
```
```
main.S
```
```
Stack data
↓
```
```
Unmapped
```
```
0x
```
```
0x
```
```
0x
```
```
DM
```
```
IM
```
```
Figure 2. Memory layout
```

```
 .text: Store instruction code.
 .init & .fini: Store instruction code for entering & leaving the
process.
 .rodata: Store constant global variable.
 .bss & .sbss: Store uninitiated global variable or global variable
initiated as zero.
 .data & .sdata: Store global variable initiated as non-zero
 .stack: Store local variables
```
```
b. setup.S
This program start at “PC = 0”, execute function as followings:
```
1. Reset register file
2. Initial stack pointer and sections
3. Call main function
4. Wait main function return, then terminate program

```
c. main.S
This program start after setup.S, it will verify all RISC-V
instructions (31 instructions).
```
```
d. main0.hex & main1.hex & main2.hex & main3.hex
Using the cross compiler of RISC-V to compile test program, and
write result in verilog format. So you do not need to compile above
program again.
```
 Simulation Result
Register Value (hex)
DM[ 0]
DM[ 1]
DM[ 2]
DM[ 3]
DM[ 4]
DM[ 5]
DM[ 6]
DM[ 7]
DM[ 8]
DM[ 9]

```
fffffff
fffffff
00000008
00000001
00000001
78787878
000091a
00000003
fefcfefd
10305070
```

### DM[ 10]

### DM[ 11]

### DM[ 12]

### DM[ 13]

### DM[ 14]

### DM[ 15]

### DM[ 16]

### DM[ 17]

### DM[ 18]

### DM[ 19]

### DM[ 20]

### DM[ 21]

### DM[ 22]

### DM[ 23]

### DM[ 24]

### DM[ 25]

### DM[ 26]

### DM[ 27]

### DM[ 28]

### DM[ 29]

### DM[ 30]

### DM[ 31]

### DM[ 32]

### DM[ 33]

### DM[ 34]

### DM[ 35]

### DM[ 36]

### DM[ 37]

### DM[ 38]

### DM[ 39]

### DM[ 40]

### DM[ 41]

### DM[ 42]

### DM[ 43]

### DM[ 44]

### DM[ 45]

```
cccccccc
00000d9d
00000004
00000003
000001a
00000ec
2468b7a
5dbf9f
00012b
fa2817b
ff
000f
0000f
00000f
000000f
0000000f
000f
000f
000f
000f
000f
0000000f
000000f
00000f
000f
000f
000f
fffff
fffff
fffff
fffff
fffff
fffff
1357a
13578000
fffff
```

## Homework Requirements

1. Complete the Single cycle CPU that can execute all instructions from the

## RISC-V ISA section.

2. Verify your CPU with the benchmark and take a snapshot (e.g. Figure 3)

```
Figure 3. Snapshot of correct simulation
a. Using waveform to verify the execute results.
b. Please annotate the waveform
```
## 3. Finish the Project Report.

```
a. Complete the project report. The report template is provided.
```
## Important

## When you upload your file, please make sure you have

## satisfied all the homework requirements, including the File

## hierarchy, Requirement file and Report format.

```
If you have any questions, please contact us.
```


