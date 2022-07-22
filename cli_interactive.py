import argparse
from textwrap import dedent
from os import system

less_spacing = lambda prog: argparse.RawDescriptionHelpFormatter(prog,
                  max_help_position=6)

parser = argparse.ArgumentParser(\
    formatter_class=less_spacing,
    description=dedent('''\
             Interactive Function
          =+==+==+==+==+==+==+==+==+=
             Enter interactive
             mode on bladeRF SDR.
          ---------------------------
         '''))

parser._action_groups.pop()
help = parser.add_argument_group('help')
help.add_argument("-hld", "--holder", help=argparse.SUPPRESS)

args = parser.parse_args()

print("Entering Interactive Mode...\n")
system("bladeRF-cli -i")
print("")