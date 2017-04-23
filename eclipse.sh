eclipse(){
    # Reference - https://github.com/chanezon/docker-tips/blob/master/x11/README.md
    if [ -z "$(ps -ef|grep XQuartz|grep -v grep)" ] ; then
        open -a XQuartz
        socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
    fi
    DISPLAY_MAC=`ifconfig en0 | grep "inet " | cut -d " " -f2`:0
    docker run -d -it \
        -e DISPLAY=$DISPLAY_MAC \
        -e "TZ=America/Chicago" \
        --name eclipse \
        psharkey/eclipse
    echo -e "Eclipse started on $DISPLAY_MAC \xF0\x9f\x8d\xba"
}
