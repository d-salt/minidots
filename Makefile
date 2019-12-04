DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*)
EXCLUSIONS := .DS_Store .git .gitignore .gitmodules
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL := help

list: ## Show dot files in this repo
	@$(foreach file, $(DOTFILES), ls -dF $(file);)

deploy: ## Create symbolic link to home dir
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo ''
	@$(foreach file, $(DOTFILES), ln -snfv $(abspath $(file)) $(HOME)/$(file);)

update: ## Fetch changes fot this repo
	git pull origin master

install: update deploy ## Run make update, deploy, init
	@exec $$SHELL

clean: ## Remove the dot files and this repo
	@read -n 1 -p 'Are you sure? [yN]: ' ans; echo; \
			case "$$ans" in 'y') \
				echo 'Remove dot files in your home directory...'; \
				-$(foreach file, $(DOTFILES), rm -vrf $(HOME)/$(file);); \
				-rm -rf $(DOTPATH);; \
			esac


help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

