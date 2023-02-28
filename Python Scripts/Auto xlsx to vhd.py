# pip install openpyxl
import math
import numpy as np
import pandas as pd
import os

def main():
    
    os.system('cls')
    print('Files in directory:\n')
    os.system('dir/b')
    print('\n')
    filename = input('Enter file name: ')
    SheetNames = pd.ExcelFile(filename).sheet_names
    
    print(SheetNames)
    SheetChoose = input('Choose Sheet Name: ')
    
    File_Excel = pd.read_excel(filename,sheet_name = SheetChoose)
    
    df_TopModuleName = pd.DataFrame(File_Excel,columns = ['TopModule']);
    df_TopModuleName = df_TopModuleName.dropna()
    
    df_TopModulePort = pd.DataFrame(File_Excel,columns = ['Ports'])
    df_TopModuleBits = pd.DataFrame(File_Excel,columns = ['Bits'])
    df_TopModuleDirct = pd.DataFrame(File_Excel,columns = ['Direct'])
    
    df_TopModulePort = df_TopModulePort.dropna()
    df_TopModuleBits = df_TopModuleBits.dropna()
    df_TopModuleDirct = df_TopModuleDirct.dropna()
    
    f = open(df_TopModuleName.iloc[0,0] + '.vhd','w')
    f.write('library ieee;\nuse ieee.std_logic_1164.all;\n\n')
    
    f.write(f'entity {df_TopModuleName.iloc[0,0]} is\n')
    f.write('port(\n')
    for i in df_TopModulePort.index:
        f.write(f'\t{df_TopModulePort.iloc[i,0]}:')
        f.write(f'\t{df_TopModuleDirct.iloc[i,0]}')
        if (df_TopModuleBits.iloc[i,0] == 1):
            f.write(f'\tstd_logic')
            if (i == df_TopModulePort.shape[0]-1):
                f.write(');\n')
            else:
                f.write(';\n')
        else:
            f.write(f'\tstd_logic_vector({int(df_TopModuleBits.iloc[i,0])-1} downto 0)')
            if (i == df_TopModulePort.shape[0]-1):
                f.write(');\n')
            else:
                f.write(';\n')
    
    f.write('end;\n\n')
    
    f.write(f'architecture one of {df_TopModuleName.iloc[0,0]} is\n\n')
    f.write('\t-- / Components \ --\n')
    
    df_SubModules = pd.DataFrame(File_Excel,columns = ['SubModule'])
    df_SubModules = df_SubModules.dropna()
    df_SubModules_rst_index = df_SubModules.reset_index(drop=True)
    
    indexes_num = df_SubModules.index.to_numpy()
    df_SubModules_Ports = pd.DataFrame(File_Excel,columns = ['Ports.1'])
    df_SubModules_Ports = df_SubModules_Ports.dropna()
    port_index = df_SubModules_Ports.index.to_numpy()
    val = port_index[len(port_index)-1]+1
    indexes_num = np.insert(indexes_num,len(indexes_num),val)
    
    
    df_SubModules_Bits = pd.DataFrame(File_Excel,columns = ['Bits.1'])
    df_SubModule_Dir = pd.DataFrame(File_Excel,columns = ['Direct.1'])
    df_SubModule_Dir = df_SubModule_Dir.dropna()
    df_SubModules_Bits = df_SubModules_Bits.dropna()
    
    start = 0
    for i in df_SubModules_rst_index.index:
        f.write(f'\tcomponent {df_SubModules_rst_index.iloc[i,0]}\n') # Enter name of component
        f.write('\tport(\n')
        end = indexes_num[i+1]
        for j in range(start,end):
            start = start + 1
            f.write(f'\t\t{df_SubModules_Ports.iloc[j,0]}:')
            f.write(f'\t{df_SubModule_Dir.iloc[j,0]}')
            if (df_SubModules_Bits.iloc[j,0] == 1):
                f.write('\tstd_logic')
                if (j == end-1):
                    f.write(');\n')
                else:
                    f.write(';\n')
            else:
                f.write(f'\tstd_logic_vector({int(df_SubModules_Bits.iloc[j,0])-1} downto 0)')
                if (j == end-1):
                    f.write(');\n')
                else:
                    f.write(';\n')
        f.write('\tend component;\n')
        
    f.write('\t-- / Components \ --\n\n')
    f.write('\t-- / Signals\ --\n')
    
    df_Signals = pd.DataFrame(File_Excel,columns = ['Signals'])
    df_Signals_Bits = pd.DataFrame(File_Excel,columns = ['Bits.2'])
    df_Signals = df_Signals.dropna()
    df_Signals_Bits = df_Signals_Bits.dropna()
    
    for i in df_Signals.index:
        f.write(f'\tsignal {df_Signals.iloc[i,0]}:')
        if(df_Signals_Bits.iloc[i,0] == 1):
            f.write('\tstd_logic;\n')
        else:
            f.write(f'\tstd_logic_vector({int(df_Signals_Bits.iloc[i,0])-1} downto 0);\n')
    f.write('\t-- / Signals \ --\n\n')
    f.write('begin\n')
    
    #df_SubModules_rst_index = df_SubModules.reset_index(drop=True)
    df_Modules = pd.DataFrame(File_Excel,columns = ['Modules']).dropna()
    df_Modules_rst_index = df_Modules.reset_index(drop=True)
    df_Internal = pd.DataFrame(File_Excel,columns = ['Internal Port']).dropna()
    df_External = pd.DataFrame(File_Excel,columns = ['External Signal']).dropna()
    
    start = 0
    indexes_num = df_Modules.index.to_numpy()
    Internal_index = df_Internal.index
    val = Internal_index[len(Internal_index)-1]+1
    indexes_num = np.insert(indexes_num,len(indexes_num),val)
    
    for i in df_Modules_rst_index.index:
        f.write(f'\tU{i+1}: {df_Modules_rst_index.iloc[i,0]} port map(\n')
        end = indexes_num[i+1]
        #add Connections
        for j in range(start,end):
            f.write(f'\t\t\t{df_Internal.iloc[j,0]}\t=>\t{df_External.iloc[j,0]}')
            start = start+1
            if (j == end-1):
                f.write(');\n')
            else:
                f.write(',\n')
        f.write('\n')

    df_Source_Signal = pd.DataFrame(File_Excel,columns = ['Source_Signal']).dropna()
    df_Destin_Signal = pd.DataFrame(File_Excel,columns = ['Destination_Signal']).dropna()
    
    for i in df_Source_Signal.index:
        f.write(f'\t{df_Destin_Signal.iloc[i,0]} <= {df_Source_Signal.iloc[i,0]};\n')
    
    f.write('end;\n\n')
    
    wa = input('Do you want that I will write you the architecture of the Sub Modules?[y/n] ') # wa = write architecture
    
    if (wa == 'y'):
        #End of Program#
        indexes_num = df_SubModules.index.to_numpy()
        df_SubModules_Ports = pd.DataFrame(File_Excel,columns = ['Ports.1'])
        df_SubModules_Ports = df_SubModules_Ports.dropna()
        port_index = df_SubModules_Ports.index.to_numpy()
        val = port_index[len(port_index)-1]+1
        indexes_num = np.insert(indexes_num,len(indexes_num),val)
    
        start = 0
        for i in df_SubModules_rst_index.index:
            f.write(f'-- SubModule: {df_SubModules_rst_index.iloc[i,0]} --\n\n')
            f.write('library ieee;\n')
            f.write('use ieee.std_logic_1164.all;\n\n')
            f.write(f'entity {df_SubModules_rst_index.iloc[i,0]} is\n') # Enter name of component
            f.write('port(\n')
            end = indexes_num[i+1]
            for j in range(start,end):
                start = start + 1
                f.write(f'\t{df_SubModules_Ports.iloc[j,0]}:')
                f.write(f'{df_SubModule_Dir.iloc[j,0]}')
                if (df_SubModules_Bits.iloc[j,0] == 1):
                    f.write('\tstd_logic')
                    if (j == end-1):
                        f.write(');\n')
                    else:
                        f.write(';\n')
                else:
                    f.write(f'\tstd_logic_vector({int(df_SubModules_Bits.iloc[j,0])-1} downto 0)')
                    if (j == end-1):
                        f.write(');\n')
                    else:
                        f.write(';\n')
            f.write('end;\n\n')
        
            f.write(f'architecture one of {df_SubModules_rst_index.iloc[i,0]} is\n')
            f.write('begin\n\n')
            f.write('end;\n\n')
        #End of Program#
    
    f.close()
    
    print(f'The File "{df_TopModuleName.iloc[0,0]}.vhd" Generated')
    
    input('Enter any Button to exit... ')
main()
