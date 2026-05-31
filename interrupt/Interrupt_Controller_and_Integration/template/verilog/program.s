.section ".text.init"

# Memory-mapped I/O addresses
.equ BUTTON_BASE, 0x70000000
.equ LED_BASE,    0x50000000
.equ GAME_STATE,  0x90000000
.equ SP_BASE,     0x9FFFFFC0

# Register offsets for button controller
.equ BTN_SRC_OFF, 4
.equ BTN_PTM_OFF, 8
.equ BTN_STM_OFF, 12

.globl _start
_start:
    # Set up game value in memory
    li t0, GAME_STATE
    sw zero, 0(t0)     # Initialize game value to 0 (lose)
    
    # Set up interrupt vector
    lui t0, %hi(interrupt_handler)
    addi t0, t0, %lo(interrupt_handler)
    csrw mtvec, t0
    
    # TODO: Implement the rest of the setup for the interrupt handler
    
    li sp, SP_BASE

    li t0, BUTTON_BASE
    # set push buttons trigger mode to rising-edge
    li t2, 0x55555;
    sw t2, BTN_PTM_OFF(t0)
    # set switch buttons trigger mode to rising-edge
    li t2, 0x5555;
    sw t2, BTN_STM_OFF(t0)
    # enable interrupts
    li t1, 0x8
    csrrs x0, mstatus, t1
    li t1, 0x800
    csrrw x0, mie, t1

    
    li s1, LED_BASE
    
    # Long wait loop
    li t0, 5000  # Adjust this value to change the wait time
wait_loop:
    addi t0, t0, -1
    bnez t0, wait_loop
    
    # Load and check game result
    li t0, GAME_STATE
    lw t1, 0(t0)
    beqz t1, lose
    j win
    
lose:
    li t1, 0xFFFF01FF  # Set red LEDs on for all
    sw t1, 0(s1)
    j end_game
    
win:
    # Turn on green LEDs
    li t1, 0xFFFF02FF  # Set green LEDs on for all
    sw t1, 0(s1)
    
end_game:
    # Stop execution
    ebreak

interrupt_handler:
    # TODO: Implement the interrupt handler
    # save registers on the stack
    addi sp, sp, -32
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)
    sw t3, 16(sp)
    sw t4, 20(sp)
    sw t5, 24(sp)
    sw t6, 28(sp)

    li t0, GAME_STATE
    li t1, 1
    sw t1, 0(t0)

    # clear interrupt source by writing 0 to SRC
    li t0, BUTTON_BASE
    sw x0, BTN_SRC_OFF(t0)

    # pop registers from the stack
    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw t2, 12(sp)
    lw t3, 16(sp)
    lw t4, 20(sp)
    lw t5, 24(sp)
    lw t6, 28(sp)
    addi sp, sp, 32
    mret