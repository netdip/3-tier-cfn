# Three-Tier Architecture in AWS (CloudFormation)

A three-tier architecture is a software architecture pattern where the application is broken down into three logical tiers: the presentation layer, the business logic layer and the data storage layer. Each of these layers or tiers does a specific task and can be managed independently of each other. This a shift from the monolithic way of building an application where the Loadbalancer in public subnet, the backend and the database are both sitting in private subnet. All private subnet resources can be manageable via bastion host for operation purpose.

![Example1](img/3-tier.png "Example of a successfull infra")

This three-tier cloud infrastructure build on Amazon Web Service (AWS) with services: Elastic Compute Cloud (EC2), Auto Scaling Group, Virtual Private Cloud(VPC), Elastic Load Balancer (ELB), RDS, Security Groups and the Internet Gateway. This infrastructure is designed to be highly available and fault tolerant.

Various cloudformation stacks used here to provision infrastructure automatically. High level overview of the stack is given below.

![Example2](img/cfn-stack.png "Example of cfn stack")
