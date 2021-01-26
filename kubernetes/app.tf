resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
    labels = var.labels
  }
  depends_on = [ var.namespace_depends_on ]
}

resource "kubernetes_deployment" "deploy" {
  metadata {
    name = "${var.deployment_name}-${terraform.workspace}"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    labels = var.labels
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = var.labels
    }

    template {
      metadata {
        labels = var.labels
      }

      spec {
        container {
          image = "wordpress"
          name  = "wordpress"
          port   {
              name = "wordpress"
              container_port = 80
          }
          volume_mount  {
              name = "wordpress-persistent-storage"
              mount_path = "/var/www/html"
          }
          env {
            name = "WORDPRESS_DB_HOST"
            value = var.db_address
          }
          env { 
            name = "WORDPRESS_DB_USER"
            value = var.db_user
          }
          env { 
            name = "WORDPRESS_DB_PASSWORD"
            value = var.db_pass 
          } 
          env {
            name = "WORDPRESS_DB_NAME"
            value = var.db_name
          }
        }
        volume  {
          name = "wordpress-persistent-storage"
          persistent_volume_claim { 
              claim_name = kubernetes_persistent_volume_claim.wordpress.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "wordpress" {
  metadata {
    name = "${var.deployment_name}-pvc"
    namespace = kubernetes_namespace.namespace.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteMany"]
    storage_class_name = kubernetes_storage_class.wordpress.metadata[0].name
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
  depends_on = [ kubernetes_persistent_volume.wordpress ]
}

resource "kubernetes_service" "wordpress" {
  metadata {
    name = "${var.deployment_name}-service"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    /*annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb-ip"
    }*/
    labels = var.labels
  }
  spec {
    selector = var.labels
    type  = "NodePort"
    port {
      port = 80
      target_port = 80
      protocol = "TCP"
    }
  }
  depends_on = [ kubernetes_deployment.deploy ]
}

resource "kubernetes_ingress" "wordpress" {
  metadata {
    name      = "${var.deployment_name}-ingress"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"           = "alb"
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
    labels = var.labels
  }

  spec {
    backend {
      service_name = kubernetes_service.wordpress.metadata[0].name
      service_port = kubernetes_service.wordpress.spec[0].port[0].port
    }
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = kubernetes_service.wordpress.metadata[0].name
            service_port = kubernetes_service.wordpress.spec[0].port[0].port
          }
        }
      }
    }
  }
  wait_for_load_balancer = true
  depends_on = [ kubernetes_service.wordpress, helm_release.using_iamserviceaccount ]
}