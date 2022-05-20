locals {
  tags = {
    Terraform = true
  }
}

resource "aws_ecs_cluster" "this" {
  count              = var.create_cluster ? 1 : 0
  name               = var.cluster_name
  capacity_providers = var.ecs_capacity_providers

  dynamic "default_capacity_provider_strategy" {
    for_each = var.ecs_capacity_providers[0] == "FARGATE" || var.ecs_capacity_providers[0] == "FARGATE_SPOT" || var.ecs_capacity_providers[1] == "FARGATE" || var.ecs_capacity_providers[1] == "FARGATE_SPOT" ? var.default_capacity_provider_strategy : []

    content {
      capacity_provider = default_capacity_provider_strategy.value.name
      weight            = default_capacity_provider_strategy.value.weight
      base              = default_capacity_provider_strategy.value.base
    }
  }

  setting { 
    name = "containerInsights"
    value = "enabled"
  }

  tags = merge(
    local.tags,
    var.tags,
    var.cluster_tags,
  )
}

resource "aws_ecs_task_definition" "this_no_fargate" {
  count                 = var.create_task_definition && var.service_use_fargate == false ? 1 : 0
  family                = var.family_name
  container_definitions = var.container_definitions
  task_role_arn         = var.task_role_arn
  execution_role_arn    = var.task_execution_role_arn
  network_mode          = var.task_network_mode
  ipc_mode              = var.task_ipc_mode
  pid_mode              = var.task_pid_mode

  dynamic "volume" {
    for_each = length(var.task_volumes) == 0 ? [] : var.task_volumes

    content {
      name      = volume.value.name
      host_path = lookup(volume.value, "host_path", null)

      dynamic "docker_volume_configuration" {
        for_each = length(keys(volume.value.docker_volume_configuration)) == 0 ? [] : [volume.value.docker_volume_configuration]

        content {
          scope         = lookup(docker_volume_configuration.value, "scope", null)
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
          driver        = lookup(docker_volume_configuration.value, "driver", null)
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
          labels        = lookup(docker_volume_configuration.value, "labels", null)
        }
      }
    }
  }

  dynamic "placement_constraints" {
    for_each = length(var.task_placement_constraints) == 0 ? [] : var.task_placement_constraints

    content {
      type       = placement_constraints.value.type
      expression = lookup(placement_constraints.value, "expression", null)
    }
  }

  cpu                      = var.task_cpu
  memory                   = var.task_memory
  requires_compatibilities = var.task_requires_compatibilities

  dynamic "proxy_configuration" {
    for_each = length(keys(var.task_proxy_configuration)) == 0 ? [] : [var.task_proxy_configuration]

    content {
      container_name = proxy_configuration.value.container_name
      properties     = proxy_configuration.value.properties
      type           = lookup(proxy_configuration.value, "type", null)
    }
  }

  tags = merge(
    local.tags,
    var.task_tags,
  )

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_ecs_task_definition" "this" {
  count                 = var.create_task_definition && var.task_use_fargate ? 1 : 0
  family                = var.family_name
  container_definitions = var.container_definitions
  task_role_arn         = var.task_role_arn
  execution_role_arn    = var.task_execution_role_arn
  network_mode          = var.task_network_mode

  dynamic "volume" {
    for_each = length(var.task_volumes) == 0 ? [] : var.task_volumes

    content {
      name      = volume.value.name
      host_path = lookup(volume.value, "host_path", null)

      dynamic "docker_volume_configuration" {
        for_each = length(keys(volume.value.docker_volume_configuration)) == 0 ? [] : [volume.value.docker_volume_configuration]

        content {
          scope         = lookup(docker_volume_configuration.value, "scope", null)
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
          driver        = lookup(docker_volume_configuration.value, "driver", null)
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
          labels        = lookup(docker_volume_configuration.value, "labels", null)
        }
      }
    }
  }

  dynamic "placement_constraints" {
    for_each = length(var.task_placement_constraints) == 0 ? [] : var.task_placement_constraints

    content {
      type       = placement_constraints.value.type
      expression = lookup(placement_constraints.value, "expression", null)
    }
  }

  cpu                      = var.task_cpu
  memory                   = var.task_memory
  requires_compatibilities = var.task_requires_compatibilities

  dynamic "proxy_configuration" {
    for_each = length(keys(var.task_proxy_configuration)) == 0 ? [] : [var.task_proxy_configuration]

    content {
      container_name = proxy_configuration.value.container_name
      properties     = proxy_configuration.value.properties
      type           = lookup(proxy_configuration.value, "type", null)
    }
  }

  tags = merge(
    local.tags,
    var.task_tags,
  )

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_ecs_service" "this_no_fargate_no_daemon" {
  count               = var.create_service && var.service_use_fargate == false && var.service_use_daemon == false ? 1 : 0
  name                = var.service_name
  task_definition     = var.service_task_definition
  desired_count       = var.service_desired_count
  launch_type         = "EC2"
  scheduling_strategy = "REPLICA"
  cluster             = var.cluster_arn
  iam_role            = var.service_iam_role_arn

  deployment_controller {
    type = "ECS"
  }

  deployment_maximum_percent         = var.service_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.service_deployment_minimum_healthy_percent
  enable_ecs_managed_tags            = var.service_enable_ecs_managed_tags
  propagate_tags                     = var.service_enable_ecs_managed_tags ? var.service_propagate_tags : null

  dynamic "ordered_placement_strategy" {
    for_each = length(var.service_ordered_placement_strategy) == 0 ? [] : var.service_ordered_placement_strategy

    content {
      type  = ordered_placement_strategy.value.type
      field = ordered_placement_strategy.value.field
    }
  }

  health_check_grace_period_seconds = var.service_health_check_grace_period_seconds

  dynamic "load_balancer" {
    for_each = length(var.service_load_balancers) == 0 ? [] : var.service_load_balancers

    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }

  dynamic "placement_constraints" {
    for_each = length(var.service_placement_constraints) == 0 ? [] : var.service_placement_constraints

    content {
      type       = placement_constraints.value.type
      expression = lookup(placement_constraints.value, "expression", null)
    }
  }

  dynamic "network_configuration" {
    for_each = length(keys(var.service_network_configuration)) == 0 ? [] : [var.service_network_configuration]

    content {
      subnets          = network_configuration.value.subnets
      security_groups  = network_configuration.value.security_groups
      assign_public_ip = network_configuration.value.assign_public_ip
    }
  }

  dynamic "service_registries" {
    for_each = length(keys(var.service_registries)) == 0 ? [] : [var.service_registries]

    content {
      registry_arn   = service_registries.value.registry_arn
      port           = service_registries.value.port
      container_port = service_registries.value.container_port
      container_name = service_registries.value.container_name
    }
  }

  tags = var.service_enable_ecs_managed_tags ? merge(local.tags, var.tags, var.service_tags) : {}

  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count,
      health_check_grace_period_seconds,
      deployment_minimum_healthy_percent,
      deployment_maximum_percent,
    ]
  }

  depends_on = [var.service_load_balancers, var.service_network_configuration, var.service_task_definition, var.service_iam_role_arn]
}

