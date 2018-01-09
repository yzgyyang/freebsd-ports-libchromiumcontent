# Created by: Guangyuan Yang <ygy@FreeBSD.org>
# $FreeBSD$

PORTNAME=	libchromiumcontent
CATEGORIES=	www

MAINTAINER=	ygy@FreeBSD.org

USE_GITHUB=	yes
GH_ACCOUNT=	electron
GH_PROJECT=	libchromiumcontent
GH_TAGNAME=	e301597

pre-build:
	svnlite co -r442282 svn://svn.freebsd.org/ports/head/www/chromium ${WRKSRC}/chromium
	rm ${WRKSRC}/chromium/files/patch-gpu_command__buffer_service_program__manager.cc
	rm ${WRKSRC}/chromium/files/patch-gpu_config_gpu__control__list.cc
	rm ${WRKSRC}/chromium/files/patch-third__party_leveldatabase_env__chromium.cc
	patch -p1 --ignore-whitespace -d ${WRKSRC}/chromium/ < chromium-Makefile.diff
	cd ${WRKSRC}/chromium && make configure DISABLE_VULNERABILITIES=yes
	${WRKSRC}/script/bootstrap
	mv ${WRKSRC}/chromium/work/chromium-58.0.3029.110 ${WRKSRC}/src
	mv ${WRKSRC}/src/third_party/ffmpeg/BUILD.gn.orig ${WRKSRC}/src/third_party/ffmpeg/BUILD.gn
	patch -p1 --ignore-whitespace -d ${WRKSRC}/src/ < chromiumv1.diff

do-build:
	${WRKSRC}/script/update -t x64
	${WRKSRC}/build --no_shared_library -t x64
	${WRKSRC}/create-dist -c static_library -t x64

.include <bsd.port.mk>
