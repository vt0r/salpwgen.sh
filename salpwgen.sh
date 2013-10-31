#!/bin/bash
#-----------
# salpwgen.sh
#
# It's a password generator for Bash.
# This was originally a function to
# include in your .bashrc or wherever,
# but I think it makes more sense as a
# script when publishing it to Github.

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

if [ -z "$2" ]
then
     export LEN="19"
else
     export LEN="$2"
fi

if [ -z "$3" ]
then
     export NUM="1"
else
     export NUM="$3"
fi

if [ "$PHPMA" == "1" ]
then
     tr -dc 'a-zA-Z0-9-_!@#$%^&*/\()_+{}|:<>?=' < /dev/random | fold -w 46 | head -n 1
     exit 0
elif [ "$WORDPRESS" == "1" ]
then
     WP1=$(tr -dc 'a-zA-Z0-9-_!@#$%^&*/\()_+{}|:<>?=' < /dev/random | fold -w 64 | head -n 1)
     WP2=$(tr -dc 'a-zA-Z0-9-_!@#$%^&*/\()_+{}|:<>?=' < /dev/random | fold -w 64 | head -n 1)
     WP3=$(tr -dc 'a-zA-Z0-9-_!@#$%^&*/\()_+{}|:<>?=' < /dev/random | fold -w 64 | head -n 1)
     WP4=$(tr -dc 'a-zA-Z0-9-_!@#$%^&*/\()_+{}|:<>?=' < /dev/random | fold -w 64 | head -n 1)
     WP5=$(tr -dc 'a-zA-Z0-9-_!@#$%^&*/\()_+{}|:<>?=' < /dev/random | fold -w 64 | head -n 1)
     WP6=$(tr -dc 'a-zA-Z0-9-_!@#$%^&*/\()_+{}|:<>?=' < /dev/random | fold -w 64 | head -n 1)
     WP7=$(tr -dc 'a-zA-Z0-9-_!@#$%^&*/\()_+{}|:<>?=' < /dev/random | fold -w 64 | head -n 1)
     WP8=$(tr -dc 'a-zA-Z0-9-_!@#$%^&*/\()_+{}|:<>?=' < /dev/random | fold -w 64 | head -n 1)
     echo "define('AUTH_KEY',         '$WP1');"
     echo "define('SECURE_AUTH_KEY',  '$WP2');"
     echo "define('LOGGED_IN_KEY',    '$WP3');"
     echo "define('NONCE_KEY',        '$WP4');"
     echo "define('AUTH_SALT',        '$WP5');"
     echo "define('SECURE_AUTH_SALT', '$WP6');"
     echo "define('LOGGED_IN_SALT',   '$WP7');"
     echo "define('NONCE_SALT',       '$WP8');"
     exit 0
elif [ "$YUBIKEY" == "1" ]
then
     # Comment the following three lines and uncomment the "OTP AES Key" line
     # to modify this for static key generation (OTP Mode).
     echo "Public Identity: vv$(tr -dc 'a-f0-9' < /dev/random | fold -w 10 | head -n 1 | tr "[0123456789abcdef]" "[cbdefghijklnrtuv]")"
     echo "Private Identity: $(tr -dc 'a-f0-9' < /dev/random | fold -w 12 | head -n 1)"
     echo "Secret Key: $(tr -dc 'a-f0-9' < /dev/random | fold -w 32 | head -n 1)"
     #echo "OTP AES Key: $(tr -dc 'a-f0-9' < /dev/random | fold -w 40 | head -n 1)"
elif [ "$SYMBOLS" == "1" ]
then
     tr -dc 'a-zA-Z0-9-_!@#$%^&*/\()_+{}|:<>?=' < /dev/random | fold -w "$LEN" | head -n "$NUM"
else
     tr -dc 'a-zA-Z0-9' < /dev/random | fold -w "$LEN" | head -n "$NUM"
fi

exit 0
