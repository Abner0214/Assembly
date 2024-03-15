# Assembly Course Homework

This repository hosts the assembly language homework assignments for the Assembly Language course offered by the Department of Computer Science and Engineering at National Sun Yat-sen University (NSYSU). Each assignment is designed to challenge students with different aspects of ARM and x86 assembly language programming, focusing on practical applications and code analysis.

## Repository Structure

The repository is divided into three folders, corresponding to the three homework assignments:

- `hw1/` - Programming Problem I
- `hw2/` - Programming Problem II
- `hw3/` - Programming Problem III

### <> hw1: String Manipulation in ARM Assembly

**Objective:** Write an ARM assembly code program to convert an input string into lowercase and remove all non-alphabet characters. The result is then displayed on the screen.

**Example:**  
- Input: "Tom’s brother Timmy is 6 years old."  
- Output: "prog1 result: tomsbrothertimmyisyearsold"  

**Requirements:**
- Use `printf()` for output.
- Do not use `scanf()` for input.

### <> hw2: Partial Disassembler in ARM Assembly

**Objective:** Implement a disassembly program in ARM assembly that can partially disassemble the instruction contents of your program. It should identify data processing, LDR, STR, and branch instructions, showing their condition field and instruction name. For branch instructions, also show the target PC value.

**Example Output:**
```c++
PC    condition   instruction    
0     AL          ADD     
4     EQ          SUB     
8     GE          B           4 
12    EQ          LDR     
16    AL          UND 
20    LT          CMP
```

**Requirements:**
- Include the test program using `.include` gcc assembly directive.

### <> hw3: Arithmetic Functions in x86 Assembly

**Objective:** Write an x86 assembly code program to compute specific arithmetic functions (maximum, greatest common divisor, least common multiple) based on inputs and display the results.

**Example:**

- Input: "4 5 3"
- Output: "Function 3: least common multiply of 4 and 5 is 20."

**Requirements:**
- Accept three arguments (intA, intB, op) from the console as strings, converted into positive integers.
- Utilize `int 80h` instructions for input and output.

## Development Tools

- Online Assembly Compiler: [onecompiler/assembly/](https://onecompiler.com/assembly/)
- x86 Emulation for Debugging: [Asm86 Emulator](https://carlosrafaelgn.com.br/Asm86/)
