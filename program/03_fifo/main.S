# RISC-V simple counter program
#
# Stanislav Zhelnio, 2020
#

        .text

start:  li      a0, 0               # count = 0
        li      a2, 7               # max = 7
push_l: addi    a0, a0, 1           # count += 1
        sw      a0, 0(a0)           # push count
        bne     a0, a2, push_l      # if count <= max then push_l
        li      a2, -1              # min = -1
pop_l:  
        sw      a1, 0(a1)           # pop check
        bne     a1, a0, bad         # if check != count then bad
        addi    a0, a0, -1          # count -= 1
        bne     a0, a2, push_l      # if count > min then pop_l
good:   li      a1, 0               # result = 0
        beqz    zero, end           # end
bad:    li      a1, 1               # result = 1
end:    beqz    zero, end           # end
