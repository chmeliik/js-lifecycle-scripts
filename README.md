# js-lifecycle-scripts

Testing which lifecycle scripts are relevant for the `install` and `pack` commands
of various JavaScript package managers.

## Results

|                      | npm main package | npm workspaces | yarn main package | yarn workspaces | yarnberry main package | yarnberry workspaces | pnpm main package | pnpm workspaces |
| -------------------- | ---------------- | -------------- | ----------------- | --------------- | ---------------------- | -------------------- | ----------------- | --------------- |
| install              | ✅               | ✅             | ✅                | ✅              | ✅                     | ✅                   | ✅                | ✅              |
| preinstall           | ✅               | ✅             | ✅                | ✅              | ✅                     | ✅                   | ✅                | ✅              |
| postinstall          | ✅               | ✅             | ✅                | ✅              | ✅                     | ✅                   | ✅                | ✅              |
| prepublish           | ✅               |                | ✅                |                 |                        |                      |                   |                 |
| prepare              | ✅               | ✅             | ✅                |                 |                        |                      | ✅                | ✅              |
| preprepare           | ✅               |                |                   |                 |                        |                      |                   |                 |
| postprepare          | ✅               |                |                   |                 |                        |                      |                   |                 |
| prepack              | ☑️               | ☑️             | ☑️                | ☑️              | ☑️                     | ☑️                   | ☑️                | ☑️              |
| postpack             | ☑️               | ☑️             | ☑️                | ☑️              | ☑️                     | ☑️                   | ☑️                | ☑️              |
| dependencies         | ✅               |                |                   |                 |                        |                      |                   |                 |

✅ = always executed

☑️ = executed only in the workspace that is getting packed
