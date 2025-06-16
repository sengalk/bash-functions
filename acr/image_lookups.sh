# Intended to be sourced (e.g. ". thisfilename" in bash)

# Output all images (tagged or untagged) found in the
# registry provided as first argument
#
# Will do an az login as first step, so please choose correct
# subscription
dump_all_images() {

    # Arg to function
    local registry_name=$1

    if [[ -z $registry_name ]]; then
        echo "Please provide the acr registry name as first and only arg to this script"
        return 1
    fi

    echo "Logging into az. If asked pick the subscription with the ACR registry you provided"    
    az acr login --name "$registry_name"
    
    # Get all repositories
    REPOS=$(az acr repository list --name "$registry_name" --output tsv)
    
    echo "Getting tags and digests from ACR: $registry_name"
    echo "---------------------------------------------"
    
    for repo in $REPOS; do
        echo "Repository: $repo"
        
        # Get all manifests (digests) for the repository
        digests=$(az acr repository show-manifests \
            --name "$registry_name" \
            --repository "$repo" \
            --query "[].digest" \
            --output tsv)
    
        for digest in $digests; do
            # Get tags for the digest
            tags=$(az acr repository show-manifests \
                --name "$registry_name" \
                --repository "$repo" \
                --query "[?digest=='$digest'].tags[]" \
                --output tsv)
    
            if [[ -z "$tags" ]]; then
                echo "  Digest: $digest (untagged)"
            else
                for tag in $tags; do
                    echo "  Tag: $tag | Digest: $digest"
                done
            fi
        done
    
        echo ""
    done 2>/dev/null
}
