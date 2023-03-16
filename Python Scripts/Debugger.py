import time
import os.path
import serial.tools.list_ports
import threading
from PyQt5.QtWidgets import *
from PyQt5 import uic

class GUI(QMainWindow):

    def __init__(self):
        
        port = serport()
        
        super(GUI, self).__init__()
        uic.loadUi('gui_design.ui',self)
        self.show()
        
        self.pushButton_clock.clicked.connect(lambda: self.sendclk(port))
        self.pushButton_I_Memory_Program.clicked.connect(lambda: self.program_Instructions(port,self.LineEdit_File_Directory.text()))
        self.pushButton_I_Memory_Read.clicked.connect(lambda: self.Read_I_Memory(port,self.lineEdit_I_Memory_Address.text()))
        
    
    def Read_I_Memory(self,port,string_address):
        print('Enter Read Instruction Memory mode')
        int_address = int(string_address)
        hex_address = hex(int_address)
        print(f'The user want to read the address: {int_address}')
        
        print('Send this address to the core')
        port.write(int_address.to_bytes(1,'big'))
        print(int_address.to_bytes(1,'big'))
        
        print('Wait for getting the data in this address')
        byte0 = int(port.read())
        byte1 = int(port.read())
        byte2 = int(port.read())
        byte3 = int(port.read())
        
        data = byte0 + (byte1 * (2**8)) + (byte2 * (2**16)) + (byte3 * (2**24))
        
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
        print('Enter to Program Instruction mode')
        print('Now the software will burn commands in the instruction memory')
        
        #   send En to IM (Instruction Memory) - it will enable the programming function
        print('Enabling the Instruction Memory:')
        port.write(b'I')    #   0x49
        port.write(b'M')    #   0x4d
        port.write(b'E')    #   0x45
        port.write(b'n')    #   0x6e
        
        print(b'I')
        print(b'M')
        print(b'E')
        print(b'n')
        time.sleep(5)
        
        print('Program Memory Enabled for burn software')
        
        print(f'Read from the encoded file: {directory}')
        
        # -- add check if file exists -- #
        encode_file = open(directory,'r')
        for index,line in enumerate(encode_file):
            line = line.replace('\n','')
            print(f'index = {index}: line = {line}')
            line_list = line.split(':')
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
            port.write(b'0')
            port.write(b'0')
            port.write(b'0')
            
            print(num_address.to_bytes(1,'big'))
            print(b'0')
            print(b'0')
            print(b'0')
            time.sleep(5)
            
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
            time.sleep(5)
            
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
            time.sleep(5)
            
        # Exit from programming mode (Disable the progmode)
        port.write(b'I')
        port.write(b'M')
        port.write(b'E')
        port.write(b'n')
        
        print(b'I')
        print(b'M')
        print(b'E')
        print(b'n')
        time.sleep(5)
        
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
        Connection = serial.Serial(COM,9600)
        Connection.baudrate = 9600
        Connection.parity = 'N'
        Connection.bytesize = 8
        Connection.stopbits = 1
        return Connection


if __name__ == '__main__':
    main()
    

