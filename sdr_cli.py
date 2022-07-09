from os import system
def run_sdr_command(usr_input_str: str):

    usr_input_list = usr_input_str.split(" ")
    usr_command = usr_input_list[0].lower()

    if usr_command=="run" or "r":
        angle=int(input("Select target angle [-20,-10,0,10,20]:"))
        if angle == -20:
            system("bladeRF-cli -s signal_ntwenty.txt -i")
        elif angle == -10:
            system("bladeRF-cli -s signal_nten.txt -i")
        elif angle == 0:
            system("bladeRF-cli -s signal_zero.txt -i")
        elif angle == 10:
            system("bladeRF-cli -s signal_ten.txt -i")
        elif angle == 20:
            system("bladeRF-cli -s signal_twenty.txt -i")
    
    elif usr_command=="interactive" or "i":
        print("Entering Interactive Mode...")
        system("bladeRF-cli -i")

    elif usr_command=="probe" or usr_command=="p":
        system("bladeRF-cli -p")



def main():
    print("Welcome to the SDR Controller... ")
    while True:
        rtrn_str = run_sdr_command(input("controller@bladeRF:~$ "))
        print(rtrn_str)

if __name__ == '__main__':
    main()