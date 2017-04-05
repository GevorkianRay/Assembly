#<------------------ MACRO DEFINITIONS ---------------------->#
        # Macro : print_str
        # Usage: print_str(<address of the string>)
        .macro print_str($arg)
	li	$v0, 4     # System call code for print_str  
	la	$a0, $arg   # Address of the string to print
	syscall            # Print the string        
	.end_macro
	
	# Macro : print_int
        # Usage: print_int(<val>)
        .macro print_int($arg)
	li 	$v0, 1     # System call code for print_int
	li	$a0, $arg  # Integer to print
	syscall            # Print the integer
	.end_macro
	
	# Macro : read_int
	# Usage : read_int(<val>)
	.macro read_int($reg)
	li	$v0, 5 	    # System call for read_int
	syscall
	move	$reg, $v0   # Integer to move to new memory location
	.end_macro
	
	# Macro : read_int
	# Usage : read_int(<val of input>)
	.macro print_reg_int($reg)
	li	$v0, 1	  # System call for print_reg_int
	move	$a0, $reg # Integer to move to new memory location 
	syscall		  # Print the reg_int
	.end_macro
	
	# Macro : swap_hi_lo
	# Usage : swap_hi_lo(<val of inputs>)
	.macro swap_hi_lo ($temp1, $temp2)
	mfhi $temp1 # Move from hi register
	mflo $temp2 # Move from lo register
	mthi $temp2 # Move from hi register
	mtlo $temp1 # Move from lo register
	.end_macro 
	
	# Macro : print_hi_lo
	# Usage : print_hi_lo(<val of inputs>)
	.macro print_hi_lo ($strHi, $strEqual, $strComma, $strLo)
	li $v0, 4
	la $a0, $strHi 		# This can be simplified, by calling print_str($strHi)
	syscall			# Print the Hi value.
	
	li $v0, 4
	la $a0, $strEqual	# This can be simplified, by calling print_str($strEqual)
	syscall			# Print the equal string '='
	
	mfhi $t1
	print_reg_int($t1) 	# Print the reg_int
	
	li $v0, 4
	la $a0, $strComma	# This can be simplified, by calling print_str($strComma)
	syscall			# Print the comma string ','
			
	li $v0, 4
	la $a0, strLo		# This can be simplified, by calling print_str($strLo)
	syscall			# Print the Lo value
	
	li $v0, 4
	la $a0, $strEqual	# This can be simplified, by calling print_str($strEqual)
	syscall			# Print the equal string '='
	
	mflo $t1
	print_reg_int($t1)	# Print the reg_int
	.end_macro 
		
	.macro lwi ($reg, $ui, $li)
	lui $reg, $ui
	ori $reg, $reg, $li
	.end_macro
	
	#PUSH IT
	.macro push($arg)
	sw $arg, 0x0($sp)	# Taken from lecture notes.
	addi $sp, $sp, -4	# Taken from lecture notes.
	.end_macro

	#POP IT
	.macro pop($arg)	# Taken from lecture notes.
	addi $sp, $sp, +4	# Taken from lecture notes.
	lw $arg, 0x0($sp)
	.end_macro

	# Macro : exit
        # Usage: exit
        .macro exit
	li 	$v0, 10 
	syscall
	.end_macro
	
