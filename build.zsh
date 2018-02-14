#!/bin/zsh

SPEC=$1
RPMBUILDROOT=~/rpmbuild

if [[ "$1" == "" ]]; then
	echo "Usage: build.sh specfile.spec";
	exit 1;
elif [[ ! -e "$RPMBUILDROOT/SPECS/$SPEC" ]]; then
	echo "Could not find $RPMBUILDROOT/$SPEC.spec ";
	exit 1;
else
	BUILD_CMD="/bin/build-spec /home/rpmbuilder/rpmbuild/SPECS/$SPEC";
	CONTAINER="c6-rpmbuild-${SPEC%.spec}";

	echo "Executing '$BUILD_CMD' in new container named '$CONTAINER'";
	eval "docker run \
		-ti \
		--name $CONTAINER \
		-v $RPMBUILDROOT:/home/rpmbuilder/rpmbuild \
		-v /var/cache/yum:/var/cache/yum \
		local/rpmbuild-c6 \
		$BUILD_CMD 2>&1";

	# Change ownership back to this user, as my build-spec changes
	# needed to chown the $RPMBUILDROOT to rpmbuilder in order to run properly	
	chown `whoami`: $RPMBUILDROOT -R	

	exit $?;
fi;
