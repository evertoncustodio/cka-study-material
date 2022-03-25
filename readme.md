# Certified Kubernetes Administrator Study Material

## AWS EC2 Instances

The directory terraform/ creates 3 EC2 instances for practicing the exam objectives.
One machine is for master and 2 for workers. It is good to know how kubernetes works with multimasters, but you can perfectly practice for the exam with just one master.

Before executing the scripts you must first create an SSH key for acessing the machines. This is done with the following command  (from the terraform directory):
```bash
ssh-keygen -o -a 100 -t ed25519 -f ./cka-cluster
```

To access the machines, first get the public IP in the AWS console and them execute the following:
```bash
ssh -i .\terraform\cka-cluster ubuntu@[public IP]
```

### Configuring Hosts

You can configure hosts names for the machines executing the follwing in each one:
```bash
echo "
172.31.0.10 kubemaster
172.31.0.11 kubenode01
172.31.0.12 kubenode02
" | sudo tee -a /etc/hosts
```

You can also copy your private key in the master machine for easy acess to the another machines.
In the master machine:
```bash
echo "[PRIVATE KEY CONTENT (file in terraform/cka-cluster)]" | tee -a ~/.ssh/id_rsa; chmod 400 id_rsa
```

With that you can acess the worker machines from the master with:
```bash
ssh kubenode01
```

## Tasks:

Following are some tasks you can use for training. During the exam you can access the kubernetes documentation (https://kubernetes.io/docs/home/), so try to execute the tasks using only the documentation (except for installing the container runtime and the network plugin).


- Create a kubernetes clustes with kubeadm using all machines (kubernetes 1.20)
- Create a deployment called nginx
- Backup de etcd cluster
- Create a deployment called redis
- Restore the backup of nginx
- Create a new user that can manipulate pods, deployments and service in the namespace dev
- See the logs of the kubelet service
- Upgrade the cluster to kubernetes 1.21 (master)
- Upgrade the cluster to kubernetes 1.21 (workers)
- Create a pod with a persisten volume of the type hostPath, using claims
- Create a nginx pod with a service exposing the port 80 of the pod to the nodeport 32180
- Install a ingress controller
- Create an ingress host for the nginx pod/service
- Configure a networkpolicy to allow only traffic from the ingress controller to the nginx pod
- Configure a networkpolicy to block traffic out of an pod to the internet

## Other Materials

For preparing for the exam I only used this course from Mumshad Mannambeth:
```
https://www.udemy.com/course/certified-kubernetes-administrator-with-practice-tests
```

It covers all the objectives and have a lot of practical exercises you execute in an environment very similar to the one you will use in the exam.

After you register for the exam you will have acess to the killer.sh (https://killer.sh/cka) simulator. You will be able to start the environment 2 times, after each start the evironment will last for 36 hours and you will have a lot of tasks to practice. Because the acess is limited I recommend using it near your exam date, like one week before for example, so you will have time to complete all questions and revisit some concepts you may have struggled.



