#!/bin/sh

set -e

# set -v on # 显示命令执行回显

# export NODE_VERSION=10.15.0

# . ~/.nvm/nvm.sh

# nvm install ${NODE_VERSION}
# NPM="nvm exec 10.15.0 npm"

# ${NPM} install --registry https://registry.npm.taobao.org

npm install --registry https://registry.npm.taobao.org

#----------------------------------------

# 1、获取当前工程名字 即package.json文件中的name

export PROJECT_NAME=""

if [ -s "./package.json" ]; then
    echo "-----package.json 文件存在-----"

    head -10 "./package.json" > test.txt # 如果找到package.json文件 取其前10行的内容

    while read line

    do
    echo "line : $line"
    if [[ $line =~ "name" ]]; then

        # echo $line
        
        line="$(echo "${line}" | tr -d '[:space:]')" # 去掉空格

        IFS=":"

        array=($line)

        len=${#array[1]}

        partlen=`expr $len - 1`

        PROJECT_NAME=${array[1]: 0: $partlen}

        break
    fi
    done < "./test.txt"

fi

echo "-----工程名：$PROJECT_NAME-----"

# 2、获取配置文件 按照配置安装对应的依赖包

fileName="package-config-test"

gitcloneurl="https://github.com/AUW-su/package-config-test.git"

git clone "$gitcloneurl"

#  chmod u+x *.sh

# 判断配置文件是否有内容，在[   ]内要有空格
if [ -s "./${fileName}/.config" ]; then

    echo "-----依赖包版本配置文件有内容-----"

    # 开始读配置文件
    while read line

    do
    echo ${line}
    echo $PROJECT_NAME
    # if [[ $line =~ "all" ]] || [[ ! -z $PROJECT_NAME && $line =~ $PROJECT_NAME ]]; then
    #     echo "依赖包版本配置文件当前一行的内容：$line"

    #     line="$(echo "${line}" | tr -d '[:space:]')" # 去掉空格

    #     IFS=":"

    #     array=($line)

    #     echo "-----要安装的依赖包信息：${array[1]}-----"

    #     npm install ${array[1]}  --registry https://registry.npm.taobao.org
    # fi
    
    done < "./${fileName}/.config"
fi

# # 3、删除本次脚本执行新增的文件
rm -rf "./test.txt"

rm -rf "./${fileName}"

# # 4、判断是否有需要提交的文件的文件
# if [[ "${GIT_STATUS}" == *"nothing to commit"* ]]; then
#     echo "-----自动更新依赖包版本 没有可提交的内容-----";
# else
#     echo "-----自动更新依赖包版本 自动提交diff-----"
#     git add ./package.json
#     git add ./package-lock.json
#     git commit --no-verify -m "build.sh auto commit package.json & package-lock.json";
#     git push
# fi

#----------------------------------------

# 后面就是 build.sh 剩下的脚本内容

