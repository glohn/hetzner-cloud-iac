output "storage_box_id" {
  description = "ID of the Storage Box"
  value       = var.storage_box_type != null ? data.external.storage_box_info[0].result.id : ""
}

