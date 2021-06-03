package main

import (
    "log"
    "net/http"
    "strings"
)

func main() {
    mux := http.NewServeMux()

    fileServer := http.FileServer(http.Dir("./storage"))
    mux.Handle("/", http.StripPrefix("", neuter(fileServer)))

    err := http.ListenAndServe(":8080", mux)
    log.Fatal(err)
}

func neuter(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        if strings.HasSuffix(r.URL.Path, "/") {
            http.NotFound(w, r)
            return
        }

        next.ServeHTTP(w, r)
    })
}
