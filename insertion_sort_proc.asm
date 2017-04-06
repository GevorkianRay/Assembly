.text
#-------------------------------------------
# Procedure: insertion_sort
# Argument: 
#	$a0: Base address of the array
#       $a1: Number of array element
# Return:
#       None
# Notes: Implement insertion sort, base array 
#        at $a0 will be sorted after the routine
#	 is done.
#-------------------------------------------
#-------------------------------------------
# C psuedo code for insertion sort
# for i = 1 to length(A)
#    j = i
#    while j > 0 and A[j-1] > A[j]
#        swap A[j] and A[j-1]
#        j = j - 1
#    end while
# end for
#-------------------------------------------

insertion_sort:
	# RTE STORE 
	subi $sp, $sp, 20	
	sw  $fp, 20($sp)			# Setting stack pointer...
	sw  $ra, 16($sp)			# $a0, $a1, $fp, $ra are allocated as registers
	sw  $a0, 12($sp)			# This translates to 4 * 4 = 16 bytes.
	sw  $a1, 8($sp)				# We allocate 4 more bytes for future ops.
	addi $fp, $sp, 20			# Thus, we sw for 20 bytes.
	
	li $t0, 1				# Using temp register for swap procedures.
						# Setting $t0 to 1 (in psuedo code, this is i)
	bgt $a1, $t0, for_loop			# If the number of array elements > i ... goto for_loop.
	
for_loop:					# End while when $t1 = length (Array)  	
	bge $t0, $a1, insertion_sort_end	# goto insertion_sort_end  	
	move $t1, $t0				# Move value of $t0 into $t1
						
check_loop_condition:						
	bgtz $t1, swap_check			# If $t1 > 0 goto label
	li $t6, 4				# Loading 4 bytes into register $t6. 
						# This is used for moving index by 1
	mult $t0, $t6				# Storing value of $t0 * $t6 into hi/lo respectively.	 
	mflo $t7				# Setting $t7 to value in lo.
	add $t7, $t7, 4				# Set $t7 to $t7 + 4. ( Moving index ).
	add $a0, $a0, $t7			# Set $a0 to $a0 + $t7.	( Add it back [ note index has now moved ] )
	addi $t0, $t0, 1			# Set $t0 to $t0 + 1. Increment i.
	j	for_loop			# goto for_loop

swap_check:	
	lw $t2, 4($a0) 				# Load the contents that have now been saved previously.				
	lw $t3, 0($a0) 				# Load the contents that have now been saved previously.
							# Please note these are just holders, not specifically needed.
	blt $t2, $t3, move_proc			# not in order, so, if t2 > t3, then goto move_proc. 
	j index_element_proc			# goto index_element_proc
	
# Switching the array to be in the proper order.
move_proc:	
						# Attributions to online sources for simple swap procedure.	
						# http://stackoverflow.com/questions/21745109/swapping-in-assembly				
	move $t4, $t2				# Set $t2 to $t4
	move $t2, $t3				# Set $t3 to $t2	
	move $t3, $t4				# Set $t4 to $t3
	# Storing values for later use
	sw $t2, 4($a0)				# Store $t2	--> 4 bytes	
	sw $t3, 0($a0)				# Store $t3	--> 0 bytes
	# Moving to the next element.
	j index_element_proc			# goto index_element_proc
	
index_element_proc:	
	subi $t1, $t1, 1			# subi $t1 - 1		--> decrement j
	subi $a0, $a0, 4			# subi $a0 - 4		--> move back by 4 bytes ( 1 index )	
	j check_loop_condition								
	
insertion_sort_end:
	lw  $fp, 20($sp)			# RTE RESTORE
	lw  $ra, 16($sp)			# Loading 20 bytes for stack pointer
	lw  $a0, 12($sp)
	lw  $a1, 8($sp)
	addi $sp, $sp, 20
	jr	$ra
