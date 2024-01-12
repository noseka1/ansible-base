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

Many of Ansible roles in this repo require that autogitops is deployed on the cluster. You can
deploy autogitops using the command:

```
$ ansible-playbook -i inventory/localhost.yml openshift_autogitops_deploy.yml
```

Run a playbook:

```
$ ansible-playbook -i inventory/localhost.yml <playbook>
```
