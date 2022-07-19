import argparse
import sys

less_spacing = lambda prog: argparse.RawTextHelpFormatter(prog,
                  max_help_position=6)

parser = argparse.ArgumentParser(\
    formatter_class=less_spacing,
    usage=argparse.SUPPRESS)

parser._action_groups.pop()
commands = parser.add_argument_group('Commands')
commands.add_argument("r", help="Command to run script files for given beam angle")
commands.add_argument("i", help="Command to enter interactive mode")
commands.add_argument("p", help="Command to probe for devices")
commands.add_argument("q", help="Command to quit the program")

if len(sys.argv)==1:
    parser.print_help(sys.stderr)
    sys.exit(1)

args = parser.parse_args()