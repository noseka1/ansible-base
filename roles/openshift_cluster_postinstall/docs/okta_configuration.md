# Configuring Okta as an Identity Provider for OpenShift

To configure Okta as an OIDC provider for OpenShift, you can follow the article [How to Configure Okta as An Identity Provider for OpenShift](https://www.redhat.com/en/blog/how-to-configure-okta-as-an-identity-provider-for-openshift)

The above article does not include the Okta configuration for including the `groups` claim in the access token. If you'd like OpenShift to create the groups and group membership based on the groups claim in the Okta token, it is required to configure Okta to include the groups claim in the token. Such an Okta configuration is described in the paragraph [Add a groups claim for the org authorization server](https://developer.okta.com/docs/guides/customize-tokens-groups-claim/main/#add-a-groups-claim-for-the-org-authorization-server) of Okta documentation.

The following screenshots illustrate the configuration:

![Groups claim enabled](images/okta1.png "Groups claim enabled")

![Refresh application data](images/okta2.png "Refresh application data")

After Okta was configured to include the groups claim in the token and the user logged into OpenShift, OpenShift will create the respective user groups and add the user to those groups:

```
$ oc get group

```
```
NAME                                          USERS
Everyone                                      anosek@redhat.com
cluster-admins                                admin, anosek@redhat.com
mygroup1                                      anosek@redhat.com
open-cluster-management-subscription-admins   admin
```

```
$ oc get group cluster-admins -o yaml
```

```
apiVersion: user.openshift.io/v1
kind: Group
metadata:
  annotations:
    oauth.openshift.io/idp.okta: synced
  creationTimestamp: "2025-11-19T19:55:45Z"
  name: cluster-admins
  resourceVersion: "437771"
  uid: 0e8202e2-06c6-4f8a-879d-c7f25d6c25cf
users:
- admin
- anosek@redhat.com
```
