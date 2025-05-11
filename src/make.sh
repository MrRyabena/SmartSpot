# This is a simple file for transferring libraries to the Arduino environment.

# Last update: v1.1.0
#  Versions:
#    v1.1.0 — created.
#

# Уou must specify the path to the folder in the file libraries_path:

source libraries_paths.sh

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: make.sh [OPTION]"
    echo
    echo "This script transfers libraries to the specified environment."
    echo
    echo "Options:"
    echo "  --qt, -q       Transfer libraries to the Qt environment."
    echo "  --ard, -a      Transfer libraries to the Arduino environment."
    echo "  --oth, -o      Transfer libraries to other specified environments."
    echo "  --help, -h     Display this help message and exit."
    echo
    echo "You must specify the path to the folder in the file libraries_path."
    echo
    #exit 0
elif [[ "$1" == "--qt" || "$1" == "-q" ]]; then
    echo "No assembly required!"
elif [[ "$1" == "--ard" || "$1" == "-a" ]]; then
    for dir in "${ARDUINO_PATHS[@]}"; do
        rm -rf "${dir}SHS_SmartSpot"
        cp -r ./SHS_SmartSpot/ "${dir}SHS_SmartSpot/"
    done
elif [[ "$1" == "--oth" || "$1" == "-o" ]]; then
    echo "No assembly required!"
fi
