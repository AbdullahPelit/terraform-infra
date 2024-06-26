resource "aws_eks_addon" "addons" {
  # Eğer var.eks_addons true ise var.addons listesini kullan, değilse boş bir map kullan
  for_each = var.eks_addons ? { for addon in var.addons : addon.name => addon } : {}

  cluster_name      = local.cluster_name
  addon_name        = each.value.name
  addon_version     = each.value.version
  resolve_conflicts_on_create = "OVERWRITE"
}