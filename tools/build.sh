#!/bin/bash
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/oreka/orkaudio/audiocaptureplugins/mirror_tools

NODOWNLOAD=$1

ROOT=`pwd`
MIRRORTOOLS=${ROOT}/../orkaudio/audiocaptureplugins/mirror_tools

# 下载libmirrortools库
if [[ ! -n "$NODOWNLOAD" && -e ${MIRRORTOOLS}/download.sh ]];then
	sh ${MIRRORTOOLS}/download.sh
fi
# 读取下载的版本
VERSION_FILE=${MIRRORTOOLS}/version.txt
MIRROR_VERSION=`head -n +1 ${VERSION_FILE}`
echo "MIRROR_VERSION: ${MIRROR_VERSION}"

version() {
  if [ -z "${GIT_LOCAL_BRANCH}" ]; then
    echo "${MAJOR_NUMBER}"."${MINOR_NUMBER}"."${FIX_NUMBER}"."${BUILD_VERSION}"
  else
    echo "${GIT_LOCAL_BRANCH}"_"${MAJOR_NUMBER}"."${MINOR_NUMBER}"."${FIX_NUMBER}"."${CI_BUILD_NUMBER}"
  fi
}

VERSION=$(version)  # 镜像版本号

CURPATH=`pwd`
echo "CURPATH: $CURPATH"

# tools 目录下创建docker目录存储构建出的二进制和so
rm -rf ${CURPATH}/docker
mkdir -p ${CURPATH}/docker
OUTPUT=${CURPATH}/docker
echo "OUTPUT: ${OUTPUT}"

LPATH=$(dirname "${CURPATH}")

cd ${LPATH}/orkbasecxx/
autoreconf -i
./configure CXX=g++
make
make install

# copy 二进制可执行程序和so到docker目录
cp -df ${LPATH}/orkbasecxx/.libs/liborkbase.so* ${OUTPUT}

cd ${LPATH}/orkaudio
autoreconf -i
./configure CXX=g++
make
# make install

# copy 二进制可执行程序和so到docker目录
cp -df ${LPATH}/orkaudio/audiocaptureplugins/voip/.libs/libvoip.so* ${OUTPUT}
cp -df ${LPATH}/orkaudio/audiocaptureplugins/generator/.libs/libgenerator.so* ${OUTPUT}
cp -df ${LPATH}/orkaudio/audiocaptureplugins/mirror_tools/libmirrortools.so* ${OUTPUT}
# cp -df ./plugins/*.so ${OUTPUT}
cp -df ${LPATH}/orkaudio/orkaudio ${OUTPUT}

#拷贝配置文件
cp -f ${LPATH}/distribution/docker/entrypoint.sh ${OUTPUT}
cp -f ${LPATH}/distribution/docker/config-linux-template.xml ${OUTPUT}/config.xml
cp -f ${LPATH}/distribution/docker/logging-linux-template.properties ${OUTPUT}/logging.properties

# 打包镜像
cd ${LPATH}/tools

# 生成Dockerfile
cp -f DockerfileTemplate Dockerfile
sed -i "s/{MIRROR_VERSION}/${MIRROR_VERSION}/g" Dockerfile

TAG=oreka:${VERSION}
docker login --username=100015805750 --password=8XoMIOGEnabqEeiD ccr.ccs.tencentyun.com
docker build -t ccr.ccs.tencentyun.com/yunbao/"${TAG}" .
docker push ccr.ccs.tencentyun.com/yunbao/"${TAG}"
docker logout ccr.ccs.tencentyun.com
