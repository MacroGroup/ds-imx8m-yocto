$PATH_TO - путь до места, где будет создана папка imx-yocto-bsp

01. sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib \
    build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
    xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa \
    libsdl1.2-dev pylint3 xterm rsync curl zstd pzstd lz4c lz4
02. mkdir ~/bin
03. curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
04. chmod a+x ~/bin/repo
05. export PATH=~/bin:$PATH
06. mkdir imx-yocto-bsp
07. cd imx-yocto-bsp
08. repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-kirkstone -m imx-5.15.32-2.0.0.xml
09. repo sync
10. DISTRO=fsl-imx-wayland MACHINE=imx8mm-lpddr4-evk source imx-setup-release.sh -b build
11. devtool modify linux-imx
 11a. На следуюшем шаге может возникнуть ошибка компиляции, из-за того что более
      свежие верии git более не поддерживают "git submodule--helper list":
      "Command '['git', 'submodule--helper', 'list']' returned non-zero exit status 129".
      Решить проблему можно следующим образом:
      curl https://git.yoctoproject.org/poky/patch/?id=0533edac277080e1bd130c14df0cbac61ba01a0c > ../externalrc.bbclass.patch
      patch -d ../sources/poky/meta/classes -p3 < ../externalrc.bbclass.patch
12. devtool modify u-boot-imx
13. cd workspace/sources/linux-imx
14. patch -p1 < $PATH_TO_DIFF/linux_imx.diff
15. cd ../u-boot-imx
16. patch -p1 < $PATH_TO_DIFF/uboot_imx.diff
17. Скопировать файлы для сборки из папки imx-source в $PATH_TO/imx-yocto-bsp/downloads
18. Скопировать папку machine в $PATH_TO/imx-yocto-bsp/build/conf
19. Cкопировать папку recipes в $PATH_TO/imx-yocto-bsp/build/workspace
20. Скопировать файл layer.conf в $PATH_TO/imx-yocto-bsp/build/workspace/conf
21. Перейти в папку $PATH_TO/imx-yocto-bsp/build
22. Перед сборкой убедитесь, что свободного места на диске больше чем 150ГБ
23. Запустить сборку для платы MACHINE=imx8mm-mgqs bitbake imx-image-multimedia
24. Полученный образ расположен в $PATH_TO/imx-yocto-bsp/build/tmp/deploy/images/imx8mm-mgqs/imx-image-multimedia-imx8mm-mgqs-*.rootfs.wic.bz2
