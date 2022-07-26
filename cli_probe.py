import argparse
from textwrap import dedent
from os import system

less_spacing = lambda prog: argparse.RawTextHelpFormatter(prog,
                  max_help_position=6)

def usage_msg(name=None):                                                            
    return '''ls [-h]'''

parser = argparse.ArgumentParser(\
    formatter_class=less_spacing,
    description=dedent('''\
              Probe Function
          =+==+==+==+==+==+==+==+=
             Probe for devices,
             print results,
             then exit.
          ------------------------
         '''), usage=usage_msg())

parser._action_groups.pop()
help = parser.add_argument_group('help')
help.add_argument("-hld", "--holder", help=argparse.SUPPRESS)

args = parser.parse_args()

print("Probing for bladeRF devices...\n")
system("bladeRF-cli -p")
print("")