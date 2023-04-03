def main():
    
    filename = input('Enter file name: ')
    
    ReadFile = open(filename,'r')
    WriteFile = open('output file.txt', 'w')
    
    instruction_number = 0
    
    Encode = 0 # 1 - Encode Instructions | 2 - Encode Data
    
    for index,line in enumerate(ReadFile):
        
        line = line.replace('\n','')
        #print(f'Line Number: {index} = Line Data: {line}')
        
        if(line == '.start'):
            Encode = 1
        elif(line == '.data'):
            Encode = 2
        
        else:
            if(Encode == 1):    # Instruction Encode
                if(line != ''):
                    line = line.replace(',',' ').replace('(',' ').replace(')',' ')
                    instruction_list = line.split()
                    
                    if(instruction_list[0] == 'NOP'):
                        Instruction_Encode = 4 # ADD R0,R0,R0
                        print(f'Instruction_list = {instruction_list}')
                    # -- R - Type Instructions -- #
                    elif(instruction_list[0] == 'ADD'):
                        Instruction_Encode = R_Type_Encode(instruction_list,function = 4)
                    elif(instruction_list[0] == 'SUB'):
                        Instruction_Encode = R_Type_Encode(instruction_list,function = 5)
                    elif(instruction_list[0] == 'MUL'):
                        Instruction_Encode = R_Type_Encode(instruction_list,function = 6)
                    elif(instruction_list[0] == 'DIV'):
                        Instruction_Encode = R_Type_Encode(instruction_list,function = 7)
                    
                    elif(instruction_list[0] == 'AND'):
                        Instruction_Encode = R_Type_Encode(instruction_list,function = 8)
                    elif(instruction_list[0] == 'OR'):
                        Instruction_Encode = R_Type_Encode(instruction_list,function = 9)
                    elif(instruction_list[0] == 'NOR'):
                        Instruction_Encode = R_Type_Encode(instruction_list,function = 10)
                    elif(instruction_list[0] == 'XOR'):
                        Instruction_Encode = R_Type_Encode(instruction_list,function = 11)
                        
                    elif(instruction_list[0] == 'SLL'):
                        Instruction_Encode = R_Type_Encode(instruction_list,function = 24)
                    elif(instruction_list[0] == 'SRL'):
                        Instruction_Encode = R_Type_Encode(instruction_list,function = 25)
                    elif(instruction_list[0] == 'SLA'):
                        Instruction_Encode = R_Type_Encode(instruction_list,function = 26)
                    elif(instruction_list[0] == 'SRA'):
                        Instruction_Encode = R_Type_Encode(instruction_list,function = 27)
                        
                    elif(instruction_list[0] == 'ADDF'):
                        Instruction_Encode = R_Type_Encode(instruction_list,function = 0)
                    elif(instruction_list[0] == 'SUBF'):
                        Instruction_Encode = R_Type_Encode(instruction_list,function = 1)
                    elif(instruction_list[0] == 'MULF'):
                        Instruction_Encode = R_Type_Encode(instruction_list,function = 2)
                    elif(instruction_list[0] == 'DIVF'):
                        Instruction_Encode = R_Type_Encode(instruction_list,function = 3)
                    # -- R - Type Instructions -- #
                    
                    # -- I - Type Instructions -- #
                    elif(instruction_list[0] == 'ADDI'):
                        Instruction_Encode = I_Type_Encode(instruction_list,opcode = 4)
                    elif(instruction_list[0] == 'SUBI'):
                        Instruction_Encode = I_Type_Encode(instruction_list,opcode = 5)
                    elif(instruction_list[0] == 'MULI'):
                        Instruction_Encode = I_Type_Encode(instruction_list,opcode = 6)
                    elif(instruction_list[0] == 'DIVI'):
                        Instruction_Encode = I_Type_Encode(instruction_list,opcode = 7)
                        
                    elif(instruction_list[0] == 'ADDHI'):
                        Instruction_Encode = I_Type_Encode(instruction_list,opcode = 36)
                    elif(instruction_list[0] == 'SUBHI'):
                        Instruction_Encode = I_Type_Encode(instruction_list,opcode = 37)
                    elif(instruction_list[0] == 'MULHI'):
                        Instruction_Encode = I_Type_Encode(instruction_list,opcode = 38)
                    elif(instruction_list[0] == 'DIVHI'):
                        Instruction_Encode = I_Type_Encode(instruction_list,opcode = 39)
                        
                    elif(instruction_list[0] == 'ANDI'):
                        Instruction_Encode = I_Type_Encode(instruction_list,opcode = 8)
                    elif(instruction_list[0] == 'ORI'):
                        Instruction_Encode = I_Type_Encode(instruction_list,opcode = 9)
                    elif(instruction_list[0] == 'NORI'):
                        Instruction_Encode = I_Type_Encode(instruction_list,opcode = 10)
                    elif(instruction_list[0] == 'XORI'):
                        Instruction_Encode = I_Type_Encode(instruction_list,opcode = 11)
                        
                    elif(instruction_list[0] == 'ANDHI'):
                        Instruction_Encode = I_Type_Encode(instruction_list,opcode = 40)
                    elif(instruction_list[0] == 'ORHI'):
                        Instruction_Encode = I_Type_Encode(instruction_list,opcode = 41)
                    elif(instruction_list[0] == 'NORHI'):
                        Instruction_Encode = I_Type_Encode(instruction_list,opcode = 42)
                    elif(instruction_list[0] == 'XORHI'):
                        Instruction_Encode = I_Type_Encode(instruction_list,opcode = 43)
                    # -- I - Type Instructions -- #

                    # -- Branch - Type Instructions -- #
                    elif(instruction_list[0] == 'BEQ'):
                        Instruction_Encode = BR_Type_Encode(instruction_list,opcode = 12)
                    elif(instruction_list[0] == 'BNE'):
                        Instruction_Encode = BR_Type_Encode(instruction_list,opcode = 13)
                    elif(instruction_list[0] == 'BGT'):
                        Instruction_Encode = BR_Type_Encode(instruction_list,opcode = 14)
                    elif(instruction_list[0] == 'BLE'):
                        Instruction_Encode = BR_Type_Encode(instruction_list,opcode = 15)
                    # -- Branch - Type Instructions -- #
                    
                    # -- Memory - Type Instructions -- #
                    elif(instruction_list[0] == 'LDW'):
                        Instruction_Encode = MEM_Type_Encode(instruction_list, opcode = 1)
                    elif(instruction_list[0] == 'STW'):
                        Instruction_Encode = MEM_Type_Encode(instruction_list, opcode = 2)
                    # -- Memory - Type Instructions -- #
                    
                    # -- J - Type Instructions -- #
                    elif(instruction_list[0] == 'JMP'):
                        Instruction_Encode = J_Type_Encode(instruction_list,opcode = 63)
                    elif(instruction_list[0] == 'CALL'):
                        Instruction_Encode = J_Type_Encode(instruction_list,opcode = 62)
                    elif(instruction_list[0] == 'RET'):
                        Instruction_Encode = J_Type_Encode(instruction_list,opcode = 61)
                    # -- J - Type Instructions -- #
                    
                    # -- BUS - Type Instructions -- #
                    elif(instruction_list[0] == 'PERBUSW'):
                        Instruction_Encode = BUS_Type_Encode(instruction_list,opcode = 56)
                    elif(instruction_list[0] == 'PERBUSR'):
                        Instruction_Encode = BUS_Type_Encode(instruction_list,opcode = 55)
                    # -- BUS - Type Instructions -- #
                    
                    # -- Print Encod to output file -- #
                    WriteFile.write(f'{instruction_number}:{hex(Instruction_Encode)}|{Instruction_Encode}| - / {line} \ -\n')
                    instruction_number += 1
                    # -- Print Encod to output file -- #
                    
                    
                
    ReadFile.close()
    WriteFile.close()
    print('Output file generated.')
    input('Press enter to exit')
    
