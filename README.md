# Ec2named

Get information &mdash; mostly private IP addresses &mdash; about your AWS EC2 instances quickly.

By default, assumes tagging conventions like `app` and `env`, but these are configurable.

### Installation

    $ gem install ec2named

### Configuration

```yaml
# ~/.ec2named.yml
application_tag: 'app'
environment_tag: 'env'

# By default, all queries will have these tag filters applied.
default_filters:
  - status:in-use
  - color:blue

# Provide all the values that can go in the `environment_tag` specified above.
environments:
  - staging
  - production

# All tags beginning with these strings will be excluded in verbose output.
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

Note that because you provided `environments` in your config file, `ec2named facerock staging` and `ec2named staging facerock` behave identically.

#### Advanced

```
$ ec2named -h
Options:
  -l, --list            display all matching instances, including those not in-use
  -v, --verbose         display more instance attributes to stderr in addition to ip
  -q, --show-query      print the describe-instance query filter
  -d, --debug           write debug_response.txt for later inspection
  -x, --no-default      don't apply default filters
  -t, --tags=<s>        filter on arbitrary tags (e.g. class:pipeline,name:_bastion_)
  -n, --name=<s>        filter on tag:Name, using _ for wildcard (e.g. jenkins_, _standby, _labs_)
  -y, --type=<s>        filter on instance-type (e.g. t2.micro, c4.xlarge, m3.medium)
  -i, --id=<s>          filter on ec2 instance-id
  -k, --key-name=<s>    filter on amazon ssh key name (e.g. development, production)
  -h, --help            Show this message
```

##### Examples

~~~bash
$ ec2named -q myapp stage
> tag:env:stage tag:app:myapp tag:status:in-use
10.11.147.229

$ ec2named -q stage myapp
> tag:env:stage tag:app:myapp tag:status:in-use
10.11.147.229

# count total number of instances
$ ec2named -lx | wc -l
220

# show all machines with tag process:web
$ ec2named -t process:web,app:facerock -lvq
> tag:process:*web*
10.99.1.83  [i-abcdef01, development, 11:00:25, app:facerock, env:staging, process:web, status:in-use]
10.99.1.69  [i-abcdef02, trial, 4:18:21:47, app:facerock, env:trial, process:web, status:in-use]
10.99.1.184 [i-abcdef03, production, 16:52:18, app:facerock, env:production, process:web, status:in-use]
10.99.1.185 [i-abcdef04, production, 16:52:18, app:facerock, env:production, process:web, status:in-use]
10.99.1.127 [i-abcdef07, development, 10:59:21, app:facerock, env:staging, process:web, status:in-use]

# get the ip of a production box, running a web-worker, on a specific git commit
$ ec2named -q -t git_commit:c95_,process:web,env:prod_
> limit:1 tag:git_commit:c95* tag:process:web tag:env:prod*
10.11.11.123
~~~

## Development

    $ bundle && bundle exec rake

## Contributing

1. Fork it ( https://github.com/nonrational/ec2named/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
