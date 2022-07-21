# Prepare VMs on Digitalocean 

1. Install ansible requirements
   ```bash
    ansible-galaxy install -r requierment.yml
   ```

1. Run Terraform command by Make file
   ```bash
   make terraform cmd=init
   make terraform cmd=plan
   make terraform cmd=apply
   ```

1. Update the `inventory.ini` file in `ansible` directory by output of terraform command.

1. Run `install-docker` command by Make file
   ```bash
   make install-docker
   ```

1. Run `create-certificate` command by Make file to Create `certificates`
   ```bash
   make create-certificate
   ``` 

1. Run `scp-cers-confs-to-nodes` command by Make file to copy config files and certs to destination hosts
   ```bash
   make scp-cers-confs-to-nodes
   ```

1. Run `run-nodes` command by Make file to create the container and prepare the node
   ```bash
   make run-nodes
   ```

# Further work around
   ```txt
   1. preparing monitoring for nodes.
   2. writing exporter for node to check health of the node and 3 compare its’ status by other nodes in the cluster and outside nodes.
   3.  creating dynamic inventory for ansible. 
   ```
