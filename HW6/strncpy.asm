.text
.global strncpy
strncpy:
    mv t0, a0          # Save destination pointer
    mv t1, a1          # Source pointer
    mv t2, a2          # Length to copy

copy_loop:
    beqz t2, done      # If length is zero, finish
    lbu t3, 0(t1)      # Load byte from source
    beqz t3, fill_null # If source is null, fill remaining with '\0'

    sb t3, 0(t0)       # Store byte to destination
    addi t0, t0, 1     # Move destination pointer
    addi t1, t1, 1     # Move source pointer
    addi t2, t2, -1    # Decrement length
    j copy_loop        # Continue copying

fill_null:
    sb zero, 0(t0)     # Store null byte
    addi t0, t0, 1     # Move destination pointer
    addi t2, t2, -1    # Decrement length
    bnez t2, fill_null # Continue filling if length > 0

done:
    ret                # Return to caller