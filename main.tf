provider "aws" {
  region = "ap-east-1"
}

resource "aws_backup_plan" "webserver_backup_plan" {
  name = "webserver-backup-plan"

  rule {
    rule_name         = "webserver-backup-rule"
    target_vault_name = aws_backup_vault.webserver_vault.name
    schedule          = "cron(0 17 * * ? *)"

    lifecycle {
      delete_after = 7
    }
  }
}

resource "aws_backup_vault" "webserver_vault" {
  name = "webserver-vault"
}

# assign resource to backup plan by tag
resource "aws_backup_selection" "resource_assign" {
  iam_role_arn = "arn:aws:iam::952800808852:role/service-role/AWSBackupDefaultServiceRole"
  name         = "webserver-backup-selection"
  plan_id      = aws_backup_plan.webserver_backup_plan.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "workload"
    value = "web"
  }
}