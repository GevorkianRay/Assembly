.include "./macro.asm"

.data
msg1: .asciiz "Enter a number ? "
msg2: .asciiz "Factorial of the number is "
charCR: .asciiz "\n"

.text
.globl main
main:	print_str(msg1)
	read_int($t0)
	
# Write body of the iterative
# factorial program here
# Store the factorial result into 
# register $s0
	
	li $s0, 1 #Store value
	li $t1, 1 #Store counter
	Factorial:
	mul $s0, $s0, $t1 # Multiply and save value into $s0. 
	addi $t1, $t1, 1 # Increment the counter.
	ble $t1, $t0, Factorial # Go back depending on value of counter (loop). 
	
	# A not so good way to do this problem (but another approach nonetheless). 
	# LOOP: 
	# sub $t2, $t0, $t1
	# mul $t3, $t0, $t2
	# mul $s0, $t3, $s0
	# li $t2, 2
	# sub $t0, $t0, $t2
	# bgt $t0, $t1, LOOP

	print_str(msg2)
	print_reg_int($s0)
	print_str(charCR)
	
	exit
	
