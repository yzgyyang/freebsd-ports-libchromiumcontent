# Created by: Guangyuan Yang <ygy@FreeBSD.org>
# $FreeBSD$

PORTNAME=	libchromiumcontent
DISTVERSION=	1.0
CATEGORIES=	www

MAINTAINER=	ygy@FreeBSD.org

USE_GITHUB=	yes
GH_ACCOUNT=	electron
GH_PROJECT=	libchromiumcontent
GH_TAGNAME=	0e76062883
GH_TUPLE=	piotrbulinski:boto:c3b81eb:boto/vendor/boto \
		yzgyyang:depot-tools:c55eecf:depot_tools/vendor/depot_tools

pre-build:
	svnlite co -r456719 svn://svn.freebsd.org/ports/head/www/chromium ${WRKSRC}/chromium
	patch -p1 -d ${WRKSRC}/chromium/ < chromium_make.diff
	(cd ${WRKSRC}/chromium && make configure DISABLE_LICENSES=1 DISABLE_VULNERABILITIES=yes)
	patch -p1 --ignore-whitespace -d ${WRKSRC} < libchromiumcontent_111.diff
	(cd ${WRKSRC} && script/bootstrap)
	${MV} ${WRKSRC}/chromium/work/chromium-61.0.3163.100 ${WRKSRC}/src
	patch -p1 -d ${WRKSRC} < libchromiumcontent_patches.diff
	patch -p1 --ignore-whitespace -d ${WRKSRC}/src/ < chromiumv1.diff
	patch -p1 --ignore-whitespace -d ${WRKSRC}/src/ < libchromiumcontent_bsd.diff
	patch -p1 --ignore-whitespace -d ${WRKSRC}/src/ < libchromiumcontent_v8.diff
	${RM} ${WRKSRC}/patches/v8/025-cherry_pick_cc55747.patch*

do-build:
	(cd ${WRKSRC} && script/update -t x64 --skip_gclient)
	(cd ${WRKSRC} && script/build -c static_library -t x64)
	(cd ${WRKSRC} && script/build -c ffmpeg -t x64)
	(cd ${WRKSRC} && script/create-dist -c static_library -t x64)

.include <bsd.port.mk>
