clean:
	find . -type d -name ".terragrunt-cache" -exec rm -rf {} +
	find . -type d -name ".terraform" -exec rm -rf {} +
	find . -type f -name ".terraform.lock.hcl" -exec rm -rf {} +
	clear

providers:
	AWS_PROFILE=dev terragrunt providers --all
	
init:
	echo -e '\033[36m ------ Going to Init & Validate ------ \033[0m'
	terragrunt hcl format --working-dir ../../
	AWS_PROFILE=dev terragrunt init --all --parallelism=6
	AWS_PROFILE=dev terragrunt validate --all
	echo -e '\033[36m ------ Exiting Init & Validate ------ \033[0m'

plan:
	echo -e '\033[36m ------ Going to Plan ------ \033[0m'
	AWS_PROFILE=dev terragrunt plan --all --parallelism=6
	echo -e '\033[36m ------ Exiting Plan ------ \033[0m'

apply:
	echo -e '\033[36m ------ Going to Apply ------ \033[0m'
	AWS_PROFILE=dev terragrunt apply --all --parallelism=6
	echo -e '\033[36m ------ Exiting Apply ------ \033[0m'

deploy:
	echo -e '\033[36m ------ Going to Deploy ------ \033[0m'
	make plan
	make apply
	echo -e '\033[36m ------ Exiting Deploy ------ \033[0m'