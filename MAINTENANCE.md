PRE MAINTENANCE
1. Make a public comment with Customer Disclaimer:

```
\*\*\*\*\*\*\*\*\*\*\*\*\*\* IMPORTANT \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

Please be advised this maintenance might cause customers losing their Managed 
Kubernetes clusters and/or short network interruptions

As Rackspace lacks access into customer instances, Rackspace strongly advises 
customers to backup their work.

\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
```

MAINTENANCE PREP
1. Maintenance objective: Install OpenStack Designate DNSaaS
1. What should we check to confirm the solution is functioning as expected?
	1. OpenStack system is still functional (build, destroy VM, etc.)
	1. Create a DNS zone
	1. Create a DNS record under that zone and confirm that it resolves	
	1. Departments involved: RPC
	1. Owning department: RPC
1. Amount of time estimated for maintenance: 90 minutes


Maintenance Steps:
1. Update ticket to inform the customer that maintenance is commencing.
1. Add the [pool](CONFIGURATION.md) configuration to /etc/openstack\_deploy/openstack\_user\_config.yml
1. Install Designate
	1. Clone the rpc-designate repo by running: cd /opt &amp;&amp; git clone [https://github.com/rcbops/rpc-designate.git](https://github.com/rcbops/rpc-designate.git)
	1. Run the Designate install script: cd /opt/rpc-designate &amp;&amp; ./scripts/deploy.sh
1. Test Designate Functionality
	1. Attach to the utility container and source an openrc
	1. Run designate server-list and verify that the servers defined in the pool configuration appear.
	1. Create a new zone, designate create-zone –name example.org. (Be sure to include the trailing dot in the command)
	1. Test resolving the domain against the name servers in the pool
1. Update ticket signaling end of maintenance.
1. Verify inside the intelligence portal that MaaS checks are green
1. Remove monitoring suppression window https://rba.rackspace.com

Escalation procedure:  // DO NOT ABORT MAINTENANCE UNTIL FOLLOWED
1. Troubleshoot using remaining time
1. Escalate to senior/lead tech
1. Contact customer


Rollback plan
1. These services shouldn&#39;t cause any impact to the other services, so it shouldn&#39;t cause any downtime to the rest of the infrastructure
1. Verify that the haproxy node on the infra controller is still running and accepting connections to the other services.
1. Manually remove the designate containers, remove the database for designate from the galera nodes.


Post Maintenance Notification
1. Success – Update ticket
1. Failure – Update ticket
1. Reschedule – Update ticket
