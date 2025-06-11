# Intended to be sourced (e.g. ". thisfilename" in bash)

# Outputs similar with docker ps, but with an extra first column we call OFFSET ID.
# Sample:
#
# $ dps
# ID  CONTAINER_ID  IMAGE     NAMES
# 1   977f5885612c  api       api-server-1
# 2   453f1dbae850  mongo:7   mongo-1
# 3   78421db0de7f  postgres  postgres-1
#
# ^ First column called OFFSET_ID in remainng functions' comments.  
#   This column is not part of the default 'docker ps' output
dps() {

    ( echo "ID  CONTAINER_ID IMAGE  NAMES"
    docker ps --format "{{.ID}}  {{.Image}}  {{.Names}}" | tail -n +1 | cat -n ) | column -t

}

# Kills docker container with supplied offset id.
#
# Usage: dkill OFFSET_ID
#
#        where OFFSET_ID comes from the line number from
#        output of first function in this file (i.e., dps)
dkill() {

    if [[ -z $1 ]]; then
        echo "Missing offset id from dps output shown here:"
        dps
        return 0
    fi

    local offset_id=$1

    container_id=$(docker ps --format "{{.ID}}" | tail -n +1 | sed -n "${offset_id}p")

    echo "Killing container id: $container_id"
    docker kill "$container_id"
}

# Shows logs for docker container with supplied offset id.
#
# Usage: dogs OFFSET_ID     
#
#        where OFFSET_ID comes from the line number from
#        output of first function in this file (i.e., dps)
dlogs() {

    if [[ -z $1 ]]; then
        echo "Missing offset id from dps output shown here:"
        dps
        return 0
    fi

    local offset_id=$1

    container_id=$(docker ps --format "{{.ID}}" | tail -n +1 | sed -n "${offset_id}p")

    echo "Showins logs for container id: $container_id"
    docker logs "$container_id"
}

# Kills all running containers
#
dkillall() {
    docker ps -q | xargs docker kill
}

# Kills all running containers
# and removes metadata of all dead containers and their unnamed volumes
drmall() {
    dkillall
    docker ps -q -a | xargs docker rm
}
