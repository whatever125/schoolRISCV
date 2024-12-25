# RISC-V simple counter program
#
# Stanislav Zhelnio, 2020
#

        .text

start:  addi    a1, zero, 0             # count = 0
        addi    a3, zero, 8             # max = 8
push_l: addi    a1, a1, 1               # count += 1
        sw      a1, 0(a1)               # push count
        bne     a1, a3, push_l          # if count <= max then push_l
        addi    a3, zero, 0             # min = 0
pop_l:  lw      a2, 0(a2)               # pop check
        bne     a2, a1, bad             # if check != count then bad
        addi    a1, a1, -1              # count -= 1
        bne     a1, a3, pop_l           # if count > min then pop_l
good:   addi    a4, zero, 0             # result = 0
        beq     zero, zero, end         # end
bad:    addi    a4, zero, 1             # result = 1
end:    beq     zero, zero, end         # end
