#!/usr/bin/env bash
#
# Family Node Kit
#
# health-runtime.sh
#
# Purpose:
#   Translate component verification results
#   into standardized health statuses.
#
# Architecture:
#   Rule 1  - One responsibility
#   Rule 2  - Libraries never talk
#   Rule 6  - Independently verifiable
#

#
# Prevent multiple sourcing.
#
[[ -n "${HEALTH_RUNTIME_LIB_LOADED:-}" ]] && return
readonly HEALTH_RUNTIME_LIB_LOADED=1

#
# Standard Health Statuses
#
readonly HEALTH_VERIFIED="🟢 Verified"
readonly HEALTH_UPDATE_AVAILABLE="🟡 Update available"
readonly HEALTH_NEWER_VERSION="🟡 Newer version detected"
readonly HEALTH_PARTIALLY_VERIFIED="🟡 Partially verified"
readonly HEALTH_NOT_INSTALLED="🔴 Not installed"
readonly HEALTH_VERIFICATION_FAILED="🔴 Verification failed"

#
# Public API
#
# Returns one of the standard HEALTH_* constants.
#

get_bitcoin_health_status() {

    local version

    version="$(get_bitcoin_version)" || {
        printf '%s\n' "$HEALTH_NOT_INSTALLED"
        return
    }

    if [[ -n "$version" ]]; then
        printf '%s\n' "$HEALTH_VERIFIED"
    else
        printf '%s\n' "$HEALTH_VERIFICATION_FAILED"
    fi
}

#
# Returns one of the standard HEALTH_* constants.
#

get_fulcrum_health_status() {

    local installed
    local official

    #
    # Is Fulcrum installed?
    #
    if ! is_fulcrum_installed; then
        printf '%s\n' "$HEALTH_NOT_INSTALLED"
        return
    fi

    #
    # Can we determine the installed version?
    #
    installed="$(get_fulcrum_version)"

    if [[ -z "$installed" ]]; then
        printf '%s\n' "$HEALTH_PARTIALLY_VERIFIED"
        return
    fi

    #
    # Can we determine the official version?
    #
    official="$(get_official_fulcrum_version)" || {
        printf '%s\n' "$HEALTH_VERIFICATION_FAILED"
        return
    }

    if [[ -z "$official" ]]; then
        printf '%s\n' "$HEALTH_PARTIALLY_VERIFIED"
        return
    fi

    #
    # Same version.
    #
    if [[ "$installed" == "$official" ]]; then
        printf '%s\n' "$HEALTH_VERIFIED"
        return
    fi

    #
    # Compare semantic versions.
    #
    if printf '%s\n%s\n' "$official" "$installed" |
        sort -V -C; then

        printf '%s\n' "$HEALTH_NEWER_VERSION"

    else

        printf '%s\n' "$HEALTH_UPDATE_AVAILABLE"

    fi
}

#
# Returns one of the standard HEALTH_* constants.
#
get_tor_health_status() {

    if ! get_tor_image_digest >/dev/null 2>&1; then
        printf '%s\n' "$HEALTH_NOT_INSTALLED"
        return
    fi

    printf '%s\n' "$HEALTH_PARTIALLY_VERIFIED"
}
