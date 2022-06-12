sshIP=$1
sshPassword=$2
function sshKeygenAuto() {
    if [ ! -e ~/.ssh/id_rsa.pub ]; then
        echo "The public/private rsa key pair not exist, start Generating..."
        yum install expect -y >/dev/null 2>&1
        expect -c "
            spawn ssh-keygen
            expect {
                \"ssh/id_rsa):\" {send \"\r\";exp_continue}
                \"passphrase):\" {send \"\r\";exp_continue}
                \"again:\" {send \"\r\";exp_continue}
            }
        " >/dev/null 2>&1
        if [ -e ~/.ssh/id_rsa.pub ]; then
            echo "Generating public/private rsa key pair successfully."
        else
            echo "Generating public/private rsa key pair failure!"
            
        fi
    fi
}

function sshCopyIdAuto() {
        cd
        expect -c "
                    spawn ssh-copy-id -i .ssh/id_rsa.pub $sshIP
            expect {
                \"(yes/no)?\" {send \"yes\r\";exp_continue}
                \"password:\" {send \"$sshPassword\r\";exp_continue}
            }
        " >/dev/null 2>&1
}


[[  -z "$sshIP" ]] && echo "\$1   empty,please input   \$1 "  ! || sshKeygenAuto
[[  -z "$sshPassword" ]] && echo "\$2  empty,please input   \$2"  ! ||sshCopyIdAuto