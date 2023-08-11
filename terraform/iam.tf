resource "aws_iam_role" "iam_flojoy_hyperplot_data" {
    assume_role_policy    = file("./files/role_flojoy_hyperplot_data.json")
    force_detach_policies = false
    managed_policy_arns   = [
        "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
        "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole",
    ]
    name                  = "iam_flojoy_hyperplot_data"

    inline_policy {
        name   = "policy_flojoy_hyperplot_data"
        policy = templatefile(
          "./files/policy_flojoy_hyperplot_data.json",
          { 
            REGION = var.region
          }
        )
    }
}