## 工程实践内容

### 1、npm & package.json & package-lock.json

可以用这个test项目来实践，当然按照对应的文档 直接本地实践也是可以的。

https://app.yinxiang.com/fx/d2c9ba27-da72-4c26-969d-6349b2d2b314

https://app.yinxiang.com/fx/7142f44c-b59a-4b89-8ff6-d00e9bf5bd15

### 2、在现有build.sh脚本基础上，新增依赖包配置文件

新增依赖包配置文件维护在另外一个工程里，https://github.com/AUW-su/package-config-test.git

在build.sh执行过程中，会根据配置的信息，对应的工程（集群）会安装其需要的配置的依赖包的版本