def R_Type_Encode(instruction_list,function):
    opcode = 0
    shamt = 0
    rd = int(instruction_list[1].replace('R',''))
    rs = int(instruction_list[2].replace('R',''))
    rt = int(instruction_list[3].replace('R',''))
    Instruction_Encode = (opcode * (2**26)) + (rd * (2**21)) + (rs * (2**16)) + (rt * (2**11)) + (shamt * (2*6)) + (function * (2**0))
    print(f'instruction_list = {instruction_list} | function = {function} | rd = {rd} | rs = {rs} | rt = {rt} | Encode = {hex(Instruction_Encode)}')
    return (Instruction_Encode)
    
    
def I_Type_Encode(instruction_list,opcode):
    rd = int(instruction_list[1].replace('R',''))
    rs = int(instruction_list[2].replace('R',''))
    imm = int(instruction_list[3])
    Instruction_Encode = (opcode * (2**26)) + (rd * (2**21)) + (rs * (2**16)) + (imm * (2**0))
    print(f'instruction_list = {instruction_list} | opcode = {opcode} | rs = {rs} | rd = {rd} | imm = {imm} | Encode = {hex(Instruction_Encode)}')
    return (Instruction_Encode)
    
def BR_Type_Encode(instruction_list,opcode):
    rd = int(instruction_list[1].replace('R',''))
    rs = int(instruction_list[2].replace('R',''))
    addr = int(instruction_list[3])
    Instruction_Encode = (opcode * (2**26)) + (rd * (2**21)) + (rs * (2**16)) + (addr * (2**0))
    print(f'instruction_list = {instruction_list} | opcode = {opcode} | rd = {rd} | rs = {rs} | addr = {addr} | Encode = {hex(Instruction_Encode)}')
    return (Instruction_Encode)
    
def MEM_Type_Encode(instruction_list,opcode):
    rd = int(instruction_list[1].replace('R',''))
    rs = int(instruction_list[3].replace('R',''))
    imm = int(instruction_list[2])
    Instruction_Encode = (opcode * (2**26)) + (rd * (2**21)) + (rs * (2**16)) + (imm * (2**0))
    print(f'instruction_list = {instruction_list} | opcode = {opcode} | rd = {rd} | rs = {rs} | imm = {imm} | Encode = {hex(Instruction_Encode)}')
    return (Instruction_Encode)
    
def J_Type_Encode(instruction_list,opcode):
    if (instruction_list[0] == 'RET'):
        Instruction_Encode = opcode * (2**26)
        print(f'instruction_list = {instruction_list} | opcode = {opcode} | Encode = {hex(Instruction_Encode)}')
    else:
        addr = int(instruction_list[1])
        Instruction_Encode = (opcode * (2**26)) + (addr * (2**0))
        print(f'instruction_list = {instruction_list} | opcode = {opcode} | addr = {addr} | Encode = {hex(Instruction_Encode)}')
    return (Instruction_Encode)
    
def BUS_Type_Encode(instruction_list,opcode):
    string = 'BUS Type Instructions not suppurtted yet'
    print(f'\033[91m {stirng} \033[00m')
    print(f'instruction_list = {instruction_list} | opcode = {opcode}')
    return (Instruction_Encode)
    
main()