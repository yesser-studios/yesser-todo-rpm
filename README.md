COPR repo for yesser-todo-cli, yesser-todo-server and related projects.

Enable with:

```
sudo dnf copr enable yesseruser/yesser-todo
```

## Building

Builds are automatic, when pushing a tag, COPR will build the correct package.
Tags must adhere to the naming convention described in [COPR docs](https://docs.copr.fedorainfracloud.org/user_documentation.html#triggerring-builds-by-tag-events)

### Building locally

0. Navigate into the subdirectory of the package you want to build
1. Run `../vendor.sh` (Make sure spectool and cargo are installed)
2. Run `fedpkg mockbuild` (Make sure fedpkg and mock are installed)
