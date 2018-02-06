All of the designate configuration is done through the ```designate_pools_yaml``` map that can be placed in the /etc/openstack\_deploy/openstack\_user\_config.yml configuration file.
There are several section to this map:

Name:

    - name: default
    description: Default Pool

Attributes:
Attributes are Key:Value pairs that describe the pool. for example the level
of service (i.e. service_tier:GOLD), capabilities (i.e. anycast: true) or
other metadata. Users can use this information to point their zones to the
correct pool. Right now we only use a single pool so we don't need to define any 
attrbutes.

    attributes: {}

ns_records:
We need to list out the NS records for the zones we are hosting within this pool
    ns_records:
    - hostname: ns1-1.example.org.
      priority: 1

nameservers:
This section is where we list out all of the name server that we are testing against.
They are used to confirm that the zone changes have been made.

    nameservers:
    - host: 127.0.0.1
      port: 53

targets:

Since initially we are only supporting BIND as the backend, there won't be many changes to this section of the configuration. Since we are using BIND to perform the configuration we have to run rndc commands on each server to create the zone and to send NOTIFY commands. Here is where you add the addresses of the dns masters, these would be the addresses of the infra nodes. The masters are the server that the dns server will request the zone transfers from. In our application they would normally be the address of the infra nodes directly. This can be through a firewall but this can&#39;t be done via haproxy as all of the transfers are completed via UDP. You will also need to have a key that will be uploaded to each of the designate containers that will provide. The port should be 5354 unless you change the port that the designate-mdns service listens on.

  targets:

    - type: bind9
      description: BIND9 Server 1
      masters:
        - host: 127.0.0.1
          port: 5354
      options:
        host: 127.0.0.1
        port: 53
        rndc_host: 127.0.0.1
        rndc_port: 953
        rndc_key_file: /etc/designate/rndc.key
