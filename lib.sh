#!/usr/bin/env bash
set -u

_use_color() {
    use_color=0
    if [[ -t 1 ]]; then
        use_color=1
    fi
}

_log() {
    local level="$1"; shift
    local timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    local color=37
    [[ "$level" == "INFO" ]] && color=36
    [[ "$level" == "WARN" ]] && color=33
    [[ "$level" == "ERROR" ]] && color=31
    [[ "$level" == "DEBUG" ]] && color=35

    if [[ "$use_color" -eq 1 ]]; then
    printf "\033[%dm%s: [%-8ss] %s\033[0m\n" "$color" "$timestamp" "$level" "$*"
    else
    printf "%s [%-8s] %s\n" "$timestamp" "$level" "$*"
    fi
}

log_info()  { _log "INFO"  "$@"; }
log_warn()  { _log "WARN"  "$@"; }
log_error() { _log "ERROR" "$@"; }
log_fatal() { _log "FATAL" "$@"; exit 1; }
log_debug() {
    if [[ "$DEBUG" == "true" ]]; then
    _log "DEBUG" "$@";
    fi
}

_use_color
