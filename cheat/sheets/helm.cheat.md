# Helm
Helm is a package manager for Kubernetes.

A *Helm chart* defines a Kubernetes application and can be used to install and
upgrade that application. It's a Kubernetes counterpart of `apt` `.deb` package.

Helm charts can be published and shared via *Helm repos*.

A *release* is an instance of a chart running in a Kubernetes cluster.

Helm Hub: https://hub.helm.sh/
Official helm charts: https://github.com/helm/charts

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

Want to learn more about a chart?

    helm inspect stable/mariadb

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

This creates a *release* of the chart (with a generated name, since no `--name`
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

To remove a release completely (and allow reuse of the name) one can use *purge*
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

Template files follow the conventions for writing Go templates. See
https://helm.sh/docs/developing_charts/#template-files. Besides the values
passed to the chart via `values.yaml` files, there are also some predefined
values https://helm.sh/docs/developing_charts/#predefined-values.

After editing a chart `helm lint` can be used to ensure that it's
well-formatted.

To package a chart (in a `.tgz` file) for distribution run:

    helm package <chart directory>