resource "aws_ecs_service" "this_no_fargate" {
  count               = var.create_service && var.service_use_fargate == false && var.service_use_daemon ? 1 : 0
  name                = var.service_name
  task_definition     = var.service_task_definition
  launch_type         = "EC2"
  scheduling_strategy = "DAEMON"
  cluster             = var.cluster_arn
  iam_role            = var.service_iam_role_arn

  deployment_controller {
    type = "ECS"
  }

  enable_ecs_managed_tags = var.service_enable_ecs_managed_tags
  propagate_tags          = var.service_enable_ecs_managed_tags ? var.service_propagate_tags : null

  dynamic "ordered_placement_strategy" {
    for_each = length(var.service_ordered_placement_strategy) == 0 ? [] : var.service_ordered_placement_strategy

    content {
      type  = ordered_placement_strategy.value.type
      field = ordered_placement_strategy.value.field
    }
  }

  health_check_grace_period_seconds = var.service_health_check_grace_period_seconds

  dynamic "load_balancer" {
    for_each = length(var.service_load_balancers) == 0 ? [] : var.service_load_balancers

    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }

  dynamic "placement_constraints" {
    for_each = length(var.service_placement_constraints) == 0 ? [] : var.service_placement_constraints

    content {
      type       = placement_constraints.value.type
      expression = placement_constraints.value.expression
    }
  }

  dynamic "network_configuration" {
    for_each = length(keys(var.service_network_configuration)) == 0 ? [] : [var.service_network_configuration]

    content {
      subnets          = network_configuration.value.subnets
      security_groups  = network_configuration.value.security_groups
      assign_public_ip = network_configuration.value.assign_public_ip
    }
  }

  dynamic "service_registries" {
    for_each = length(keys(var.service_registries)) == 0 ? [] : [var.service_registries]

    content {
      registry_arn   = service_registries.value.registry_arn
      port           = service_registries.value.port
      container_port = service_registries.value.container_port
      container_name = service_registries.value.container_name
    }
  }

  tags = var.service_enable_ecs_managed_tags ? merge(local.tags, var.tags, var.service_tags) : {}

  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count,
      health_check_grace_period_seconds,
      deployment_minimum_healthy_percent,
      deployment_maximum_percent,
    ]
  }

  depends_on = [var.service_load_balancers, var.service_network_configuration, var.service_task_definition, var.service_iam_role_arn]
}

