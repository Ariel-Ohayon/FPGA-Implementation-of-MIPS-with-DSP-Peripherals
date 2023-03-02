import os

def main():

    data = 6
    
    filename = input('Enter file name: ')
    fr = open(filename,"r");
    
    line_number = 0
    
    outfile = input('Do you want to create output file?[y/n]')
    if(outfile == 'y'):
        f = open('output_file.txt','w')
    
    for line in fr:
        function = list('xxxxxxx')
        line_number = line_number + 1
        #print(line)
        
        # Decode the Command Type
        
        
        x=0
        while(line[x] != ' '):
            function[x] = line[x]
            x = x + 1
        if(function == list('ADDxxxx')):
            data = R_Type_Encode(line)
        elif(function == list('SUBxxxx')):
            data = R_Type_Encode(line)
        elif(function == list('MULxxxx')):
            data = R_Type_Encode(line)
        elif(function == list('DIVxxxx')):
            data = R_Type_Encode(line)
            
        elif(function == list('ADDUxxx')):
            data = R_Type_Encode(line)
        elif(function == list('SUBUxxx')):
            data = R_Type_Encode(line)
        elif(function == list('MULUxxx')):
            data = R_Type_Encode(line)
        elif(function == list('DIVUxxx')):
            data = R_Type_Encode(line)
            
        elif(function == list('ANDxxxx')):
            data = R_Type_Encode(line)
        elif(function == list('ORxxxxx')):
            data = R_Type_Encode(line)
        elif(function == list('NORxxxx')):
            data = R_Type_Encode(line)
        elif(function == list('XORxxxx')):
            data = R_Type_Encode(line)
            
        elif(function == list('SLLxxxx')):
            data = R_Type_Encode(line)
        elif(function == list('SRLxxxx')):
            data = R_Type_Encode(line)
        elif(function == list('SLAxxxx')):
            data = R_Type_Encode(line)
        elif(function == list('SRAxxxx')):
            data = R_Type_Encode(line)
            
        elif(function == list('ADDFxxx')):
            data = R_Type_Encode(line)
        elif(function == list('SUBFxxx')):
            data = R_Type_Encode(line)
        elif(function == list('MULFxxx')):
            data = R_Type_Encode(line)
        elif(function == list('DIVFxxx')):
            data = R_Type_Encode(line)
            
        elif(function == list('ADDIxxx')):
            data = I_Type_Encode(line)
        elif(function == list('SUBIxxx')):
            data = I_Type_Encode(line)
        elif(function == list('MULIxxx')):
            data = I_Type_Encode(line)
        elif(function == list('DIVIxxx')):
            data = I_Type_Encode(line)
            
        elif(function == list('ADDUIxx')):
            data = I_Type_Encode(line)
        elif(function == list('SUBUIxx')):
            data = I_Type_Encode(line)
        elif(function == list('MULUIxx')):
            data = I_Type_Encode(line)
        elif(function == list('DIVUIxx')):
            data = I_Type_Encode(line)
            
        elif(function == list('ADDHIxx')):
            data = I_Type_Encode(line)
        elif(function == list('SUBHIxx')):
            data = I_Type_Encode(line)
        elif(function == list('MULHIxx')):
            data = I_Type_Encode(line)
        elif(function == list('DIVHIxx')):
            data = I_Type_Encode(line)
            
        elif(function == list('ADDUHIx')):
            data = I_Type_Encode(line)
        elif(function == list('SUBUHIx')):
            data = I_Type_Encode(line)
        elif(function == list('MULUHIx')):
            data = I_Type_Encode(line)
        elif(function == list('DIVUHIx')):
            data = I_Type_Encode(line)
            
        elif(function == list('ANDIxxx')):
            data = I_Type_Encode(line)
        elif(function == list('ORIxxxx')):
            data = I_Type_Encode(line)
        elif(function == list('NORIxxx')):
            data = I_Type_Encode(line)
        elif(function == list('XORIxxx')):
            data = I_Type_Encode(line)
            
        elif(function == list('ANDHIxx')):
            data = I_Type_Encode(line)
        elif(function == list('ORHIxxx')):
            data = I_Type_Encode(line)
        elif(function == list('NORHIxx')):
            data = I_Type_Encode(line)
        elif(function == list('XORHIxx')):
            data = I_Type_Encode(line)
            
        elif(function == list('BEQxxxx')):
            data = BR_Encode(line)
        elif(function == list('BNExxxx')):
            data = BR_Encode(line)
        elif(function == list('BGTxxxx')):
            data = BR_Encode(line)
        elif(function == list('BLExxxx')):
            data = BR_Encode(line)
            
        elif(function == list('LDWxxxx')):
            data = MEM_Encode(line)
        elif(function == list('STWxxxx')):
            data = MEM_Encode(line)
        
        elif (function == list('JMPxxxx')):
            data = J_Type_Encode(line)
        elif(function == list('CALLxxx')):
            data = J_Type_Encode(line)
        elif(function == list('RETxxxx')):
            data = J_Type_Encode(line)
        
        elif (function == list('PERBUSW')):
            data = BUS_Type_Encode(line)
        elif(function == list('PERBUSR')):
            data = BUS_Type_Encode(line)
        else:
            print(f'ERROR line: {line_number}')
        
        
        if (data == 0):
            print('R_Type Operation')
        elif(data == 1):
            print('I_Type Operation')
        elif(data == 2):
            print('J_Type_Operation')
        elif(data == 3):
            print('Branch Operation')
        elif(data == 4):
            print('Memory Operation')
        elif(data == 5):
            print('BUS_Type Operation')

        for i in range(0,len(line)):
            if (line[i] == '\n'):
                line = line.replace('\n','');
                break
        
        print(f'Operation: {line}\t|Encode_Data[BIN]: {bin(data)}\t|Encode_Data[HEX]: {hex(data)}')
        if(outfile == 'y'):
            f.write(f'{line_number-1}:{hex(data)}\n')
        
        
        
    fr.close()
    if(outfile == 'y'):
        f.close()
        print('Output File Generated.')
    
    os.system('pause')
    
    
