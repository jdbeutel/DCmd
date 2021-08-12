# This Makefile is for building the DCmd project in Docker.
# A lot of this is here, instead of in the Jenkinsfile, so that
# the developer can also run it locally.

imagename = dcmd-buildenv:SNAPSHOT
volumes = -v $(shell pwd)/../:/home/dcmduser/workspace
grails_opts = -Dhttps.protocols=TLSv1,TLSv1.1,TLSv1.2 --stacktrace

image:
	docker build --build-arg DCMD_UID=$$(id -u) -t ${imagename} .

echo:
	echo $(shell pwd)

war:
	docker run ${volumes} ${imagename} grails war ${grails_opts}

shell:
	docker run -it ${volumes} ${imagename} bash
