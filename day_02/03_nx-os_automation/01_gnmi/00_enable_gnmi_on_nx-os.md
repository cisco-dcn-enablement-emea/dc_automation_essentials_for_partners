# Generating Certificates for NX-OS Devices to Use with gNMI

To enable secure gNMI communication with NX-OS devices, certificates must be generated and configured properly. This guide explains the step-by-step process to create and install the required certificates.

---

## Overview

Secure communication using gNMI requires:
- A trusted Certificate Authority (CA) for signing the certificates.
- A server certificate for the NX-OS device.


Certificates must conform to the X.509 standard and use TLS for secure connections.

---

## Steps to Generate Certificates
You can do these steps on the nexus device after enabling the feature bash-shell or you can use any machine with openssl installed. I tested both ways and they work

### 1. Create a Certificate Authority (CA)
The CA is responsible for signing server and client certificates.

1. Generate a private key for the CA:
   ```bash
   openssl genrsa -des3 -out myCA.key 2048
   ```

2. Create a self-signed CA certificate:
   ```bash
   openssl req -x509 -new -nodes -key myCA.key -sha256 -days 1000 -out myCA.pem \
       -subj "/C=US/ST=California/L=San Jose/O=YourOrg/OU=IT/CN=YourCA"
   ```
   - Replace the `-subj` fields with your organization's details.

### 2. Generate the NX-OS Device Server Certificate
This certificate is used by the NX-OS device to authenticate itself to clients.

1. Generate a private key for the server:
   ```bash
   openssl genrsa -out nxos_server.key 2048
   ```

2. Create a Certificate Signing Request (CSR):
   ```bash
   openssl req -new -key nxos_server.key -out nxos_server.csr \
       -subj "/C=US/ST=California/L=San Jose/O=YourOrg/OU=IT/CN=nxos-device"
   ```
   - Replace the `-subj` fields with your device details. Ensure the `CN` matches the hostname or IP of the device.

3. Add Alternative names. In case you are using the FQN but you later want to access the device via its IP
   ```bash
        cat > Server.test.ext 
        authorityKeyIdentifier=keyid,issuer
        basicConstraints=CA:FALSE
        keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
        subjectAltName = @alt_names
        [alt_names]
        IP.1 = X.X.X.X
   ```
    - Replace the `X.X.X.X` fields with your device IP Address.

4. Sign the CSR with the CA:
   ```bash
   openssl x509 -req -in nxos_server.csr -CA myCA.pem -CAkey myCA.key -CAcreateserial \
       -out nxos_server.crt -days 365 -sha256
   ```

5. Create the .pfx file to be used in the switch later on
    ```bash
    openssl pkcs12 -export -out nxos_server.pfx -inkey nxos_server.key -in nxos_server.crt -certfile myCA.pem -password pass:cisco 
    ```
    - Replace the `pass:cisco` fields with your 'pass:YOUR_PSW'. This will be required by NX-OS cli

### 4. Install the Certificates on the NX-OS Device

1. Copy the server certificate and private key to the NX-OS device. This is valid if you run the procedure outside of the switch
   ```bash
   scp nxos_server.pfx admin@<device-ip>:/bootflash/
   ```

2. Log in to the NX-OS device and install the certificates:
   ```bash
    feature grpc
    feature netconf
    feature openconfig
    crypto ca trustpoint gnmi_trust                                 
    crypto ca import gnmi_trust pkcs12 bootflash:nxos_server.pfx **cisco**    
    grpc certificate gnmi_trust   
   ```
    - Replace **cisco** with the password you set when you have created the pfx

3. Verify the gNMI status:
   ```bash
        isn-5# show grpc gnmi service statistics
        
        =============
        gRPC Endpoint
        =============
        
        Vrf            : management
        Server address : [::]:50051
        
        Cert notBefore : Jan 10 09:58:10 2025 GMT    
        Cert notAfter  : Jan 10 09:58:10 2026 GMT  <==== New certificates have been installed. See that expiry date is in 1 year
        Client Root Cert notBefore : n/a
        Client Root Cert notAfter  : n/a
   ```

## Testing and Validation

1. Test connectivity from the gNMI client to the NX-OS device:
   ```bash
   gnmi_cli -address <device-ip>:50051 -u admin -p XXXX --skip-verify  --print-request capabilities

    Capabilities Request:
    {}
    Capabilities Response:
    gNMI version: 0.5.0
    supported models:
      - Cisco-NX-OS-device, Cisco Systems, Inc., 2022-08-18
      - DME, Cisco Systems, Inc.,
      - Cisco-NX-OS-Syslog-oper, Cisco Systems, Inc., 2019-08-15
    supported encodings:
      - JSON
      - PROTO
   ```
    


2. Verify that the gNMI connection is established and secure.

## Troubleshooting

- **Certificate Mismatch**: Ensure the `CN` in the server certificate matches the device's hostname or IP address.
- **Expired Certificates**: Renew certificates before their expiration date.
- **Connectivity Issues**: Verify firewall rules, port configurations, and TLS settings.
- **Proxy**: If the gNMI client has proxy configure you might need to disable it. Remember that this will be HTTPs traffic

By following this guide, you can set up and secure gNMI communication with NX-OS devices effectively.

