#------------------------------------------
# Originally Test and Set example by Eric Villasenor
# Modified to be LL and SC example by Yue Du
#------------------------------------------

#----------------------------------------------------------
# First Processor
#----------------------------------------------------------
  org   0x0000              # first processor p0
  ori   $sp, $zero, 0x3ffc  # stack
  jal   mainp0              # go to program
  halt

# pass in an address to lock function in argument register 0
# returns when lock is available
lock:
aquire:
  ll    $t0, 0($a0)         # load lock location
  bne   $t0, $0, aquire     # wait on lock to be open
  addiu $t0, $t0, 1
  sc    $t0, 0($a0)
  beq   $t0, $0, lock       # if sc failed retry
  jr    $ra


# pass in an address to unlock function in argument register 0
# returns when lock is free
unlock:
  sw    $0, 0($a0)
  jr    $ra

# main function does something ugly but demonstrates beautifully
mainp0:
  push $ra
  ori $a0, $0, 0x1000
  jal lock
  ori $t5, $0, 0x1004
  ori $t6, $0, 0x0000
  ori $t7, $0, 0x0100
  ori $a0, $0, 0x0005
randloop:
  beq $t6, $t7, randfinish
  jal crc32
  or $a0, $0, $v0
  sw $v0, 0($t5)
  addiu $t6, $t6, 0x0001
  addiu $t5, $t5, 0x0004
  j randloop
randfinish:
  ori $a0, $0, 0x1000
  jal unlock
  pop $ra
  jr $ra


#----------------------------------------------------------
# Second Processor
#----------------------------------------------------------
  org   0x200               # second processor p1
  ori   $sp, $zero, 0x7ffc  # stack
  jal   mainp1              # go to program
  halt

# main function does something ugly but demonstrates beautifully
mainp1:
  push $ra
  ori $a0, $0, 0x1000
  ori $t9, $0, 0x0001
checkdone:
  lw $t8, 0($a0)
  beq $t8, $t9, moveon
  j checkdone
moveon:
  jal lock
  ori $t1, $0, 0x1004 #stack pointer
  ori $t2, $0, 0x0000 #loop invariant
  ori $t3, $0, 0x00FF #loop closer
  jal ourpop
  or $t4, $v0, $0 #min register
  sll $t4, $t4, 16
  srl $t4, $t4, 16
  or $t5, $v0, $0 #max register
  sll $t5, $t5, 16
  srl $t5, $t5, 16
  or $t6, $v0, $0 #running total
  sll $t6, $t6, 16
  srl $t6, $t6, 16
findall:
  beq $t2, $t3, findfinish
  jal ourpop
  or $t7, $v0, $0
  sll $t7, $t7, 16
  srl $t7, $t7, 16
  add $t6, $t6, $t7
  or $a1, $t7, $0
  or $a0, $t4, $0
  jal min
  or $t4, $v0, $0
  or $a1, $t7, $0
  or $a0, $t5, $0
  jal max
  or $t5, $v0, $0
  addiu $t2, $t2, 0x0001
  j findall
findfinish:
  srl $t6, $t6, 8
  ori $a0, $0, 0x1000
  jal unlock
  pop $ra
  jr    $ra                 # return to caller


#REGISTERS
#at $1 at
#v $2-3 function returns
#a $4-7 function args
#t $8-15 temps
#s $16-23 saved temps (callee preserved)
#t $24-25 temps
#k $26-27 kernel
#gp $28 gp (callee preserved)
#sp $29 sp (callee preserved)
#fp $30 fp (callee preserved)
#ra $31 return address

# USAGE random0 = crc(seed), random1 = crc(random0)
#       randomN = crc(randomN-1)
#------------------------------------------------------
# $v0 = crc32($a0)
crc32:
  lui $t1, 0x04C1
  ori $t1, $t1, 0x1DB7
  or $t2, $0, $0
  ori $t3, $0, 32

l1:
  slt $t4, $t2, $t3
  beq $t4, $zero, l2

  srl $t4, $a0, 31
  sll $a0, $a0, 1
  beq $t4, $0, l3
  xor $a0, $a0, $t1
l3:
  addiu $t2, $t2, 1
  j l1
l2:
  or $v0, $a0, $0
  jr $ra


# registers a0-1,v0-1,t0
# a0 = Numerator
# a1 = Denominator
# v0 = Quotient
# v1 = Remainder

#-divide(N=$a0,D=$a1) returns (Q=$v0,R=$v1)--------
divide:               # setup frame
  push  $ra           # saved return address
  push  $a0           # saved register
  push  $a1           # saved register
  or    $v0, $0, $0   # Quotient v0=0
  or    $v1, $0, $a0  # Remainder t2=N=a0
  beq   $0, $a1, divrtn # test zero D
  slt   $t0, $a1, $0  # test neg D
  bne   $t0, $0, divdneg
  slt   $t0, $a0, $0  # test neg N
  bne   $t0, $0, divnneg
divloop:
  slt   $t0, $v1, $a1 # while R >= D
  bne   $t0, $0, divrtn
  addiu $v0, $v0, 1   # Q = Q + 1
  subu  $v1, $v1, $a1 # R = R - D
  j     divloop
divnneg:
  subu  $a0, $0, $a0  # negate N
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
  beq   $v1, $0, divrtn
  addiu $v0, $v0, -1  # return -Q-1
  j     divrtn
divdneg:
  subu  $a0, $0, $a1  # negate D
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
divrtn:
  pop $a1
  pop $a0
  pop $ra
  jr  $ra
#-divide--------------------------------------------


# registers a0-1,v0,t0
# a0 = a
# a1 = b
# v0 = result

#-max (a0=a,a1=b) returns v0=max(a,b)--------------
max:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a0, $a1
  beq   $t0, $0, maxrtn
  or    $v0, $0, $a1
maxrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra
#--------------------------------------------------

#-min (a0=a,a1=b) returns v0=min(a,b)--------------
min:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a1, $a0
  beq   $t0, $0, minrtn
  or    $v0, $0, $a1
minrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra
#--------------------------------------------------

ourpop:
  lw $v0, 0($t1)
  sw $0, 0($t1)
  addiu $t1, $t1, 0x04
  jr $ra
