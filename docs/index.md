## IaC Module - Elastic Container Service (ECS) 

### Content
- [Creating a Cluster ECS](#cluster-fargate)
- [Creating a Task Definition](#task-definition)
- [Creating a Service](#service)

<a name="cluster-fargate"></a>
#### Creating a Cluster Fargate

```hcl
module "cluster_fargate" {
  source = "github.com/PROJECT-DILI/DILI-AWS-ECS-IAC?ref=v1.0.0"

  providers = {
    aws = aws.virginia
  }

  create_cluster = true
  cluster_name   = "private"

  default_capacity_provider_strategy = [
    {
      name   = "FARGATE_SPOT"
      weight = 5
      base   = 5
    },
  ]
}
```
---
<a name="task-definition"></a>
#### Creating a Task Definition

```hcl
module "task_definition" {
  source = "github.com/PROJECT-DILI/DILI-AWS-ECS-IAC?ref=v1.0.0"

  providers = {
    aws = aws.virginia
  }

  create_task_definition  = true
  family_name             = "container-ecs"
  container_definitions   = data.template_file.container_definitions_ecs.rendered
  task_network_mode       = "awsvpc"
  task_role_arn           = "arn:aws:iam::132972109843:role/ecs-task-execution"
  task_execution_role_arn = "arn:aws:iam::132972109843:role/ecs-task-execution"
  task_memory             = 512

  task_tags = {
    Terraform = true
  }
}
```
---
<a name="service"></a>
#### Creating a Service

```hcl
module "service" {
  source = "github.com/PROJECT-DILI/DILI-AWS-ECS-IAC?ref=v1.0.0"

  providers = {
    aws = aws.virginia
  }

  create_service            = true
  service_name              = "service-ecs"
  service_task_definition   = "container-ecs"
  service_desired_count     = 1
  cluster_name              = "private"
  cluster_arn               = "arn:aws:ecs:us-east-1:132972109843:cluster/private"
  create_autoscaling_config = true

  service_network_configuration = {
    subnets = ["subnet-08debfa840dbd24e8"]
  }

  service_load_balancers = [{
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:132972109843:targetgroup/ecs-target/231a8353c269bab6"
    container_name   = "container-ecs"
    container_port   = 8031
  }]
  service_tags = {
    Terraform = true
  }
}
```