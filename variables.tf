variable "create_cluster" {
  description = "Whether to create the ECS cluster"
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "The ECS cluster name"
  type        = string
  default     = ""
}

variable "cluster_arn" {
  type        = string
  default     = ""
  description = "The ECS cluster arn"
}


variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "cluster_tags" {
  description = "A mapping of tags to assign to the ECS cluster"
  type        = map(string)
  default     = {}
}

variable "ecs_capacity_providers" {
  description = "List of short names of one or more capacity providers to associate with the cluster"
  type        = list(string)
  default     = ["FARGATE", "FARGATE_SPOT"]
}

variable "default_capacity_provider_strategy" {
  description = "The capacity provider strategy to use by default for the cluster. Can be one or more"
  type        = any
  default = [
    {
      name   = "FARGATE"
      weight = 5
      base   = 5
    },
    {
      name   = "FARGATE_SPOT"
      weight = 1
      base   = 5
    },
  ]
}

variable "create_task_definition" {
  description = "Whether to create the ECS Task Definition"
  type        = string
  default     = false
}

variable "family_name" {
  description = "A unique name for your task definition"
  type        = string
  default     = ""
}

variable "task_role_arn" {
  description = "The ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services"
  type        = string
  default     = ""
}

variable "task_execution_role_arn" {
  description = "The Amazon Resource Name (ARN) of the task execution role that the Amazon ECS container agent and the Docker daemon can assume"
  type        = string
  default     = ""
}

variable "container_definitions" {
  description = "Full compiled JSON for container definitions"
  type        = string
  default     = ""
}

variable "task_network_mode" {
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host"
  type        = string
  default     = "bridge"
}

variable "task_ipc_mode" {
  description = "The IPC resource namespace to be used for the containers in the task The valid values are host, task, and none"
  type        = string
  default     = "host"
}

variable "task_pid_mode" {
  description = "The process namespace to use for the containers in the task. The valid values are host and task"
  type        = string
  default     = "host"
}

variable "task_volumes" {
  description = "A set of volume blocks that containers in your task may use"
  type        = any
  default     = []
}

variable "task_placement_constraints" {
  description = "A set of placement constraints rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10"
  type        = any
  default     = []
}

variable "task_cpu" {
  description = "The number of cpu units used by the task. If the requires_compatibilities is FARGATE this field is required"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "The amount (in MiB) of memory used by the task. If the requires_compatibilities is FARGATE this field is required"
  type        = number
  default     = 512
}

variable "task_requires_compatibilities" {
  description = "A set of launch types required by the task. The valid values are EC2 and FARGATE"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "task_proxy_configuration" {
  description = "The proxy configuration details for the App Mesh proxy"
  type        = any
  default     = {}
}

variable "task_tags" {
  description = "Key-value mapping of resource tags for Task Definition"
  type        = map(string)
  default     = {}
}

variable "task_use_fargate" {
  description = "Whether to use FARGATE for Task Definition"
  type        = bool
  default     = true
}

variable "create_service" {
  description = "Whether to create the ECS service"
  type        = bool
  default     = false
}

variable "service_name" {
  description = "The name of the service (up to 255 letters, numbers, hyphens, and underscores)"
  type        = string
  default     = ""
}

variable "service_task_definition" {
  description = "The family and revision (family:revision) or full ARN of the task definition that you want to run in your service"
  type        = string
  default     = ""
}

variable "service_use_fargate" {
  description = "Whether to use ECS Fargate instead of EC2"
  type        = bool
  default     = true
}

variable "service_use_daemon" {
  description = "Whether to use service in mode DAEMON instead of REPLICA"
  type        = bool
  default     = false
}

variable "service_desired_count" {
  description = "The number of instances of the task definition to place and keep running. Defaults to 0"
  type        = number
  default     = 0
}

variable "service_cluster_name" {
  description = "Name of an ECS cluster"
  type        = string
  default     = ""
}

variable "service_iam_role_arn" {
  description = "ARN of the IAM role that allows Amazon ECS to make calls to your load balancer on your behalf"
  type        = string
  default     = ""
}

variable "service_deployment_maximum_percent" {
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment"
  type        = number
  default     = 100
}

variable "service_deployment_minimum_healthy_percent" {
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment"
  type        = number
  default     = 0
}

variable "service_enable_ecs_managed_tags" {
  description = "Specifies whether to enable Amazon ECS managed tags for the tasks within the service"
  type        = bool
  default     = true
}

variable "service_propagate_tags" {
  description = "Specifies whether to propagate the tags from the task definition or the service to the tasks"
  type        = string
  default     = "SERVICE"
}

variable "service_ordered_placement_strategy" {
  description = "Service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence"
  type        = any
  default     = []
}

variable "service_health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647"
  type        = number
  default     = 10
}

variable "service_load_balancers" {
  description = "A load balancer block"
  type        = any
  default     = []
}

variable "service_placement_constraints" {
  description = "Rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10"
  type        = any
  default     = []
}

variable "service_network_configuration" {
  description = "The network configuration for the service. This parameter is required for task definitions that use the awsvpc network mode to receive their own Elastic Network Interface, and it is not supported for other network modes"
  type        = any
  default     = {}
}

variable "service_registries" {
  description = "The service discovery registries for the service. The maximum number of service_registries blocks is 1"
  type        = any
  default     = {}
}

variable "service_tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}

variable "service_platform_version" {
  description = "The platform version on which to run your service. Only applicable for launch_type set to FARGATE"
  type        = string
  default     = "LATEST"
}

variable "create_autoscaling_config" {
  description = "Whether to create an autoscaling configuration for the ECS service"
  type        = bool
  default     = false
}

variable "autoscaling_target_max_capacity" {
  description = "The max capacity of task for your ECS service autoscaling configuration"
  type        = number
  default     = 4
}

variable "autoscaling_target_min_capacity" {
  description = "The min capacity of task for your ECS service autoscaling configuration"
  type        = number
  default     = 1
}

variable "autoscaling_average_mem_utilization_trigger" {
  description = "The percent of average memory utilization to scale up"
  type        = number
  default     = 80
}

variable "autoscaling_average_cpu_utilization_trigger" {
  description = "The percent of average cpu utilization to scale up"
  type        = number
  default     = 60
}

variable "enable_circuit_breaker" {
  description = "Specifies whether to enable deployment circuit breaker"
  type        = bool
  default     = false
}