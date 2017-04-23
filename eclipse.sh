studio(){
    # Reference - https://github.com/chanezon/docker-tips/blob/master/x11/README.md
    if [ -z "$(ps -ef|grep XQuartz|grep -v grep)" ] ; then
        open -a XQuartz
    fi
    DISPLAY_MAC=`ifconfig en0 | grep "inet " | cut -d " " -f2`:0
	xhost + $DISPLAY_MAC
    docker run -d -it \
        -e DISPLAY=$DISPLAY_MAC \
        --name anypoint-studio \
        granthbr/studio
    echo -e "Anypoint Studio started on $DISPLAY_MAC \xF0\x9f\x8d\xba"
}