def R_Type_Encode(cmd):
    
    function = ''
    
    opcode = 0 # constant
    
    rt = 0
    rd = 0
    shamt = 0
    funct = 0
    
    Encode_cmd = 0
    
    # -- / Calculating function \ --#
    x=0
    while(cmd[x] != ' '):
        function += cmd[x]
        x=x+1
    # -- / Calculating function \ --#
    
    # -- / Calculating rs \ --#
    while(cmd[x]!='R'):
        x=x+1
    x=x+1
    rs = int(cmd[x])*10
    x = x + 1
    if(cmd[x] == ','):
        x=x+1
        rs = rs/10
    else:
        rs = rs+int(cmd[x])
        x = x + 2
    # -- / Calculating rs \ --#
    
    # -- / Calculating rt \ -- #
    x = x + 1
    while(cmd[x]!=','):
        rt += int(cmd[x])
        rt *= 10
        x = x + 1
    rt = int(rt / 10)
    # -- / Calculating rt \ -- #
    x = x + 2
    
    for i in range(x,len(cmd)):
        if(cmd[i] == '\n'):
            break
        rd += int(cmd[x])
        rd *= 10
        x = x + 1
    rd = int(rd/10)
    
    if(function == 'ADD'):
        funct = 4
    elif(function == 'SUB'):
        funct = 5
    elif(function == 'MUL'):
        funct = 6
    elif(function == 'DIV'):
        funct = 7
        
    elif(function == 'ADDU'):
        funct = 20
    elif(function == 'SUBU'):
        funct = 21
    elif(function == 'MULU'):
        funct = 22
    elif(function == 'DIVU'):
        funct = 23
            
    elif(function == 'AND'):
        funct = 8
    elif(function == 'OR'):
        funct = 9
    elif(function == 'NOR'):
        funct = 10
    elif(function == 'XOR'):
        funct = 11
            
    elif(function == 'SLL'):
        funct = 24
        # shamt = 
    elif(function == 'SRL'):
        funct = 25
        # shamt = 
    elif(function == 'SLA'):
        funct = 26
        # shamt = 
    elif(function == 'SRA'):
        funct = 27
        # shamt = 
        
    elif(function == 'ADDF'):
        funct = 0
    elif(function == 'SUBF'):
        funct = 1
    elif(function == 'MULF'):
        funct = 2
    elif(function == 'DIVF'):
        funct = 3
        
    Encode_cmd = (rs*(2**21)) + (rt*(2**16)) + (rd*(2**11)) + (funct*(2**0))
    Encode_cmd = int(Encode_cmd)
    
    return Encode_cmd
    
    
