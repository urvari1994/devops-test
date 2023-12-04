provider "kubernetes" {
  config_path = "~/.kube/config"  # Adjust as per urv kubeconfig location
}

resource "kubernetes_deployment" "urvapp" {
  metadata {
    name = "urvapp"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "urvapp"
      }
    }

    template {
      metadata {
        labels = {
          app = "urvapp"
        }
      }

      spec {
        container {
          image = "urv/urvapp:latest"
          name  = "urvapp"
          ports {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "urvapp" {
  metadata {
    name = "urvapp"
  }

  spec {
    selector = {
      app = kubernetes_deployment.urvapp.spec[0].template.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}
