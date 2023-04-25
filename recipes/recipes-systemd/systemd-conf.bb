SECTION = "examples"
DEPENDS = ""
LICENSE = "CLOSED"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = "file://10-eth.network"
S = "${WORKDIR}"

#inherit allarch

FILES:${PN} += "${sysconfdir}/systemd/network/10-eth.network"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/10-eth.network ${D}${sysconfdir}/systemd/network
}

