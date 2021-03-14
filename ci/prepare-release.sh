#!/bin/sh

set -ev

l3build tag $1
l3build ctan -q -H

swufethesis="swufethesis"

# 源码版本
cp $swufethesis-ctan.zip $swufethesis.zip
zip -q -d $swufethesis.zip $swufethesis.tds.zip

# TDS包
cp build/distrib/tds/$swufethesis.tds.zip .

# 示例文件
demo="swufethesis-demo"
rm -rf $demo && mkdir $demo
cp -r demo/* $demo
zip -vrX $demo.zip $demo
rm -rf $demo

# 免安装版
portable="swufethesis-portable"
rm -rf $portable && mkdir $portable
cp -r demo/* $portable
cp -r build/distrib/tds/tex/latex/$swufethesis $portable
zip -vrX $portable.zip $portable
rm -rf $portable

