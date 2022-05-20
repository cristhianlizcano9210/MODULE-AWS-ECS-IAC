output "this_ecs_cluster_id" {
  description = "The Amazon Resource Name (ARN) that identifies the cluster"
  value       = element(concat(aws_ecs_cluster.this.*.id, [""]), 0)
}

output "this_ecs_cluster_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the cluster"
  value       = element(concat(aws_ecs_cluster.this.*.arn, [""]), 0)
}

output "cluster_name" {
  description = "The cluster name"
  value       = element(concat(aws_ecs_cluster.this.*.name, [""]), 0)
}

output "this_task_definition_arn" {
  description = "Full ARN of the Task Definition"
  value       = element(concat(aws_ecs_task_definition.this_no_fargate.*.arn, aws_ecs_task_definition.this.*.arn, [""]), 0)
}

output "this_task_definition_family" {
  description = "The family of the Task Definition"
  value       = element(concat(aws_ecs_task_definition.this_no_fargate.*.family, aws_ecs_task_definition.this.*.family, [""]), 0)
}

output "this_task_definition_revision" {
  description = "The revision of the task in a particular family"
  value       = element(concat(aws_ecs_task_definition.this_no_fargate.*.revision, aws_ecs_task_definition.this.*.revision, [""]), 0)
}

output "this_service_id" {
  description = "The Amazon Resource Name (ARN) that identifies the service"
  value       = element(concat(aws_ecs_service.this_no_fargate_no_daemon.*.id, aws_ecs_service.this_no_fargate.*.id, aws_ecs_service.this.*.id, [""]), 0)
}

output "this_service_name" {
  description = "The name of the service"
  value       = element(concat(aws_ecs_service.this_no_fargate_no_daemon.*.name, aws_ecs_service.this_no_fargate.*.name, aws_ecs_service.this.*.name, [""]), 0)
}

output "this_service_cluster" {
  description = "The Amazon Resource Name (ARN) of cluster which the service runs on"
  value       = element(concat(aws_ecs_service.this_no_fargate_no_daemon.*.cluster, aws_ecs_service.this_no_fargate.*.cluster, aws_ecs_service.this.*.cluster, [""]), 0)
}

output "this_service_iam_role" {
  description = "The ARN of IAM role used for ELB"
  value       = element(concat(aws_ecs_service.this_no_fargate_no_daemon.*.iam_role, aws_ecs_service.this_no_fargate.*.iam_role, aws_ecs_service.this.*.iam_role, [""]), 0)
}

output "this_service_desired_count" {
  description = "The number of instances of the task definition"
  value       = element(concat(aws_ecs_service.this_no_fargate_no_daemon.*.desired_count, aws_ecs_service.this_no_fargate.*.desired_count, aws_ecs_service.this.*.desired_count, [""]), 0)
}
