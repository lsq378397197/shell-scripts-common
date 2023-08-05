### [安全专题](http://www.aqzt.com)

#### 1. 查文件从32994到34871行内容
```shell
sed -n '32994,34871p'  config_file
```

#### 2. 删除文件从32994到34871行内容
```shell
sed '32994,34871 d' config_file
```

#### 3. 替换文件中performance_schema改为performance_schema_bak
```shell
sed -i "s/performance_schema/performance_schema_bak/g" config_file
```

#### 4. sed去除注释行
```shell
sed -i -c -e '/^#/d' config_file
```

#### 5. sed去除空行
```shell
sed -i -c -e '/^$/d' config_file
```

#### 6. sed去空行和注释行
```shell
sed -i -c -e '/^$/d;/^#/' config_file
```

#### 7. 在某字符串下面一行增加一字符串
```shell
sed -i '/fastcgi_path_info/a\fastcgi_param ENV_VAR_MY test;' test*.conf
```
#### 8. 假设处理的文本为test.file,在每行的头添加字符，比如"HEAD"，命令如下：
```shell
sed 's/^/HEAD&/g' test.file
```

#### 9.在每行的行尾添加字符，比如“TAIL”，命令如下：
```shell
sed 's/$/&TAIL/g' test.file
```

#### 10. 替换某些后缀文件中的字符
```shell
sed -i "s/text_to_replace/replacement/g" `find . -type f -name <filename>`
sed -i "s/10.0.0.75/10.0.0.76/g" `find . -type f -name "*.properties"`
sed -i "s/10.0.0.18/10.0.0.17/g" `find . -type f -name "*.properties"`
sed -i "s/10.0.0.16/10.0.0.17/g" `find . -type f -name "*.php"`
sed -i "s/d12/111222/g" `find . -type f -name "*.properties"`

```
#### 11. sed删除文件倒数10行
```shell
sed -i '$ d' filename # 删除最后一行
sed -i '$ s/.*//' filename # 另一种方法删除最后一行

# 删除倒数10行
sed -i -e :a -e '$d;N;2,10ba' -e 'P;D' filename
```
> $表示最后一行   
sed -i表示就地编辑文件   
$ d 删除最后一行   
$ s/.*// 用空字符串替换最后一行,即删除   
-e :a 设置循环标签a   
-e '$d;N;2,10ba' 删除最后一行,读取下一行,如果行号在2-10之间,跳到标签a   
-e 'P;D' 打印并删除第一行,即输出删除的行   

#### 12. 把文件倒序
```shell
sed -i '1!G;$!h;$!d' filename
```
#### 13. 删除13行
```shell
sed -i '1,10d' filename
```
#### 14. 把文件倒序回来
```shell
sed -i '1!G;$!h;$!d' filename

nl file | tail -n 10 | awk 'NR == 1 '{print $1}'

awk 'BEGIN{CMD="wc -l file";CMD|getline i}NR<=(i-10)' file
sed -n ':a;1,10!{P;N;D;};N;ba' file
```