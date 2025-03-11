# Ansible Base

## Setup

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

## Example usage

You can run a playbook using:

```
$ ansible-playbook -i inventory/localhost.yml <playbook>
```

For example, to deploy NMState operator along with the respective instance, you can issue:

```
$ ansible-playbook -i inventory/localhost.yml openshift_nmstate_deploy.yml
```

To uninstall NMState instance and the operator, issue:

```
$ ansible-playbook -i inventory/localhost.yml openshift_nmstate_delete.yml
```

To get a list of available tags for deploying individual components, issue:

```
$ ansible-playbook -i inventory/localhost.yml openshift_nmstate_deploy.yml --list-tags
```

```
playbook: openshift_nmstate_deploy.yml

  play #1 (localhost): localhost        TAGS: []
        TASK TAGS: [nmstate_instance, nmstate_operator]
```

To deploy just the NMState operator, issue:

```
$ ansible-playbook -i inventory/localhost.yml openshift_nmstate_deploy.yml --tags nmstate_operator
```

To uninstall just the NMState operator, issue:

```
$ ansible-playbook -i inventory/localhost.yml openshift_nmstate_delete.yml --tags nmstate_operator
```
