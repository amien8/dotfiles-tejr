# Shortcut to make HEAD requests with cURL; good for testing webpage
# compression and caching headers
curlh() {
    curl -IH 'Accept-Encoding: gzip,deflate' "$@"
}

