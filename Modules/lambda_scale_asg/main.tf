# In summary, this code sets up the minimum IAM permissions for a Lambda function to run and log to CloudWatch.
resource "aws_iam_role" "lambda_exec" {
  name = "${var.lambda_function_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com" //This means the role can be assumed only by Lambda service
      }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "asg_modify_policy" {
  name = "${var.lambda_function_name}-asg-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "autoscaling:SetDesiredCapacity",
        "autoscaling:DescribeAutoScalingGroups"
      ],
      Effect   = "Allow",
      Resource = "*" //Resource = "*" means it can modify any ASG in the account. 
                      # You can scope this to a specific ASG ARN if needed for least privilege
    }]
  })
}
resource "aws_iam_role_policy_attachment" "asg_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.asg_modify_policy.arn
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/${var.lambda_function_name}.py"
  output_path = "${path.module}/lambda/${var.lambda_function_name}.zip"
}

resource "aws_lambda_function" "asg_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_exec.arn
  handler          = "${var.lambda_function_name}.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  environment {
    variables = {
      ASG_NAME         = var.asg_name
      DESIRED_CAPACITY = var.desired_capacity
    }
  }
}

//Schedule the Lambda function to run at a specific time
resource "aws_cloudwatch_event_rule" "invoke_lambda" {
  count               = var.lambda_schedule_expression != null ? 1 : 0
  name                = "${var.lambda_function_name}-schedule"
  schedule_expression = var.lambda_schedule_expression
}
# It only gets created if var.lambda_schedule_expression is not null.


resource "aws_cloudwatch_event_target" "target" {
  count     = var.lambda_schedule_expression != null ? 1 : 0
  rule      = aws_cloudwatch_event_rule.invoke_lambda[0].name
  target_id = "lambda"
  arn       = aws_lambda_function.asg_lambda.arn
}
# This sets the target for the CloudWatch Event Rule to invoke the Lambda function when the schedule matches.

resource "aws_lambda_permission" "allow_events" {
  count         = var.lambda_schedule_expression != null ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asg_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.invoke_lambda[0].arn
}
# This permission allows CloudWatch Events to invoke the Lambda function based on the schedule defined in the event rule.



  


