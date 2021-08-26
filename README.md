```
$ bazel run //:main
peekA

$ bazel run //:main --//peek:peek-flag=a
peekA

$ bazel run //:main --//peek:peek-flag=b
peekB
```
