from os import system

def run_sdr_command(usr_input_str: str):

    usr_input_list = usr_input_str.split(" ")
    usr_command = usr_input_list[0].lower()

    if usr_command=="run" or usr_command=="r":
        # Run command starts the bladeRF with a precreated txt file of commands.
        # The txt file chosen corresponds to the chosen angle.
        # Target angle must be one of these [-20,-10,0,10,20]
        # If no angle is selected the user will be prompted to try again.
        angle=int(usr_input_list[1])
        if angle == -20:
            system("bladeRF-cli -s signal_ntwenty.txt -i")
            pass
        elif angle == -10:
            system("bladeRF-cli -s signal_nten.txt -i")
            pass
        elif angle == 0:
            system("bladeRF-cli -s signal_zero.txt -i")
            pass
        elif angle == 10:
            system("bladeRF-cli -s signal_ten.txt -i")
            pass
        elif angle == 20:
            system("bladeRF-cli -s signal_twenty.txt -i")
            pass
        else: return "ERR: Target angle is not in set. \nTry again with one of the following angles: [-20,-10,0,10,20]"
    
    elif usr_command=="interactive" or usr_command=="i":
        print("Entering Interactive Mode...")
        system("bladeRF-cli -i")

    elif usr_command=="probe" or usr_command=="p":
        system("bladeRF-cli -p")

    elif usr_command=="quit" or usr_command=="q":
    # Quit command to allow user to kill program within command line structure.
    # Check Y/N to make sure user is prepared to exit.
    # If check fails, return to while loop.
        confirm=input("Quit? [Y/N] ").lower()
        if confirm=="y":
            quit()
            return "ERR: Quit failed!"
        elif confirm=="n":
            pass
        else: return "Incorrect input. Returning..."

    else: return "ERR: Command not recognised."


def main():
    print("Welcome to the SDR Controller... ")
    while True:
        rtrn_str = run_sdr_command(input("controller@bladeRF:~$ "))
        print(rtrn_str)

if __name__ == '__main__':
    main()