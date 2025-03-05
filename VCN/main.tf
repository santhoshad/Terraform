# 🔹 Create VCN
resource "oci_core_vcn" "my_vcn" {
  compartment_id = var.compartment_id
  cidr_block     = var.vcn_cidr
  display_name   = "MyVCN"
  dns_label      = "myvcn"
}

# 🔹 Create Internet Gateway
resource "oci_core_internet_gateway" "my_igw" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.my_vcn.id
  display_name   = "InternetGateway"
}

# 🔹 Create Public Route Table
resource "oci_core_route_table" "public_rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.my_vcn.id
  display_name   = "PublicRouteTable"

  route_rules {
    network_entity_id = oci_core_internet_gateway.my_igw.id
    destination       = "0.0.0.0/0"
    description       = "Route to Internet"
  }
}

# 🔹 Create Private Route Table (No Internet Access)
resource "oci_core_route_table" "private_rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.my_vcn.id
  display_name   = "PrivateRouteTable"
}

# 🔹 Create Public Security List (Allow SSH, HTTP, HTTPS)
resource "oci_core_security_list" "public_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.my_vcn.id
  display_name   = "PublicSecurityList"

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options { 
        min = 22 
        max = 22
         }
  }
  
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options { 
        min = 80 
        max = 80 
        }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options { 
        min = 443 
        max = 443
         }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

# 🔹 Create Private Security List (Allow Internal VCN Communication)
resource "oci_core_security_list" "private_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.my_vcn.id
  display_name   = "PrivateSecurityList"

  ingress_security_rules {
    protocol = "all"
    source   = var.vcn_cidr
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

# 🔹 Create Public Subnet
resource "oci_core_subnet" "public_subnet" {
  compartment_id        = var.compartment_id
  vcn_id               = oci_core_vcn.my_vcn.id
  cidr_block           = var.public_subnet_cidr
  display_name         = "PublicSubnet"
  dns_label            = "publicsubnet"
  route_table_id       = oci_core_route_table.public_rt.id
  security_list_ids    = [oci_core_security_list.public_security_list.id]
  prohibit_public_ip_on_vnic = false
}

# 🔹 Create Private Subnet
resource "oci_core_subnet" "private_subnet" {
  compartment_id        = var.compartment_id
  vcn_id               = oci_core_vcn.my_vcn.id
  cidr_block           = var.private_subnet_cidr
  display_name         = "PrivateSubnet"
  dns_label            = "privatesubnet"
  route_table_id       = oci_core_route_table.private_rt.id
  security_list_ids    = [oci_core_security_list.private_security_list.id]
  prohibit_public_ip_on_vnic = true
}
