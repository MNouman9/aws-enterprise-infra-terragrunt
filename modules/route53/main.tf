resource "aws_route53_zone" "this" {
  name          = var.zone_name
  comment       = var.comment
  force_destroy = var.force_destroy

  tags = var.tags
}


resource "aws_route53_record" "this" {
  for_each = local.recordsets

  zone_id = aws_route53_zone.this.id

  name                             = each.value.name != "" ? "${each.value.name}.${aws_route53_zone.this.name}" : aws_route53_zone.this.name
  type                             = each.value.type
  ttl                              = lookup(each.value, "ttl", null)
  records                          = contains(keys(each.value), "alias") ? null : each.value.records
  set_identifier                   = lookup(each.value, "set_identifier", null)
  health_check_id                  = lookup(each.value, "health_check_id", null)
  multivalue_answer_routing_policy = lookup(each.value, "multivalue_answer_routing_policy", null)
  allow_overwrite                  = lookup(each.value, "allow_overwrite", false)

  dynamic "alias" {
    for_each = contains(keys(each.value), "alias") ? [each.value.alias] : []
    content {
      name                   = each.value.alias.name
      zone_id                = try(each.value.alias.zone_id, aws_route53_zone.this.id)
      evaluate_target_health = lookup(each.value.alias, "evaluate_target_health", false)
    }
  }

  dynamic "failover_routing_policy" {
    for_each = length(keys(lookup(each.value, "failover_routing_policy", {}))) == 0 ? [] : [true]
    content {
      type = each.value.failover_routing_policy.type
    }
  }

  dynamic "weighted_routing_policy" {
    for_each = length(keys(lookup(each.value, "weighted_routing_policy", {}))) == 0 ? [] : [true]
    content {
      weight = each.value.weighted_routing_policy.weight
    }
  }

  dynamic "geolocation_routing_policy" {
    for_each = length(keys(lookup(each.value, "geolocation_routing_policy", {}))) == 0 ? [] : [true]
    content {
      continent   = lookup(each.value.geolocation_routing_policy, "continent", null)
      country     = lookup(each.value.geolocation_routing_policy, "country", null)
      subdivision = lookup(each.value.geolocation_routing_policy, "subdivision", null)
    }
  }

  depends_on = [
    aws_route53_zone.this
  ]
}