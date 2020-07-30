# install OKD 3.11 on CentOS 7

install single node OKD 3.11 on CentOS 7

https://computingforgeeks.com/setup-openshift-origin-local-cluster-on-centos/#ex1


## installation

```
sh -x install-okd3.11.sh
```

## start OKD cluster

```
oc cluster up
```

## login

```
oc login -u system:admin
```

## get status

```
oc cluster status
```
