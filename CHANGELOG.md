## [Unreleased]

## [0.4.1] - 2024-04-01

- Add support ts and tsx file. [#38](https://github.com/junara/js_dependency/pull/38)

## [0.4.0] - 2024-03-31

- Breaking change: Support only Ruby 3.0 or later. [#34](https://github.com/junara/js_dependency/pull/34)

- Add support Vue script setup and lang. [#35](https://github.com/junara/js_dependency/pull/35) [#36](https://github.com/junara/js_dependency/pull/36)
  - `<script setup>` and `<script lang="ts">` are supported.

- Fix some typos. [#33](https://github.com/junara/js_dependency/pull/33)

## [0.3.15] - 2022-08-21

- Add exclude_output_names option for export_markdown_report.

## [0.3.14] - 2022-08-21

- Add export_markdown_report cli. This will export the markdown report to a file for GitHub comment.

## [0.3.13] - 2022-08-14

- Add rspec test.

## [0.3.12] - 2022-08-14

- Add rspec test.
- Fix script tag contents extraction if script tag has `src` like `<script src="">` .

## [0.3.11] - 2022-08-13

- Add target_paths options in configuration file to use array.

## [0.3.10] - 2022-08-13

- Add file_config options to specify configuration yaml which user like.

## [0.3.9] - 2022-08-12

- Add alias_paths options of hash.

## [0.3.8] - 2022-08-11

- `.js_dependency.yaml` is arrowed for configuration file name.
- Refactor codes.
- Add test codes.

## [0.3.7] - 2022-08-11

- If target is index.js, orphan include in analysis.

## [0.3.6] - 2022-08-11

- Add src path in script tag for create index.

## [0.3.5] - 2022-07-27

- Export orphan components list.
- Export left components list.

## [0.3.4] - 2022-07-26

- Add version CLI command
- Bug fix excludes option in parents and children commands.

## [0.3.3] - 2022-07-26

- Add special style to target_paths in mermaid output CLI.

## [0.3.2] - 2022-07-26

- Multiple excludes option for CLI.

## [0.3.1] - 2022-07-25

- Multiple target paths for JsDependency.export and export_mermaid CLI.

## [0.3.0] - 2022-07-24

- Stable mermaid support.
- Stable `excludes` option.
- Refactor JsDependency class method using `JsDependency::TargetPathname`.

## [0.2.3.1] - 2022-07-21

- Revert for script tag with line brake.
- Fix exclude pattern.

## [0.2.3] - 2022-07-21

- Fix for script tag with line brake.

## [0.2.2] - 2022-07-21

- Add CLI option parameter "exclude".
- Add yaml configuration option parameter "excludes" that is array of "exclude".

## [0.2.1] - 2022-07-20

- Output parents and children cli with line brake and sort.
- Output mermaid with parent and child string sorting.

## [0.2.0] - 2022-07-19

- Add CLI interface.

## [0.1.1] - 2022-07-19

- Bug fix of double quotation mark.

## [0.1.0] - 2022-07-16

- Initial release
