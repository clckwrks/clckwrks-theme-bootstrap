#
# BUILD BOOTSWATCH SWATCH
#

OUTPUT_PATH = ../data

bootswatch:
	mkdir -p ${OUTPUT_PATH}/css
	recess --compile swatchmaker.less > ${OUTPUT_PATH}/css/bootstrap.css
	recess --compress swatchmaker.less > ${OUTPUT_PATH}/css/bootstrap.min.css
	recess --compile swatchmaker-responsive.less > ${OUTPUT_PATH}/css/bootstrap-responsive.css
	recess --compress swatchmaker-responsive.less > ${OUTPUT_PATH}/css/bootstrap-responsive.min.css
	rsync -av img ${OUTPUT_PATH}

bootstrap:
	-test -d bootstrap && rm -r bootstrap
	curl --location -o latest_bootstrap.tar.gz https://github.com/twitter/bootstrap/tarball/master
	tar -xvzf latest_bootstrap.tar.gz
	mv twitter-bootstrap* bootstrap
	rm latest_bootstrap.tar.gz

default:
	-test -f ${OUTPUT_PATH}/variables.less && rm ${OUTPUT_PATH}/variables.less
	-test -f ${OUTPUT_PATH}/bootswatch.less && rm ${OUTPUT_PATH}/bootswatch.less
	curl --location -o ${OUTPUT_PATH}/variables.less https://raw.github.com/twitter/bootstrap/master/less/variables.less
	curl --location -o ${OUTPUT_PATH}/bootswatch.less https://raw.github.com/thomaspark/bootswatch/gh-pages/swatchmaker/swatch/bootswatch.less
	make bootswatch

.PHONY: bootswatch bootstrap default

