# Assembly 8086 Programs

This repository contains five 8086 Assembly language programs, each demonstrating different computational and logical functionalities. These programs can be assembled and executed using MASM (Microsoft Macro Assembler) or an emulator like DOSBox with TASM.

## Table of Contents
- [Programs Overview](#programs-overview)
- [Requirements](#requirements)
- [Usage](#usage)
- [Programs Description](#programs-description)
  - [GCD & LCM Calculation](#gcd--lcm-calculation)
  - [Fibonacci Sequence](#fibonacci-sequence)
  - [Weighted Sum Calculation](#weighted-sum-calculation)
  - [Integer Input & Error Handling](#integer-input--error-handling)
  - [Tic-Tac-Toe Game](#tic-tac-toe-game)
- [License](#license)

## Requirements
- MASM/TASM assembler
- DOSBox (if running on modern systems)
- Basic understanding of x86 Assembly

## Usage
1. Assemble the program using MASM or TASM:
   ```sh
   masm program.asm;
   link program.obj;
   ```
2. Run the executable in DOSBox:
   ```sh
   program.exe
   ```

## Programs Description

### GCD & LCM Calculation
- **File:** `q1.asm`
- **Description:** Computes the Greatest Common Divisor (GCD) and Least Common Multiple (LCM) of two numbers.
- **Implementation:** Uses Euclidean algorithm for GCD and the formula `LCM(a, b) = (a * b) / GCD(a, b)`.

### Fibonacci Sequence
- **File:** `q2.asm`
- **Description:** Recursively calculates the nth Fibonacci number.
- **Implementation:** Uses stack frames to manage recursive calls efficiently.

### Weighted Sum Calculation
- **File:** `q3.asm`
- **Description:** Computes the weighted sum of an array where each element is multiplied by its position index.
- **Implementation:** Iterates through an array, multiplying each value by its index and summing the result.

### Integer Input & Error Handling
- **File:** `q4.asm`
- **Description:** Reads an integer from user input and detects invalid characters.
- **Implementation:** Uses a buffer to store input digits and validates them before converting to an integer.

### Tic-Tac-Toe Game
- **File:** `q5.asm`
- **Description:** A simple command-line Tic-Tac-Toe game for two players.
- **Implementation:** Uses a 3x3 matrix to track game state, validates moves, and checks for a winner.


