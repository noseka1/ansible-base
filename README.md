# Ansible Base

Install dependencies with:

```
$ ansible-galaxy role install \
  --role-file requirements.yml \
  --force
```

Insert your credentials:

```
$ cp inventory/group_vars/all/credentials.yml.sample inventory/group_vars/all/credentials.yml
$ vi inventory/group_vars/all/credentials.yml
```

Run a playbook:

```
$ ansible-playbook -i inventory/localhost.ini <playbook>
```
