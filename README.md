The algorithm proposes a prototype to design a 32-bit processor. The processor is capable of performing the task which includes fetching the instructions, decoding the instructions to figure out what operation needs to be performed, on what operands it needs to perform and where to store, write, the result obtained.

This code represents the designing part of 32-bit processor that includes an ALU, RAM and Instruction Decoder. 
The processor is capable of processing the data which is 32-bit wide. It will have 32 general purpose registers where each register is capable of holding 32-bit data. 
The data can also be fetched from external memory where the address of external memory is 32-bit wide. 
There will be a program counter that will point to the next instruction that will be executed. 
Further, condition bits are there which will be updated with each ALU operation such that it can be used in conditional statements.

Basic Introduction:
Based on Harvard Architecture
It has Arithmetic and Logic Unit
It has general purpose 32-bit registers for storing the data during execution time
It has 32-bit address and each stores 8 bit of data


Instruction Decoder Design:
It includes these five process:
Instruction fetching
Instruction decoding
Execution
Memory Access
Writing back to memory


Instruction Format:
5 bits opcode
5 bits destination register location
5 bits source register location
16 bits Immediate values
Condition bit (1 bit)
Conditional Jump address (26 bits)
Unconditional Jump address (27 bits)


Result and interpretation:

![image](https://github.com/theiturhs/Implementation-of-Verilog-HDL-Based-32-bit-Processor/assets/96874023/1a637e00-c0b5-47a5-bba1-d088915e73c7)

OPCODE: 00010 – ADD
OPERAND1 REG ADD – 00011
16th BIT – 0
OPERAND2 REG ADD – 00000
DESTINATION ADD – 00010
OPERAND2 = 00000000 (hex)
OPERAND1 = F0F0F0F0 (hex)

![image](https://github.com/theiturhs/Implementation-of-Verilog-HDL-Based-32-bit-Processor/assets/96874023/c632e634-188c-49e6-bc3b-fec3ebfcaba7)


AFTER OPERATION:
00010 – Initially stored 0000000
Now stores – F0F0F0F0

