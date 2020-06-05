<img src="https://oasislmf.org/packages/oasis_theme_package/themes/oasis_theme/assets/src/oasis-lmf-colour.png" alt="Oasis LMF logo" width="250"/>

# Oasis at scale Platform Installation 

An evaluation repository for testing the redesigned oasis architecture, where the keys lookup and analyses are now distributed across a pool of workers

## Distributed Architecture 
![alt text](https://github.com/OasisLMF/OasisAtScaleEvaluation/blob/master/.img/new_arch.png)

<TODO: more details and diagrams> 


## Install Prerequisites
Docker support is the main requirement for running the platform.
A Linux based installation is the main focus of this example deployment. 
Running the install script from this repository automates install process of the OasisPlatform API v1, User Interface and example PiWind model. 
* Host operating system with docker support, see [Docker compatibility matrix](https://success.docker.com/article/compatibility-matrix).
* For this example we have used [Docker compose](https://docs.docker.com/compose/) which is required for running the install script.

  
## Installation Steps

1) install git, docker and docker-compose

For example on an Ubuntu/Debian based Linux system use:
```
sudo apt update && sudo apt install git docker docker-compose 
```

2) Clone this repository 
```
git clone https://github.com/OasisLMF/OasisAtScaleEvaluation.git 
cd OasisAtScaleEvaluation
```
3) Run the deployment script 
```
sudo ./install.sh
```
> Note: sudo is not required if the Docker [post-install steps](https://docs.docker.com/install/linux/linux-postinstall/) are followed to run docker as a non-root user.


## Web interfaces 
On installation a single admin account is created which is used to access the following web interfaces.

```
User: admin
Pass: password
```

### [OasisUI Interface](http://localhost:8080/app/BFE_RShiny) - *localhost:8080/app/BFE_RShiny* 
![alt text](https://github.com/OasisLMF/OasisAtScaleEvaluation/raw/master/.img/oasisui.png)

### [API Swagger UI](http://localhost:8000/) - *localhost:8000*
![alt text](https://github.com/OasisLMF/OasisAtScaleEvaluation/raw/master/.img/api_swagger.png)

### [API Admin Panel](http://localhost:8000/admin) - *localhost:8000/admin*
![alt text](https://github.com/OasisLMF/OasisAtScaleEvaluation/raw/master/.img/admin_panel.png)

### [Portainer Docker Panel](http://localhost:9000) - *localhost:9000/admin*
![alt text](https://github.com/OasisLMF/OasisAtScaleEvaluation/raw/master/.img/portainer.png)


## Exposure inputs

The Oasis platform supports the [Open Exposure Data (OED)](https://github.com/Simplitium/OED) standard for importing exposure.
Example files are available for the PiWind model:

* [SourceLocOEDPiWind10.csv](https://raw.githubusercontent.com/OasisLMF/OasisPiWind/master/tests/data/SourceLocOEDPiWind10.csv) --- Locations Data 10 rows
* [SourceLocOEDPiWind.csv](https://raw.githubusercontent.com/OasisLMF/OasisPiWind/master/tests/data/SourceLocOEDPiWind.csv) --- Locations Data
* [SourceAccOEDPiWind.csv](https://raw.githubusercontent.com/OasisLMF/OasisPiWind/master/tests/data/SourceAccOEDPiWind.csv) --- Accounts Data
* [SourceReinsInfoOEDPiWind.csv](https://raw.githubusercontent.com/OasisLMF/OasisPiWind/master/tests/data/SourceReinsInfoOEDPiWind.csv) --- Reinsurance Info 
* [SourceReinsScopeOEDPiWind.csv](https://raw.githubusercontent.com/OasisLMF/OasisPiWind/master/tests/data/SourceReinsScopeOEDPiWind.csv) --- Reinsurance Scope 

## Troubleshooting 
Feedback and error reports are invaluable for improving the stability and performance of the Oasis Platform, If you encounter an issue please consider [submitting an issue here](https://github.com/OasisLMF/OasisPlatform/issues)

