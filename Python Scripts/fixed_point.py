from colorama import Fore, Back, Style

def main():
    
    while(True):
        number = None
        while(number == None ):
            number = input('Enter fixed point number: ')
            if(number == ''):
                number = None
                print('Enter value again.')
            else:
                number = float(number)
        if(number == 0):
            break
        
        bits = None
        while(bits == None):
            bits = input('Enter number of bits: ')
            if(bits == ''):
                bits = None
                print('Enter value again.')
            else:
                bits = int(bits)
        
        fraction = None
        while(fraction == None):
            fraction = input('Enter number of fraction bits: ')
            if(fraction == ''):
                fraction = None
                print('Enter value again.')
            else:
                fraction = int(fraction)
        
        value = int(number * (2**(bits-fraction)))
        
        print(f'The number is: {number}')
        print(f'number of bits: {bits}')
        print(f'number of fraction bits: {fraction}\n')
        
        print(Fore.GREEN + ' / --- Results --- \ ')
        print(Style.RESET_ALL)
        
        print(f'fixed point value in hexadecimal: {hex(value)}')
        print(f'fixed point value in binary: {bin(value)}')
        print(f'fixed point value in decimal: {value}\n')
        
        
        print(Fore.RED + 'Enter 0 to exit')
        print(Style.RESET_ALL)
    
if __name__ == '__main__':
    main()