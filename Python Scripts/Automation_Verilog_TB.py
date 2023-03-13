def main():
	
    filename = input('Enter file name of the output file: ')
    module_name = filename.split('.')[0]
    
    Readfilename = input('Enter the file name of the encode data: ')
    
    WriteFile = open(filename,'w')
    
    WriteFile.write('`timescale 1ns/1ns\n')
    WriteFile.write(f'module {module_name};\n')

    WriteFile.write("\tinteger i;\n")
	
    WriteFile.write('\treg\t\t\tT_clk;\n')
    WriteFile.write('\treg\t\t\tT_reset;\n')
    WriteFile.write('\treg\t\t\tT_ProgMode;\n')
    WriteFile.write('\treg\t[11:0]\tT_ADDR_Prog;\n');
    WriteFile.write('\treg\t[31:0]\tT_DATA_Prog;\n');
    WriteFile.write('\treg\t\t\tT_En_Prog_Data_MEM;\n')
	
    WriteFile.write('\tMIPS_Core\tDUT (\n')
    WriteFile.write('\t\t.clk\t\t\t\t(T_clk),\n')
    WriteFile.write('\t\t.reset\t\t\t\t(T_reset),\n')
    WriteFile.write('\t\t.ProgMode\t\t\t(T_ProgMode),\n')
    WriteFile.write('\t\t.ADDR_Prog\t\t\t(T_ADDR_Prog),\n')
    WriteFile.write('\t\t.DATA_Prog\t\t\t(T_DATA_Prog),\n')
    WriteFile.write('\t\t.En_Prog_Data_MEM\t(T_En_Prog_Data_MEM));\n')
	
    WriteFile.write('\talways\n')
    WriteFile.write('\tbegin\n')
    WriteFile.write("\t\tT_clk = 1'b1;\n")
    WriteFile.write('\t\t#10;\n')
    WriteFile.write("\t\tT_clk = 1'b0;\n")
    WriteFile.write('\t\t#10;\n')
    WriteFile.write('\tend\n')
    
    WriteFile.write('\tinitial\n\tbegin\n')
    ReadFile = open(Readfilename,'r')
    WriteFile.write("\t\tT_reset = 1'b1;\n")
    WriteFile.write("\t\tT_ProgMode = 1'b0;\n")
    WriteFile.write("\t\tT_ADDR_Prog = 12'd0;\n")
    WriteFile.write("\t\tT_DATA_Prog = 32'd0;\n")
    WriteFile.write("\t\tT_En_Prog_Data_MEM = 1'b1;\n")
    WriteFile.write("\t\t#20;\n")
    WriteFile.write("\t\tT_reset = 1'b0;\n\n")
    # Add the instructions
    for LineNumber, Line in enumerate(ReadFile):
        current_Line = Line.replace(':',' ')
        Line_List = current_Line.split()
        WriteFile.write(f"\t\tT_ADDR_Prog = 12'd{Line_List[0]};\n")
        WriteFile.write(f"\t\tT_DATA_Prog = 32'h{Line_List[1].replace('x','')};\n")
        WriteFile.write("\t\t#20;\n")
    # Add the instructions
    ReadFile.close()
    
    WriteFile.write("\t\tT_reset = 1'b1;\n")
    WriteFile.write("\t\tT_ProgMode = 1'b1;\n")
    WriteFile.write("\t\t#20;\n")
    WriteFile.write("\t\tT_reset = 1'b0;\n")
    WriteFile.write("\t\t#20;\n")
    
    WriteFile.write('\tend\n')
    WriteFile.write('endmodule\n')
    WriteFile.write(f"// -- minimum: run {(LineNumber-1)*20 + 100}ns -- //")
    WriteFile.close()
main()
