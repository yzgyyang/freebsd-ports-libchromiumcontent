# Created by: Guangyuan Yang <ygy@FreeBSD.org>
# $FreeBSD$

PORTNAME=	libchromiumcontent
CATEGORIES=	www

MAINTAINER=	ygy@FreeBSD.org

USE_GITHUB=	yes
GH_ACCOUNT=	electron
GH_PROJECT=	libchromiumcontent
GH_TAGNAME=	electron-1-6-x
GH_TUPLE=	svn2github:python-patch:a336a45:pythonpatch/vendor/python-patch

pre-build:
	svnlite co -r435428 svn://svn.freebsd.org/ports/head/www/chromium ${WRKSRC}/chromium
	patch -p1 -d ${WRKSRC}/chromium/ < chromium_make.diff
	rm ${WRKSRC}/chromium/files/patch-third__party_ffmpeg_ffmpeg__generated.gni.orig
	cd ${WRKSRC}/chromium && make configure DISABLE_VULNERABILITIES=yes
	patch -p1 -d ${WRKSRC} < libchromiumcontent.diff
	${WRKSRC}/script/bootstrap
	mv ${WRKSRC}/chromium/work/chromium-56.0.2924.87 ${WRKSRC}/src
	patch -p1 -d ${WRKSRC}/src/third_party/ffmpeg/ < ${WRKSRC}/patches/third_party/ffmpeg/build_gn.patch
	patch -p1 -d ${WRKSRC}/src/third_party/icu/ < ${WRKSRC}/patches/third_party/icu/build_gn.patch
	patch -p1 -d ${WRKSRC}/src/v8/ < ${WRKSRC}/patches/v8/build_gn.patch
	patch -p1 -d ${WRKSRC}/src/ < ${WRKSRC}/patches/build_gn.patch
	rm ${WRKSRC}/patches/third_party/ffmpeg/build_gn.patch
	rm ${WRKSRC}/patches/third_party/icu/build_gn.patch
	rm ${WRKSRC}/patches/v8/build_gn.patch
	rm ${WRKSRC}/patches/build_gn.patch
	rm ${WRKSRC}/src/base/process/launch.h.orig
	rm ${WRKSRC}/src/content/browser/renderer_host/*.orig
	rm ${WRKSRC}/src/chrome/browser/ui/libgtkui/*.orig
	rm ${WRKSRC}/src/content/app/*.orig
	rm ${WRKSRC}/src/content/renderer/*.orig
	patch -p1 --ignore-whitespace -d ${WRKSRC}/src/ < chromiumv2.diff

do-build:
	${WRKSRC}/script/update -t x64
	${WRKSRC}/script/build --no_shared_library -t x64
	${WRKSRC}/script/create-dist -c static_library -t x64

.include <bsd.port.mk>
