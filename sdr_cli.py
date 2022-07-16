from os import system

def run_sdr_command(usr_input_str: str):

    usr_input_list = usr_input_str.split(" ")
    usr_command = usr_input_list[0].lower()

    if usr_command=="run" or usr_command=="r":
    # DESCRIPTION
        arg_str = (' '.join(usr_input_list[1::]))
        system("python3 cli_run.py "+arg_str)
        pass

    elif usr_command=="interactive" or usr_command=="i":
    # DESCRIPTION
        arg_str = (' '.join(usr_input_list[1::]))
        system("python3 cli_interactive.py "+arg_str)
        pass

    elif usr_command=="probe" or usr_command=="p":
    # DESCRIPTION
        arg_str = (' '.join(usr_input_list[1::]))
        system("python3 cli_probe.py "+arg_str)
        pass

    elif usr_command=="help" or usr_command=="h":
    # Help command provides list of allowed commands and needed params
        system("python3 cli_help.py")
        pass

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
        run_sdr_command(input("controller@bladeRF:~$ "))

if __name__ == '__main__':
    main()