.include "./  macro.asm"

.data
msg1: .asciiz "Enter a +ve number : "
msg2: .asciiz "Enter another +ve number : "
msg3: .asciiz "LCM of "
s_is: .asciiz "is"
s_and: .asciiz "and"
s_space: .asciiz " "
s_cr: .asciiz "\n"

.text
.globl main
main:
	print_str(msg1)
	read_int($s0)
	print_str(msg2)
	read_int($s1)
	
	move $v0, $zero
	move $a0, $s0
	move $a1, $s1
	move $a2, $s0
	move $a3, $s1
	jal  lcm_recursive
	move $s3, $v0
	
	print_str(msg3)
	print_reg_int($s0)
	print_str(s_space)
	print_str(s_and)
	print_str(s_space)
	print_reg_int($s1)
	print_str(s_space)
	print_str(s_is)
	print_str(s_space)
	print_reg_int($s3)
	print_str(s_cr)
	exit

#------------------------------------------------------------------------------
# Function: lcm_recursive 
# Argument:
#	$a0 : +ve integer number m
#       $a1 : +ve integer number n
#       $a2 : temporary LCM by increamenting m, initial is m
#       $a3 : temporary LCM by increamenting n, initial is n
# Returns
#	$v0 : lcm of m,n 
#
# Purpose: Implementing LCM function using recursive call.
# 
#------------------------------------------------------------------------------

# Example in higher level code. (Please note that there are three cases, the base case, greater than, and less than).
#------------------------------------------------------------------------------
#	Call: lcm_recursive(m,n,m,n);
#	int lcm_recursive (int m, int n, int lcm_m, lcm_n) {
#	     if (lcm_m == lcm_n) return lcm_m;		# Case 1
#	     if (lcm_m > lcm_n) lcm_n = lcm_n + n;	# Case 2
#	     else lcm_m = lcm_m + m;			# Case 3
#	 return (lcm_recursive(m,n, lcm_m, lcm_n));	# Return recursively by function call.
# }
#------------------------------------------------------------------------------
lcm_recursive:
	
	# Attributions to the CS club where I worked on this problem with a small group including Michael Huang and Khoi Dinh / others.
	# Also attributions to Professor Patra's office hours where he helped me fix my code, and I then tutored Khoi on the zero condition.
	# Please note: The zero condition is purely extra but we were both curious while working together so we included it.
	
	# ----------------------------------------------
	# Store frame first by setting the stack pointer.
	# ----------------------------------------------
	
	subi $sp, $sp, 28	# Changing stack pointer to the number 28, though multiple variants of numbers may be used.
	# addi $sp, $sp, -28 	# This also worked for changing the stack pointer, though it is reverse logic.
	sw $fp, 28($sp)		# Storing the arguments into the stack pointer.
	sw $ra, 24($sp)		
	sw $a0, 20($sp)
	sw $a1, 16($sp)
	sw $a2, 12($sp)
	sw $a3, 8($sp)		# Finished storing the arguments into the stack pointer.	
	addi $fp, $sp, 28	# Setting the frame pointer to where the stack pointer is i.e. returning to where the stack pointer should be.
	# subi $fp, $sp, -28	# This also worked for setting the frame pointer to where the stack pointer is i.e. returning to where the pointer should be.
	
	# ---------------------------------------------
	# Body
	# ---------------------------------------------
	
	beq $a0, $zero, ARGZERO 	# If the first argument is a zero, move to that specific set of statements.
	beq $a1, $zero, ARGZERO		# If the second argument is a zero, move to that specific set of statements. 
	beq $a2, $a3, RETURN_CONDITION	# Move to the condition where a2 = a3.
	bgt $a2, $a3, GREATER_CASE	# Move to the condition where a2 > a3.
	bgt $a3, $a2, LOWER_CASE	# Move to the condition where a2 < a3. 
	
	# ---------------------------------------------
	# Case 1 - a2 > a3
	# ---------------------------------------------
	
	GREATER_CASE:
	add $a3, $a3, $a1	# a3 = a3 + a1.
	jal lcm_recursive	# Loop back!
	j  RESTORE		# Restore the pointer to where it should be.
	
	# Junk - This didn't work because we weren't restoring the full frame ( Note to self ).
	# addi $sp, $sp, 28		# Restoring stack pointer.
	# lw $ra, 24($sp)		# Restoring return address to one byte (4 bits) lower.
	# jr $ra			
	
	# ---------------------------------------------
	# Case 2 - a2 < a3
	# ---------------------------------------------
	
	LOWER_CASE:
	add $a2, $a0, $a2	# a2 = a0 + a2
	jal lcm_recursive	# Loop back!
	j RESTORE
	
	# Junk - This didn't work because we weren't restoring the full frame ( Note to self ).
	# addi $sp, $sp, 28		# Restoring stack pointer.
	# lw $ra, 24($sp)		# Restoring return address to one byte (4 bits) lower.
	# jr $ra
	
	# ---------------------------------------------
	# Zero Case - a1 or a0 contains a zero!
	# ---------------------------------------------
	
	ARGZERO:
	move $v0, $zero	# Move the value from $zero register into $v0. 
	j RESTORE	# Restore the frame.
	
	# ---------------------------------------------
	# End Case - The value has been found.
	# ---------------------------------------------
	
	RETURN_CONDITION:
	move $v0, $a2		# Move the value from a2 into v0 for print out.
	
	# ---------------------------------------------
	# Restoring the frame.
	# ---------------------------------------------
	RESTORE:	
	lw $fp, 28($sp)		# Loading the arguments into the stack pointer.
	lw $ra, 24($sp)
	lw $a0, 20($sp)
	lw $a1, 16($sp)
	lw $a2, 12($sp)
	lw $a3, 8($sp)
	addi $sp, $sp, 28

	jr $ra			# Jump registers back to $ra.
	
