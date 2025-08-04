resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name      = "${var.environment}-${var.application}-${var.app_name}-ingress"
    namespace = var.namespace
    annotations = {
      "alb.ingress.kubernetes.io/wafv2-acl-arn"                = var.waf_acl_arn
      "alb.ingress.kubernetes.io/scheme"                       = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"                  = "ip"
      "alb.ingress.kubernetes.io/load-balancer-name"           = var.lb_name
      "alb.ingress.kubernetes.io/ip-address-type"              = "ipv4"
      "alb.ingress.kubernetes.io/healthcheck-protocol"         = "HTTP"
      "alb.ingress.kubernetes.io/healthcheck-port"             = "traffic-port"
      "alb.ingress.kubernetes.io/group.name"                   = var.ingress_group_name
      "alb.ingress.kubernetes.io/listen-ports"                 = jsonencode([{ "HTTPS" : 443 }, { "HTTP" : 80 }])
      "alb.ingress.kubernetes.io/certificate-arn"              = var.certificate_arn
      "alb.ingress.kubernetes.io/ssl-redirect"                 = "443"
      "alb.ingress.kubernetes.io/backend-protocol"             = "HTTP"
      "alb.ingress.kubernetes.io/healthcheck-interval-seconds" = "15"
      "alb.ingress.kubernetes.io/healthcheck-timeout-seconds"  = "5"
      "alb.ingress.kubernetes.io/healthy-threshold-count"      = "5"
      "alb.ingress.kubernetes.io/unhealthy-threshold-count"    = "5"
      "alb.ingress.kubernetes.io/success-codes"                = "200-399"
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      host = var.url
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = var.service_name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}



resource "aws_route53_record" "alb_cname" {
  zone_id = var.route53_zone_id
  name    = var.url
  type    = "CNAME"
  ttl     = 300
  records = [var.record]
}
