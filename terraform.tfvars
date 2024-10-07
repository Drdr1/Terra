vpc_cidr = "10.0.0.0/16"
vpc_name = "DR_vpc" 
    
subnet-info = {
    "public1" = {
        cidr_block = "10.0.1.0/24 "
        availability_zone = "us-east-1b"
        map_public_ip_on_launch = true
        Name = "public1"
    }
    "public2" = {
        cidr_block = "10.0.2.0/24 "
        availability_zone = "us-east-1c"
        map_public_ip_on_launch = true
        Name = "public2"

    }
    "private1" = {
        cidr_block = "10.0.3.0/24 "
        availability_zone = "us-east-1b"
        map_public_ip_on_launch = true
        Name = "private1"

    }
    "private2" = {
        cidr_block = "10.0.2.0/24 "
        availability_zone = "us-east-1c"
        map_public_ip_on_launch = true
        Name = "private2"

    }
}
igw_name = "DR-igw"
route_name = "public-route"
ngw-name = "DR-ngw"
route-name = "private-route"
ami_id = "ami-0e86e20dae9224db8" 
key_name = "TF_key"
instance-type = "t2.micro"