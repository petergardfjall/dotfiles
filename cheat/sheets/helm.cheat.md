# Helm

Helm is a package manager for Kubernetes.

A _Helm chart_ defines a Kubernetes application and can be used to install and
upgrade that application. It's a Kubernetes counterpart of `apt` `.deb` package.

Helm charts can be published and shared via _Helm repos_.

A _release_ is an instance of a chart running in a Kubernetes cluster.

Helm Hub: https://hub.helm.sh/ Official helm charts:
https://github.com/helm/charts

Helm consists of two parts: `tiller` (server-side) and `helm` (client).
`HELM_HOME` (defaults to `~/.helm`) stores client state (repositories, plugins,
chart cache).

## Install Helm

Helm's server-side component, `tiller`, can be installed (after setting up
`kubectl`) into Kubernetes via:

    helm init

Note that this produces an insecure installation. To install helm with strong
TLS authentication, use the `~/bin/scripts/kubernetes/helm/helm-init.sh` script.

To upgrade Tiller, run:

    helm init --upgrade

To uninstall helm, run:

    helm reset

## Helm repo management

When you first install Helm, it is preconfigured to talk to the official
Kubernetes charts repository.

One can search for charts via `helm search [pattern]`.

    # Find latest release in configured repos that match 'minio'.
    helm search repo minio
    # Find all releases in configured repos that match 'minio'.
    helm search repo minio -l

Want to learn more about a chart?

    # Show chart definition.
    helm inspect chart stable/mariadb
    # Show values file.
    helm inspect values stable/mariadb
    # Show README file.
    helm inspect readme stable/mariadb
    # Show everything.
    helm inspect all stable/mariadb

Pull down a local copy of a helm chart (`minio-6.0.5.tgz`):

    helm pull minio --version 6.0.5

To see which repositories are available to `helm` use:

    helm repo list

To modify the list of repositories use `helm repo add/remove`.

To update the local repo cache, run:

    helm repo update

## Install/upgrade a chart (release)

To install a chart, run `helm install`. To use one of the official stable
charts, this is as easy as:

    # refresh list of charts (to use charts from one of your repos)
    helm repo update

    # install official chart
    helm install stable/mysql

    # install local archive
    helm install foo-0.1.1.tgz

    # install local chart directory
    helm install path/to/foo

    # install via URL
    helm install https://example.com/charts/foo-1.2.3.tgz

This creates a _release_ of the chart (with a generated name, since no `--name`
was passed). To give an explicit release name, pass `--name`.

Before installing a chart, it may be interesting to know which values are
customizable:

    helm inspect values stable/mariadb

Values can be overriden by passing `-f values.yaml` or `--set`, `--set-string`,
`--set-file` to `helm install`.

Override values can be unset for a release via:

    helm upgrade --reset-values <release>

To upgrade (or install if not available) a particular chart version, one can
use:

    helm upgrade mariadb stable/mariadb --install --version=2.0

One can pass `--recreate-pods` to `helm upgrade` to have chart pods (not
belonging to deployments) be recreated during the upgrade.

## Find releases

    helm ls
    helm status <release>

## Uninstall a release

Uninstalling a release is done via

    helm delete <release>

This uninstalls the release but the release is still kept in `helm`'s release
history, so the `status` command still works:

    helm status <release>

The deleted release will also be shown via `helm list --all`.

One can even run `helm rollback <release> <revnum>` to undo a `delete`.

To see the available reviesions of a release run:

    helm history <release>

To remove a release completely (and allow reuse of the name) one can use _purge_
the release.

    helm delete --purge <release>

## Developing Helm charts

To get started quickly run:

    helm create my-sample-chart

A chart is organized in a certain number of files:

    wordpress/
      Chart.yaml          # Metadata about the chart
      requirements.yaml   # OPTIONAL: lists dependencies for the chart
      values.yaml         # Default configuration values
      charts/             # A directory with charts upon which this chart depends.
      templates/          # Templates that, when combined with values,
                          # will generate valid Kubernetes manifest files.
      templates/NOTES.txt # OPTIONAL: plain text with short usage notes

Chart dependencies can be dynamically linked through the `requirements.yaml`
file or brought in to the `charts/` directory and managed manually.

Once you have a dependencies file, you can run `helm dependency update` and it
will use your dependency file to download all the specified charts into your
`charts/` directory for you.

Template files follow the conventions for writing Go templates. See the
documentation for developing charts for details. Besides the values passed to
the chart via `values.yaml` files, there are also some predefined values such as
`.Relase.Name`.

To debug one can render a particular template with a given set of values, e.g.:

    # render all templates
    helm template -f somve-values.yaml /path/to/chart
    # render a particular template
    helm template -f somve-values.yaml /path/to/chart -x templates/deployment.yaml

After editing a chart `helm lint` can be used to ensure that it's
well-formatted.

To package a chart (in a `.tgz` file) for distribution run:

    helm package <chart directory>

## Plugins

The `helm` cli tool allows for add-on tools that extend the `helm` functionality
without being built into the Helm codebase. These plugins live in
`${HELM_PLUGINS}` (as can be found via `helm env`).

A plugin is typically installed via VCS repo URL.

    helm plugin install <path|url>

To see the list of installed plugins:

    helm plugin list

For plugin examples, see https://helm.sh/docs/community/related/#helm-plugins.

### Plugin: helm diff

Produces a diff explaining what running `helm upgrade` would change. When
executed, it generates a diff between the latest deployed version of a release
and a `helm upgrade --debug --dry-run`.

    helm diff upgrade [flags] [RELEASE] [CHART]

Example

    helm diff -n local upgrade local-webserver ../web-server/helm

It can also be used to compare two revisions/versions of a helm release.

### Plugin: helm secrets

Supports management of secrets (passwords, keys, certificates, etc) that are
needed by Helm charts. It supports a common workflow where secrets are stored
encrypted directly in version control (`git`). The `helm secrets` plugin can
then be used both to edit and to perform on-the-fly decryption when the helm
chart is installed/upgraded.

`helm secrets` relies on SOPS (Secrets OperationS) as a "secret driver", which
uses structured formats (yaml, json) to store secrets. Being able to store
secrets in yaml is useful in Helm as it allows secrets to be handles just like
any other `values.yaml` file. Also SOPS only encrypts _values_ (not keys),
making it easy to see what secrets are in a file without needing to decrypt it.

SOPS supports different key stores (PGP, AWS KMS, GCP KMS, Azure Key Vault,
Hashicorp Vault) used to encrypt/decrypt secrets. The type of keys to use can be
inidcated via command-line parameters, environment variables or a `.sops.yaml`
file in an ancestor directory.

    ---
    # can have different keys depending on paths/patterns.
    # creation rules are evaluated sequentially, first match wins
    creation_rules:
      - path_regex: \.dev.yaml$
      # fingerprint of GPG key to use for encryption
      - pgp: 'FBC7B9E2A4F9289AC0C1D4843D16CEE4A27381B4'

Encrypt a clear-text secrets file:

    # enter yaml structure with credentials in clear text
    ${EDITOR} secrets.yaml

    # use a pgp fingerprint to indicate which encryption key to use
    export SOPS_PGP_FP=''FBC7B9E2A4F9289AC0C1D4843D16CEE4A27381B4'
    # encrypt
    helm secrets encrypt secrets.yaml

To view a secrets file in clear-text:

    helm secrets decrypt secrets.yaml

To edit a secrets file and have it encrypted on exit:

    # note: opens ${EDITOR}
    helm secrets edit secrets.yaml