def I_Type_Encode(cmd):

    function = ''
    rs = 0
    rt = 0
    imm = 0
    
    # -- / Calculating function \ --#
    x = 0
    while(cmd[x] != ' '):
        function += cmd[x]
        x = x + 1
    # -- / Calculating function \ --#
    
    # -- / Calculating rs \ --#
    while(cmd[x]!='R'):
        x = x + 1
    x = x + 1
    rs = int(cmd[x])*10
    x = x + 1
    if(cmd[x] == ','):
        x=x+1
        rs = rs/10
    else:
        rs = rs+int(cmd[x])
        x = x + 2
    rs = int(rs)
    # -- / Calculating rs \ --#
    
    # -- / Calculating rt \ -- #
    x = x + 1
    while(cmd[x]!=','):
        rt += int(cmd[x])
        rt *= 10
        x = x + 1
    rt = int(rt / 10)
    # -- / Calculating rt \ -- #
    x = x + 1
    
    for i in range(x,len(cmd)):
        if(cmd[i] == '\n'):
            break
        imm += int(cmd[i])
        imm *= 10
    imm /= 10
    
    imm = int(imm)
    
    if(function == 'ADDI'):
        opcode = 4
    elif(function == 'SUBI'):
        opcode = 5
    elif(function == 'MULI'):
        opcode = 6
    elif(function == 'DIVI'):
        opcode = 7
        
    elif(function == 'ADDUI'):
        opcode = 20
    elif(function == 'SUBUI'):
        opcode = 21
    elif(function == 'MULUI'):
        opcode = 22
    elif(function == 'DIVUI'):
        opcode = 23
    
    elif(function == 'ADDHI'):
        opcode = 36
    elif(function == 'SUBHI'):
        opcode = 37
    elif(function == 'MULHI'):
        opcode = 38
    elif(function == 'DIVHI'):
        opcode = 39
    
    elif(function == 'ADDUHI'):
        opcode = 52
    elif(function == 'SUBUHI'):
        opcode = 53
    elif(function == 'MULUHI'):
        opcode = 54
    elif(function == 'DIVUHI'):
        opcode = 55
        
    elif(function == 'ANDI'):
        opcode = 8
    elif(function == 'ORI'):
        opcode = 9
    elif(function == 'NORI'):
        opcode = 10
    elif(function == 'XORI'):
        opcode = 11
        
    elif(function == 'ANDHI'):
        opcode = 40
    elif(function == 'ORHI'):
        opcode = 41
    elif(function == 'NORHI'):
        opcode = 42
    elif(function == 'XORHI'):
        opcode = 43
        
    
    Encode_cmd = (opcode*(2**26)) + (rs*(2**21)) + (rt*(2**16)) + imm
    
    return Encode_cmd


def J_Type_Encode(cmd):
    
    function = ''
    imm = 0
    
    # copy #
    # -- / Calculating function \ --#
    x = 0
    while(cmd[x] != ' '):
        function += cmd[x]
        x = x + 1
    # -- / Calculating function \ --#
    # copy #
    x = x + 1
    
    for i in range(x,len(cmd)):
        if(cmd[i] == '\n'):
            break
        imm += int(cmd[i])
        imm *= 10
    imm /= 10
    imm = int(imm)
    
    if (function == 'JMP'):
        opcode = 63
    elif(function == 'CALL'):
        opcode = 62
    elif(function == 'RET'):
        opcode = 61
    
    Encode_cmd = (opcode*(2**26)) + imm
    
    return Encode_cmd
    
