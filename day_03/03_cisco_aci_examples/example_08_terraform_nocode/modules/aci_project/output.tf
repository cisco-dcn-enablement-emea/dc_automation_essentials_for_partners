output "project_frontend_epg_id" {
  description = "DN of the project's frontend EPG"
  value       = aci_application_epg.project_frontend.id
}

output "project_backend_epg_id" {
  description = "DN of the project's backend EPG"
  value       = aci_application_epg.project_backend.id
}

output "project_database_epg_id" {
  description = "DN of the project's database EPG"
  value       = aci_application_epg.project_database.id
}

output "project_outer_contract_id" {
  description = "DN of the project's outer contract"
  value       = aci_contract.project_outer_contract.id
}
