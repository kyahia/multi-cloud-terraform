resource "subnet" "subs" {
  for_each = subnet
}

variable "prv_sub" {
  value = [for s in var.sub : s if s.type == "private"]
}

resource "route_table" "name" { 

}