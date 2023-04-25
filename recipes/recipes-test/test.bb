DESCRIPTION = "Test file load to roots"
SECTION = "examples"
DEPENDS = ""
LICENSE = "CLOSED"
FILESEXTRAPATHS:prepend := "${THISDIR}:"

SRC_URI = "file://scripts"
S = "${WORKDIR}"

#inherit allarch

do_install() {
    install -d ${D}/home/root
    cp -r ${WORKDIR}/scripts ${D}/home/root
    #tar -xvf ${WORKDIR}/scripts/esptool.tar.gz -C ${D}/home/root 
#    install -m 0644 ${WORKDIR}/ ${D}${datadir}/scripts
}

FILES:${PN} = "/home/root"
