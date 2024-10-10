# Ansible Base

Install dependencies with:

```
$ ansible-galaxy role install \
  --role-file requirements.yml \
  --force
```

```
$ ansible-galaxy collection install \
  --requirements-file requirements.yml \
  --force
```

Insert your credentials:

```
$ cp inventory/group_vars/all/credentials.yml.sample inventory/group_vars/all/credentials.yml
$ vi inventory/group_vars/all/credentials.yml
```

Many of the Ansible roles in this repo require that autogitops is deployed on the cluster. You can deploy autogitops using the command:

```
$ ansible-playbook -i inventory/localhost.yml openshift_autogitops_deploy.yml
```

Ansible roles utilizing autogitops need access to Kubernetes manifests located in the [GitOps Catalog Helm repository](https://github.com/noseka1/gitops-catalog-helm). These roles expect to find a clone of this repository on the local machine at *{{ playbook_dir }}/../gitops-catalog-helm* by default. You can clone the repository by changing to the parent directory:

```
$ pushd ..
```

and cloning the GitOps Catalog Helm repository:

```
$ git clone https://github.com/noseka1/gitops-catalog-helm.git
```

```
$ popd
```

You can run a playbook using:

```
$ ansible-playbook -i inventory/localhost.yml <playbook>
```
