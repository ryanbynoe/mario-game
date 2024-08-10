provider "azurerm" {
  features {}
}

provider "kubernetes" {
  # Assuming you're using the default kubeconfig path
  config_path = "~/.kube/config"
}