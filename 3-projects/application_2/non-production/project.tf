/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  env = "non-production"
  env_code        = element(split("", local.env), 0)
  shared_vpc_mode = var.enable_hub_and_spoke ? "net-spoke" : ""
}

data "google_projects" "projects" {
  filter = "parent.id:${split("/", data.google_active_folder.env.name)[1]} labels.application_name=shared-vpc-host labels.environment=${local.env} lifecycleState=ACTIVE"
}

data "google_compute_network" "shared_vpc" {
  name    = "vpc-${local.env_code}-shared-${local.shared_vpc_mode}"
  project = data.google_projects.projects.projects[0].project_id
}

module "project" {
  source                      = "../../../modules/single_project"
  org_id                      = var.org_id
  billing_account             = var.billing_account
  folder_id                   = data.google_active_folder.env.name
  environment                 = local.env
  vpc_type                    = "base"
  alert_spent_percents        = var.alert_spent_percents
  alert_pubsub_topic          = var.alert_pubsub_topic
  budget_amount               = var.budget_amount
  project_prefix              = var.project_prefix
  enable_hub_and_spoke        = var.enable_hub_and_spoke
  sa_roles                    = ["roles/editor"]
  enable_cloudbuild_deploy    = false
  activate_apis = [
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "accesscontextmanager.googleapis.com"
  ]

  vpc_service_control_attach_enabled = "true"
  vpc_service_control_perimeter_name = "accessPolicies/${var.access_context_manager_policy_id}/servicePerimeters/${lookup(var.perimeter_name, local.env)}"
  svpc_host_project_id = data.google_compute_network.shared_vpc.project
  project_parent_folder_id = module.folders.id

  # Metadata
  project_suffix    =  var.project_metadata["project_suffix"]
  application_name  =  var.project_metadata["application_name"]
  billing_code      =  var.project_metadata["billing_code"]
  primary_contact   =  var.project_metadata["primary_contact"]
  secondary_contact =  var.project_metadata["secondary_contact"]
  business_code     =  var.project_metadata["business_code"]
}