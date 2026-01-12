# curl-impersonate Web Fetch

Use curl-impersonate to fetch web content while mimicking real browser TLS fingerprints. This bypasses bot detection that blocks standard curl/wget requests.

## Instructions

When you need to fetch a webpage that blocks standard requests, use curl-impersonate via the Bash tool.

### Available Commands

- `curl_chrome116` - Chrome 116 (recommended)
- `curl_chrome110` - Chrome 110
- `curl_ff117` - Firefox 117
- `curl_ff109` - Firefox 109

### Common Patterns

```bash
# Basic fetch (silent, follow redirects)
curl_chrome116 -sL 'https://example.com'

# Save to temp file for processing
curl_chrome116 -sL 'https://example.com' -o /tmp/page.html

# POST JSON
curl_chrome116 -sL -X POST -H 'Content-Type: application/json' -d '{"key":"value"}' 'https://example.com/api'

# With custom headers
curl_chrome116 -sL -H 'Authorization: Bearer token' 'https://example.com'
```

### When to Use

- WebFetch fails with 403/blocking errors
- Site has Cloudflare or similar protection
- User requests browser-like fetching
- Need to bypass TLS fingerprinting

### Workflow

1. Fetch content to temp file
2. Use Read tool to examine the content
3. Process as needed

Always use `-s` (silent) and `-L` (follow redirects) flags for cleaner output.
