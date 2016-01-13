# Ec2named

- A.K.A: _FindMeABoxLike_

Get information (mostly IP addresses) from your EC2 instances quickly.

Currently, strongly assumes many conventions like `app`, `env`, and `status` tags.

    $ gem install ec2named

## Usage

#### Basic

    $ ssh $(ec2named superapp staging)

#### Advanced

```
$ ec2named -h
Options:
  -l, --list          display all matching instances, including those not in-use
  -v, --verbose       display more instance attributes to stderr in addition to ip
  -q, --show-query    print the describe-instance query filter in AWS console-friendly format
  -z, --zombie        display status:zombie instances
  -x, --statuses      include instances with status not equal to status:in-use
  -c, --class=<s>     filter on tag:class (e.g. pipeline, labs)
  -t, --type=<s>      filter on instance-type (e.g. t2.micro, c4.xlarge, m3.medium)
  -n, --name=<s>      filter on tag:Name, using _ for wildcard (e.g. jenkins_, _standby, _labs_)
  -h, --help          Show this message
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
