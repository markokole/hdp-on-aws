# HDP on AWS

The repository creates an HDP High Availability cluster in AWS using Terraform and Ansible.

## Prerequisities

### Infrastructure on AWS

Make sure the infrastructure is setup before continuing. Run:

```bash
consul kv get -recurse | grep aws/generated
```

to check if VPC in AWS are up and running. You should see a few lines with key-value pairs for VPC. If not, [clone this repository](https://github.com/markokole/iac-aws-vpc) to prepare the infrastructure.

### HDP configuration in Consul

HDP configuration is defined in Consul. This is done by [cloning](https://github.com/markokole/iac-consul-config) and updating the `hdp.yml` file. Some examples are available already - a minimal one and one with some of the most popular services. If you add a new configuration, make sure to also add a new file under `resources/templates/blueprints` that matches the configuration name with suffix `.json.tmpl`

## Accessing S3

HDFS can access files from AWS S3. To do so, it needs access key and secret key which are written to *hdfs-site* in HDFS under properties *fs.s3a.access.key* and *fs.s3a.secret.key*. I have solved the AWS keys issue by adding *TF_VAR_s3a_access_key* and *TF_VAR_s3a_secret_key* to the environmental file that is being read by Docker when the container is run.

Terraform takes care of the rest. If you define variables as follows:

```bash
variable s3a_access_key {}
variable s3a_secret_key {}
```

in one of the *.tf files, the variable will read from respective environmental variables. Hashicorp's Vault would be the safest option, of course.

**This is not a prerequisite. S3 offers an object storage to which HDFS connects to**

## Provisioning

Step into `modules\provision-hdp` to create an HDP cluster. The configuration of the cluster is prepared in [separate github repository](https://github.com/markokole/iac-consul-config). The name of the cluster should be copied to *terraform.tfvars* in the following key-value format: `cluster_type = "multi-min-s3"`.

### Initialization

Loading the modules and dependencies

```bash
terraform init
```

### Show plan

Show the provisioning plan - what is terraform planning to create.

```bash
terraform plan
```

### Run provisioning

Build the cluster - smart to run it with `nohup` and write output to a file

```bash
nohup terraform apply -auto-approve > apply.log &
```

### Destroy the HDP cluster

```bash
terraform destroy -auto-approve
```

## Access to the cluster

The security has been taken care of on the level of AWS with security groups. in folder `instance` is a file `securit_groups.tf` where new ports can be opened. For now, port for Ambari and Ranger are defined by default as well as SSH access for the IP address you are currently working on.
