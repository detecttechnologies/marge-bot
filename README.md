# Marge-bot
## Steps to build and push Docker Image to GitHub
Note: Use a minimum of 2 Cores and 1GB RAM on AWS or equivalent
* Install git
    ```sh
    sudo apt update
    sudo apt install git
    ```
* Setup Docker and nix
    ```sh
    git clone https://github.com/detecttechnologies/marge-bot.git
    cd marge-bot
    . install-docker-and-nix.sh
    ```
* Log out and log in to complete the setup
* Build docker image
    ```sh
    cd marge-bot
    make dockerize
    ```
* Generate an access token from https://github.com/settings/tokens/new with ```write:packages``` context and paste it in TOKEN.txt
* Authenticate to GitHub Docker Registry with your username
    ```sh
    cat TOKEN.txt | docker login https://docker.pkg.github.com -u <username> --password-stdin
    ```
* Tag and push
    ```sh
    docker tag docker.pkg.github.com/detecttechnologies/marge-bot/docker-marge:<version> docker.pkg.github.com/detecttechnologies/marge-bot/docker-marge:latest
    docker push docker.pkg.github.com/detecttechnologies/marge-bot/docker-marge:<version>
    docker push docker.pkg.github.com/detecttechnologies/marge-bot/docker-marge:latest
    ```
