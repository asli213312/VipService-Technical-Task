listen {
  port = 4040
  address = "0.0.0.0"
}

namespace "app" {
  source = {
    files = ["/var/log/nginx/access.log"]
  }

  format = "$remote_addr - $remote_user [$time_local] \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent\""

  labels {
    app = "backend"
  }

  metrics {
    counter {
      name  = "http_requests_total"
      help  = "Total number of HTTP requests"
      match = ".*"

      labels {
        status = "$status"
        method = "$request_method"
        path   = "$request_uri"
      }
    }

    counter {
      name  = "http_errors_total"
      help  = "Total number of HTTP errors (5xx)"
      match = ".*"

      labels {
        status = "$status"
        method = "$request_method"
      }
    }
  }
}