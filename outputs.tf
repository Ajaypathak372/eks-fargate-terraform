output "webapp_url" {
    value = module.kubernetes.load_balancer_hostname
}