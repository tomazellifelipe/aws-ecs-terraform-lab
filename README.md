# aws-ecs-terraform-lab

Tutorial para criacao de uma stack utilizando aws ecs de madeira serverless utilizando fargate

- Criar um usuario para terraform na aws com permissoes de administrador (nao eh necessario habilitar o login via console)
- Criar um arquivo terraform.auto.tfvars
- Caso esteja utilizando git/github adicionar este arquivo em `.gitignore`
  ```
  # Local .terraform directories
  **/.terraform/*

  # .tfstate files
  *.tfstate
  *.tfstate.*

  # Crash log files
  crash.log
  crash.*.log

  # Exclude all .tfvars files, which are likely to contain sensitive data, such as
  # password, private keys, and other secrets. These should not be part of version 
  # control as they are data points which are potentially sensitive and subject 
  # to change depending on the environment.
  *.tfvars
  *.tfvars.json

  # Ignore override files as they are usually used to override resources locally and so
  # are not checked in
  override.tf
  override.tf.json
  *_override.tf
  *_override.tf.json

  # Include override files you do wish to add to version control using negated pattern
  # !example_override.tf

  # Include tfplan files to ignore the plan output of command: terraform plan -out=tfplan
  # example: *tfplan*

  # Ignore CLI configuration files
  .terraformrc
  terraform.rc
  ```
- Criar credenciais de acesso para o usuario da aws
