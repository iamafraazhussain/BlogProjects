##################################################################################################
# Boudnary worker
##################################################################################################
worker {
  name = "{{ base_domain | replace('.','-') }}-worker"
  description = "{{ base_domain }} Boundary worker"

  controllers = [
    "127.0.0.1"
  ]

  public_addr = "{{ ipify_public_ip }}"

}

##################################################################################################
# Boudnary listener
##################################################################################################
listener "tcp" {
  purpose = "proxy"
  tls_disable = true
  address = "127.0.0.1"
}

##################################################################################################
# Boudnary KMS
##################################################################################################
# must be same key as used on controller config
kms "transit" {
  purpose            = "worker-auth"
  address            = "{{ vault_addr }}"
  token              = "{{ vault_kms_worker_token }}"
  disable_renewal    = "false"

  // Key configuration
  key_name           = "boundary-worker-token"
  mount_path         = "{{ vault_kms_mount_path }}"
  namespace          = "keys/"

  // TLS Configuration
  tls_ca_cert        = "{{ }}"
  tls_server_name    = "{{ }}"
  tls_skip_verify    = "false"
}