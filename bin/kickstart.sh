#!/bin/bash

##  Private ##########################

# Colors
RED="\033[0;31m"
YELLOW="\033[0;33m"
GREEN="\033[0;32m"
DEFAULT="\033[0m"

# Fails the script
fail ()
{
  echo
  echo -e $RED"Kickstarting Failed!"$DEFAULT
  exit 1
}

# Runs a command, swallows any output, and prints out any error messaging.
run_command ()
{
  if ERROR=$( $1 2>&1 ); then
    : # do nothing
  else
    echo "$ERROR"
    fail
  fi
}

please_install ()
{
  echo ""
  echo "==========================================================================================="
  echo ""
  echo "Please follow the instructions for installing $1 $2 at $3"
  echo ""
  echo "==========================================================================================="
  echo ""  
}

######################################

#################
# Node
#################
echo -e $GREEN"==>$DEFAULT Checking for NodeJS..."
if which node > /dev/null; then
  : # do nothing
else
  please_install NodeJS 0.6.16+ http://nodejs.org/#download
  fail
fi

#################
# NPM
#################
echo -e $GREEN"==>$DEFAULT Checking for NPM..."
if which npm > /dev/null; then
  : # do nothing
else
  please_install NPM 1.1+ http://npmjs.org/doc/README.html
  fail
fi

#################
# Dependencies
#################
echo -e $GREEN"==>$DEFAULT Installing dependencies... (this may take awhile)"
echo "      Installing NPM dependencies..."
run_command "npm install"
echo "      Installing Git submodules..."
run_command "git submodule update --init"

#################
# Tests - This should always be the last step!
#################
echo -e $GREEN"==>$DEFAULT Testing environment creation... (this may take awhile)"
echo
if node_modules/grunt/bin/grunt; then
  : # do nothing
else
  fail
fi



#################
# All done!
#################
echo ""
echo ""
echo "== Kickstarting completed successfully! ================="

if which grunt > /dev/null; then
  : # do nothing
else
  echo -e $YELLOW
  echo "  You might want to install Grunt globally."
  echo "  It will make running tests and building the library a lot easier."
  echo ""
  echo "  You can do this by running the following:"
  echo -e $DEFAULT
  echo "      npm install -g grunt"
  echo -e $YELLOW
  echo "  If you choose not to globally install Grunt, then the following grunt"
  echo "  commands should be replaced with:"
  echo -e $DEFAULT
  echo "      node_modules/grunt/bin/grunt"
fi
echo -e $YELLOW
echo -e "  To run tests:"$DEFAULT" grunt jasmine"
echo -e $YELLOW"  To run the build script:"$DEFAULT" grunt"
echo -e $YELLOW
echo "  For more information, refer to the Grunt documentation"
echo -e $DEFAULT
echo "      http://gruntjs.com"
echo ""