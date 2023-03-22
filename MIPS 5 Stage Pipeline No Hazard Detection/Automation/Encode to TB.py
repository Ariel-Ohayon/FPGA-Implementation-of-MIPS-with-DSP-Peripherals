def main():
    readfilename = input('Enter file name: ')
    readfile = open(readfilename,'r')
    write_file = open('output file.v','w')
    for index,line in enumerate(readfile):
        line = line.replace('\n','').replace('|',' ').replace(':',' ')
        line_list = line.split()
        addr = line_list[0]
        data = line_list[2]
        print(f'addr: {addr} | data: {data}')
        write_file.write(f"\t\tT_Addr_Prog = 8'd{addr};\n\t\tT_Data_Prog = 32'd{data};\n\t\t#20;\n")
        
        
    readfile.close()
    write_file.close()
    
main()