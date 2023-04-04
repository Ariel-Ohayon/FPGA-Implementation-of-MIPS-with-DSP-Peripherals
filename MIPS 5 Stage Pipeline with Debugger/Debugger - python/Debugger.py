from colorama import Fore, Back, Style
import time
import os.path
import serial.tools.list_ports
import threading
from PyQt5.QtWidgets import *
from PyQt5 import uic

class GUI(QMainWindow):

    def __init__(self):
        
        port = serport()
        if(port == None):
            print(Fore.RED + 'Error')
            print('You have to exit from the software and connect COM port')
            print(Style.RESET_ALL)
            
        super(GUI, self).__init__()
        uic.loadUi('gui_design.ui',self)
        self.show()
        
        self.pushButton_clock.clicked.connect(lambda: self.sendclk(port))
        self.pushButton_I_Memory_Program.clicked.connect(lambda: self.program_Instructions(port,self.LineEdit_File_Directory.text()))
        self.pushButton_I_Memory_Read.clicked.connect(lambda: self.Read_I_Memory(port))
        self.pushButton_Reset.clicked.connect(lambda: self.Reset(port))
        self.pushButton_Run.clicked.connect(lambda: self.Run(port))
        self.pushButton_Stop.clicked.connect(lambda: self.Stop())
        self.pushButton_Read_Reg.clicked.connect(lambda: self.Read_Reg(port,self.lineEdit_Reg_number.text()))
        self.pushButton_Read_All_Registers.clicked.connect(lambda:self.Read_All_Reg(port))
        self.actionClose.triggered.connect(exit)
        
    def thread_read_serial(self,port):
        self.byte0 = port.read()
        self.byte1 = port.read()
        self.byte2 = port.read()
        self.byte3 = port.read()
    
    def function_Read_Reg(self,port,reg_num):
        print(f'Read data from register number: {reg_num}')
        num = int(reg_num)
        
        self.thread = threading.Thread(target = self.thread_read_serial, args = (port,))
        self.thread.start()
        
        while(self.thread.is_alive()):
            port.write(b'R')    # 0x52
            port.write(b'E')    # 0x45
            port.write(b'G')    # 0x47
            port.write(num.to_bytes(1,'big'))
            time.sleep(0.01)
        
        port.write(b'0')
        port.write(b'0')
        port.write(b'0')
        port.write(b'0')
        
        self.byte0 = int.from_bytes(self.byte0,'big')
        self.byte1 = int.from_bytes(self.byte1,'big')
        self.byte2 = int.from_bytes(self.byte2,'big')
        self.byte3 = int.from_bytes(self.byte3,'big')
        
        data = self.byte0 + (self.byte1 * (2**8)) + (self.byte2 * (2**16)) + (self.byte3 * (2**24))
        
        if(num == 1):
            self.Label_Reg1.setText(f'Register 1: {data}')
        elif(num == 2):
            self.Label_Reg2.setText(f'Register 2: {data}')
        elif(num == 3):
            self.Label_Reg3.setText(f'Register 3: {data}')
        elif(num == 4):
            self.Label_Reg4.setText(f'Register 4: {data}')
        elif(num == 5):
            self.Label_Reg5.setText(f'Register 5: {data}')
        elif(num == 6):
            self.Label_Reg6.setText(f'Register 6: {data}')
        elif(num == 7):
            self.Label_Reg7.setText(f'Register 7: {data}')
        elif(num == 8):
            self.Label_Reg8.setText(f'Register 8: {data}')
        elif(num == 9):
            self.Label_Reg9.setText(f'Register 9: {data}')
        elif(num == 10):
            self.Label_Reg10.setText(f'Register 10: {data}')
        elif(num == 11):
            self.Label_Reg11.setText(f'Register 11: {data}')
        elif(num == 12):
            self.Label_Reg12.setText(f'Register 12: {data}')
        elif(num == 13):
            self.Label_Reg13.setText(f'Register 13: {data}')
        elif(num == 14):
            self.Label_Reg14.setText(f'Register 14: {data}')
        elif(num == 15):
            self.Label_Reg15.setText(f'Register 15: {data}')
        elif(num == 16):
            self.Label_Reg16.setText(f'Register 16: {data}')
        elif(num == 17):
            self.Label_Reg17.setText(f'Register 17: {data}')
        elif(num == 18):
            self.Label_Reg18.setText(f'Register 18: {data}')
        elif(num == 19):
            self.Label_Reg19.setText(f'Register 19: {data}')
        elif(num == 20):
            self.Label_Reg20.setText(f'Register 20: {data}')
        elif(num == 21):
            self.Label_Reg21.setText(f'Register 21: {data}')
        elif(num == 22):
            self.Label_Reg22.setText(f'Register 22: {data}')
        elif(num == 23):
            self.Label_Reg23.setText(f'Register 23: {data}')
        elif(num == 24):
            self.Label_Reg24.setText(f'Register 24: {data}')
        elif(num == 25):
            self.Label_Reg25.setText(f'Register 25: {data}')
        elif(num == 26):
            self.Label_Reg26.setText(f'Register 26: {data}')
        elif(num == 27):
            self.Label_Reg27.setText(f'Register 27: {data}')
        elif(num == 28):
            self.Label_Reg28.setText(f'Register 28: {data}')
        elif(num == 29):
            self.Label_Reg29.setText(f'Register 29: {data}')
        elif(num == 30):
            self.Label_Reg30.setText(f'Register 30: {data}')
        elif(num == 31):
            self.Label_Reg31.setText(f'Register 31: {data}')
        
        print(f'Register {num} = {data}')
    
    def Read_Reg(self,port,reg_num):
        self.function_Read_Reg(port,reg_num)
    
    def Read_All_Reg(self,port):
        for i in range(1,32):
            self.function_Read_Reg(port,str(i))
        print('Update all registers data in the GUI')
    
    def Stop(self):
        print('Stop')
        self.stop_thread = True
        

    def Run (self,port):
        print('The CPU run with constant frequency clock')
        self.stop_thread = False
        self.thread = threading.Thread(target = self.clockcycles, args = (port,lambda:self.stop_thread))
        self.thread.start()
    
    def clockcycles(self,port,flag):
        while(True):
            port.write(b'c')    # 0x63 = 01100011
            port.write(b'c')    # 0x63 = 01100011
            port.write(b'l')    # 0x6C = 01101100
            port.write(b'k')    # 0x6B = 01101011
            time.sleep(0.1)
            port.write(b'0')    # c - cmd (command)
            port.write(b'0')    # send clk (clock)
            port.write(b'0')
            port.write(b'0')
            time.sleep(0.1)
            if flag():
                break
        
    def Reset(self,port):
        port.write(b'R')
        port.write(b'S')
        port.write(b'T')
        port.write(b'1')
        time.sleep(0.5)
        port.write(b'0')
        port.write(b'0')
        port.write(b'0')
        port.write(b'0')
        print('Reset operation accomplished')
        
    def Read_I_Memory(self,port):   # use here threads to read from COM port
    
        self.thread = threading.Thread(target = self.thread_read_serial, args = (port,))
        self.thread.start()
        
        if(self.thread.is_alive()):
            print('Enter Read Instruction Memory mode')
            port.write(b'I')    # 0x49
            port.write(b'M')    # 0x4D
            port.write(b'R')    # 0x52
            port.write(b'E')    # 0x45
            time.sleep(0.1)
        
        self.byte0 = int.from_bytes(self.byte0,'big')
        self.byte1 = int.from_bytes(self.byte1,'big')
        self.byte2 = int.from_bytes(self.byte2,'big')
        self.byte3 = int.from_bytes(self.byte3,'big')
        
        port.write(b'0')
        port.write(b'0')
        port.write(b'0')
        port.write(b'0')
        
        data = self.byte0 + (self.byte1 * (2**8)) + (self.byte2 * (2**16)) + (self.byte3 * (2**24))
        
        print(f'the data in this specific cell: {data}')
        self.label_Value_from_I_Memory.setText(f'{hex(data)}')
    
    def sendclk(self,port):
        print('Send Pulse')
        port.write(b'c')    # 0x63 = 01100011
        port.write(b'c')    # 0x63 = 01100011
        port.write(b'l')    # 0x6C = 01101100
        port.write(b'k')    # 0x6B = 01101011
        time.sleep(0.5)
        port.write(b'0')    # c - cmd (command)
        port.write(b'0')    # send clk (clock)
        port.write(b'0')
        port.write(b'0')
        
    def program_Instructions(self,port,directory):
        
        print('check if file is exist')
        print(directory)
        exist = os.path.exists(directory)
        print(exist)
        if(exist == False):
            print(Fore.RED + 'File does not exist.')
            print(Style.RESET_ALL)
            return None
        
            
        print('Enter to Program Instruction mode')
        print('Now the software will burn commands in the instruction memory')
        
        #   send En to IM (Instruction Memory) - it will enable the programming function
        print('Enabling the Instruction Memory:')
        port.write(b'I')    #   0x49
        port.write(b'M')    #   0x4d
        port.write(b'E')    #   0x45
        port.write(b'0')    #   0x30
        
        print(b'I')
        print(b'M')
        print(b'E')
        print(b'0')
        time.sleep(0.2)
        
        print('Program Memory Enabled for burn software')
        
        print(f'Read from the encoded file: {directory}')
        
        # -- add check if file exists -- #
        encode_file = open(directory,'r')
        for index,line in enumerate(encode_file):
            line = line.replace('\n','')
            print(f'index = {index}: line = {line}')
            line_list = line.split(':')
            print(f'line_list = {line_list}')
            address = line_list[0]
            instruction = line_list[1]
            instruction_list = instruction.split('|')
            
            hex_instruction = instruction_list[0]
            dec_instruction = instruction_list[1]
            print(f'address = {address}, hex_instruction = {hex_instruction}, dec_instruction = {dec_instruction}')
            
            num_address = int(address)
            num_instruction = int(dec_instruction)
            
            print(f'num_address = {num_address}, num_instruction = {num_instruction}')
            
            # write address to the core
            print('write the address of the current cell in instruction memory')
            port.write(num_address.to_bytes(1,'big'))
            port.write(b'\x00')
            port.write(b'\x00')
            port.write(b'\x00')
            
            print(num_address.to_bytes(1,'big'))
            print(b'\x00')
            print(b'\x00')
            print(b'\x00')
            time.sleep(0.2)
            
            mask_byte0 = 0x000000FF
            mask_byte1 = 0x0000FF00
            mask_byte2 = 0x00FF0000
            mask_byte3 = 0xFF000000
            
            byte0 = num_instruction & mask_byte0
            byte1 = (num_instruction & mask_byte1) >> 8
            byte2 = (num_instruction & mask_byte2) >> 16
            byte3 = (num_instruction & mask_byte3) >> 24
            
            # write data to the core
            print('Write the data to prog the cell')
            port.write(byte0.to_bytes(1,'big'))
            port.write(byte1.to_bytes(1,'big'))
            port.write(byte2.to_bytes(1,'big'))
            port.write(byte3.to_bytes(1,'big'))
            
            print(byte0.to_bytes(1,'big'))
            print(byte1.to_bytes(1,'big'))
            print(byte2.to_bytes(1,'big'))
            print(byte3.to_bytes(1,'big'))
            time.sleep(0.2)
            
            # clk pulse:
            print('Send Pulse')
            port.write(b'c')    # 0x63 = 01100011
            port.write(b'c')    # 0x63 = 01100011
            port.write(b'l')    # 0x6C = 01101100
            port.write(b'k')    # 0x6B = 01101011
            
            port.write(b'0')    # c - cmd (command)
            port.write(b'0')    # send clk (clock)
            port.write(b'0')
            port.write(b'0')
            time.sleep(0.2)
            
        # Exit from programming mode (Disable the progmode)
        port.write(b'I')    # 0x49
        port.write(b'M')    # 0x4d
        port.write(b'E')    # 0x45
        port.write(b'1')    # 0x31
        
        print(b'I')
        print(b'M')
        print(b'E')
        print(b'1')
        time.sleep(0.2)
        
        print('Finish program the Instruction Memory.')


def main():
    
    app = QApplication([])
    window = GUI()
    app.exec_()
    pass

def serport():
        # -- Initialize Serial Ports -- #
    ports = serial.tools.list_ports.comports()
    serialInst = serial.Serial()
    
    portlist = []
    for onePort in ports:
        portlist.append(str(onePort))
    if (portlist == []):
        print('COM PORTs not Found')
        return None
    else:
        print('List of the COM Ports:')
        for onePort in ports:
            print(str(onePort))
        # -- Serial Port Detection -- #
        
        
        # -- Connect to serial Port -- #
        COM = input('Enter The COM Port you want to connect: ')
        print(f"connect to COM Port: {COM}")
        Connection = serial.Serial(COM,115200)
        Connection.baudrate = 115200
        Connection.parity = 'N'
        Connection.bytesize = 8
        Connection.stopbits = 1
        return Connection


if __name__ == '__main__':
    main()
    
