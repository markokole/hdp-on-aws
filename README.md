# HDP on AWS
The repository creates a single HDP node or an HDP HA cluster in AWS using Terraform and Ansible.

## Prerequisities
### Infrastructure on AWS
Make sure the infrastructure is setup before continuing. Run `consul kv get -recurse | grep aws/generated` to check if all services in AWS are up and running. If not, [clone this repository](https://github.com/markokole/iac-aws-vpc) to prepare the infrastructure.

### HDP configuration in Consul
HDP configuration should be defined in Consul. This is done by (cloning)[https://github.com/markokole/iac-consul-config] and updating the `hdp.yml` file. Some examples are available already - for single and for HA cluster.
If you add a new configuration, make sure to also add a new file under `resources/templates/blueprints` that matches the configuration name with suffix `.json.tmpl`

## Add S3 secrets to Consul
**This is not a prerequisite. S3 offers an object storage to which HDFS connects to**
Prior to provisioning, in order to use S3 storage, the secrets should be put to Consul.
`consul kv put aws/s3a/access_key <ACCESS_KEY>`
and
`consul kv put aws/s3a/secret_key <SECRET_KEY>`
This way, Terraform will fetch the secrets from Consul. Remember, this is local Consul, running on the provisioner (machine you use for provisioning clusters).

## Provisioning
Step into `modules\provision-hdp` to create an HDP cluster. It is possible to create a single node cluster or a multinode HA cluster. The configuration of the cluster is prepared in [separate github repository](https://github.com/markokole/aws-terraform-hdp-config). The name of the cluster should be copied to *terraform.tfvars* in the following key-value format: `cluster_type = "single-min-s3"`.

### Initialization
Loading the modules and dependencies
`terraform init`

### Show plan
Show the provisioning plan - what is terraform planning to create.
`terraform plan`

### Run provisioning
Build the cluster - smart to run it with `nohup` and write output to a file
`nohup terraform apply -auto-approve > apply.log &`

### Destroy the HDP cluster
`terraform destroy -auto-approve`

## Access to the cluster
The security has been taken care of on the level of AWS with security groups. in folder `instance` is a file `securit_groups.tf` where new ports can be opened. For now, port for Ambari and Ranger are defined by default as well as SSH access for the IP address you are currently working on.
