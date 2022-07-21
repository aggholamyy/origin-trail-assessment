.PHONY: terraform

terraform:
	docker run -it --rm \
		-v ~/.ssh/id_phinix.pub:/root/.ssh/id_rsa.pub \
		-v ${CURDIR}/digitalocean-terraform:/go/src/github.com/hashicorp/terraform \
		-w /go/src/github.com/hashicorp/terraform \
		hashicorp/terraform \
		$(cmd)

install-docker:
	ansible-playbook -i ansible/inventory.ini ansible/play.yml 

create-certificate:
	for i in {1..5}; do \
		echo node$$i; \
		openssl req -x509 -sha256 -nodes -newkey rsa:4096 -keyout certs_keys/node$$i.origintrail.com.key -days 730 -out certs_keys/node$$i.origintrail.com.pem -subj "/C=IR/ST=Tehran/L=Tehran/O=Origin Trail. /OU=DevOps/CN=node$$i.origintrail.com"; \
	done;

scp-cers-confs-to-nodes:
	filenames=(node1.origintrail.com node2.origintrail.com node3.origintrail.com node4.origintrail.com node5.origintrail.com); \
	j=0; \
    for i in `grep  "host" ansible/inventory.ini | cut -d "=" -f2`; do \
		echo $$i; \
		ssh root@$$i 'mkdir certs; touch .origintrail_noderc'; \
		scp certs_keys/$${filenames[$$j]}.* root@$$i:certs; \
		scp origintrail_noderc_conf/origintrail_noderc_node$$(($$j + 1)) root@$$i:.origintrail_noderc; \
		j=$$(($$j + 1)); \
	done;

run-nodes:
	for i in `grep  "host" ansible/inventory.ini|cut -d "=" -f2`; do \
		ssh root@$$i 'docker run -d -i --log-driver json-file --log-opt max-size=1g --name=otnode -p 8900:8900 -p 5278:5278 -p 3000:3000  -v ~/certs:/ot-node/certs -v ~/.origintrail_noderc:/ot-node/.origintrail_noderc origintrail/ot-node:release_testnet'; \
	done;
