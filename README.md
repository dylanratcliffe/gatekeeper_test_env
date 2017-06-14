# Gatekeeper Test Environment

Ideally the following command should fail with a useful error:

`bundle exec onceover run spec`

This is because the `profile::override` class is overriding some of the functionality of the `profile::base` class, which is a security enforcing class and should never be overridden.
