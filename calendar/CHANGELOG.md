# Changelog

All notable changes to this endpoint will be documented in this file.

Updates follow a [conventional commit][commits] style and the project is
versioned with [calendar versioning][calver]. Breaking changes are noted with a
new major version.

## Changes - `v1`

- feat: return the quintus date of this current date for today 2024-07-17
- feat: return an offset count of days since starting the year 2024-07-17
- feat: return an epoch offset from around the time of request 2024-06-30
- style: reformat project code according to rules of the biome 2024-06-30
- build: create a project package file for known calendar code 2024-06-30
- feat: determine if leap days exists within the provided year 2024-03-10
- docs: reference information about coordinated universal time 2024-03-10
- docs: unveil a new endpoint for discovering the present date 2024-03-03
- feat: return gregorian values for requests of the date today 2024-03-02
- feat: respond with the expected object type for lambda invocations 2024-03-02
- feat: prepare plans for casual computations on dates of a calendar 2024-02-29

[calver]: https://calver.org
[commits]: https://www.conventionalcommits.org/en/v1.0.0/
