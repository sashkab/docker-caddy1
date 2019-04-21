package main

import (
	"github.com/mholt/caddy/caddy/caddymain"

	// _ "github.com/pyed/ipfilter"
)

func main() {
	caddymain.EnableTelemetry = false
	caddymain.Run()
}
