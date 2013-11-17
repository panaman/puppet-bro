Puppet will sync everythig you stick in this directory.

It is recommened to put bro scripts in individual directories and use __load__.bro files.

Example:
directory = scripts/something
script = scripts/something/something.bro
loader = scripts/something/__load__.bro

Then in your custom.local.bro you can @load scripts/something

