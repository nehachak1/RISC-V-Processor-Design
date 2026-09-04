# A RISC-V Processor in Verilog

A custom RISC-V processor implemented in Verilog as part of the EPFL CS-200 Computer Architecture course. The project includes instruction decoding, execution, scheduling, memory interactions, interrupt handling, and assembly-level program execution.

## Overview

It is a hardware implementation of a RISC-V CPU designed and developed using Verilog HDL. The processor supports instruction fetching, decoding, execution, register management, control logic, and interrupt handling while executing programs written in RISC-V assembly.

The project provides practical experience with computer architecture concepts, digital design, and low-level hardware-software interaction.

---

## Features

### Processor Architecture

- RISC-V ISA implementation
- Instruction fetch stage
- Instruction decode stage
- Execution stage
- Register file management
- Program counter control

### Instruction Support

- Arithmetic instructions
- Logical instructions
- Load and store operations
- Branch instructions
- Jump instructions
- Immediate operations

### Control Logic

- Instruction parsing
- Scheduling and execution control
- Hazard management
- State transitions

### Interrupt Handling

- Interrupt detection
- Interrupt servicing
- Control transfer mechanisms
- Return from interrupt support

### Assembly Integration

- Execution of RISC-V assembly programs
- Register manipulation
- Memory access operations
- Program testing and verification

---

## Architecture

```text
                +----------------+
                | Program Counter|
                +--------+-------+
                         |
                         v
                +----------------+
                | Instruction    |
                | Fetch Unit     |
                +--------+-------+
                         |
                         v
                +----------------+
                | Instruction    |
                | Decoder        |
                +--------+-------+
                         |
         +---------------+---------------+
         |                               |
         v                               v
+----------------+             +----------------+
| Register File  |             | Control Unit   |
+----------------+             +----------------+
         |                               |
         +---------------+---------------+
                         |
                         v
                +----------------+
                | ALU / Execution|
                +--------+-------+
                         |
                         v
                +----------------+
                | Memory System  |
                +--------+-------+
                         |
                         v
                +----------------+
                | Write Back     |
                +----------------+
```

---

## Project Structure

```text
.
├── src/
│   ├── cpu/
│   ├── alu/
│   ├── control/
│   ├── memory/
│   ├── registers/
│   └── interrupts/
│
├── assembly/
│   ├── tests/
│   └── programs/
│
├── simulations/
│
├── testbench/
│
└── README.md
```

---

## Technologies

- Verilog HDL
- RISC-V Assembly
- Digital Logic Design
- Hardware Simulation Tools

---

## Key Concepts

- Computer Architecture
- CPU Design
- Instruction Set Architectures
- Digital Systems
- Hardware Description Languages
- Pipeline Control
- Interrupt Handling
- Register Management
- Assembly Programming

---

## Testing

The processor was validated through:

- Unit testing of hardware modules
- Assembly program execution
- Register state verification
- Memory access testing
- Interrupt handling tests

---

## Learning Outcomes

This project provided hands-on experience with:

- Processor design
- Hardware implementation in Verilog
- RISC-V architecture
- Instruction execution pipelines
- Control unit design
- Low-level system programming
- Hardware verification and debugging
