# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands
- Init: `terraform init`
- Plan: `terraform plan`
- Apply: `terraform apply`
- Format: `terraform fmt`
- Validate: `terraform validate`
- Lint: `tflint`
- Environment specific: `cd environments/dev && terraform <command>`

## Style Guidelines
- Module structure: main.tf, variables.tf, outputs.tf
- Variable names: snake_case, descriptive and consistent
- Tag all resources with environment and name
- Use modules for reusable components
- Indent with 2 spaces
- Use resource blocks with relevant names
- Group related resources
- Use data sources when referencing existing resources
- Document variables with descriptions
- Use map(string) for tags
- Always define variable types
- Use conditional expressions for environment-specific logic