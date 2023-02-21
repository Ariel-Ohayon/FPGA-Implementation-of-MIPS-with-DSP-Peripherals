# pip install openpyxl
import numpy as np
import pandas as pd

def main():
    filename = input('Enter file name: ')
    SheetNames = pd.ExcelFile(filename).sheet_names
    
    print(SheetNames)
    SheetChoose = input('Choose Sheet Name: ')
    
    x = pd.read_excel(filename,sheet_name = SheetChoose)
    
    ReadyFileContent(x,TopModuleName = SheetChoose)
    
    #print(y)
    
    
def ReadyFileContent(x,TopModuleName):
    f = open(TopModuleName + '.vhd','w')
    module_key = pd.DataFrame(x,columns = ['Modules'])
    signal_key = pd.DataFrame(x,columns = ['Signals'])
    Internal_Input_Port_key = pd.DataFrame(x,columns = ['Internal Input Port'])
    Internal_Output_Port_key = pd.DataFrame(x,columns =['Internal_Output_Port'])
    i = 0
    j = 0
    while(module_key.iloc[i,0] != 0):
        f.write(f'component {module_key.iloc[i,0]}')
        f.write('\n')
        f.write('\tport(\n')
        # enter here code for print ports to the file
        while(Internal_Input_Port_key.iloc[j,0] != 0):
            f.write(f'\t\t\t{Internal_Input_Port_key.iloc[j,0]}: in std_logic;\n')
            j = j + 1
        for i in range(len(Internal_Output_Port_key)):
            f.write(f'\t\t\t{Internal_Output_Port_key.loc[i,0]}: out std_logic;\n')
        # enter here code for print ports to the file
        f.write(');\n')
        f.write('end component;\n')
        i=i+1
    
    f.close()

main()
