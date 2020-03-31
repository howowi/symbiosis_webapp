# Symbiosis Web Application

## Architecture Explained

Based on the high level requirements, basically the client would like to have a highly available and elastic web tier which connects to the highly available managed SQL database. There are 2 ways to implement this solution namely **Traditional** and **Cloud-native**. Let's deep dive into the 2 implementations.

### Traditional Architecture
![Architecture](symbiosis_architecture.jpg)

#### 1) Web
1) In the traditional architecture, the webservers are deploye as EC2 instances within an `Auto Scaling Group (ASG)` to provide elasticity to scale in and out based on the actual demand. The scaling policy can be based on:
* Load Balancer requests
* CPU utilization
* Average In/out traffic

2) To ensure seamless access to the web application, an `Elastic Load Balancer (ELB)` must be deployed to handle the elasticity of the webservers and ensure the traffic wont get routed to "unhealthy" instances using health checks to the html index directory. Based on the requirement, the client would like to implement a load balancer operates in L4 and L7, hence a `Classic Load Balancer` is needed.    

#### 2) Database
1) AWS offers managed database service called RDS which supports different SQL database engine such as MySQL, PostgreSQL, Oracle etc. Based on the client's requirement to have a highly available database, RDS supports `Multi-AZ Deployment` to run a standby database node on a different AZ which the active database node is running. The traffic will be directed seamlessly to the standby node in another AZ if the active node is down for some reasons.

#### 3) Network
1) Now let's look at the network architecture for the Symbiosis Webapp.
2) The VPC of private IP address 192.168.0.0/16 is assigned to Symbiosis and it's futher broken into smaller subnets as seen in the diagram.
3) In general there are 2 types of subnets will be created:
* Public subnet: able to route to the Internet gateway and a public IP address will be assigned to the each EC2 instance created using this subnet for inbound access.
* Private subnet: only for internal access to this subnet and the outbound traffic will go through NAT gateway via its Elastic IP address (EIP).
4) For the Multi-AZ Deployment mode of RDS, each AZ requires one private subnet hence 2 private subnets must be created for RDS.
5) Although the web traffic will be routed through ELB, the websevers still require public subnet for inbound access for system administration purposes.

#### 4) Network Security
1) To prevent unauthorised access to the nodes from both internally and externally, there will be 2 Security Groups to protect the web tier and database tier.
2) The web tier should only allow HTTP and SSH inbound access and the database should only allow port 3306 (assuming MySQL is used) access from the subnet assigned to the webservers.  

