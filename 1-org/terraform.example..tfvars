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

// Must include the domain of the organization you are deploying the foundation.
domains_to_allow = ["cloudfoundationtoolkit.com"]

billing_data_users = "gcp-billing-admins@cloudfoundationtoolkit.com"

audit_data_users = "gcp-security-admins@cloudfoundationtoolkit.com"

org_id = "790475255155"

billing_account = "014B3B-FEFA55-F8DEA8"

default_region = "us-east1"

scc_notification_name = "scc-notify"

enable_hub_and_spoke = true

create_access_context_manager_access_policy = true

// Optional - for an organization with existing projects or for development/validation.
// Must be the same value used in step 0-bootstrap.
//parent_folder = "01234567890"

//scc_notification_filter = "state=\\\"ACTIVE\\\""


