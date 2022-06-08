# 0xABAD1DEA should be written to R15 before last infinite loop

_start:
               xor     sp,sp,sp             # 000 00214133
               addi    sp,sp,1024           # 004 40010113
               addi    s0,sp,32             # 008 02010413
               lui     a5,0x00000           # 00C 000007b7
               addi    a5,a5,-1             # 010 fff78793
               sw      a5,-20(s0)           # 014 fef42623
               lw      a5,-20(s0)           # 018 fec42783
               sw      a5,-24(s0)           # 01C fef42423
               lw      a5,-20(s0)           # 020 fec42783
               sw      a5,-28(s0)           # 024 fef42223
               sb      zero,-29(s0)         # 028 fe0401a3
               jal     zero,_b1             # 02C 0300006f
_b0:
               lw      a5,-24(s0)           # 030 fe842783
               slli    a5,a5,0x8            # 034 00879793
               sw      a5,-24(s0)           # 038 fef42423
               lw      a5,-28(s0)           # 03C fe442783
               srli    a5,a5,0x8            # 040 0087d793
               sw      a5,-28(s0)           # 044 fef42223
               lb      a5,-29(s0)           # 048 fe340783
               andi    a5,a5,255            # 04C 0ff7f793
               addi    a5,a5,1              # 050 00178793
               andi    a5,a5,255            # 054 0ff7f793
               sb      a5,-29(s0)           # 058 fef401a3
_b1:
               lb      a4,-29(s0)           # 05C fe340703
               xor     a5,a5,a5             # 060 00f7c7b3
               addi    a5,a5,3              # 064 00378793
               bge     a5,a4,_b0            # 068 fce7d4e3
               lw      a4,-24(s0)           # 06C fe842703
               lui     a5,0xb               # 070 0000b7b7
               addi    a5,a5,-858           # 074 ca678793
               add     a5,a4,a5             # 078 00f707b3
               sw      a5,-24(s0)           # 07C fef42423
               lw      a5,-28(s0)           # 080 fe442783
               addi    a5,a5,-1             # 084 fff78793
               sw      a5,-28(s0)           # 088 fef42223
               lw      a4,-24(s0)           # 08C fe842703
               lw      a5,-28(s0)           # 090 fe442783
               bne     a4,a5,_b2            # 094 00f71a63
               xor     a5,a5,a5             # 098 00f7c7b3
               addi    a5,a5,0xff           # 09C 0ff78793
               sw      a5,-20(s0)           # 0A0 fef42623
               jal     zero,_b3             # 0A4 0100006f
_b2:
               lui     a5,0x10              # 0A8 000107b7
               addi    a5,a5,-256           # 0AC f0078793
               sw      a5,-20(s0)           # 0B0 fef42623
_b3:
               lw      a5,-24(s0)           # 0B4 fe842783
               xori    a5,a5,255            # 0B8 0ff7c793
               sw      a5,-24(s0)           # 0BC fef42423
               lw      a5,-28(s0)           # 0C0 fe442783
               ori     a5,a5,255            # 0C4 0ff7e793
               sw      a5,-28(s0)           # 0C8 fef42223
               lw      a1,-24(s0)           # 0CC fe842583
               lw      a0,-20(s0)           # 0D0 fec42503
               jal     ra,__mulsi3          # 0D4 03c000ef
               addi    a5,a0,0              # 0D8 00050793
               sw      a5,-20(s0)           # 0DC fef42623
               lw      a4,-20(s0)           # 0E0 fec42703
               lui     a5,0x17              # 0E4 000177b7
               addi    a1,a5,405            # 0E8 19578593
               addi    a0,a4,0              # 0EC 00070513
               jal     ra,__udivsi3         # 0F0 044000ef
               addi    a5,a0,0              # 0F4 00050793
               sh      a5,-32(s0)           # 0F8 fef41023
               lh      a5,-32(s0)           # 0FC fe041783
               lw      a4,-20(s0)           # 100 fec42703
               add     a5,a4,a5             # 104 00f707b3
               sw      a5,-20(s0)           # 108 fef42623
_fin:
               jal     zero,_fin            # 10C 0000006f

__mulsi3:
               addi    a2,a0,0              # 110 00050613
               xor     a0,a0,a0             # 114 00a54533
__mulsi3_b0:
               andi    a3,a1,1              # 118 0015f693
               beq     a3,zero,__mulsi3_b1  # 11C 00068463
               add     a0,a0,a2             # 120 00c50533
__mulsi3_b1:
               srli    a1,a1,0x1            # 124 0015d593
               slli    a2,a2,0x1            # 128 00161613
               bne     a1,zero,__mulsi3_b0  # 12C fe0596e3
               jalr    zero,ra,0            # 130 00008067

__udivsi3:
               addi    a2,a1,0              # 134 00058613
               addi    a1,a0,0              # 138 00050593
               lui     a0,0x00000           # 13C 00000537
               addi    a0,a0,-1             # 140 fff50513
               beq     a2,zero,__udivsi3_4  # 144 02060e63
               xor     a3,a3,a3             # 148 00d6c6b3
               ori     a3,a3,1              # 14C 0016e693
               bgeu    a2,a1,__udivsi3_1    # 150 00b67a63
__udivsi3_0:
               bge     zero,a2,__udivsi3_1  # 154 00c05863
               slli    a2,a2,0x1            # 158 00161613
               slli    a3,a3,0x1            # 15C 00169693
               bltu    a2,a1,__udivsi3_0    # 160 feb66ae3
__udivsi3_1:
               xor     a0,a0,a0             # 164 00a54533
__udivsi3_2:
               bltu    a1,a2,__udivsi3_3    # 168 00c5e663
               sub     a1,a1,a2             # 16C 40c585b3
               or      a0,a0,a3             # 170 00d56533
__udivsi3_3:
               srli    a3,a3,0x1            # 174 0016d693
               srli    a2,a2,0x1            # 178 00165613
               bne     a3,zero,__udivsi3_2  # 17C fe0696e3
__udivsi3_4:
               jalr    zero,ra,0            # 180 00008067