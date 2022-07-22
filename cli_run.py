import argparse
from textwrap import dedent
from subprocess import Popen

less_spacing = lambda prog: argparse.RawTextHelpFormatter(prog,
                  max_help_position=6)

parser = argparse.ArgumentParser(\
    formatter_class=less_spacing,
    description=dedent('''\
              Run Script Function
          =+==+==+==+==+==+==+==+==+=
             Loads text files of
             commands to the bladeRF
             SDRs to target the array
             beam at given angle.
          ```````````````````````````
         '''))

# [-h] -ang ANGLE
# Required argument must be given or function will not run
parser._action_groups.pop()
required = parser.add_argument_group('required arguments')
required.add_argument('-agl','--angle', help="Target beam angle in degrees\n\n", type=int,required=True)

args = parser.parse_args()

# Run command starts the bladeRF with a precreated txt file of commands.
# The txt file chosen corresponds to the chosen angle.
# If no angle is selected the user will be prompted to try again.
# Set str variable angle_str to string for specific beam angle file
if args.angle:
    angle_str=str(args.angle)

print("Running bladeRF script files for "+ angle_str +" degree beam angle...\n")

# Create string for specific beam angle files
# File for leader and follower must exist in this directory
leader_file = "leader_" + angle_str + ".txt"
follower_file = "follower_" + angle_str + ".txt"

# Open leader and follower command prompts and execute bladeRF command to load selected files
# Follower SDR will wait for trigger from leader command prompt
# Command prompt opener string is specific for Microsoft OS
process1 = Popen(['start', '/wait', 'cmd', '/k', "bladeRF-cli -s " + leader_file + " -i"], shell = True)
process2 = Popen(['start', '/wait', 'cmd', '/k', "bladeRF-cli -s " + follower_file + " -i"], shell = True)
process1.wait()
process2.wait()

print("")