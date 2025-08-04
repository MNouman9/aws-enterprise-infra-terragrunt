locals {
  # Convert records to a map with string keys
  recordsets = {
    for idx, rs in var.records :
    "${rs.name}_${rs.type}_${idx}" => merge(rs, {
      records = try(rs.records, [])
    })
  }
} 