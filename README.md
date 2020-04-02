## Terraform Excercise

Terraform code base to create a simple vpc in multiple regions with a local
backend statefile

## project structure
The project is strucutred in a specific way that each region has its own folder
and uses a common module structure to create the vpc. The statefiles are stored
in the state_files folder but in a real world it should be stored in S3 with
filelock

```
.
├── eu-west-1
│   ├── dublin.tfvars
│   ├── main.tf
│   └── variables.tf
├── modules
│   └── vpc
│       ├── main.tf
│       └── variables.tf
├── README.md
├── state_files
│   ├── eu-west-1.tfstate
│   └── us-east-1.tfstate
└── us-east-1
    ├── main.tf
    ├── variables.tf
    └── virginia.tfvars

```

## Executing a specific region
```
#Building Ireland region
cd eu-west-1
tf init && tf apply -var-file=dublin.tfvars -auto-approve

#validating output
tf output nginx_domain |xargs curl

#Building US-East region
cd us-east-1
tf init && tf apply -var-file=virginia.tfvars -auto-approve

#validating output
tf output nginx_domain |xargs curl
```

Task 1 & 2 - Done

Task 3 - use an autoscaling group and build the vms behind Load Balancer

Task 4 - Add private subnets from the left over cidr range or add an second cidr block to the vpc range and build the nginx hosts in private subnet and Load Balancer in public subnet

Task 5 - Add the code block to build the bastion VM similar to the existing VM creation and variablise the count value based on variable existance
