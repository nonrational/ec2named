# Ec2named

Get information about your AWS EC2 instances quickly.

Currently, strongly assumes conventions like `app`, `env`, and `status` tags.

### Installation

    $ gem install ec2named

### Configuration

```yaml
# ~/.ec2named.yml
application_tag: 'app'
environment_tag: 'env'
default_filters:
  - status:in-use
environments:
  - staging
  - production
reject_tag_prefixes:
  - elasticbeanstalk:environment-id
  - opsworks
```

### Usage

#### Basic

Connect to the first instance that matches your query. You'll only get an IP address.

    ~$ ec2named staging facerock
    10.10.10.1

    ~$ ssh $(ec2named facerock staging)
    Last login: Fri Apr  1 16:53:24 2016 from ip-0-0-0-0.ec2.internal

           __|  __|_  )
           _|  (     /   Amazon Linux AMI
          ___|\___|___|

    https://aws.amazon.com/amazon-linux-ami/2016.03-release-notes/
    No packages needed for security; 1 packages available
    Run "sudo yum update" to apply all updates.
    [ec2-user@ip-10-10-10-1 ~]$

#### Advanced

Query based on _lots_ of stuff.

```
$ ec2named -h
Options:
  -l, --list            display all matching instances, including those not in-use
  -v, --verbose         display more instance attributes to stderr in addition to ip
  -q, --show-query      print the describe-instance query filter
  -z, --zombie          display status:zombie instances
  -x, --statuses        include instances with status not equal to status:in-use
  -d, --debug           write debug_response.txt for later inspection
  -t, --tags=<s>        filter on arbitrary tags (e.g. class:pipeline,name:_bastion_)
  -c, --class=<s>       filter on tag:class (e.g. pipeline, labs)
  -n, --name=<s>        filter on tag:Name, using _ for wildcard (e.g. jenkins_, _standby, _labs_)
  -y, --type=<s>        filter on instance-type (e.g. t2.micro, c4.xlarge, m3.medium)
  -k, --key-name=<s>    amazon ssh key name (e.g. development, production)
  -i, --id=<s>          filter on ec2 instance-id
  -h, --help            Show this message
```

    $ ec2named -q myapp stage
    > tag:env:stage tag:app:myapp tag:status:in-use
    10.11.147.229

    $ ec2named -q stage myapp
    > tag:env:stage tag:app:myapp tag:status:in-use
    10.11.147.229

## Development

    $ bundle && rake && bundle exec rake install

## Contributing

1. Fork it ( https://github.com/nonrational/ec2named/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
