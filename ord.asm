##ord.asm

# SECCION DE INSTRUCCIONES (.text)
.text
.globl __start

__start:
la $s1, array #direccion inicial del array
li $s2, 8     #tamaño del array

li $s3, 8     #contador que se usara para el bucle
loop1:la $a0, array #direccion del primer elemento (es el maximo antes de iniciar)
      la $a1, array #guardara direccion del ultimo elemento de la parte no ordenada (donde ira el maximo encontrado)
      li $t0, 4
      sub $s4, $s3, 1
      mul $s4, $s4, $t0
      add $a1, $a1, $s4
      
      lw $t0,0($a0) # initialize maximum to A[0]
      li $t1,0 # initialize index i to 0

      loop2: add $t2,$t1,$t1 # compute 2i in $t2
             add $t2,$t2,$t2 # compute 4i in $t2
             add $t3,$t2,$s1 # form address of A[i] in $t3
             lw $t4,0($t3) # load value of A[i] into $t4
             slt $t5,$t0,$t4 # maximum < A[i]?
             beq $t5,$zero,no_cambio # if not, repeat with no change
             addi $t0,$t4,0 # if so, A[i] is the new maximum
             add $a0,$s1,$t2 # guardar direccion del maximo
             add $t1,$t1,1 # increment index i by 1
             beq $t1,$s3,done1 # if all elements examined, quit
             j loop2 # change completed; now repeat
      
      no_cambio: add $t1,$t1,1
                 beq $t1,$s3,done1 # if all elements examined, quit
                 j loop2
             
      done1: lw $t6, 0($a0)
             lw $t7, 0($a1)
             sw $t6, 0($a1)
             sw $t7, 0($a0)
             addi $s3, $s3, -1
             li $t0, 1
             beq  $s3,$t0,print
             j loop1
      
print:li $t0, 4
      li $t1, 0
      
      loop3:mul $t2,$t1,$t0
            add $t3,$t2,$s1
            lw  $t4,0($t3)
            addi $a0,$t4,0
            li $v0,1
            syscall
            li $v0,4
            la $a0,esp
            syscall
            add $t1,$t1,1
            beq $t1,$s2,fin
            j loop3  

 fin:
      la $a0,endl
      li $v0,4
      syscall
      li $v0,10
      syscall
 
.data
array: .word 5,10,12,12,15,20,26,5
ordrpta: .asciiz "El numero mayor es: "
esp: .asciiz " "
endl: .asciiz "\n"
