#!/bin/bash

#ChengRuoFei

#sshAuto.sh脚本名，需要传入 对方服务器 用户和密码（$1 $2 传参）

sshIP=$1
sshPassword=$2

#本机公私秘钥 expect免交互方式生成函数
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

#发送对方服务器公钥匙的expect免交互函数

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

#对传参的判断并执行函数
[[  -z "$sshIP" ]] && echo "\$1   empty,please input   \$1 "  ! || sshKeygenAuto
[[  -z "$sshPassword" ]] && echo "\$2  empty,please input   \$2"  ! ||sshCopyIdAuto

#脚本到此完

###########################################################

#脚本执行过程：

#测试环境为4台服务器，密码123456，具体执行命令如下：

vi sshAuto.sh 

bash sshAuto.sh 192.168.18.101 123456
bash sshAuto.sh 192.168.18.102 123456
bash sshAuto.sh 192.168.18.103 123456
bash sshAuto.sh 192.168.18.104 123456
scp sshAuto.sh  192.168.18.102:~
ssh 192.168.18.102 "bash sshAuto.sh 192.168.18.101 123456"
ssh 192.168.18.102 "bash sshAuto.sh 192.168.18.102 123456"
ssh 192.168.18.102 "bash sshAuto.sh 192.168.18.103 123456"
ssh 192.168.18.102 "bash sshAuto.sh 192.168.18.104 123456"
scp sshAuto.sh  192.168.18.103:~
ssh 192.168.18.103 "bash sshAuto.sh 192.168.18.101 123456"
ssh 192.168.18.103 "bash sshAuto.sh 192.168.18.102 123456"
ssh 192.168.18.103 "bash sshAuto.sh 192.168.18.103 123456"
ssh 192.168.18.103 "bash sshAuto.sh 192.168.18.104 123456"
scp sshAuto.sh  192.168.18.104:~
ssh 192.168.18.104 "bash sshAuto.sh 192.168.18.101 123456"
ssh 192.168.18.104 "bash sshAuto.sh 192.168.18.102 123456"
ssh 192.168.18.104 "bash sshAuto.sh 192.168.18.103 123456"
ssh 192.168.18.104 "bash sshAuto.sh 192.168.18.104 123456"