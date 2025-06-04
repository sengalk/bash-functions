# Intended to be sourced (e.g. ". thisfilename" in bash)

# Precondition:  kubectx extention to kubectl already installed
ktx() {

    if [[ -z $1 ]]; then
        script -q /dev/null kubectx | awk '{ print NR, $0 }'
        return 0
    fi

    local ctx_number=$1

    local ctx_name=$(kubectx | sed -n "${ctx_number}p")

    kubectx "$ctx_name"
}

# Precondition: kubens extension to kubectl already installed
kns() {

    if [[ -z $1 ]]; then
        script -q /dev/null kubens | awk '{ print NR, $0 }'
        return 0
    fi

    local ns_number=$1

    local ns_name=$(kubens | sed -n "${ns_number}p")

    kubens "$ns_name"
}

