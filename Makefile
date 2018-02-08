# Created by: Guangyuan Yang <ygy@FreeBSD.org>
# $FreeBSD$

PORTNAME=	libchromiumcontent
DISTVERSION=	1.0
CATEGORIES=	www

MAINTAINER=	ygy@FreeBSD.org

USE_GITHUB=	yes
GH_ACCOUNT=	electron
GH_PROJECT=	libchromiumcontent
GH_TAGNAME=	2bdad00587
GH_TUPLE=	yzgyyang:ports-electron-depends-chromium:e9098f3:chromium/chromium \
		piotrbulinski:boto:c3b81eb:boto/vendor/boto \
		yzgyyang:depot-tools:c55eecf:depot_tools/vendor/depot_tools

pre-build:
	(cd ${WRKSRC}/chromium && make configure DISABLE_LICENSES=1 DISABLE_VULNERABILITIES=yes)
	(cd ${WRKSRC} && script/bootstrap)
	${MV} ${WRKSRC}/chromium/work/chromium-61.0.3163.100 ${WRKSRC}/src
	${RM} ${WRKSRC}/patches/v8/025-cherry_pick_cc55747.patch*
	patch -p1 --ignore-whitespace -d ${WRKSRC}/src/ < chromiumv1.diff
	patch -p1 --ignore-whitespace -d ${WRKSRC}/src/ < libchromiumcontent_bsd.diff

do-build:
	(cd ${WRKSRC} && script/update -t x64 --skip_gclient)
	(cd ${WRKSRC} && script/build --no_shared_library -t x64)
	(cd ${WRKSRC} && script/create-dist -c static_library -t x64)

.include <bsd.port.mk>