resource "aws_ecs_service" "this" {
  count               = var.create_service && var.service_use_fargate ? 1 : 0
  name                = var.service_name
  task_definition     = var.service_task_definition
  desired_count       = var.service_desired_count
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"
  platform_version    = var.service_platform_version
  cluster             = var.cluster_arn

  # deployment_configuration {
  #   deployment_circuit_breaker {
  #     enable   = var.enable_circuit_breaker
  #     rollback = var.enable_circuit_breaker
  #   }
  #   maximum_percent = 100
  #   minimum_healthy_percent = 100
  # }
  deployment_controller {
    type = "ECS"
  }

  deployment_maximum_percent         = var.service_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.service_deployment_minimum_healthy_percent
  enable_ecs_managed_tags            = var.service_enable_ecs_managed_tags
  propagate_tags                     = var.service_enable_ecs_managed_tags ? var.service_propagate_tags : null

  dynamic "ordered_placement_strategy" {
    for_each = length(var.service_ordered_placement_strategy) == 0 ? [] : var.service_ordered_placement_strategy

    content {
      type  = ordered_placement_strategy.value.type
      field = ordered_placement_strategy.value.field
    }
  }

  health_check_grace_period_seconds = var.service_health_check_grace_period_seconds

  dynamic "load_balancer" {
    for_each = length(var.service_load_balancers) == 0 ? [] : var.service_load_balancers

    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }

  dynamic "placement_constraints" {
    for_each = length(var.service_placement_constraints) == 0 ? [] : var.service_placement_constraints

    content {
      type       = placement_constraints.value.type
      expression = placement_constraints.value.expression
    }
  }

  dynamic "network_configuration" {
    for_each = length(keys(var.service_network_configuration)) == 0 ? [] : [var.service_network_configuration]

    content {
      subnets          = network_configuration.value.subnets
      security_groups  = lookup(network_configuration.value, "security_groups", null)
      assign_public_ip = lookup(network_configuration.value, "assign_public_ip", null)
    }
  }

  dynamic "service_registries" {
    for_each = length(keys(var.service_registries)) == 0 ? [] : [var.service_registries]

    content {
      registry_arn   = service_registries.value.registry_arn
      port           = service_registries.value.port
      container_port = service_registries.value.container_port
      container_name = service_registries.value.container_name
    }
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count,
      health_check_grace_period_seconds,
    ]
  }

  tags       = var.service_enable_ecs_managed_tags ? merge(local.tags, var.tags, var.service_tags) : {}
  depends_on = [var.service_load_balancers, var.service_network_configuration, var.service_task_definition]
}

resource "aws_appautoscaling_target" "ecs_target" {
  count              = var.create_service && var.create_autoscaling_config ? 1 : 0
  max_capacity       = var.autoscaling_target_max_capacity
  min_capacity       = var.autoscaling_target_min_capacity
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  depends_on         = [aws_ecs_cluster.this, aws_ecs_service.this_no_fargate, aws_ecs_service.this]
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  count              = var.create_service && var.create_autoscaling_config ? 1 : 0
  name               = "ecs-${var.service_name}-mem-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = element(concat(aws_appautoscaling_target.ecs_target.*.resource_id, [""]), 0)
  scalable_dimension = element(concat(aws_appautoscaling_target.ecs_target.*.scalable_dimension, [""]), 0)
  service_namespace  = element(concat(aws_appautoscaling_target.ecs_target.*.service_namespace, [""]), 0)

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = var.autoscaling_average_mem_utilization_trigger
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  count              = var.create_service && var.create_autoscaling_config ? 1 : 0
  name               = "ecs-${var.service_name}-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = element(concat(aws_appautoscaling_target.ecs_target.*.resource_id, [""]), 0)
  scalable_dimension = element(concat(aws_appautoscaling_target.ecs_target.*.scalable_dimension, [""]), 0)
  service_namespace  = element(concat(aws_appautoscaling_target.ecs_target.*.service_namespace, [""]), 0)

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = var.autoscaling_average_cpu_utilization_trigger
  }
}
