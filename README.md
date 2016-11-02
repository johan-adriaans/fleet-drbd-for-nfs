# fleet-drbd-for-nfs

**Warning: The block device you specify will be used to create a drbd device. This might cause data loss. Although the block device needs to be unmounted to do so, caution is still advised.**

I do use this container myself, but this is more or less a proof-of-concept.

It uses fleet to start 2 drbd services in secondary mode. The examples needs 2 fleet machines with metadata name=data-1 and name=data-2. When used for the first time a new drbd device will be initiated.

Next the nfs-service will be started. This fleet unit will: 
- Make the drbd device primary
- Mount the drbd device
- Add the mount to the /etc/exports file
- Start the NFS service
- Add the floating ip (in this example it is 10.0.0.5)
- Send 10 unsolicited arp packages so everyone will update their arp cache.

After that you can start the NFS client units.