def BR_Encode(cmd):

    rs = 0
    rt = 0
    imm = 0
    
    function = ''
    # copy #
    # -- / Calculating function \ --#
    x = 0
    while(cmd[x] != ' '):
        function += cmd[x]
        x = x + 1
    # -- / Calculating function \ --#
    # copy #
    x += 2
    
    while(cmd[x] != ','):
        rs += int(cmd[x])
        rs *= 10
        x += 1
    rs /= 10
    rs = int(rs)
    
    x += 2
    while(cmd[x] != ','):
        rt += int(cmd[x])
        rt *= 10
        x += 1
    rt /= 10
    rt = int(rt)
    
    x += 1
    for i in range(x,len(cmd)):
        if (cmd[i] == '\n'):
            break
        imm += int(cmd[i])
        imm *= 10
    imm /= 10
    imm = int(imm)
    
    if(function == 'BEQ'):
        opcode = 12
    elif(function == 'BNE'):
        opcode = 13
    elif(function == 'BGT'):
        opcode = 14
    elif(function == 'BLE'):
        opcode = 15
    
    Encode_cmd = (rs*(2**21)) + (rt*(2**16)) + (opcode*(2**26)) + imm

    
    return Encode_cmd
    
def MEM_Encode(cmd):
    
    function = ''
    rs = 0
    rt = 0
    imm = 0
    # copy #
    # -- / Calculating function \ --#
    x = 0
    while(cmd[x] != ' '):
        function += cmd[x]
        x = x + 1
    # -- / Calculating function \ --#
    # copy #
    x += 2
    
    while(cmd[x] != ','):
        rs += int(cmd[x])
        rs *= 10
        x += 1
    rs /= 10
    rs = int(rs)
    
    x += 1
    while(cmd[x] != '('):
        imm += int(cmd[x])
        imm *= 10
        x += 1
    imm /= 10
    imm = int(imm)
    
    x += 2
    while(cmd[x] != ')'):
        rt += int(cmd[x])
        rt *= 10
        x += 1
    rt /= 10
    rt = int(rt)
    
    if (function == 'LDW'):
        opcode = 1
    elif(function == 'STW'):
        opcode = 2
    
    Encode_cmd = (opcode*(2**26)) + (rs*(2**21)) + (rt*(2**16)) + imm
    
    return Encode_cmd
    
def BUS_Type_Encode(cmd):
    
    imm = 0
    rd = 0
    Per_Addr = 0
    
    function = ''
    # copy #
    # -- / Calculating function \ --#
    x = 0
    while(cmd[x] != ' '):
        function += cmd[x]
        x = x + 1
    # -- / Calculating function \ --#
    # copy #
    
    x = x + 1
    while(cmd[x] != ','):
        Per_Addr += int(cmd[x])
        Per_Addr *= 10
        x += 1
    Per_Addr /= 10
    Per_Addr = int(Per_Addr)
    
    if (function == 'PERBUSW'):
        opcode = 56
        x += 1
        for i in range(x,len(cmd)):
            if(cmd[i] == '\n'):
                break
            imm += int(cmd[i])
            imm *= 10
        imm = int(imm/10)
        
        Encode_cmd = imm
        
    elif(function == 'PERBUSR'):
        opcode = 57
        x += 2
        for i in range(x,len(cmd)):
            if (cmd[i] == '\n'):
                break
            rd += int(cmd[i])
            rd *= 10
        rd = int(rd/10)
        
        Encode_cmd = rd
        
    Encode_cmd += (opcode*(2**26)) + (Per_Addr*(2**16))
    
    return Encode_cmd
    
    
main()
