#!/bin/bash
# --------------------------------
# Sal's Random Password Generator
# --------------------------------
# It does what it says.
# --------------------------------
# Copyright (c) 2015, Salvatore LaMendola <salvatore@lamendola.me>
# All rights reserved.

case "$1" in
  -s|--symbols)
      export SYMBOLS="1" PHPMA="0" WORDPRESS="0" YUBIKEY="0"
  ;;
  -a|--alphanumeric)
      export SYMBOLS="0" PHPMA="0" WORDPRESS="0" YUBIKEY="0"
  ;;
  -p|--phpmyadmin)
      export PHPMA="1" WORDPRESS="0" YUBIKEY="0"
  ;;
  -w|--wordpress)
      export WORDPRESS="1" PHPMA="0" YUBIKEY="0"
  ;;
  -y|--yubikey)
      export YUBIKEY="1" PHPMA="0" WORDPRESS="0"
  ;;
  -h|--help|*)
      echo $"Usage: "$0" <OPTIONS> [length] [number] (length and number optional)"
      echo $""
      echo $"OPTIONS (MUST SPECIFY ONE!):"
      echo $"--symbols (-s)               Add symbols to output (NOT FOR MYSQL!)"
      echo $"--alphanumeric (-a)          Alphanumeric only"
      echo $"--phpmyadmin (-p)            Generate phpMyAdmin Blowfish secret (for cookie auth)"
      echo $"--wordpress (-w)             Generate Wordpress encryption keys (wp-config.php)"
      echo $"--yubikey (-y)               Generate Public/Private/Secret keys for Yubikey OTP"
      echo $"--help (-h)                  Display this usage information"
      echo $""
      echo $"If no length or number are defined, a default length of 19 and number of 1 will be used."
      exit 0
  ;;
esac

# If length argument was specified, override the default
if [ -z "$2" ]; then
     export LEN="19"
else
     export LEN="$2"
fi

# If number argument was specified, override the default
if [ -z "$3" ]; then
     export NUM="1"
else
     export NUM="$3"
fi

# Function to do most of the dirty work
pwgenerator () {
    case "$2" in
        symbols)
            gtr -dc 'a-zA-Z0-9-_!@#$%^&*/\()_+{}|:<>?=' < /dev/urandom | fold -w $1 | head -n $3
        ;;
        alphanumeric)
            gtr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w $1 | head -n $3
        ;;
        hex)
            gtr -dc 'a-f0-9' < /dev/urandom | fold -w $1 | head -n $3
        ;;
        *)
            echo "ERROR: Empty/incorrect password type was specified."
            exit 1
        ;;
    esac
}

if [ "$PHPMA" == "1" ]; then
    pwgenerator 64 symbols 1
    exit 0
elif [ "$WORDPRESS" == "1" ]; then
    echo "define('AUTH_KEY',         '$(pwgenerator 64 symbols 1)');"
    echo "define('SECURE_AUTH_KEY',  '$(pwgenerator 64 symbols 1)');"
    echo "define('LOGGED_IN_KEY',    '$(pwgenerator 64 symbols 1)');"
    echo "define('NONCE_KEY',        '$(pwgenerator 64 symbols 1)');"
    echo "define('AUTH_SALT',        '$(pwgenerator 64 symbols 1)');"
    echo "define('SECURE_AUTH_SALT', '$(pwgenerator 64 symbols 1)');"
    echo "define('LOGGED_IN_SALT',   '$(pwgenerator 64 symbols 1)');"
    echo "define('NONCE_SALT',       '$(pwgenerator 64 symbols 1)');"
    exit 0
elif [ "$YUBIKEY" == "1" ]; then
    # Comment the following three lines and uncomment the "OTP AES Key" line
    # to modify this for static key generation (OTP Mode).
    echo "Public Identity: vv$(pwgenerator 10 hex 1 | tr "[0123456789abcdef]" "[cbdefghijklnrtuv]")"
    echo "Private Identity: $(pwgenerator 12 hex 1)"
    echo "Secret Key: $(pwgenerator 32 hex 1)"
    #echo "OTP AES Key: $(pwgenerator 40 hex 1)"
elif [ "$SYMBOLS" == "1" ]; then
    pwgenerator $LEN symbols $NUM
else
    pwgenerator $LEN alphanumeric $NUM
fi

exit 0
