function op () {
    DOCKER_VOLUME_OPTION=rw
    if [[ "$OSTYPE" = "darwin"* ]]; then
        DOCKER_VOLUME_OPTION=delegated
    fi
    DOCKER_RUN_OPTS=(--rm -i)
    if [ -t 0 ]; then DOCKER_RUN_OPTS+=(-t); fi
    mkdir -p "$HOME/.op" /tmp/com.agilebits.op.SingleUserEnvironment
    DOCKER_RUN_OPTS+=(-e "HOME=$HOME" -v "$HOME/.op:$HOME/.op:$DOCKER_VOLUME_OPTION")
    DOCKER_RUN_OPTS+=(-u "$(id -u):$(id -g)")
    DOCKER_RUN_OPTS+=(-v "$PWD:$PWD:$DOCKER_VOLUME_OPTION")
    DOCKER_RUN_OPTS+=(-v "/tmp/com.agilebits.op.SingleUserEnvironment:/tmp/com.agilebits.op.SingleUserEnvironment:$DOCKER_VOLUME_OPTION")
    for e in $(env | grep ^OP_SESSION); do
        DOCKER_RUN_OPTS+=(-e "$e")
    done
    set -x
    docker run "${DOCKER_RUN_OPTS[@]}" tophfr/op "$@"
    { set +x; } 2>/dev/null
}

# vim: ts=4 sts=4 sw=4 et:
