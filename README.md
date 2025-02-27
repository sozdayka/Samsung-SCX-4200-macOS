# Samsung-SCX-4200-macOS

Patch for Samsung SCX-4200 Printer Driver on macOS

## Install Patch

### Step 1. Install Base Drivers
1. Download Samsung Printer Drivers v2.6 for OS X:
- Direct link: [Samsung Printer Drivers v2.6 for OS X](https://support.apple.com/en-au/106427)
Alternatively, open the ```SamsungPrinterDrivers.dmg``` file if you already have it.
2. It is recommended to use Pacifist for the installation:
- Download **Pacifist** here: [Pacifist](https://www.charlessoft.com/)

### Step 2. Install the Patch
1. Open and install the package ```SamsungSCX4200-Installer-Distribution.pkg```.
2. **Important:**
- After starting the installation, check the **Privacy & Security** settings (System Preferences → Security & Privacy) to ensure that installations from the selected source are allowed.
- In **Privacy & Security**, if you see a message regarding the installation, click the Open button to proceed.
- If the scanner does not launch, also check the permissions in **Privacy & Security** and click the **Open** button if prompted to allow the app to run.

## Build Packages in terminal

1. Make the scripts executable:
- Run the following command:
```chmod +x build_pkg.sh```
- Run the following command:
```chmod +x build_distribution.sh```

2. Execute the build scripts:
- First, run:
```./build_pkg.sh```
- Then, run:
```./build_distribution.sh```
