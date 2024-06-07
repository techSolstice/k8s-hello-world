# Helm Chart Hello World
This repository is intended to showcase basics of a variety of Kubernetes setups.  To begin, this will share `helm`setup and usage.

## Prerequisites
You will need to set up
* Docker
* Helm
* Kind (k2d, different from k3d)
* A Docker Hub account (for image push)

## Directory structure

We will separate the Helm Charts from the rest of the code.  They don't necessarily need to, but intrinsically the demand a certain directory structure, so it makes sense to keep it organized from the rest of the code base.

As a result, we have created the `charts/helloworld/` directory to house the Helm Chart directory pattern.  Note that this allows you to house other Helm Charts that can *share* the rest of your code repository.  You might want to run different docker setups depending on the slice of your codebase or the purpose of the process (e.g. CronJob, data processing, web application, etc.).

For the first Helm chart, a simple PHP application with Nginx has been created.

## How does a Helm Chart work?

You will notice `templates/` contains reusable yaml among other items.  How you make the yaml reusable is by using the [Mustache](https://github.com/mustache/mustache) syntax.
This allows us to pass in/bind variables.  Usually you'll want to separate your constants/variables into a separate values.yaml.  Although there's some automagic to pull these in, we can explicitly add these entire files as part of Helm installation.  You can also set individual values via CLI.

Like in other templating, functions and escapes can be used.  We can define our own custom functions.  Examples of these definitions can be found in `charts/helloworld/templates/_helpers.tpl`.

## Setting up Docker images
For this to work, we will be creating PHP and nginx Docker images.

Let's build the images.  The Dockerfiles do this work for us by setting up based on publicly available PHP and nginx images then adding our personal configuration with what we have in `docker/nginx/` and `docker/php`.  Generally READMEs on Docker Hub will guide you on what your Dockerfiles should look like.
This build process presumes your current working directory is at the root of this repository.

```shell
docker build -t <dockerHubAccount>/php:3 -f php.dockerfile .
docker build -t <dockerHubAccount>/nginx:3 -f nginx.dockerfile .

docker push <dockerHubAccount>/php:3
docker push <dockerHubAccount>/nginx:3
```
replace `<dockerHubAccount>` with your personal account name.  Replace `3` with your tag, hash, or branch name.  The `.` indicates the current directory where your image will start from.

Note that you should increment your tag number and perhaps use semantic versioning.  Also, using the `latest` tag although not recommended, can be fine for introducing yourself.

For local testing, execute
```shell
kind load docker-image <dockerHubAccount>/php:3
kind load docker-image <dockerHubAccount>/nginx:3
```
## Example Helm Install
For our purposes, we can run 
```shell
helm install helloworld charts/helloworld -f charts/helloworld/values.yaml -f charts/helloworld/values-local.yaml
```
which will allow us to:
* Install a Helm Chart (tell it to deploy your Resources)
* Name the runtime reference of the chart (accessible via CLI `helm` command) as `helloworld`
* Tell it to initialize with file `charts/helloworld/values.yaml`
* Tell it to initialize with file `charts/helloworld/values-local.yaml` (order is important for precedence)

If you want to tear down your Resources, you will want to run `helm uninstall helloworld`.  Alternatively you can modify Resources manually and individually via `kubectl`.

To monitor or debug your installation you may want to use `kubectl get all` to see all your resources
To debug your `helm install` command, you may want to see the generated YAML (essentially all the templating hydrated with corresponding values and functions).  To do this, use `helm template`.  You may still pass the `values` files similar to install if you would like those parsed in.
You may also see the status of a Helm installation via `helm status helloworld`.

## Usage
When this Helm chart is successfully installed and its resources successfully running, you will need to execute
```shell
kubectl port-forward service/nginx-service 8080:80
```
then in a browser go to https://localhost:8080
to get a `phpinfo()` dump.



