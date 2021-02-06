#!/bin/sh

set -e

# build.sh 脚本前面的内容忽略

#----------------------------------------

# 1、获取当前工程名字 即package.json文件中的name

export PROJECT_NAME=""

# -s 用来判断 file exists and has a size greater than zero.

if [ -s "./package.json" ]; then

    while read line # 读取 package.json 文件内容

    do
    if [[ $line =~ "name" ]]; then

        line="$(echo "${line}" | tr -d '[:space:]')" # 去掉空格

        IFS=":" # shell 内置分隔符

        array=($line)

        len=${#array[1]} # 长度

        partlen=`expr $len - 1`

        PROJECT_NAME=${array[1]: 0: $partlen} # 字符串截取

        break
    fi
    done < "./package.json"

fi

echo "-----工程名：$PROJECT_NAME-----"

# 2、获取配置文件 按照配置安装对应的依赖包

folderName="package-config-test"

gitcloneurl="https://github.com/AUW-su/package-config-test.git"

git clone "$gitcloneurl"

# 在[   ]内要有空格

if [ -s "./${folderName}/.config" ]; then

    echo "-----依赖包版本配置文件有内容-----"

    # 开始读配置文件内容 
    # -n ${line} 是为了解决 while read line无法读取最后一行的问题
    # 当文件没有到最后一行时不会测试-n $line，当遇到文件结束（最后一行）时，仍然可以通过测试$line是否有内容来进行继续处理

    while read line || [[ -n ${line} ]]

    do
    if [[ $line =~ "all" ]] || [[ ! -z $PROJECT_NAME && $line =~ $PROJECT_NAME ]]; then # -z 判断字符串长度是否为0
    
        line="$(echo "${line}" | tr -d '[:space:]')" # 去掉空格

        IFS=":"

        array=($line)

        # echo ${array[1]}

        npm install ${array[1]}  --registry https://registry.npm.taobao.org
    fi
    done < "./${folderName}/.config"

fi
    
# 3、删除新增的文件

rm -rf "./${folderName}"

# 4、判断是否有需要提交的文件

if [[ "${GIT_STATUS}" == *"nothing to commit"* ]]; then
    echo "-----自动更新依赖包版本 没有可提交的内容-----";
else
    echo "-----自动更新依赖包版本 自动提交diff-----"
    git add ./package.json
    git add ./package-lock.json
    git commit --no-verify -m "build.sh auto commit package.json & package-lock.json";
    git push
fi

#----------------------------------------

# 后面就是 build.sh 剩下的脚本内容
