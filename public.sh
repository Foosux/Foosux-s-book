#!/bin/bash

start=$(date +%s)
echo "build Start!"
gitbook build
echo "build End! "
end=$(date +%s)
time=$(( $end - $start ))
echo "fe build in ($time) 秒"

echo "开始推送代码"
scp -r ./_book/* root@10.33.106.182:/root/gitbook/_book
echo "推送完毕！"
