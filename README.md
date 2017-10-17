

Welcome to the RDS_Set-Cert wiki!

Basically the current script is setup to grab all valid certificates in the computer level personal store that match computer name + domain name in the subject alternate name extension and then grab the longest duration to expiry ECC certificate (if exists) and then the same selection process with RSA certificates. So ECC > RSA. It then uses the WMI method to set the certificate via its thumbprint, this way it will error if the cert cannot be used as opposed to the registry which will just crash the service.
