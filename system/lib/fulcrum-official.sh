#!/usr/bin/env bash

############################################
#
# Family Node Kit
#
# Official Fulcrum information
#
# Functions only.
# No output.
# No side effects.
#
############################################

FULCRUM_GITHUB_API="https://api.github.com/repos/cculianu/Fulcrum"

#
# Returns the latest official stable version.
#
get_official_fulcrum_version() {

    local tag

    tag="$(
        curl -fsSL \
            "$FULCRUM_GITHUB_API/releases/latest" |
        sed -nE 's/^[[:space:]]*"tag_name":[[:space:]]*"v([^"]+)".*/\1/p' |
        head -n1
    )"

    [[ -n "$tag" ]] || return 1

    echo "$tag"
}

#
# Returns the commit associated with the latest
# official release tag.
#
get_official_fulcrum_release() {

    local version
    local sha

    version="$(get_official_fulcrum_version)" || return 1

    sha="$(
        curl -fsSL \
            "$FULCRUM_GITHUB_API/git/ref/tags/v${version}" |
        sed -nE 's/.*"sha":[[:space:]]*"([^"]+)".*/\1/p' |
        head -n1
    )"

    [[ -n "$sha" ]] || return 1

    echo "${sha:0:7}"
}

#
# Returns the official versioned container image.
#
get_official_fulcrum_image() {

    local version

    version="$(get_official_fulcrum_version)" || return 1

    echo "docker.io/cculianu/fulcrum:v${version}"
}

#
# Returns the official AMD64 OCI image digest
# for the latest stable Fulcrum release.
#
get_official_fulcrum_amd64_digest() {

    local version
    local image
    local digest

    version="$(get_official_fulcrum_version)" || return 1

    image="docker.io/cculianu/fulcrum:v${version}"

    digest="$(
        podman manifest inspect "$image" 2>/dev/null |
        grep -B5 -A5 '"architecture": "amd64"' |
        sed -nE 's/.*"digest":[[:space:]]*"([^"]+)".*/\1/p' |
        head -n1
    )"

    [[ -n "$digest" ]] || return 1

    echo "$digest"
}

#
# Returns the official Fulcrum project URL.
#
get_fulcrum_project_url() {
    echo "https://github.com/cculianu/Fulcrum"
}
