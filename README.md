# 32-bit RISC-V Processor Design (RV32I)

A personal hardware design project focused on designing, implementing, and verifying a 32-bit RISC-V processor using Verilog HDL.

The project aims to develop a functional processor based on the RV32I instruction set architecture, starting with individual hardware modules and gradually integrating them into a complete processor.

## Project Overview

The processor will be developed from scratch using Verilog HDL.

**Target Architecture:** RISC-V RV32I  
**Data Width:** 32-bit  
**HDL:** Verilog  
**Simulation:** Icarus Verilog  
**Waveform Analysis:** GTKWave  
**Synthesis:** Yosys  
**Target FPGA:** Sipeed Tang Nano 9K

## Planned Architecture

The processor will consist of the following modules:

- Program Counter (PC)
- Instruction Memory
- Instruction Decoder
- Control Unit
- Register File
- Arithmetic Logic Unit (ALU)
- Immediate Generator
- Data Memory
- Branch Control Unit

## Development Roadmap

- [ ] Understand RV32I architecture
- [ ] Design and verify ALU
- [ ] Implement 32-bit Register File
- [ ] Develop Program Counter
- [ ] Implement Instruction Decoder
- [ ] Develop Control Unit
- [ ] Implement Immediate Generator
- [ ] Integrate processor datapath
- [ ] Implement instruction and data memory
- [ ] Develop processor testbench
- [ ] Simulate and debug complete processor
- [ ] Synthesize using Yosys
- [ ] Deploy on Tang Nano 9K FPGA

## Development Environment

The project will initially be developed and verified entirely through simulation.

| Tool | Purpose |
|---|---|
| VS Code | RTL development |
| Icarus Verilog | Simulation |
| GTKWave | Waveform analysis |
| Yosys | Logic synthesis |
| Tang Nano 9K | FPGA implementation |

## Project Structure

```text
riscv-32bit-processor/
│
├── rtl/
│   ├── alu.v
│   ├── register_file.v
│   ├── program_counter.v
│   ├── instruction_decoder.v
│   ├── control_unit.v
│   ├── immediate_generator.v
│   └── riscv_top.v
│
├── testbench/
│   ├── alu_tb.v
│   ├── register_file_tb.v
│   └── riscv_top_tb.v
│
├── simulation/
│
├── constraints/
│
├── docs/
│
└── README.md
```

*The directory structure will evolve as development progresses.*

## Project Objective

The final objective is to implement a functional 32-bit RISC-V processor, verify its instruction execution through simulation, and demonstrate its operation on an FPGA.

This project is an ongoing exploration of digital design, computer architecture, RTL development, and FPGA implementation.
