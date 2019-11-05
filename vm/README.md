## Criação do ambiente

**Ferramentas**

- gcloud (https://cloud.google.com/sdk/downloads)
- terraform
- docker
- docker-compose



**Regiões**

http://www.gcping.com/

- southamerica-east1 (PRD)



**Listar maquinas disponíveis**

```sh
gcloud compute machine-types list --filter="zone:(southamerica-east1) name~'standard'"
```



**Listar SO disponíveis**

```sh
gcloud compute images list --filter="name~'ubuntu'"
```



**Criar GCP Service Account (apenas 1 vez por projeto)**

```sh
https://cloud.google.com/resource-manager/docs/access-control-proj
https://console.cloud.google.com/iam-admin/serviceaccounts
```



**Habilitar Serviços GCP (apenas 1 vez por projeto)**

```sh
# iniciar projeto
gcloud init
gcloud config get-value project

# ou alterar projeto
gcloud projects list
gcloud config set project my-project

# habilitar serviços no GCP
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable serviceusage.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable containerregistry.googleapis.com

# verificar acessos
gcloud projects get-iam-policy <PROJECT_ID>
gcloud compute zones list --project=<PROJECT_ID>
```



**Gerar chave SSH**

```sh
ssh-keygen -t rsa -b 4096 -C "<EMAIL>"
```



### Executar Terraform

```sh
terraform get

terraform init

terraform validate -var-file="config/env.tfvars"

terraform plan -var-file="config/env.tfvars"

terraform apply -var-file="config/env.tfvars"

gcloud compute instances list

# Caso seja necessario destruir a maquina
terraform destroy -var-file="config/env.tfvars"
```



### Referências



**Terraform**


https://blog.marcelocavalcante.net/tags/terraform/

https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform



https://www.terraform.io/docs/providers/google/getting_started.html 

https://www.terraform.io/docs/provisioners/file.html



https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform 

https://cloud.google.com/community/tutorials/modular-load-balancing-with-terraform


https://www.terraform-best-practices.com/naming

https://blog.stigok.com/2018/04/13/terraform-staging-environment.html

https://www.terraform.io/docs/configuration/variables.html


https://imasters.com.br/devsecops/automatize-sua-estrutura-com-terraform

https://collabnix.com/5-minutes-to-run-your-first-docker-container-on-google-cloud-platform-using-terraform/

https://medium.com/@josephbleroy/using-terraform-with-google-cloud-platform-part-1-n-6b5e4074c059

https://www.popularowl.com/cloud-platforms/building-and-destroying-projects-with-terraform/

https://www.popularowl.com/api-first/automating-kong-api-gateway-automating-setup/ 



https://github.com/HoussemDellai/Terraform-GCP

https://github.com/HoussemDellai/Terraform-Demo

https://github.com/steinim/gcp-terraform-workshop

https://github.com/chiefy/tf-gcp-mediawiki

https://github.com/xxEvilxx/terraform_gcp_jenkins/blob/master/gcp_jenkins.tf

https://github.com/incubus8/gcp-cicd-terraform-jenkins
