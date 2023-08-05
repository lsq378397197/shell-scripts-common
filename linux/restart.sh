#!/bin/bash
###根据传入参数的jar包名称决定杀死哪个服务，并重新启动指定目录下的jar；如果不传参数，默认启动所有指定部署目录下的jar服务

LOG_DIR="./deploy/logs"
DEPLOY_DIR="./deploy"
# 记录重启过的服务
restarted_apps=()

# 如果不传入任何参数,处理所有jar包
if [ $# -eq 0 ]; then
  echo "$(date) - No jar file specified, restarting all services" >> ${LOG_DIR}/restart.log

  for jar in ${DEPLOY_DIR}/*.jar; do
    app=${jar%.jar}
    app_name=${app##*/}
    restarted_apps+=($app_name)
    echo "$(date) - Restarting ${app_name}" >> ${LOG_DIR}/restart.log
    pid=$(ps aux | grep "${app_name}" | grep -v "grep" | grep -v "log" | grep -v "$0" | awk '{print $2}')
    echo "need killed pid=${pid}"
    if [ ! -z "$pid" ]; then
      echo "$(date) - Killing process ${pid} for ${app_name}" >> ${LOG_DIR}/restart.log
      kill ${pid}
    fi
    nohup java -jar ${jar} >> ${LOG_DIR}/${app_name}.log 2>&1 &
    echo "start ${app_name} successful!"
  done

# 如果传入参数,只处理指定的jar包
else
  for jar in "$@"; do
    app=${jar%.jar}
    app_name=${app##*/}
    restarted_apps+=($app_name)
    echo "$(date) - Restarting ${app_name}" >> ${LOG_DIR}/restart.log
    #grep -v "$0" 防止自杀
    pid=$(ps aux | grep "${app_name}" | grep -v "grep" | grep -v "log" | grep -v "$0"| awk '{print $2}')
    echo "need killed pid=${pid}"
    if [ ! -z "$pid" ]; then
      echo "$(date) - Killing process ${pid} for ${app_name}" >> ${LOG_DIR}/restart.log
      kill -9 ${pid}
    fi
    nohup java -jar ${jar} >> ${LOG_DIR}/${app_name}.log 2>&1 &
    echo "start ${app_name} successful!"
  done
fi

# 等待10秒后，输出每个jar服务的最后10行日志
sleep 10

for app in "${restarted_apps[@]}"; do
  echo -e "\n======== ${app} latest 10 logs ========"
  tail -n 10 ${LOG_DIR}/${app}.log
done