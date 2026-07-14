DATE = formatdate("YYYY.MM.DD", timestamp())
APP = "steam-base-container"
SOURCE = "https://github.com/thelande/steam-base-container"
variable "GIT_SHA" {}

group "default" {
    targets = ["image-local"]
}

target "image" {
    inherits = ["docker-metadata-action"]
    args = {}
    labels = {
        "org.opencontainers.image.vendor" = "thelande"
        "org.opencontainers.image.source" = "https://github.com/thelande/steam-base-container"
        "org.opencontainers.image.created" = "${DATE}"
        "org.opencontainers.image.revision" = "${GIT_SHA}"
        "org.opencontainers.image.title" = "${APP}"
        "org.opencontainers.image.url" = "${SOURCE}"
    }
    no-cache = true
}

target "image-local" {
    inherits = ["image"]
    output = ["type=docker"]
    tags = ["${APP}:${DATE}"]
}

target "image-all" {
    inherits = ["image"]
    platforms = [
        "linux/amd64"
    ]
    tags = [
        "docker.io/thelande/${APP}:rolling",
        "docker.io/thelande/${APP}:sha-${GIT_SHA}"
    ]
}

target "docker-metadata-action" {}
