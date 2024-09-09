# Systems Up

## Description
This Powershell script is designed to . 

## Prerequisites
Built for Powershell 5.1

## Usage

### Setup
List your systems in systems.conf with the following format;
    `[SystemName], [ipAddress]`
    
Space is optional for readability. An Octothorpe `#` can also be used to add comment lines.

A good config looks like this

```
# Local Systems
Laptop01, 192.168.0.55
```

### Run
In Powershell terminal, navigate to the root folder (containing the script)

Run with ./UsersActive.ps1

> OR

Sign the script, in the scripts properties add powershell as the default program, and double click to run. The page will remain open until any key is pressed.

### Output
Systems up are green.
Systems unreachable are Red.

Active, and logged in users will be displayed below any 'up' systems.