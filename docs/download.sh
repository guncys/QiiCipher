#!/bin/bash

cat << EOL
==================================
  QiiCipher Downloader for macOS
==================================
EOL

# ユーザー関数の定義
# ------------------

ask_yes_or_no () {
    read input

    input=`tr '[a-z]' '[A-Z]' <<< $input`
    
    if [ ${input:0:1} = 'Y' ] ; then
        return 0
    else
        return 1
    fi
}

echo_ng () {
    echo 'NG'
    echo -e "${1}"
}

echo_q () {
    echo -n -e "  - ${1} ... "
}

has_cmd () {
    type $1 >/dev/null 2>&1
    return $?
}

is_mac () {
    sw_vers > /dev/null 2>&1
    return $?
}

is_pwd_in_path() {
    IFS=: eval 'list_path=($PATH)'
    SCRIPT_DIR=$(cd $(dirname $0); pwd)
    
    for e in "${list_path[@]}"; do
        if [ $e = $SCRIPT_DIR ] ; then
            return 0
        fi
    done
    
    return $BASH_LINENO
}

require_cmd () {
    echo_q "Is ${1} available"
    if ! has_cmd $1 ; then
        echo_ng "\tCommand not found. ${2}"
        exit $BASH_LINENO
    fi
    echo 'OK'
}

require_mac () {
    echo_q 'Is OS macOS'
    if ! is_mac ; then
        echo_ng $1
        exit $BASH_LINENO
    fi
    echo 'OK'
}

# 動作環境チェック
# ----------------
echo 'Checking environment to run QiiCipher scripts:'

require_mac 'Sorry, currently this downloader works only on macOS.'

collide_cmd () {
    echo_q "Does ${1} command exist"
    if has_cmd $1 ; then
        PATH_COLLISION=`which $1`
        MSG=""
        echo_ng "\t${2} Command found at:\n\t${PATH_COLLISION}"
        exit $BASH_LINENO
    fi
    echo 'OK'
}

collide_cmd 'enc' 'enc command already exists.'

require_cmd 'curl'       'cURL command is required.'
require_cmd 'openssl'    'OpenSSL command is required.'
require_cmd 'ssh-keygen' 'ssh-keygen command is required.'
require_cmd 'md5'        'md5 command is required.'
require_cmd 'diff'       'diff command is required.'
require_cmd 'tar'        'tar command is required.'
require_cmd 'zip'        'zip command is required.'

echo

if ! is_pwd_in_path ; then
    echo '環境変数のパスに現在のディレクトリ（下記パス）がありません。'
    echo "  - 現在のパス: ${SCRIPT_DIR}"
    echo -n "環境変数にパスを加えますか？(y/n):"

    if ask_yes_or_no ; then
        echo '追加します'
    else
        echo '追加しません'
    fi
fi





