# Workflow Artifacts

This folder contains the files that Akamas uses in the workflow of the optimization described in the guides
*[Create an Optimization Study and supporting artifacts using the Akamas CLI][AIAS-03]* and
*[Optimize a Java-based Kubernetes application (Online Boutique)][AIAB-04]*:

* `apply-boutique.sh`: the script used to apply a new configuration of the Online Boutique
* `boutique.yaml.templ`: the template file used by Akamas to apply a new configuration
* `check-boutique-up.sh`: the script to check the rollout of the deployments when applying a new configuration
* `run-test.sh`: the script to start the load test
* `stop-test.sh`: the script to stop the load test once finished

[AIAS-03]: https://docs.akamas.io/quick-guides/quick-guides-aias/aias-03-guide-create-an-optimization-study-and-supporting-artifacts-using-the-akamas-cli
[AIAB-04]: https://docs.akamas.io/quick-guides/quick-guides-aiab/aiab-04-optimize-a-java-based-kubernetes-application-online-boutique
