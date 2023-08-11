resource "aws_glue_job" "flojoy_hyperplot_data" {
    #identification
    name = "flojoy_hyperplot_data"
    description = "flojoy_hyperplot_data"
    #work configuration
    role_arn = aws_iam_role.iam_flojoy_hyperplot_data.arn
    command {
        script_location = var.script_location
        python_version  = "3"
    }
    default_arguments         = {
        "--TempDir"                          = "${var.script_location}/temporary/"
        "--enable-continuous-cloudwatch-log" = "true"
        "--enable-glue-datacatalog"          = "true"
        "--enable-job-insights"              = "true"
        "--enable-metrics"                   = "true"
        "--enable-spark-ui"                  = "true"
        "--job-bookmark-option"              = "job-bookmark-disable"
        "--job-language"                     = "python"
        "--spark-event-logs-path"            = "${var.script_location}/sparkHistoryLogs/"
        "--datalake-formats"                 = "iceberg"
    }
    #parameter configuration
    max_retries = 0
    timeout = 20
    number_of_workers = 3
    worker_type               = "G.1X"
    execution_class           = "STANDARD"
    glue_version              = "4.0"
    
}