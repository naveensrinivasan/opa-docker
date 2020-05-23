# Open Policy Agent for Dockerfile

This is not a complete implementation of https://github.com/hadolint/hadolint in OPA. This is only start to move using OPA as a tool for validation.

To validate the dockerfile the `rego` code uses https://www.conftest.dev/ as a CLI.

## Output of the test

``` bash
conftest test Dockerfile
WARN - Dockerfile - Do not use latest tag with image: ["openjdk:8-jdk-alpine"]
FAIL - Dockerfile - blacklisted image found ["openjdk:8-jdk-alpine"]
FAIL - Dockerfile - Avoid using 'sudo' command: sudo apk add --no-cache python3 python3-dev build-base && pip3 install awscli==1.18.1
FAIL - Dockerfile - [DL3002] Last user should not be root
``` 
