# bbog-dig-aws-ecs-iac
Terraform module for AWS ECS

## Terraform versions

In current version of this module, it works with `Terraform versions >= v0.12.7`

## Documentation
To see all the module documentation, do click [here](https://aws-ecs-iac.github.EXAMPLE.co/).
## List of Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create_cluster | Whether to create the ECS cluster | bool | `true` | no |
| cluster_name | The ECS cluster name | string | `""` | no |
| tags | A mapping of tags to assign to the resource | map(string) | `{}` | no |
| cluster_tags | A mapping of tags to assign to the ECS cluster | map(string) | `{}` | yes |
| ecs_capacity_providers | List of short names of one or more capacity providers to associate with the cluster | list(string) | `["FARGATE", "FARGATE_SPOT"]` | no |
| default_capacity_provider_strategy | The capacity provider strategy to use by default for the cluster. Can be one or more | any | `[{name   = "FARGATE" weight = 5 base   = 5},{name   = "FARGATE_SPOT" weight = 1 base   = 5}]` | no |
| create_task_definition | Whether to create the ECS Task Definition | bool | `true` | no |
| family_name | A unique name for your task definition | string | `""` | no |
| task_role_arn | The ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services | string | `""` | no |
| task_execution_role_arn | The Amazon Resource Name (ARN) of the task execution role that the Amazon ECS container agent and the Docker daemon can assume | string | `""` | no |
| container_definitions | Full compiled JSON for container definitions | string | `""` | no |
| task_network_mode | The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host | string | `"bridge"` | no |
| task_ipc_mode | The IPC resource namespace to be used for the containers in the task The valid values are host, task, and none | string | `"host"` | no |
| task_pid_mode | The process namespace to use for the containers in the task. The valid values are host and task | string | `"host"` | no |
| task_volumes | A set of volume blocks that containers in your task may use | any | `[]` | no |
| task_placement_constraints | A set of placement constraints rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10 | any | `[]` | no |
| task_cpu | The number of cpu units used by the task. If the requires_compatibilities is FARGATE this field is required | number | `64` | no |
| task_memory | The amount (in MiB) of memory used by the task. If the requires_compatibilities is FARGATE this field is required | number | `256` | no |
| task_requires_compatibilities | A set of launch types required by the task. The valid values are EC2 and FARGATE | list(string) | `["EC2"]` | no |
| task_proxy_configuration | The proxy configuration details for the App Mesh proxy | any | `{}` | no |
| task_tags | Key-value mapping of resource tags | map(string) | `{}` | no |
| task_use_fargate | Whether to use FARGATE for Task Definition | bool | `true` | no |
| create_service | Whether to create the ECS service | bool | `true` | no |
| service_name | The name of the service (up to 255 letters, numbers, hyphens, and underscores) | string | `n/a` | yes |
| service_task_definition | The family and revision (family:revision) or full ARN of the task definition that you want to run in your service | string | `n/a` | yes |
| service_use_fargate | Whether to use ECS Fargate instead of EC2 | bool | `true` | no |
| service_use_daemon | Whether to use service in mode DAEMON instead of REPLICA | bool | `false` | no |
| service_desired_count | The number of instances of the task definition to place and keep running. Defaults to 0 | number | `0` | no |
| service_cluster_name | Name of an ECS cluster | string | `n/a` | yes |
| service_iam_role_arn | ARN of the IAM role that allows Amazon ECS to make calls to your load balancer on your behalf | string | `""` | no |
| service_deployment_maximum_percent | The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment | number | `100` | no |
| service_deployment_minimum_healthy_percent | The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment | number | `0` | no |
| service_enable_ecs_managed_tags | Specifies whether to enable Amazon ECS managed tags for the tasks within the service | bool | `true` | no |
| service_propagate_tags | Specifies whether to propagate the tags from the task definition or the service to the tasks | string | `SERVICE` | no |
| service_ordered_placement_strategy | Service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence | any | `[]` | no |
| service_health_check_grace_period_seconds | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647 | number | `10` | no |
| service_load_balancer | A load balancer block. Load balancers documented below | any | `{}` | no |
| service_placement_constraints | rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10 | any | `[]` | no |
| service_network_configuration | The network configuration for the service. This parameter is required for task definitions that use the awsvpc network mode to receive their own Elastic Network Interface, and it is not supported for other network modes | any | `{}` | no |
| service_registries | The service discovery registries for the service. The maximum number of service_registries blocks is 1 | any | `{}` | no |
| service_tags | Key-value mapping of resource tags | map(string) | `{}` | no |
| service_platform_version | The platform version on which to run your service. Only applicable for launch_type set to FARGATE | string | `"LATEST"` | no |
| create_autoscaling_config | Whether to create an autoscaling configuration for the ECS service | bool | `false` | no |
| autoscaling_target_max_capacity | The max capacity of task for your ECS service autoscaling configuration | number | `3` | no |
| autoscaling_target_min_capacity | The min capacity of task for your ECS service autoscaling configuration | number | `1` | no |
| autoscaling_average_mem_utilization_trigger | The percent of average memory utilization to scale up | number | `80` | no |
| autoscaling_average_cpu_utilization_trigger | The percent of average cpu utilization to scale up | number | `60` | no |
| cluster_arn | The ECS cluster arn | string | `""` | no |
| service_load_balancers | A load balancer block | any | `[]` | yes |
| create_life_policy | Whether to create the ECR policy | bool |`false`| no |
| enable_circuit_breaker | Specifies whether to enable deployment circuit breaker | bool |`false`| no |

## List of Outputs.

| Name | Description |
|------|-------------|
| this_ecs_cluster_id | The Amazon Resource Name (ARN) that identifies the cluster |
| this_ecs_cluster_arn | The Amazon Resource Name (ARN) that identifies the cluster |
| this_task_definition_arn | Full ARN of the Task Definition |
| this_task_definition_family | The family of the Task Definition |
| this_task_definition_revision | The revision of the task in a particular family |
| this_service_id | The Amazon Resource Name (ARN) that identifies the service |
| this_service_name | The name of the service |
| this_service_cluster | The Amazon Resource Name (ARN) of cluster which the service runs on |
| this_service_iam_role | The ARN of IAM role used for ELB |
| this_service_desired_count | The number of instances of the task definition |
| cluster_name | The cluster name |